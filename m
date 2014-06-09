Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933636AbaFIQXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 12:23:17 -0400
Received: from mail.kernel.org ([198.145.19.201]:57314 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbaFIQXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 12:23:14 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH] f2fs: support f2fs_fiemap
Date: Tue, 10 Jun 2014 01:23:07 +0900
Message-Id: <1402330987-65438-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch links f2fs_fiemap with generic function with get_block.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/data.c | 6 ++++++
 fs/f2fs/f2fs.h | 1 +
 fs/f2fs/file.c | 1 +
 3 files changed, 8 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 39fe7d7..c1fb6dd 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -708,6 +708,12 @@ out:
 	return err;
 }
 
+int f2fs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
+		u64 start, u64 len)
+{
+	return generic_block_fiemap(inode, fieinfo, start, len, get_data_block);
+}
+
 static int f2fs_read_data_page(struct file *file, struct page *page)
 {
 	struct inode *inode = page->mapping->host;
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index f628c3c..e51c732 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1271,6 +1271,7 @@ struct page *find_data_page(struct inode *, pgoff_t, bool);
 struct page *get_lock_data_page(struct inode *, pgoff_t);
 struct page *get_new_data_page(struct inode *, struct page *, pgoff_t, bool);
 int do_write_data_page(struct page *, struct f2fs_io_info *);
+int f2fs_fiemap(struct inode *inode, struct fiemap_extent_info *, u64, u64);
 
 /*
  * gc.c
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 78110da..9c49c59 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -540,6 +540,7 @@ const struct inode_operations f2fs_file_inode_operations = {
 	.listxattr	= f2fs_listxattr,
 	.removexattr	= generic_removexattr,
 #endif
+	.fiemap		= f2fs_fiemap,
 };
 
 static void fill_zero(struct inode *inode, pgoff_t index,
-- 
1.8.5.2 (Apple Git-48)

