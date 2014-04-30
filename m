Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398AbaD3TOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 15:14:48 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:35579 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758872AbaD3TOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 15:14:47 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlQGAJBKYVNXQ3IO/2dsb2JhbABZgwbFcIEgF3SCZhwjGGoYJBOILQMVAcJYDYZnjDqCF4RAAQOPE4gjgXABjRGFWoMzOw
Date: Wed, 30 Apr 2014 21:14:43 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Eric Van Hensbergen <ericvh@gmail.com>
Subject: [PATCH 1/1] FS/9P: kernel-doc fixes
Message-Id: <20140430211443.523838cb3d35fd126f3c728e@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function parameters comment fixing.

Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/9p/vfs_dir.c        | 1 -
 fs/9p/vfs_file.c       | 4 ++--
 fs/9p/vfs_inode.c      | 6 +++---
 fs/9p/vfs_inode_dotl.c | 7 +++----
 4 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/9p/vfs_dir.c b/fs/9p/vfs_dir.c
index 4d0c2e0..0b3bfa3 100644
--- a/fs/9p/vfs_dir.c
+++ b/fs/9p/vfs_dir.c
@@ -42,7 +42,6 @@
 
 /**
  * struct p9_rdir - readdir accounting
- * @mutex: mutex protecting readdir
  * @head: start offset of current dirread buffer
  * @tail: end offset of current dirread buffer
  * @buf: dirread buffer
diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index d822320..81f1bd9 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -684,7 +684,7 @@ v9fs_direct_read(struct file *filp, char __user *udata, size_t count,
 /**
  * v9fs_cached_file_read - read from a file
  * @filp: file pointer to read
- * @udata: user data buffer to read data into
+ * @data: user data buffer to read data into
  * @count: size of buffer
  * @offset: offset at which to read data
  *
@@ -701,7 +701,7 @@ v9fs_cached_file_read(struct file *filp, char __user *data, size_t count,
 /**
  * v9fs_mmap_file_read - read from a file
  * @filp: file pointer to read
- * @udata: user data buffer to read data into
+ * @data: user data buffer to read data into
  * @count: size of buffer
  * @offset: offset at which to read data
  *
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 53161ec..00d140f 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -580,7 +580,7 @@ static int v9fs_at_to_dotl_flags(int flags)
  * v9fs_remove - helper function to remove files and directories
  * @dir: directory inode that is being deleted
  * @dentry:  dentry that is being deleted
- * @rmdir: removing a directory
+ * @flags: removing a directory
  *
  */
 
@@ -778,7 +778,7 @@ static int v9fs_vfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode
  * v9fs_vfs_lookup - VFS lookup hook to "walk" to a new inode
  * @dir:  inode that is being walked from
  * @dentry: dentry that is being walked to?
- * @nameidata: path data
+ * @flags: lookup flags (unused)
  *
  */
 
@@ -1324,7 +1324,7 @@ v9fs_vfs_put_link(struct dentry *dentry, struct nameidata *nd, void *p)
  * v9fs_vfs_mkspecial - create a special file
  * @dir: inode to create special file in
  * @dentry: dentry to create
- * @mode: mode to create special file
+ * @perm: mode to create special file
  * @extension: 9p2000.u format extension string representing special file
  *
  */
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 59dc8e8..1fa85aa 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -226,7 +226,7 @@ int v9fs_open_to_dotl_flags(int flags)
  * v9fs_vfs_create_dotl - VFS hook to create files for 9P2000.L protocol.
  * @dir: directory inode that is being created
  * @dentry:  dentry that is being deleted
- * @mode: create permissions
+ * @omode: create permissions
  *
  */
 
@@ -375,7 +375,7 @@ err_clunk_old_fid:
  * v9fs_vfs_mkdir_dotl - VFS mkdir hook to create a directory
  * @dir:  inode that is being unlinked
  * @dentry: dentry that is being unlinked
- * @mode: mode for new directory
+ * @omode: mode for new directory
  *
  */
 
@@ -607,7 +607,6 @@ int v9fs_vfs_setattr_dotl(struct dentry *dentry, struct iattr *iattr)
  * v9fs_stat2inode_dotl - populate an inode structure with stat info
  * @stat: stat structure
  * @inode: inode to populate
- * @sb: superblock of filesystem
  *
  */
 
@@ -808,7 +807,7 @@ v9fs_vfs_link_dotl(struct dentry *old_dentry, struct inode *dir,
  * v9fs_vfs_mknod_dotl - create a special file
  * @dir: inode destination for new link
  * @dentry: dentry for file
- * @mode: mode for creation
+ * @omode: mode for creation
  * @rdev: device associated with special file
  *
  */
-- 
1.9.1
