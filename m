Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbaDOK7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:59:15 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:55973 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbaDOK7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:59:10 -0400
X-AuditID: cbfee68e-b7f566d000002344-8b-534d10fb6e59
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 3/3] f2fs: flush dirty directory pages when scattered pages are
 gathered
Date: Tue, 15 Apr 2014 19:57:03 +0900
Message-id: <1397559423-27411-3-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1397559423-27411-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1397559423-27411-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t8zQ93fAr7BBjuu8lhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAldHf8Ja1YJZUxYP7
	/9gaGM+JdjFyckgImEg8fjuDCcIWk7hwbz1bFyMXh5DAMkaJo6cnMsIUXVnwixnEFhKYzihx
	t1MHoqiTSWL6qddARRwcbALaEpv3G4DUiAgwSyyYep4RpIZZYAKjxP9F71lAEsICURJ9vZtY
	QWwWAVWJOc/awIbyCrhLbGzoZoFYpi2x7TnEYk4BD4kdRx+wQCx2l+j8vw3sOgmB32wSC4/9
	Y4EYJCDxbfIhFpAjJARkJTYdYIaYIylxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXGekVJ+YWl+al
	6yXn525ihIRs3w7GmwesDzEmA42byCwlmpwPDPm8knhDYzMjC1MTU2Mjc0sz0oSVxHkXPUwK
	EhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cBoteNGmcOXugkH5nK4tT4PdE1cZ//j9YK+4x84
	fkinNicF/tpmYCfCk6m+Pc3u2Ps7X3r0D0dsXbIyzt6n2aNw5TVRc68KKUdDpUsWsTKzld8s
	ljF6tT7TtPayQRx/2Uwz37err5xpnLpv7YeVwhs7Of2aWR/Kmn/JmLNt0/fl2iclg/O6vzAr
	sRRnJBpqMRcVJwIAmKYxJW8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jQd3fAr7BBrsvc1hc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5jR3/CWtWCWVMWD+//YGhjPiXYxcnJICJhIXFnwixnCFpO4cG89G4gtJDCd
	UeJup04XIxeQ3ckkMf3Ua8YuRg4ONgFtic37DUBqRASYJRZMPc8IUsMsMIFR4v+i9ywgCWGB
	KIm+3k2sIDaLgKrEnGdtYAt4BdwlNjZ0s0As05bY9nwiI4jNKeAhsePoAxaIxe4Snf+3sU1g
	5F3AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzginknvYFzVYHGIUYCDUYmHd8I772Ah
	1sSy4srcQ4wSHMxKIrwfuX2DhXhTEiurUovy44tKc1KLDzEmA101kVlKNDkfGK15JfGGxiZm
	RpZGZhZGJubmpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cBYmF11WXPKq5sO62JKtCz+
	uFrU+C4Tf/jz7mufVGvZkI7GJtedJ+u0b556u3P5bxOjj0eSf/W9kje6tOxTKWO2lpitq2HK
	Wb6JbUxyr14IVBtJsF3dUbXT4Afzr4lOMTOFLFpr38rW1Kc+WF0xpSGRgeVK3Kq3j1/HnXVL
	qZC+6iR7e8Weoi4lluKMREMt5qLiRACocWYNzAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a lot of directory inodes have the small number of dentry pages in each
page cache, there is no chance to flush them periodically.
This patch proposes the average number of dirty dentry pages for the threshold.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/checkpoint.c |  2 ++
 fs/f2fs/f2fs.h       |  1 +
 fs/f2fs/segment.h    | 16 +++++++++-------
 fs/f2fs/super.c      |  1 +
 4 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 5133aec..d57d93f 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -562,6 +562,7 @@ static int __add_dirty_inode(struct inode *inode, struct dir_inode_entry *new)
 	set_inode_flag(F2FS_I(inode), FI_DIRTY_DIR);
 	F2FS_I(inode)->dirty_dir = new;
 	list_add_tail(&new->list, &sbi->dir_inode_list);
+	atomic_inc(&sbi->dirty_dir_inodes);
 	stat_inc_dirty_dir(sbi);
 	return 0;
 }
@@ -626,6 +627,7 @@ void remove_dirty_dir_inode(struct inode *inode)
 	list_del(&entry->list);
 	F2FS_I(inode)->dirty_dir = NULL;
 	clear_inode_flag(F2FS_I(inode), FI_DIRTY_DIR);
+	atomic_dec(&sbi->dirty_dir_inodes);
 	stat_dec_dirty_dir(sbi);
 	spin_unlock(&sbi->dir_inode_lock);
 	kmem_cache_free(inode_entry_slab, entry);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index d3180f8..e708d02 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -450,6 +450,7 @@ struct f2fs_sb_info {
 
 	/* for directory inode management */
 	struct list_head dir_inode_list;	/* dir inode list */
+	atomic_t dirty_dir_inodes;		/* # of dirty inodes */
 	spinlock_t dir_inode_lock;		/* for dir inode list lock */
 
 	/* basic file system units */
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 7091204..8eb23a0 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -668,20 +668,22 @@ static inline unsigned int max_hw_blocks(struct f2fs_sb_info *sbi)
 /*
  * It is very important to gather dirty pages and write at once, so that we can
  * submit a big bio without interfering other data writes.
- * By default, 512 pages for directory data,
+ * By default, avg. dirty pages for directory data,
  * 512 pages (2MB) * 3 for three types of nodes, and
  * max_bio_blocks for meta are set.
  */
 static inline int nr_pages_to_skip(struct f2fs_sb_info *sbi, int type)
 {
-	if (type == DATA)
-		return sbi->blocks_per_seg;
-	else if (type == NODE)
+	if (type == DATA) {
+		unsigned int dirty = atomic_read(&sbi->dirty_dir_inodes);
+		if (dirty > sbi->blocks_per_seg * sbi->blocks_per_seg)
+			return div_u64(get_pages(sbi, F2FS_DIRTY_DENTS), dirty);
+	} else if (type == NODE) {
 		return 3 * sbi->blocks_per_seg;
-	else if (type == META)
+	} else if (type == META) {
 		return MAX_BIO_BLOCKS(max_hw_blocks(sbi));
-	else
-		return 0;
+	}
+	return sbi->blocks_per_seg;
 }
 
 /*
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 5e20d2a..eabf8df 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -973,6 +973,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->last_valid_block_count = sbi->total_valid_block_count;
 	sbi->alloc_valid_block_count = 0;
 	INIT_LIST_HEAD(&sbi->dir_inode_list);
+	atomic_set(&sbi->dirty_dir_inodes, 0);
 	spin_lock_init(&sbi->dir_inode_lock);
 
 	init_orphan_info(sbi);
-- 
1.8.4.474.g128a96c

