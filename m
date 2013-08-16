Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab3HQAMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:12:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51634 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581Ab3HPWjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:39:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 043/133] mac80211: fix ethtool stats for non-station interfaces
Date: Fri, 16 Aug 2013 15:33:05 -0700
Message-Id: <1376692475-28413-44-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes@sipsolutions.net>

commit e13bae4f807401729b3f27c7e882a96b8b292809 upstream.

As reported in https://bugzilla.kernel.org/show_bug.cgi?id=60514,
the station loop never initialises 'sinfo' and therefore adds up
a stack values, leaking stack information (the number of times it
adds values is easily obtained another way.)

Fix this by initialising the sinfo for each station to add.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/cfg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 49c48c6..40732e3 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -638,6 +638,8 @@ static void ieee80211_get_et_stats(struct wiphy *wiphy,
 			if (sta->sdata->dev != dev)
 				continue;
 
+			sinfo.filled = 0;
+			sta_set_sinfo(sta, &sinfo);
 			i = 0;
 			ADD_STA_STATS(sta);
 		}
-- 
1.8.1.2

