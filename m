Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360AbaFWQa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:30:26 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:8842 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756019AbaFWQaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:30:24 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkHAJhVqFNbskjJ/2dsb2JhbABZgw2rZQUBAQEBAQEFAZk1gQ8XdYQxLyOBGjeIRgHGXheFY4kZhEoEj3KKWpNjg0Q7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, reiserfs-devel@vger.kernel.org,
        Jeff Mahoney <jeffm@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/reiserfs/xattr.c: fix blank line missing after declarations
Date: Mon, 23 Jun 2014 18:29:01 +0200
Message-Id: <1403540941-10389-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:

"WARNING: Missing a blank line after declarations"

Cc: reiserfs-devel@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/reiserfs/xattr.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index ca416d0..fdffe1f 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -84,6 +84,7 @@ static int xattr_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 static int xattr_unlink(struct inode *dir, struct dentry *dentry)
 {
 	int error;
+
 	BUG_ON(!mutex_is_locked(&dir->i_mutex));
 
 	mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
@@ -98,6 +99,7 @@ static int xattr_unlink(struct inode *dir, struct dentry *dentry)
 static int xattr_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	int error;
+
 	BUG_ON(!mutex_is_locked(&dir->i_mutex));
 
 	mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
@@ -117,6 +119,7 @@ static struct dentry *open_xa_root(struct super_block *sb, int flags)
 {
 	struct dentry *privroot = REISERFS_SB(sb)->priv_root;
 	struct dentry *xaroot;
+
 	if (!privroot->d_inode)
 		return ERR_PTR(-ENODATA);
 
@@ -127,6 +130,7 @@ static struct dentry *open_xa_root(struct super_block *sb, int flags)
 		xaroot = ERR_PTR(-ENODATA);
 	else if (!xaroot->d_inode) {
 		int err = -ENODATA;
+
 		if (xattr_may_create(flags))
 			err = xattr_mkdir(privroot->d_inode, xaroot, 0700);
 		if (err) {
@@ -157,6 +161,7 @@ static struct dentry *open_xa_dir(const struct inode *inode, int flags)
 	xadir = lookup_one_len(namebuf, xaroot, strlen(namebuf));
 	if (!IS_ERR(xadir) && !xadir->d_inode) {
 		int err = -ENODATA;
+
 		if (xattr_may_create(flags))
 			err = xattr_mkdir(xaroot->d_inode, xadir, 0700);
 		if (err) {
@@ -188,6 +193,7 @@ fill_with_dentries(void *buf, const char *name, int namelen, loff_t offset,
 {
 	struct reiserfs_dentry_buf *dbuf = buf;
 	struct dentry *dentry;
+
 	WARN_ON_ONCE(!mutex_is_locked(&dbuf->xadir->d_inode->i_mutex));
 
 	if (dbuf->count == ARRAY_SIZE(dbuf->dentries))
@@ -218,6 +224,7 @@ static void
 cleanup_dentry_buf(struct reiserfs_dentry_buf *buf)
 {
 	int i;
+
 	for (i = 0; i < buf->count; i++)
 		if (buf->dentries[i])
 			dput(buf->dentries[i]);
@@ -283,11 +290,13 @@ static int reiserfs_for_each_xattr(struct inode *inode,
 		int blocks = JOURNAL_PER_BALANCE_CNT * 2 + 2 +
 			     4 * REISERFS_QUOTA_TRANS_BLOCKS(inode->i_sb);
 		struct reiserfs_transaction_handle th;
+
 		reiserfs_write_lock(inode->i_sb);
 		err = journal_begin(&th, inode->i_sb, blocks);
 		reiserfs_write_unlock(inode->i_sb);
 		if (!err) {
 			int jerror;
+
 			mutex_lock_nested(&dir->d_parent->d_inode->i_mutex,
 					  I_MUTEX_XATTR);
 			err = action(dir, data);
@@ -340,6 +349,7 @@ static int chown_one_xattr(struct dentry *dentry, void *data)
 int reiserfs_delete_xattrs(struct inode *inode)
 {
 	int err = reiserfs_for_each_xattr(inode, delete_one_xattr, NULL);
+
 	if (err)
 		reiserfs_warning(inode->i_sb, "jdm-20004",
 				 "Couldn't delete all xattrs (%d)\n", err);
@@ -350,6 +360,7 @@ int reiserfs_delete_xattrs(struct inode *inode)
 int reiserfs_chown_xattrs(struct inode *inode, struct iattr *attrs)
 {
 	int err = reiserfs_for_each_xattr(inode, chown_one_xattr, attrs);
+
 	if (err)
 		reiserfs_warning(inode->i_sb, "jdm-20007",
 				 "Couldn't chown all xattrs (%d)\n", err);
@@ -439,6 +450,7 @@ int reiserfs_commit_write(struct file *f, struct page *page,
 static void update_ctime(struct inode *inode)
 {
 	struct timespec now = current_fs_time(inode->i_sb);
+
 	if (inode_unhashed(inode) || !inode->i_nlink ||
 	    timespec_equal(&inode->i_ctime, &now))
 		return;
@@ -514,6 +526,7 @@ reiserfs_xattr_set_handle(struct reiserfs_transaction_handle *th,
 		size_t chunk;
 		size_t skip = 0;
 		size_t page_offset = (file_pos & (PAGE_CACHE_SIZE - 1));
+
 		if (buffer_size - buffer_pos > PAGE_CACHE_SIZE)
 			chunk = PAGE_CACHE_SIZE;
 		else
@@ -530,6 +543,7 @@ reiserfs_xattr_set_handle(struct reiserfs_transaction_handle *th,
 
 		if (file_pos == 0) {
 			struct reiserfs_xattr_header *rxh;
+
 			skip = file_pos = sizeof(struct reiserfs_xattr_header);
 			if (chunk + skip > PAGE_CACHE_SIZE)
 				chunk = PAGE_CACHE_SIZE - skip;
@@ -659,6 +673,7 @@ reiserfs_xattr_get(struct inode *inode, const char *name, void *buffer,
 		size_t chunk;
 		char *data;
 		size_t skip = 0;
+
 		if (isize - file_pos > PAGE_CACHE_SIZE)
 			chunk = PAGE_CACHE_SIZE;
 		else
@@ -792,6 +807,7 @@ reiserfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 int reiserfs_removexattr(struct dentry *dentry, const char *name)
 {
 	const struct xattr_handler *handler;
+
 	handler = find_xattr_handler_prefix(dentry->d_sb->s_xattr, name);
 
 	if (!handler || get_inode_sd_version(dentry->d_inode) == STAT_DATA_V1)
@@ -813,9 +829,11 @@ static int listxattr_filler(void *buf, const char *name, int namelen,
 {
 	struct listxattr_buf *b = (struct listxattr_buf *)buf;
 	size_t size;
+
 	if (name[0] != '.' ||
 	    (namelen != 1 && (name[1] != '.' || namelen != 2))) {
 		const struct xattr_handler *handler;
+
 		handler = find_xattr_handler_prefix(b->dentry->d_sb->s_xattr,
 						    name);
 		if (!handler)	/* Unsupported xattr name */
@@ -885,6 +903,7 @@ static int create_privroot(struct dentry *dentry)
 {
 	int err;
 	struct inode *inode = dentry->d_parent->d_inode;
+
 	WARN_ON_ONCE(!mutex_is_locked(&inode->i_mutex));
 
 	err = xattr_mkdir(inode, dentry, 0700);
@@ -1015,6 +1034,7 @@ int reiserfs_xattr_init(struct super_block *s, int mount_flags)
 		mutex_lock(&privroot->d_inode->i_mutex);
 		if (!REISERFS_SB(s)->xattr_root) {
 			struct dentry *dentry;
+
 			dentry = lookup_one_len(XAROOT_NAME, privroot,
 						strlen(XAROOT_NAME));
 			if (!IS_ERR(dentry))
-- 
1.8.4.5

