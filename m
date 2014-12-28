Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbaL1F5M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 00:57:12 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:42867 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaL1F5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 00:57:07 -0500
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH] fs: overlayfs: Fix coding style issues, missing a blank line after declarations
Date: Sun, 28 Dec 2014 11:56:53 +0600
Message-Id: <1419746213-5405-1-git-send-email-kuleshovmail@gmail.com>
X-Mailer: git-send-email 2.2.1.202.g98acd41.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 fs/overlayfs/copy_up.c   |  1 +
 fs/overlayfs/overlayfs.h | 10 ++++++++++
 fs/overlayfs/super.c     |  5 +++++
 3 files changed, 16 insertions(+)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index ea10a87..593b00d 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -226,6 +226,7 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 
 	if (S_ISREG(stat->mode)) {
 		struct path upperpath;
+
 		ovl_path_upper(dentry, &upperpath);
 		BUG_ON(upperpath.dentry != NULL);
 		upperpath.dentry = newdentry;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 814bed3..6d65e77 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -23,6 +23,7 @@ extern const char *ovl_opaque_xattr;
 static inline int ovl_do_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	int err = vfs_rmdir(dir, dentry);
+
 	pr_debug("rmdir(%pd2) = %i\n", dentry, err);
 	return err;
 }
@@ -30,6 +31,7 @@ static inline int ovl_do_rmdir(struct inode *dir, struct dentry *dentry)
 static inline int ovl_do_unlink(struct inode *dir, struct dentry *dentry)
 {
 	int err = vfs_unlink(dir, dentry, NULL);
+
 	pr_debug("unlink(%pd2) = %i\n", dentry, err);
 	return err;
 }
@@ -38,6 +40,7 @@ static inline int ovl_do_link(struct dentry *old_dentry, struct inode *dir,
 			      struct dentry *new_dentry, bool debug)
 {
 	int err = vfs_link(old_dentry, dir, new_dentry, NULL);
+
 	if (debug) {
 		pr_debug("link(%pd2, %pd2) = %i\n",
 			 old_dentry, new_dentry, err);
@@ -49,6 +52,7 @@ static inline int ovl_do_create(struct inode *dir, struct dentry *dentry,
 			     umode_t mode, bool debug)
 {
 	int err = vfs_create(dir, dentry, mode, true);
+
 	if (debug)
 		pr_debug("create(%pd2, 0%o) = %i\n", dentry, mode, err);
 	return err;
@@ -58,6 +62,7 @@ static inline int ovl_do_mkdir(struct inode *dir, struct dentry *dentry,
 			       umode_t mode, bool debug)
 {
 	int err = vfs_mkdir(dir, dentry, mode);
+
 	if (debug)
 		pr_debug("mkdir(%pd2, 0%o) = %i\n", dentry, mode, err);
 	return err;
@@ -67,6 +72,7 @@ static inline int ovl_do_mknod(struct inode *dir, struct dentry *dentry,
 			       umode_t mode, dev_t dev, bool debug)
 {
 	int err = vfs_mknod(dir, dentry, mode, dev);
+
 	if (debug) {
 		pr_debug("mknod(%pd2, 0%o, 0%o) = %i\n",
 			 dentry, mode, dev, err);
@@ -78,6 +84,7 @@ static inline int ovl_do_symlink(struct inode *dir, struct dentry *dentry,
 				 const char *oldname, bool debug)
 {
 	int err = vfs_symlink(dir, dentry, oldname);
+
 	if (debug)
 		pr_debug("symlink(\"%s\", %pd2) = %i\n", oldname, dentry, err);
 	return err;
@@ -87,6 +94,7 @@ static inline int ovl_do_setxattr(struct dentry *dentry, const char *name,
 				  const void *value, size_t size, int flags)
 {
 	int err = vfs_setxattr(dentry, name, value, size, flags);
+
 	pr_debug("setxattr(%pd2, \"%s\", \"%*s\", 0x%x) = %i\n",
 		 dentry, name, (int) size, (char *) value, flags, err);
 	return err;
@@ -95,6 +103,7 @@ static inline int ovl_do_setxattr(struct dentry *dentry, const char *name,
 static inline int ovl_do_removexattr(struct dentry *dentry, const char *name)
 {
 	int err = vfs_removexattr(dentry, name);
+
 	pr_debug("removexattr(%pd2, \"%s\") = %i\n", dentry, name, err);
 	return err;
 }
@@ -120,6 +129,7 @@ static inline int ovl_do_rename(struct inode *olddir, struct dentry *olddentry,
 static inline int ovl_do_whiteout(struct inode *dir, struct dentry *dentry)
 {
 	int err = vfs_whiteout(dir, dentry);
+
 	pr_debug("whiteout(%pd2) = %i\n", dentry, err);
 	return err;
 }
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index f16d318..3681d2a 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -175,30 +175,35 @@ void ovl_path_lower(struct dentry *dentry, struct path *path)
 int ovl_want_write(struct dentry *dentry)
 {
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
+
 	return mnt_want_write(ofs->upper_mnt);
 }
 
 void ovl_drop_write(struct dentry *dentry)
 {
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
+
 	mnt_drop_write(ofs->upper_mnt);
 }
 
 struct dentry *ovl_workdir(struct dentry *dentry)
 {
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
+
 	return ofs->workdir;
 }
 
 bool ovl_dentry_is_opaque(struct dentry *dentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
+
 	return oe->opaque;
 }
 
 void ovl_dentry_set_opaque(struct dentry *dentry, bool opaque)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
+
 	oe->opaque = opaque;
 }
 
-- 
2.2.1.202.g98acd41.dirty

