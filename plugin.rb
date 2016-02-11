after_initialize do

  module SitepointDesign
    class Engine < ::Rails::Engine
      engine_name "sitepoint_design"
      isolate_namespace SitepointDesign
    end

    Rails.application.config.assets.paths.unshift File.expand_path('../assets', __FILE__)
  end

  # app/models/topic_posters_summary.rb
  TopicPostersSummary.class_eval do
    def user_ids_with_descriptions
      user_ids.zip([
        :original_poster,
        :most_recent_poster
      ].map { |description| I18n.t(description) })
    end

    def top_posters
      user_ids.map { |id| avatar_lookup[id] }.compact.uniq.take(5)
    end
  end

  # SP customisation: add SiteCustomization to add in crawler links
  header = <<-EOS.strip_heredoc.chomp
    <noscript>
      <a class="header-link" href="http://bbs.dmgeek.com/categories" tabindex="2">论坛首页</a>
      <a class="header-link" href="http://bbs.dmgeek.com/c/vrdiscuss" tabindex="3">讨论区</a>
      <a class="header-link" href="http://bbs.dmgeek.com/c/vrdevices" tabindex="4">设备区</a>
      <a class="header-link" href="http://bbs.dmgeek.com/c/resource" tabindex="5">资源区</a>
      <a class="header-link u-button" target="_blank" href="http://dmgeek.com/" tabindex="6">网站主页</a>
    </noscript>
    EOS

end

## Adding To Discourse
register_custom_html extraNavItem: "<li id='tags-menu-item'><a href='/tags'>标签查找</a></li><li id='faq-menu-item'><a href='/faq'>FAQ</a></li>"
register_asset "javascripts/pm_button.js.es6", :client_side
register_asset "stylesheets/common/foundation/variables.scss", :variables # other things need these variables

## General Changes
register_asset "stylesheets/common/components/banner.css.scss" # Make the banner grey
register_asset "stylesheets/common/components/badges.css.scss" # category dropdown badges
register_asset "stylesheets/common/components/navs.scss"       # Navigation at top of list pages and to the side of profile pages
register_asset "stylesheets/common/components/buttons.scss"    # Button Colors and radius
register_asset "stylesheets/common/base/header.scss"           # Custom Header
register_asset "stylesheets/common/base/topic-list.scss"       # Category Page Table
register_asset "stylesheets/common/base/discourse.scss"        # Blockquote styles
register_asset "stylesheets/common/base/topic-post.scss"       # Coloring usernames based on role

## Desktop Only
register_asset "stylesheets/desktop/header.scss", :desktop     # Links in navbar
register_asset "stylesheets/desktop/topic-post.scss", :desktop # General Post styles
register_asset "stylesheets/desktop/topic.scss", :desktop      # Post Progress meter styles
register_asset "stylesheets/common/base/topic-admin-menu.scss" # yeah i dunno why this is needed but...

## Mobile Only
register_asset "stylesheets/mobile/header.scss", :mobile   # Hide Header links on Mobile
register_asset "stylesheets/mobile/topic-list.scss", :mobile   # Hide Tags from Topic List
