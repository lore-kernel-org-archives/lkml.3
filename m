Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbaFRSCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 14:02:53 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:53967 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750936AbaFRSCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 14:02:52 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao0KADHToVNbtAr8/2dsb2JhbABagw2rOgUBAQEBAQEFAZkogQsXdYQxLyOBGjeIRgHNJheFYokThEoEj2yKV5NYg0Q7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH V2] fs/sysv/namei.c: whitespace noise removal
Date: Wed, 18 Jun 2014 20:01:16 +0200
Message-Id: <1403114476-8189-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing checkpatch errors:

"foo * bar" should be "foo *bar"
code indent should use tabs where possible
trailing whitespace

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V2: More appropriate subject (suggested by Al Viro)

 fs/sysv/namei.c | 56 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/fs/sysv/namei.c b/fs/sysv/namei.c
index 731b2bb..be0e2f6 100644
--- a/fs/sysv/namei.c
+++ b/fs/sysv/namei.c
@@ -42,9 +42,9 @@ const struct dentry_operations sysv_dentry_operations = {
 	.d_hash		= sysv_hash,
 };
 
-static struct dentry *sysv_lookup(struct inode * dir, struct dentry * dentry, unsigned int flags)
+static struct dentry *sysv_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
 {
-	struct inode * inode = NULL;
+	struct inode *inode = NULL;
 	ino_t ino;
 
 	if (dentry->d_name.len > SYSV_NAMELEN)
@@ -60,9 +60,9 @@ static struct dentry *sysv_lookup(struct inode * dir, struct dentry * dentry, un
 	return NULL;
 }
 
-static int sysv_mknod(struct inode * dir, struct dentry * dentry, umode_t mode, dev_t rdev)
+static int sysv_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, dev_t rdev)
 {
-	struct inode * inode;
+	struct inode *inode;
 	int err;
 
 	if (!old_valid_dev(rdev))
@@ -79,17 +79,17 @@ static int sysv_mknod(struct inode * dir, struct dentry * dentry, umode_t mode,
 	return err;
 }
 
-static int sysv_create(struct inode * dir, struct dentry * dentry, umode_t mode, bool excl)
+static int sysv_create(struct inode *dir, struct dentry *dentry, umode_t mode, bool excl)
 {
 	return sysv_mknod(dir, dentry, mode, 0);
 }
 
-static int sysv_symlink(struct inode * dir, struct dentry * dentry, 
-	const char * symname)
+static int sysv_symlink(struct inode *dir, struct dentry *dentry,
+	const char *symname)
 {
 	int err = -ENAMETOOLONG;
 	int l = strlen(symname)+1;
-	struct inode * inode;
+	struct inode *inode;
 
 	if (l > dir->i_sb->s_blocksize)
 		goto out;
@@ -115,8 +115,8 @@ out_fail:
 	goto out;
 }
 
-static int sysv_link(struct dentry * old_dentry, struct inode * dir, 
-	struct dentry * dentry)
+static int sysv_link(struct dentry *old_dentry, struct inode *dir,
+	struct dentry *dentry)
 {
 	struct inode *inode = old_dentry->d_inode;
 
@@ -127,9 +127,9 @@ static int sysv_link(struct dentry * old_dentry, struct inode * dir,
 	return add_nondir(dentry, inode);
 }
 
-static int sysv_mkdir(struct inode * dir, struct dentry *dentry, umode_t mode)
+static int sysv_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
-	struct inode * inode;
+	struct inode *inode;
 	int err;
 
 	inode_inc_link_count(dir);
@@ -151,7 +151,7 @@ static int sysv_mkdir(struct inode * dir, struct dentry *dentry, umode_t mode)
 	if (err)
 		goto out_fail;
 
-        d_instantiate(dentry, inode);
+	d_instantiate(dentry, inode);
 out:
 	return err;
 
@@ -164,11 +164,11 @@ out_dir:
 	goto out;
 }
 
-static int sysv_unlink(struct inode * dir, struct dentry * dentry)
+static int sysv_unlink(struct inode *dir, struct dentry *dentry)
 {
-	struct inode * inode = dentry->d_inode;
-	struct page * page;
-	struct sysv_dir_entry * de;
+	struct inode *inode = dentry->d_inode;
+	struct page *page;
+	struct sysv_dir_entry *de;
 	int err = -ENOENT;
 
 	de = sysv_find_entry(dentry, &page);
@@ -185,7 +185,7 @@ out:
 	return err;
 }
 
-static int sysv_rmdir(struct inode * dir, struct dentry * dentry)
+static int sysv_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
 	int err = -ENOTEMPTY;
@@ -205,15 +205,15 @@ static int sysv_rmdir(struct inode * dir, struct dentry * dentry)
  * Anybody can rename anything with this: the permission checks are left to the
  * higher-level routines.
  */
-static int sysv_rename(struct inode * old_dir, struct dentry * old_dentry,
-		  struct inode * new_dir, struct dentry * new_dentry)
+static int sysv_rename(struct inode *old_dir, struct dentry *old_dentry,
+		  struct inode *new_dir, struct dentry *new_dentry)
 {
-	struct inode * old_inode = old_dentry->d_inode;
-	struct inode * new_inode = new_dentry->d_inode;
-	struct page * dir_page = NULL;
-	struct sysv_dir_entry * dir_de = NULL;
-	struct page * old_page;
-	struct sysv_dir_entry * old_de;
+	struct inode *old_inode = old_dentry->d_inode;
+	struct inode *new_inode = new_dentry->d_inode;
+	struct page *dir_page = NULL;
+	struct sysv_dir_entry *dir_de = NULL;
+	struct page *old_page;
+	struct sysv_dir_entry *old_de;
 	int err = -ENOENT;
 
 	old_de = sysv_find_entry(old_dentry, &old_page);
@@ -228,8 +228,8 @@ static int sysv_rename(struct inode * old_dir, struct dentry * old_dentry,
 	}
 
 	if (new_inode) {
-		struct page * new_page;
-		struct sysv_dir_entry * new_de;
+		struct page *new_page;
+		struct sysv_dir_entry *new_de;
 
 		err = -ENOTEMPTY;
 		if (dir_de && !sysv_empty_dir(new_inode))
-- 
1.8.4.5

