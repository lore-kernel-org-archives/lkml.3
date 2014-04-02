Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308AbaDBNdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:33:40 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:44128 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216AbaDBNcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:32:07 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Subject: [PATCH 2/4] cfg80211: Take the BW restrictions into account when checking the channel
Date: Wed,  2 Apr 2014 15:31:53 +0200
Message-Id: <1396445515-5808-3-git-send-email-rostislav.lisovy@fel.cvut.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396445515-5808-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
References: <1396445515-5808-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since there are frequency bands restricting maximum channel
bandwidth to 5MHz or 10MHz, check the particular bandwidth
flags in cfg80211_chandef_usable() to comply with the restrictions.

Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
---
 net/wireless/chan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 78559b5..87e1576 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -531,12 +531,14 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 		width = 5;
 		break;
 	case NL80211_CHAN_WIDTH_10:
+		prohibited_flags |= IEEE80211_CHAN_NO_10MHZ;
 		width = 10;
 		break;
 	case NL80211_CHAN_WIDTH_20:
 		if (!ht_cap->ht_supported)
 			return false;
 	case NL80211_CHAN_WIDTH_20_NOHT:
+		prohibited_flags |= IEEE80211_CHAN_NO_20MHZ;
 		width = 20;
 		break;
 	case NL80211_CHAN_WIDTH_40:
-- 
1.9.1

