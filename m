Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbaCWTNu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 15:13:50 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:61678 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbaCWTNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 15:13:47 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: davem@davemloft.net, ebiederm@xmission.com, nhorman@tuxdriver.com,
        cwang@twopensource.com, kaber@trash.net, antonio@meshcoding.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/core: Use RCU_INIT_POINTER(x, NULL) in netpoll.c
Date: Mon, 24 Mar 2014 00:42:46 +0530
Message-Id: <1395601966-12490-1-git-send-email-monamagarwal123@gmail.com>
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
 net/core/netpoll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 7291dde..41c4e9c 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -809,7 +809,7 @@ void __netpoll_cleanup(struct netpoll *np)
 		if (ops->ndo_netpoll_cleanup)
 			ops->ndo_netpoll_cleanup(np->dev);
 
-		rcu_assign_pointer(np->dev->npinfo, NULL);
+		RCU_INIT_POINTER(np->dev->npinfo, NULL);
 		call_rcu_bh(&npinfo->rcu, rcu_cleanup_netpoll_info);
 	}
 }
-- 
1.7.9.5

