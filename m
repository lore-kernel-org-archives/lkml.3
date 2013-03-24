Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab3CXXlK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 19:41:10 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:49427 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab3CXXlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 19:41:07 -0400
X-AuditID: cbfee690-b7f656d0000007e3-fb-514f8f1105ce
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/4] f2fs: do not skip writing file meta during fsync
Date: Mon, 25 Mar 2013 08:40:12 +0900
Message-id: <1364168414-12815-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1364168414-12815-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1364168414-12815-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t8zQ13Bfv9Ag9fvuCyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgylh5eydbwVKpip49
	i1kaGO+IdjFyckgImEgcOrWLEcIWk7hwbz0biC0ksIxRYtU/b5iaM9d/AdVwAcWnM0q0fP4H
	5bQxSTTcP8nUxcjBwSagLbF5vwFIg4gAs8SCqefBapgFJjBK/F/0ngUkISzgKtE6fSEzSD2L
	gKrE7BUeIGFeAXeJr9smMEEs05VY/f85O0gJp4CHxN8vzhD3uEs0n30KNlJC4DubxPcJvWAj
	WQQEJL5NPsQCUi8hICux6QAzxBhJiYMrbrBMYBRewMiwilE0tSC5oDgpvchErzgxt7g0L10v
	OT93EyMkXCfsYLx3wPoQYzLQuInMUqLJ+cBwzyuJNzQ2M7IwNTE1NjK3NCNNWEmcV73FOlBI
	ID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY64qawinhcTJf/Ylh8/+fJ3+LjvcLPhJZlR9wKHp
	U50fprY66Uz4Pvc2e7FPSN79myxL9+1v0MhTm7PJec3mDAeVBxrqZu5NK3Jn/mf/M7tln3Dc
	/yc9Z2LKDvvFWDKEPk/6vDDwdSqXfdruQln3mHPLt0uKH2uursidFJLCo/3zshO71AEdJZbi
	jERDLeai4kQAHkLA5m0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jQV3Bfv9AgwtfWC2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8xYeXsnW8FSqYqePYtZGhjviHYxcnJICJhInLn+ixHCFpO4cG89WxcjF4eQ
	wHRGiZbP/xghnDYmiYb7J5m6GDk42AS0JTbvNwBpEBFgllgw9TxYDbPABEaJ/4ves4AkhAVc
	JVqnL2QGqWcRUJWYvcIDJMwr4C7xddsEJohluhKr/z9nBynhFPCQ+PvFGSQsBFTSfPYp4wRG
	3gWMDKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxguPhmdQOxpUNFocYBTgYlXh4BWr8A4VY
	E8uKK3MPMUpwMCuJ8L7pAQrxpiRWVqUW5ccXleakFh9iTAa6aSKzlGhyPjBW80riDY1NzIws
	jcwsjEzMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBcZ6o+5OL80147ruzOMlf+7Ca
	c+r9U5t/Huu7cvZqi5Zy03znfg+1Cgnn4LbvE8y3X9dwMNucMn3uxpcmqvN33ply9vXCToaY
	0wIONkms/IyxZzgFVCpks0w/vvc4dyPWbuuuoxyhhyrlu9O7677OfG339bH5r/sfl5lLeh1z
	fLTAyVhk1ZvS2UosxRmJhlrMRcWJAIjw0r7LAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes data_version check flow during the fsync call.
The original purpose for the use of data_version was to avoid writng inode
pages redundantly by the fsync calls repeatedly.
However, when user can modify file meta and then call fsync, we should not
skip fsync procedure.
So, let's remove this condition check and hope that user triggers in right
manner.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c  |  3 ---
 fs/f2fs/f2fs.h  |  1 -
 fs/f2fs/file.c  | 10 ----------
 fs/f2fs/inode.c |  1 -
 4 files changed, 15 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index ea8be6f..47a2d7c 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -435,7 +435,6 @@ static int f2fs_read_data_pages(struct file *file,
 int do_write_data_page(struct page *page)
 {
 	struct inode *inode = page->mapping->host;
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	block_t old_blk_addr, new_blk_addr;
 	struct dnode_of_data dn;
 	int err = 0;
@@ -465,8 +464,6 @@ int do_write_data_page(struct page *page)
 		write_data_page(inode, page, &dn,
 				old_blk_addr, &new_blk_addr);
 		update_extent_cache(new_blk_addr, &dn);
-		F2FS_I(inode)->data_version =
-			le64_to_cpu(F2FS_CKPT(sbi)->checkpoint_ver);
 	}
 out_writepage:
 	f2fs_put_dnode(&dn);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 109e12d..380e2b3 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -159,7 +159,6 @@ struct f2fs_inode_info {
 
 	/* Use below internally in f2fs*/
 	unsigned long flags;		/* use to pass per-file flags */
-	unsigned long long data_version;/* latest version of data for fsync */
 	atomic_t dirty_dents;		/* # of dirty dentry pages */
 	f2fs_hash_t chash;		/* hash value of given file name */
 	unsigned int clevel;		/* maximum level of given file name */
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index ff018a4..d65fcad 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -124,7 +124,6 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct inode *inode = file->f_mapping->host;
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
-	unsigned long long cur_version;
 	int ret = 0;
 	bool need_cp = false;
 	struct writeback_control wbc = {
@@ -148,15 +147,6 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
 		goto out;
 
-	mutex_lock(&sbi->cp_mutex);
-	cur_version = le64_to_cpu(F2FS_CKPT(sbi)->checkpoint_ver);
-	mutex_unlock(&sbi->cp_mutex);
-
-	if (F2FS_I(inode)->data_version != cur_version &&
-					!(inode->i_state & I_DIRTY))
-		goto out;
-	F2FS_I(inode)->data_version--;
-
 	if (!S_ISREG(inode->i_mode) || inode->i_nlink != 1)
 		need_cp = true;
 	else if (is_inode_flag_set(F2FS_I(inode), FI_NEED_CP))
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index e0e8308..f798ddf 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -80,7 +80,6 @@ static int do_read_inode(struct inode *inode)
 	fi->i_xattr_nid = le32_to_cpu(ri->i_xattr_nid);
 	fi->i_flags = le32_to_cpu(ri->i_flags);
 	fi->flags = 0;
-	fi->data_version = le64_to_cpu(F2FS_CKPT(sbi)->checkpoint_ver) - 1;
 	fi->i_advise = ri->i_advise;
 	fi->i_pino = le32_to_cpu(ri->i_pino);
 	get_extent_info(&fi->ext, ri->i_ext);
-- 
1.8.1.3.566.gaa39828

