Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961Ab3GYSIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:08:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:19868 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919Ab3GYRv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:51:58 -0400
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH V8 20/33] fs: add read_iter and write_iter to several file systems
Date: Thu, 25 Jul 2013 12:50:46 -0500
Message-Id: <1374774659-13121-21-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the simple ones.

File systems that use generic_file_aio_read() and generic_file_aio_write()
can trivially support generic_file_read_iter() and generic_file_write_iter().

This patch adds those file_operations for 9p, adfs, affs, bfs, exofs, ext2,
ext3, fat, f2fs, hfs, hfsplus, hostfs, hpfs, jfs, jffs2, logfs, minix, nilfs2,
omfs, ramfs, reiserfs, romfs, sysv, and ufs.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Acked-by: Boaz Harrosh <bharrosh@panasas.com>
Cc: Zach Brown <zab@zabbo.net>
---
 fs/9p/vfs_addr.c        | 4 ++--
 fs/9p/vfs_file.c        | 8 ++++----
 fs/adfs/file.c          | 4 ++--
 fs/affs/file.c          | 4 ++--
 fs/bfs/file.c           | 4 ++--
 fs/exofs/file.c         | 4 ++--
 fs/ext2/file.c          | 4 ++--
 fs/ext3/file.c          | 4 ++--
 fs/f2fs/file.c          | 4 ++--
 fs/fat/file.c           | 4 ++--
 fs/hfs/inode.c          | 4 ++--
 fs/hfsplus/inode.c      | 4 ++--
 fs/hostfs/hostfs_kern.c | 4 ++--
 fs/hpfs/file.c          | 4 ++--
 fs/jffs2/file.c         | 8 ++++----
 fs/jfs/file.c           | 4 ++--
 fs/logfs/file.c         | 4 ++--
 fs/minix/file.c         | 4 ++--
 fs/nilfs2/file.c        | 4 ++--
 fs/omfs/file.c          | 4 ++--
 fs/ramfs/file-mmu.c     | 4 ++--
 fs/ramfs/file-nommu.c   | 4 ++--
 fs/reiserfs/file.c      | 4 ++--
 fs/romfs/mmap-nommu.c   | 2 +-
 fs/sysv/file.c          | 4 ++--
 fs/ufs/file.c           | 4 ++--
 26 files changed, 55 insertions(+), 55 deletions(-)

diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index 5581415..da0821b 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -251,8 +251,8 @@ static int v9fs_launder_page(struct page *page)
  * the VFS gets them, so this method should never be called.
  *
  * Direct IO is not 'yet' supported in the cached mode. Hence when
- * this routine is called through generic_file_aio_read(), the read/write fails
- * with an error.
+ * this routine is called through generic_file_read_iter(), the read/write
+ * fails with an error.
  *
  */
 static ssize_t
diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index d384a8b..18d0293 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -743,8 +743,8 @@ const struct file_operations v9fs_cached_file_operations = {
 	.llseek = generic_file_llseek,
 	.read = v9fs_cached_file_read,
 	.write = v9fs_cached_file_write,
-	.aio_read = generic_file_aio_read,
-	.aio_write = generic_file_aio_write,
+	.read_iter = generic_file_read_iter,
+	.write_iter = generic_file_write_iter,
 	.open = v9fs_file_open,
 	.release = v9fs_dir_release,
 	.lock = v9fs_file_lock,
@@ -756,8 +756,8 @@ const struct file_operations v9fs_cached_file_operations_dotl = {
 	.llseek = generic_file_llseek,
 	.read = v9fs_cached_file_read,
 	.write = v9fs_cached_file_write,
-	.aio_read = generic_file_aio_read,
-	.aio_write = generic_file_aio_write,
+	.read_iter = generic_file_read_iter,
+	.write_iter = generic_file_write_iter,
 	.open = v9fs_file_open,
 	.release = v9fs_dir_release,
 	.lock = v9fs_file_lock_dotl,
diff --git a/fs/adfs/file.c b/fs/adfs/file.c
index a36da53..da1e021 100644
--- a/fs/adfs/file.c
+++ b/fs/adfs/file.c
@@ -24,11 +24,11 @@
 const struct file_operations adfs_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
-	.aio_read	= generic_file_aio_read,
+	.read_iter	= generic_file_read_iter,
 	.mmap		= generic_file_mmap,
 	.fsync		= generic_file_fsync,
 	.write		= do_sync_write,
-	.aio_write	= generic_file_aio_write,
+	.write_iter	= generic_file_write_iter,
 	.splice_read	= generic_file_splice_read,
 };
 
diff --git a/fs/affs/file.c b/fs/affs/file.c
index af3261b..d09a2db 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -28,9 +28,9 @@ static int affs_file_release(struct inode *inode, struct file *filp);
 const struct file_operations affs_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
-	.aio_read	= generic_file_aio_read,
+	.read_iter	= generic_file_read_iter,
 	.write		= do_sync_write,
-	.aio_write	= generic_file_aio_write,
+	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
 	.open		= affs_file_open,
 	.release	= affs_file_release,
diff --git a/fs/bfs/file.c b/fs/bfs/file.c
index ad3ea14..3d14806 100644
--- a/fs/bfs/file.c
+++ b/fs/bfs/file.c
@@ -24,9 +24,9 @@
 const struct file_operations bfs_file_operations = {
 	.llseek 	= generic_file_llseek,
 	.read		= do_sync_read,
-	.aio_read	= generic_file_aio_read,
+	.read_iter	= generic_file_read_iter,
 	.write		= do_sync_write,
-	.aio_write	= generic_file_aio_write,
+	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
 	.splice_read	= generic_file_splice_read,
 };
diff --git a/fs/exofs/file.c b/fs/exofs/file.c
index 491c6c0..20564f8a 100644
--- a/fs/exofs/file.c
+++ b/fs/exofs/file.c
@@ -69,8 +69,8 @@ const struct file_operations exofs_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
-	.aio_read	= generic_file_aio_read,
-	.aio_write	= generic_file_aio_write,
+	.read_iter	= generic_file_read_iter,
+	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
 	.open		= generic_file_open,
 	.release	= exofs_release_file,
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index a5b3a5d..6af043b 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -64,8 +64,8 @@ const struct file_operations ext2_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
-	.aio_read	= generic_file_aio_read,
-	.aio_write	= generic_file_aio_write,
+	.read_iter	= generic_file_read_iter,
+	.write_iter	= generic_file_write_iter,
 	.unlocked_ioctl = ext2_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext2_compat_ioctl,
diff --git a/fs/ext3/file.c b/fs/ext3/file.c
index 25cb413..a796771 100644
--- a/fs/ext3/file.c
+++ b/fs/ext3/file.c
@@ -52,8 +52,8 @@ const struct file_operations ext3_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
-	.aio_read	= generic_file_aio_read,
-	.aio_write	= generic_file_aio_write,
+	.read_iter	= generic_file_read_iter,
+	.write_iter	= generic_file_write_iter,
 	.unlocked_ioctl	= ext3_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext3_compat_ioctl,
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index d2d2b7d..d498bad 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -678,8 +678,8 @@ const struct file_operations f2fs_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
-	.aio_read	= generic_file_aio_read,
-	.aio_write	= generic_file_aio_write,
+	.read_iter	= generic_file_read_iter,
+	.write_iter	= generic_file_write_iter,
 	.open		= generic_file_open,
 	.mmap		= f2fs_file_mmap,
 	.fsync		= f2fs_sync_file,
diff --git a/fs/fat/file.c b/fs/fat/file.c
index 9b104f5..33711ff 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -172,8 +172,8 @@ const struct file_operations fat_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
-	.aio_read	= generic_file_aio_read,
-	.aio_write	= generic_file_aio_write,
+	.read_iter	= generic_file_read_iter,
+	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
 	.release	= fat_file_release,
 	.unlocked_ioctl	= fat_generic_ioctl,
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 62440ce..f9242b8 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -674,9 +674,9 @@ static int hfs_file_fsync(struct file *filp, loff_t start, loff_t end,
 static const struct file_operations hfs_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
-	.aio_read	= generic_file_aio_read,
+	.read_iter	= generic_file_read_iter,
 	.write		= do_sync_write,
-	.aio_write	= generic_file_aio_write,
+	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
 	.splice_read	= generic_file_splice_read,
 	.fsync		= hfs_file_fsync,
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index fca99cc..13813f6 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -388,9 +388,9 @@ static const struct inode_operations hfsplus_file_inode_operations = {
 static const struct file_operations hfsplus_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
-	.aio_read	= generic_file_aio_read,
+	.read_iter	= generic_file_read_iter,
 	.write		= do_sync_write,
-	.aio_write	= generic_file_aio_write,
+	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
 	.splice_read	= generic_file_splice_read,
 	.fsync		= hfsplus_file_fsync,
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index cddb052..e3adc8e 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -381,8 +381,8 @@ static const struct file_operations hostfs_file_fops = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
 	.splice_read	= generic_file_splice_read,
-	.aio_read	= generic_file_aio_read,
-	.aio_write	= generic_file_aio_write,
+	.read_iter	= generic_file_read_iter,
+	.write_iter	= generic_file_write_iter,
 	.write		= do_sync_write,
 	.mmap		= generic_file_mmap,
 	.open		= hostfs_file_open,
diff --git a/fs/hpfs/file.c b/fs/hpfs/file.c
index 4e9dabc..2561eba 100644
--- a/fs/hpfs/file.c
+++ b/fs/hpfs/file.c
@@ -198,9 +198,9 @@ const struct file_operations hpfs_file_ops =
 {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
-	.aio_read	= generic_file_aio_read,
+	.read_iter	= generic_file_read_iter,
 	.write		= do_sync_write,
-	.aio_write	= generic_file_aio_write,
+	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
 	.release	= hpfs_file_release,
 	.fsync		= hpfs_file_fsync,
diff --git a/fs/jffs2/file.c b/fs/jffs2/file.c
index 1506673..1d7ab8b 100644
--- a/fs/jffs2/file.c
+++ b/fs/jffs2/file.c
@@ -51,10 +51,10 @@ const struct file_operations jffs2_file_operations =
 {
 	.llseek =	generic_file_llseek,
 	.open =		generic_file_open,
- 	.read =		do_sync_read,
- 	.aio_read =	generic_file_aio_read,
- 	.write =	do_sync_write,
- 	.aio_write =	generic_file_aio_write,
+	.read =		do_sync_read,
+	.read_iter =	generic_file_read_iter,
+	.write =	do_sync_write,
+	.write_iter =	generic_file_write_iter,
 	.unlocked_ioctl=jffs2_ioctl,
 	.mmap =		generic_file_readonly_mmap,
 	.fsync =	jffs2_fsync,
diff --git a/fs/jfs/file.c b/fs/jfs/file.c
index dd7442c..040b6c7 100644
--- a/fs/jfs/file.c
+++ b/fs/jfs/file.c
@@ -151,8 +151,8 @@ const struct file_operations jfs_file_operations = {
 	.llseek		= generic_file_llseek,
 	.write		= do_sync_write,
 	.read		= do_sync_read,
-	.aio_read	= generic_file_aio_read,
-	.aio_write	= generic_file_aio_write,
+	.read_iter	= generic_file_read_iter,
+	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
diff --git a/fs/logfs/file.c b/fs/logfs/file.c
index 57914fc..57f994e 100644
--- a/fs/logfs/file.c
+++ b/fs/logfs/file.c
@@ -264,8 +264,8 @@ const struct inode_operations logfs_reg_iops = {
 };
 
 const struct file_operations logfs_reg_fops = {
-	.aio_read	= generic_file_aio_read,
-	.aio_write	= generic_file_aio_write,
+	.read_iter	= generic_file_read_iter,
+	.write_iter	= generic_file_write_iter,
 	.fsync		= logfs_fsync,
 	.unlocked_ioctl	= logfs_ioctl,
 	.llseek		= generic_file_llseek,
diff --git a/fs/minix/file.c b/fs/minix/file.c
index adc6f54..346d8f37 100644
--- a/fs/minix/file.c
+++ b/fs/minix/file.c
@@ -15,9 +15,9 @@
 const struct file_operations minix_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
-	.aio_read	= generic_file_aio_read,
+	.read_iter	= generic_file_read_iter,
 	.write		= do_sync_write,
-	.aio_write	= generic_file_aio_write,
+	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
 	.fsync		= generic_file_fsync,
 	.splice_read	= generic_file_splice_read,
diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index 08fdb77..7aeb8ee 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -153,8 +153,8 @@ const struct file_operations nilfs_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
-	.aio_read	= generic_file_aio_read,
-	.aio_write	= generic_file_aio_write,
+	.read_iter	= generic_file_read_iter,
+	.write_iter	= generic_file_write_iter,
 	.unlocked_ioctl	= nilfs_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= nilfs_compat_ioctl,
diff --git a/fs/omfs/file.c b/fs/omfs/file.c
index e0d9b3e..badafd8 100644
--- a/fs/omfs/file.c
+++ b/fs/omfs/file.c
@@ -339,8 +339,8 @@ const struct file_operations omfs_file_operations = {
 	.llseek = generic_file_llseek,
 	.read = do_sync_read,
 	.write = do_sync_write,
-	.aio_read = generic_file_aio_read,
-	.aio_write = generic_file_aio_write,
+	.read_iter = generic_file_read_iter,
+	.write_iter = generic_file_write_iter,
 	.mmap = generic_file_mmap,
 	.fsync = generic_file_fsync,
 	.splice_read = generic_file_splice_read,
diff --git a/fs/ramfs/file-mmu.c b/fs/ramfs/file-mmu.c
index 4884ac5..c4d8572 100644
--- a/fs/ramfs/file-mmu.c
+++ b/fs/ramfs/file-mmu.c
@@ -39,9 +39,9 @@ const struct address_space_operations ramfs_aops = {
 
 const struct file_operations ramfs_file_operations = {
 	.read		= do_sync_read,
-	.aio_read	= generic_file_aio_read,
+	.read_iter	= generic_file_read_iter,
 	.write		= do_sync_write,
-	.aio_write	= generic_file_aio_write,
+	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
 	.fsync		= noop_fsync,
 	.splice_read	= generic_file_splice_read,
diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index 8d5b438..f2487c3 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -39,9 +39,9 @@ const struct file_operations ramfs_file_operations = {
 	.mmap			= ramfs_nommu_mmap,
 	.get_unmapped_area	= ramfs_nommu_get_unmapped_area,
 	.read			= do_sync_read,
-	.aio_read		= generic_file_aio_read,
+	.read_iter		= generic_file_read_iter,
 	.write			= do_sync_write,
-	.aio_write		= generic_file_aio_write,
+	.write_iter		= generic_file_write_iter,
 	.fsync			= noop_fsync,
 	.splice_read		= generic_file_splice_read,
 	.splice_write		= generic_file_splice_write,
diff --git a/fs/reiserfs/file.c b/fs/reiserfs/file.c
index dcaafcf..f98feb2 100644
--- a/fs/reiserfs/file.c
+++ b/fs/reiserfs/file.c
@@ -245,8 +245,8 @@ const struct file_operations reiserfs_file_operations = {
 	.open = reiserfs_file_open,
 	.release = reiserfs_file_release,
 	.fsync = reiserfs_sync_file,
-	.aio_read = generic_file_aio_read,
-	.aio_write = generic_file_aio_write,
+	.read_iter = generic_file_read_iter,
+	.write_iter = generic_file_write_iter,
 	.splice_read = generic_file_splice_read,
 	.splice_write = generic_file_splice_write,
 	.llseek = generic_file_llseek,
diff --git a/fs/romfs/mmap-nommu.c b/fs/romfs/mmap-nommu.c
index f373bde..f8a9e2b 100644
--- a/fs/romfs/mmap-nommu.c
+++ b/fs/romfs/mmap-nommu.c
@@ -73,7 +73,7 @@ static int romfs_mmap(struct file *file, struct vm_area_struct *vma)
 const struct file_operations romfs_ro_fops = {
 	.llseek			= generic_file_llseek,
 	.read			= do_sync_read,
-	.aio_read		= generic_file_aio_read,
+	.read_iter		= generic_file_read_iter,
 	.splice_read		= generic_file_splice_read,
 	.mmap			= romfs_mmap,
 	.get_unmapped_area	= romfs_get_unmapped_area,
diff --git a/fs/sysv/file.c b/fs/sysv/file.c
index 9d4dc68..ff4b363 100644
--- a/fs/sysv/file.c
+++ b/fs/sysv/file.c
@@ -22,9 +22,9 @@
 const struct file_operations sysv_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
-	.aio_read	= generic_file_aio_read,
+	.read_iter	= generic_file_read_iter,
 	.write		= do_sync_write,
-	.aio_write	= generic_file_aio_write,
+	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
 	.fsync		= generic_file_fsync,
 	.splice_read	= generic_file_splice_read,
diff --git a/fs/ufs/file.c b/fs/ufs/file.c
index 33afa20..e155e4c 100644
--- a/fs/ufs/file.c
+++ b/fs/ufs/file.c
@@ -36,9 +36,9 @@
 const struct file_operations ufs_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
-	.aio_read	= generic_file_aio_read,
+	.read_iter	= generic_file_read_iter,
 	.write		= do_sync_write,
-	.aio_write	= generic_file_aio_write,
+	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
 	.open           = generic_file_open,
 	.fsync		= generic_file_fsync,
-- 
1.8.3.4

