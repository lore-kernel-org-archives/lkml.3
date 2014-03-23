Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaCWTSI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 15:18:08 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34317 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaCWTSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 15:18:03 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/mac80211: Use RCU_INIT_POINTER(x, NULL) in ibss.c
Date: Mon, 24 Mar 2014 00:47:02 +0530
Message-Id: <1395602222-13677-1-git-send-email-monamagarwal123@gmail.com>
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
 net/mac80211/ibss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index e458ca0..cb262c4 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -253,7 +253,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 
 	presp = rcu_dereference_protected(ifibss->presp,
 					  lockdep_is_held(&sdata->wdev.mtx));
-	rcu_assign_pointer(ifibss->presp, NULL);
+	RCU_INIT_POINTER(ifibss->presp, NULL);
 	if (presp)
 		kfree_rcu(presp, rcu_head);
 
-- 
1.7.9.5

