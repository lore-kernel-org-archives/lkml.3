Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaCWSrU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 14:47:20 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:62276 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaCWSrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 14:47:19 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: eparis@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] kernel: Use RCU_INIT_POINTER(x, NULL) in audit.c
Date: Mon, 24 Mar 2014 00:16:19 +0530
Message-Id: <1395600379-9668-1-git-send-email-monamagarwal123@gmail.com>
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
 kernel/audit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 3392d3e..bc240ba 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1087,7 +1087,7 @@ static void __net_exit audit_net_exit(struct net *net)
 		audit_sock = NULL;
 	}
 
-	rcu_assign_pointer(aunet->nlsk, NULL);
+	RCU_INIT_POINTER(aunet->nlsk, NULL);
 	synchronize_net();
 	netlink_kernel_release(sock);
 }
-- 
1.7.9.5

