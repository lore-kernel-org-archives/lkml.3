Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683AbaJNQYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 12:24:40 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:27058 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932236AbaJNQYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 12:24:39 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AskNAHRNPVRbtAZ+/2dsb2JhbABbgw6BK7h2BQFzmhaBFhcBfYQwLyOBGjeIQgG3V49HhiCKJR2ENQWGLYski3qBLoZzjXCBRwGCMTsvgkoBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1 linux-next] fs/affs/file.c: forward declaration clean-up
Date: Tue, 14 Oct 2014 18:24:31 +0200
Message-Id: <1413303871-6353-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Move file_operations to avoid forward declarations.
-Remove unused declarations.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/affs/file.c | 38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/fs/affs/file.c b/fs/affs/file.c
index 1ed590a..8e2e60e 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -18,29 +18,7 @@
 #error PAGE_SIZE must be at least 4096
 #endif
 
-static int affs_grow_extcache(struct inode *inode, u32 lc_idx);
-static struct buffer_head *affs_alloc_extblock(struct inode *inode, struct buffer_head *bh, u32 ext);
-static inline struct buffer_head *affs_get_extblock(struct inode *inode, u32 ext);
 static struct buffer_head *affs_get_extblock_slow(struct inode *inode, u32 ext);
-static int affs_file_open(struct inode *inode, struct file *filp);
-static int affs_file_release(struct inode *inode, struct file *filp);
-
-const struct file_operations affs_file_operations = {
-	.llseek		= generic_file_llseek,
-	.read		= new_sync_read,
-	.read_iter	= generic_file_read_iter,
-	.write		= new_sync_write,
-	.write_iter	= generic_file_write_iter,
-	.mmap		= generic_file_mmap,
-	.open		= affs_file_open,
-	.release	= affs_file_release,
-	.fsync		= affs_file_fsync,
-	.splice_read	= generic_file_splice_read,
-};
-
-const struct inode_operations affs_file_inode_operations = {
-	.setattr	= affs_notify_change,
-};
 
 static int
 affs_file_open(struct inode *inode, struct file *filp)
@@ -961,3 +939,19 @@ int affs_file_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
 	mutex_unlock(&inode->i_mutex);
 	return ret;
 }
+const struct file_operations affs_file_operations = {
+	.llseek		= generic_file_llseek,
+	.read		= new_sync_read,
+	.read_iter	= generic_file_read_iter,
+	.write		= new_sync_write,
+	.write_iter	= generic_file_write_iter,
+	.mmap		= generic_file_mmap,
+	.open		= affs_file_open,
+	.release	= affs_file_release,
+	.fsync		= affs_file_fsync,
+	.splice_read	= generic_file_splice_read,
+};
+
+const struct inode_operations affs_file_inode_operations = {
+	.setattr	= affs_notify_change,
+};
-- 
1.9.3

