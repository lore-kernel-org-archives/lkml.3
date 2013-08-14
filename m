Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732Ab3HNKhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:37:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34364 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759592Ab3HNKhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:37:11 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 02/75] mac80211: fix ethtool stats for non-station interfaces
Date: Wed, 14 Aug 2013 11:35:51 +0100
Message-Id: <1376476624-10011-3-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes@sipsolutions.net>

commit e13bae4f807401729b3f27c7e882a96b8b292809 upstream.

As reported in https://bugzilla.kernel.org/show_bug.cgi?id=60514,
the station loop never initialises 'sinfo' and therefore adds up
a stack values, leaking stack information (the number of times it
adds values is easily obtained another way.)

Fix this by initialising the sinfo for each station to add.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/mac80211/cfg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 56386f1..0042e61 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -561,6 +561,8 @@ static void ieee80211_get_et_stats(struct wiphy *wiphy,
 			if (sta->sdata->dev != dev)
 				continue;
 
+			sinfo.filled = 0;
+			sta_set_sinfo(sta, &sinfo);
 			i = 0;
 			ADD_STA_STATS(sta);
 		}
-- 
1.8.3.2

