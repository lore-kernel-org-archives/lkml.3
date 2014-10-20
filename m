Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaJTFTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 01:19:09 -0400
Received: from mail.kernel.org ([198.145.19.201]:59759 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447AbaJTFSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 01:18:40 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 05/09] f2fs: use highmem for directory pages
Date: Sun, 19 Oct 2014 22:18:28 -0700
Message-Id: <1413782312-11631-5-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413782312-11631-1-git-send-email-jaegeuk@kernel.org>
References: <1413782312-11631-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes to use highmem for directory pages.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/inode.c         | 2 +-
 include/linux/f2fs_fs.h | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 0deead4..52d6f54 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -156,7 +156,7 @@ make_now:
 		inode->i_op = &f2fs_dir_inode_operations;
 		inode->i_fop = &f2fs_dir_operations;
 		inode->i_mapping->a_ops = &f2fs_dblock_aops;
-		mapping_set_gfp_mask(inode->i_mapping, GFP_F2FS_ZERO);
+		mapping_set_gfp_mask(inode->i_mapping, GFP_F2FS_HIGH_ZERO);
 	} else if (S_ISLNK(inode->i_mode)) {
 		inode->i_op = &f2fs_symlink_inode_operations;
 		inode->i_mapping->a_ops = &f2fs_dblock_aops;
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index 860313a..6d7381b 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -33,7 +33,8 @@
 #define F2FS_META_INO(sbi)	(sbi->meta_ino_num)
 
 /* This flag is used by node and meta inodes, and by recovery */
-#define GFP_F2FS_ZERO	(GFP_NOFS | __GFP_ZERO)
+#define GFP_F2FS_ZERO		(GFP_NOFS | __GFP_ZERO)
+#define GFP_F2FS_HIGH_ZERO	(GFP_NOFS | __GFP_ZERO | __GFP_HIGHMEM)
 
 /*
  * For further optimization on multi-head logs, on-disk layout supports maximum
-- 
2.1.1

