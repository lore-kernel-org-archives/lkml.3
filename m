Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab3KNVQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 16:16:04 -0500
Received: from multi.imgtec.com ([194.200.65.239]:56789 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049Ab3KNVPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 16:15:54 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Richard Weinberger <richard@nod.at>, Jeff Dike <jdike@addtoit.com>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>,
        <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH] um: hostfs: make functions static
Date: Thu, 14 Nov 2013 21:15:13 +0000
Message-ID: <1384463713-14348-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_11_14_21_15_28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hostfs_*() callback functions are all only used within
hostfs_kern.c, so make them static.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net
---
 fs/hostfs/hostfs_kern.c | 53 ++++++++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 25 deletions(-)

diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 25437280a207..782f9d52b772 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -195,7 +195,7 @@ static struct inode *hostfs_iget(struct super_block *sb)
 	return inode;
 }
 
-int hostfs_statfs(struct dentry *dentry, struct kstatfs *sf)
+static int hostfs_statfs(struct dentry *dentry, struct kstatfs *sf)
 {
 	/*
 	 * do_statfs uses struct statfs64 internally, but the linux kernel
@@ -277,7 +277,7 @@ static const struct super_operations hostfs_sbops = {
 	.show_options	= hostfs_show_options,
 };
 
-int hostfs_readdir(struct file *file, struct dir_context *ctx)
+static int hostfs_readdir(struct file *file, struct dir_context *ctx)
 {
 	void *dir;
 	char *name;
@@ -302,7 +302,7 @@ int hostfs_readdir(struct file *file, struct dir_context *ctx)
 	return 0;
 }
 
-int hostfs_file_open(struct inode *ino, struct file *file)
+static int hostfs_file_open(struct inode *ino, struct file *file)
 {
 	static DEFINE_MUTEX(open_mutex);
 	char *name;
@@ -368,7 +368,8 @@ static int hostfs_file_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-int hostfs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+static int hostfs_fsync(struct file *file, loff_t start, loff_t end,
+			int datasync)
 {
 	struct inode *inode = file->f_mapping->host;
 	int ret;
@@ -403,7 +404,7 @@ static const struct file_operations hostfs_dir_fops = {
 	.read		= generic_read_dir,
 };
 
-int hostfs_writepage(struct page *page, struct writeback_control *wbc)
+static int hostfs_writepage(struct page *page, struct writeback_control *wbc)
 {
 	struct address_space *mapping = page->mapping;
 	struct inode *inode = mapping->host;
@@ -439,7 +440,7 @@ int hostfs_writepage(struct page *page, struct writeback_control *wbc)
 	return err;
 }
 
-int hostfs_readpage(struct file *file, struct page *page)
+static int hostfs_readpage(struct file *file, struct page *page)
 {
 	char *buffer;
 	long long start;
@@ -464,9 +465,9 @@ int hostfs_readpage(struct file *file, struct page *page)
 	return err;
 }
 
-int hostfs_write_begin(struct file *file, struct address_space *mapping,
-			loff_t pos, unsigned len, unsigned flags,
-			struct page **pagep, void **fsdata)
+static int hostfs_write_begin(struct file *file, struct address_space *mapping,
+			      loff_t pos, unsigned len, unsigned flags,
+			      struct page **pagep, void **fsdata)
 {
 	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
 
@@ -476,9 +477,9 @@ int hostfs_write_begin(struct file *file, struct address_space *mapping,
 	return 0;
 }
 
-int hostfs_write_end(struct file *file, struct address_space *mapping,
-			loff_t pos, unsigned len, unsigned copied,
-			struct page *page, void *fsdata)
+static int hostfs_write_end(struct file *file, struct address_space *mapping,
+			    loff_t pos, unsigned len, unsigned copied,
+			    struct page *page, void *fsdata)
 {
 	struct inode *inode = mapping->host;
 	void *buffer;
@@ -558,8 +559,8 @@ static int read_name(struct inode *ino, char *name)
 	return 0;
 }
 
-int hostfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
-		  bool excl)
+static int hostfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
+			 bool excl)
 {
 	struct inode *inode;
 	char *name;
@@ -600,8 +601,8 @@ int hostfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 	return error;
 }
 
-struct dentry *hostfs_lookup(struct inode *ino, struct dentry *dentry,
-			     unsigned int flags)
+static struct dentry *hostfs_lookup(struct inode *ino, struct dentry *dentry,
+				    unsigned int flags)
 {
 	struct inode *inode;
 	char *name;
@@ -637,7 +638,8 @@ struct dentry *hostfs_lookup(struct inode *ino, struct dentry *dentry,
 	return ERR_PTR(err);
 }
 
-int hostfs_link(struct dentry *to, struct inode *ino, struct dentry *from)
+static int hostfs_link(struct dentry *to, struct inode *ino,
+		       struct dentry *from)
 {
 	char *from_name, *to_name;
 	int err;
@@ -655,7 +657,7 @@ int hostfs_link(struct dentry *to, struct inode *ino, struct dentry *from)
 	return err;
 }
 
-int hostfs_unlink(struct inode *ino, struct dentry *dentry)
+static int hostfs_unlink(struct inode *ino, struct dentry *dentry)
 {
 	char *file;
 	int err;
@@ -671,7 +673,8 @@ int hostfs_unlink(struct inode *ino, struct dentry *dentry)
 	return err;
 }
 
-int hostfs_symlink(struct inode *ino, struct dentry *dentry, const char *to)
+static int hostfs_symlink(struct inode *ino, struct dentry *dentry,
+			  const char *to)
 {
 	char *file;
 	int err;
@@ -683,7 +686,7 @@ int hostfs_symlink(struct inode *ino, struct dentry *dentry, const char *to)
 	return err;
 }
 
-int hostfs_mkdir(struct inode *ino, struct dentry *dentry, umode_t mode)
+static int hostfs_mkdir(struct inode *ino, struct dentry *dentry, umode_t mode)
 {
 	char *file;
 	int err;
@@ -695,7 +698,7 @@ int hostfs_mkdir(struct inode *ino, struct dentry *dentry, umode_t mode)
 	return err;
 }
 
-int hostfs_rmdir(struct inode *ino, struct dentry *dentry)
+static int hostfs_rmdir(struct inode *ino, struct dentry *dentry)
 {
 	char *file;
 	int err;
@@ -747,8 +750,8 @@ static int hostfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode,
 	return err;
 }
 
-int hostfs_rename(struct inode *from_ino, struct dentry *from,
-		  struct inode *to_ino, struct dentry *to)
+static int hostfs_rename(struct inode *from_ino, struct dentry *from,
+			 struct inode *to_ino, struct dentry *to)
 {
 	char *from_name, *to_name;
 	int err;
@@ -765,7 +768,7 @@ int hostfs_rename(struct inode *from_ino, struct dentry *from,
 	return err;
 }
 
-int hostfs_permission(struct inode *ino, int desired)
+static int hostfs_permission(struct inode *ino, int desired)
 {
 	char *name;
 	int r = 0, w = 0, x = 0, err;
@@ -791,7 +794,7 @@ int hostfs_permission(struct inode *ino, int desired)
 	return err;
 }
 
-int hostfs_setattr(struct dentry *dentry, struct iattr *attr)
+static int hostfs_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
 	struct hostfs_iattr attrs;
-- 
1.8.1.2


