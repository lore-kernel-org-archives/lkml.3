Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278AbaDBNcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:32:16 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:39276 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262AbaDBNcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:32:11 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Subject: [PATCH 4/4] mac80211: Update conf_is_ht() to work properly with 5/10MHz channels
Date: Wed,  2 Apr 2014 15:31:55 +0200
Message-Id: <1396445515-5808-5-git-send-email-rostislav.lisovy@fel.cvut.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396445515-5808-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
References: <1396445515-5808-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The channels with 5/10MHz bandwidth are not HT. We have to
reflect this in conf_is_ht() function which returns whether the
particular channel is HT or not.

Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
---
 include/net/mac80211.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f4ab2fb..f56e45b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4585,7 +4585,9 @@ conf_is_ht40(struct ieee80211_conf *conf)
 static inline bool
 conf_is_ht(struct ieee80211_conf *conf)
 {
-	return conf->chandef.width != NL80211_CHAN_WIDTH_20_NOHT;
+	return (conf->chandef.width != NL80211_CHAN_WIDTH_5) &&
+		(conf->chandef.width != NL80211_CHAN_WIDTH_10) &&
+		(conf->chandef.width != NL80211_CHAN_WIDTH_20_NOHT);
 }
 
 static inline enum nl80211_iftype
-- 
1.9.1

