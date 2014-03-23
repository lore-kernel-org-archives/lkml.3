Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425AbaCWSmd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 14:42:33 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:58097 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbaCWSmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 14:42:31 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fs: Use RCU_INIT_POINTER(x, NULL) in afs/security.c
Date: Mon, 24 Mar 2014 00:11:31 +0530
Message-Id: <1395600091-8753-1-git-send-email-monamagarwal123@gmail.com>
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
 fs/afs/security.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/afs/security.c b/fs/afs/security.c
index 8d01042..42f7cf3 100644
--- a/fs/afs/security.c
+++ b/fs/afs/security.c
@@ -114,7 +114,7 @@ void afs_clear_permits(struct afs_vnode *vnode)
 
 	mutex_lock(&vnode->permits_lock);
 	permits = vnode->permits;
-	rcu_assign_pointer(vnode->permits, NULL);
+	RCU_INIT_POINTER(vnode->permits, NULL);
 	mutex_unlock(&vnode->permits_lock);
 
 	if (permits)
-- 
1.7.9.5

