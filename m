Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaCWTOw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 15:14:52 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:60377 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbaCWTOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 15:14:48 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/mac80211: Use RCU_INIT_POINTER(x, NULL) in cfg.c
Date: Mon, 24 Mar 2014 00:43:48 +0530
Message-Id: <1395602028-12863-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)

The rcu_assign_pointer() ensures that the initialization of a structure       
is carried out before storing a pointer to that structure. 
And in the case of the NULL pointer, there is no structure to initialize. 
So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 net/mac80211/cfg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1acb291..e92aeea 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1566,7 +1566,7 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 
 		if (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
 		    sta->sdata->u.vlan.sta) {
-			rcu_assign_pointer(sta->sdata->u.vlan.sta, NULL);
+			RCU_INIT_POINTER(sta->sdata->u.vlan.sta, NULL);
 			prev_4addr = true;
 		}
 
-- 
1.7.9.5

