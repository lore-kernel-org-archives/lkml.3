Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824Ab3K1HoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 02:44:25 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:58244 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576Ab3K1HoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 02:44:20 -0500
X-AuditID: cbfee61b-b7f166d000007a34-b2-5296f453023c
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: [f2fs-dev] [PATCH 5/5] f2fs: convert recover_orphan_inodes to void
Date: Thu, 28 Nov 2013 15:43:43 +0800
Message-id: <003501ceec0d$a14d97f0$e3e8c7d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7sDRonlWbYpJzJTQiam08dHKcVPA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jQd3gL9OCDD7+l7K4vusvk8WlRe4W
	e/aeZLG4vGsOm0XrwvPMDqweuxd8ZvLo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSujG9L+5kK
	DopU7Hv9mLGB8b9AFyMHh4SAicTL/XpdjJxAppjEhXvr2boYuTiEBKYzSkyYsJcVwvnBKHHv
	7m1WkCo2ARWJ5R3/mUBsEQFFiQ3vN7CDFDELzGCUODz3H1iRsIC3xN8Th1hAbBYBVYmvK64z
	g9i8ApYSSw88ZoGwBSV+TL4HZjMLaEj0L9rABmHLS2xe85YZ4iQFiR1nXzNCLNOTuLxkC1S9
	uMTGI7dYJjAKzEIyahaSUbOQjJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOCg
	fia9g3FVg8UhRgEORiUeXgmdaUFCrIllxZW5hxglOJiVRHgVioFCvCmJlVWpRfnxRaU5qcWH
	GKU5WJTEeQ+2WgcKCaQnlqRmp6YWpBbBZJk4OKUaGNvTtMWZg4ySNjPX8avvmnG52cQswYU7
	9p9Sf6dbhuDpWuuIq4UxX2f9UTq67OLfmoL0aLfuZZtVzk0Njy3nzVKz36Z/X1cnLa/TSYaZ
	XWl64mQmoUfdZq+NCwTqRft2sPKmV+XOLttV/sPIZPmadX/T8mYvm+YT+2vV/K9s7O2HohOl
	fdOVWIozEg21mIuKEwHD/rJdZgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/checkpoint.c |    6 +++---
 fs/f2fs/f2fs.h       |    2 +-
 fs/f2fs/super.c      |    8 ++++----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 7fe69ff..b28e61b 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -270,12 +270,12 @@ static void recover_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
 	iput(inode);
 }
 
-int recover_orphan_inodes(struct f2fs_sb_info *sbi)
+void recover_orphan_inodes(struct f2fs_sb_info *sbi)
 {
 	block_t start_blk, orphan_blkaddr, i, j;
 
 	if (!is_set_ckpt_flags(F2FS_CKPT(sbi), CP_ORPHAN_PRESENT_FLAG))
-		return 0;
+		return;
 
 	sbi->por_doing = true;
 	start_blk = __start_cp_addr(sbi) + 1;
@@ -295,7 +295,7 @@ int recover_orphan_inodes(struct f2fs_sb_info *sbi)
 	/* clear Orphan Flag */
 	clear_ckpt_flags(F2FS_CKPT(sbi), CP_ORPHAN_PRESENT_FLAG);
 	sbi->por_doing = false;
-	return 0;
+	return;
 }
 
 static void write_orphan_inodes(struct f2fs_sb_info *sbi, block_t start_blk)
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index c8eb37e..bb96b64 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1114,7 +1114,7 @@ int acquire_orphan_inode(struct f2fs_sb_info *);
 void release_orphan_inode(struct f2fs_sb_info *);
 void add_orphan_inode(struct f2fs_sb_info *, nid_t);
 void remove_orphan_inode(struct f2fs_sb_info *, nid_t);
-int recover_orphan_inodes(struct f2fs_sb_info *);
+void recover_orphan_inodes(struct f2fs_sb_info *);
 int get_valid_checkpoint(struct f2fs_sb_info *);
 void set_dirty_dir_page(struct inode *, struct page *);
 void add_dirty_dir_inode(struct inode *);
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 9981b28..09a2b07 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -946,9 +946,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	/* if there are nt orphan nodes free them */
-	err = -EINVAL;
-	if (recover_orphan_inodes(sbi))
-		goto free_node_inode;
+	recover_orphan_inodes(sbi);
 
 	/* read root inode and dentry */
 	root = f2fs_iget(sb, F2FS_ROOT_INO(sbi));
@@ -957,8 +955,10 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 		err = PTR_ERR(root);
 		goto free_node_inode;
 	}
-	if (!S_ISDIR(root->i_mode) || !root->i_blocks || !root->i_size)
+	if (!S_ISDIR(root->i_mode) || !root->i_blocks || !root->i_size) {
+		err = -EINVAL;
 		goto free_root_inode;
+	}
 
 	sb->s_root = d_make_root(root); /* allocate root dentry */
 	if (!sb->s_root) {
-- 
1.7.9.5

