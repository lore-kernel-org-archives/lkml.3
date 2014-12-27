Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbaL0Nw5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 08:52:57 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47123 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaL0Nwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 08:52:53 -0500
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH] fs: proc: use the PDE to to get proc_dir_entry
Date: Sat, 27 Dec 2014 19:52:46 +0600
Message-Id: <1419688366-26796-1-git-send-email-kuleshovmail@gmail.com>
X-Mailer: git-send-email 2.2.1.202.g98acd41.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the PDE to get proc_dir_entry instead of coding it directly.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 fs/proc/generic.c | 2 +-
 fs/proc/inode.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 7fea132..de14e46 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -122,7 +122,7 @@ static int proc_getattr(struct vfsmount *mnt, struct dentry *dentry,
 			struct kstat *stat)
 {
 	struct inode *inode = dentry->d_inode;
-	struct proc_dir_entry *de = PROC_I(inode)->pde;
+	struct proc_dir_entry *de = PDE(inode);
 	if (de && de->nlink)
 		set_nlink(inode, de->nlink);
 
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 8420a2f..13a50a3 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -40,7 +40,7 @@ static void proc_evict_inode(struct inode *inode)
 	put_pid(PROC_I(inode)->pid);
 
 	/* Let go of any associated proc directory entry */
-	de = PROC_I(inode)->pde;
+	de = PDE(inode);
 	if (de)
 		pde_put(de);
 	head = PROC_I(inode)->sysctl;
-- 
2.2.1.202.g98acd41.dirty

