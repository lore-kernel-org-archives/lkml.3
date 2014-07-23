Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbaGWNQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:16:07 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42792 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259AbaGWNP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:15:58 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-kernel@vger.kernel.org, hch@infradead.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Cc: Miklos Szeredi <mszeredi@suse.cz>, Hugh Dickins <hughd@google.com>
Subject: [PATCH 4/7] shmem: support RENAME_NOREPLACE
Date: Wed, 23 Jul 2014 15:15:33 +0200
Message-Id: <1406121336-1379-5-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1406121336-1379-1-git-send-email-miklos@szeredi.hu>
References: <1406121336-1379-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Expand noreplace_rename2() because next patch will implement one more flag.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
---
 mm/shmem.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 1140f49b6ded..791b05514f9a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2022,11 +2022,14 @@ static int shmem_rmdir(struct inode *dir, struct dentry *dentry)
  * it exists so that the VFS layer correctly free's it when it
  * gets overwritten.
  */
-static int shmem_rename(struct inode *old_dir, struct dentry *old_dentry, struct inode *new_dir, struct dentry *new_dentry)
+static int shmem_rename2(struct inode *old_dir, struct dentry *old_dentry, struct inode *new_dir, struct dentry *new_dentry, unsigned int flags)
 {
 	struct inode *inode = old_dentry->d_inode;
 	int they_are_dirs = S_ISDIR(inode->i_mode);
 
+	if (flags & ~(RENAME_NOREPLACE))
+		return -EINVAL;
+
 	if (!simple_empty(new_dentry))
 		return -ENOTEMPTY;
 
@@ -2709,7 +2712,7 @@ static const struct inode_operations shmem_dir_inode_operations = {
 	.mkdir		= shmem_mkdir,
 	.rmdir		= shmem_rmdir,
 	.mknod		= shmem_mknod,
-	.rename		= shmem_rename,
+	.rename2	= shmem_rename2,
 	.tmpfile	= shmem_tmpfile,
 #endif
 #ifdef CONFIG_TMPFS_XATTR
-- 
1.8.1.4

