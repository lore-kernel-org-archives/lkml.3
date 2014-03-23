Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbaCWSlq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 14:41:46 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:42353 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbaCWSlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 14:41:44 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fs: Use RCU_INIT_POINTER(x, NULL) in afs/inode.c
Date: Mon, 24 Mar 2014 00:10:44 +0530
Message-Id: <1395600044-8576-1-git-send-email-monamagarwal123@gmail.com>
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
 fs/afs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index ce25d75..7c09dfe 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -445,7 +445,7 @@ void afs_evict_inode(struct inode *inode)
 
 	mutex_lock(&vnode->permits_lock);
 	permits = vnode->permits;
-	rcu_assign_pointer(vnode->permits, NULL);
+	RCU_INIT_POINTER(vnode->permits, NULL);
 	mutex_unlock(&vnode->permits_lock);
 	if (permits)
 		call_rcu(&permits->rcu, afs_zap_permits);
-- 
1.7.9.5

