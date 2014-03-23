Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbaCWSqm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 14:46:42 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:39575 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaCWSqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 14:46:40 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        d.hatayama@jp.fujitsu.com, dhowells@redhat.com, JBeulich@suse.com,
        adobriyan@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] fs: Use RCU_INIT_POINTER(x, NULL) in proc/inode.c
Date: Mon, 24 Mar 2014 00:15:39 +0530
Message-Id: <1395600339-9375-1-git-send-email-monamagarwal123@gmail.com>
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
 fs/proc/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 124fc43..28c21d9 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -47,7 +47,7 @@ static void proc_evict_inode(struct inode *inode)
 		pde_put(de);
 	head = PROC_I(inode)->sysctl;
 	if (head) {
-		rcu_assign_pointer(PROC_I(inode)->sysctl, NULL);
+		RCU_INIT_POINTER(PROC_I(inode)->sysctl, NULL);
 		sysctl_head_put(head);
 	}
 	/* Release any associated namespace */
-- 
1.7.9.5

