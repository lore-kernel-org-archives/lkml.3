Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbaCWTWr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 15:22:47 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:50265 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbaCWTWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 15:22:43 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/mac80211: Use RCU_INIT_POINTER(x, NULL) in util.c
Date: Mon, 24 Mar 2014 00:51:43 +0530
Message-Id: <1395602503-14958-1-git-send-email-monamagarwal123@gmail.com>
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
 net/mac80211/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 275c94f..7601657 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1546,7 +1546,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		WARN_ON(local->resuming);
 		res = drv_add_interface(local, sdata);
 		if (WARN_ON(res)) {
-			rcu_assign_pointer(local->monitor_sdata, NULL);
+			RCU_INIT_POINTER(local->monitor_sdata, NULL);
 			synchronize_net();
 			kfree(sdata);
 		}
-- 
1.7.9.5

