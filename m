Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab3JWJrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:47:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:52232 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab3JWJrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:47:04 -0400
X-AuditID: cbfee68f-b7f836d000001b39-9d-52679b1511b9
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: clean up several status-related operations
Date: Wed, 23 Oct 2013 18:46:25 +0900
Message-id: <1382521585-27450-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zI13R2elBBj1btCyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyji9u7xgqVpF07/1
	LA2MX+W7GDk5JARMJI69fMwIYYtJXLi3nq2LkYtDSGAZo8Sc7omsMEW3Pj2BSixilHj7sx/K
	aWaSeLN1FZDDwcEmoC2xeb8BSIOIALPEgqnnGUFqmAUmMEr8X/SeBSQhLOAocWD+DbB1LAKq
	Emf2vWYHsXkF3CXuPJ3ODrFNW2Lb84lgzRIC99kkDm+fyQbRICDxbfIhFpBlEgKyEpsOMEPU
	S0ocXHGDZQKj4AJGhlWMoqkFyQXFSelFxnrFibnFpXnpesn5uZsYISHYv4Px7gHrQ4zJQOMm
	MkuJJucDQzivJN7Q2MzIwtTE1NjI3NKMNGElcd77D5OChATSE0tSs1NTC1KL4otKc1KLDzEy
	cXBKNTBOn9WtulJ1XbEzh1r+6l/rnllHXJIL9jIOOHbsst/rLesPTNj1QvzZVqvHlx6/uae+
	vMJiuaPEJV1bRonpf/TjJgguy1BcePRkRLbVp9DZOifvGCdcX7rcOzh54+YZse6HalkOi5zR
	zv3htSZll/0317l3r/1N2NDq7HzJyELjD+e0ZT/y6k4IKbEUZyQaajEXFScCAGjjGa5XAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jAV3R2elBBq1XVC2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8w4vbu8YKlaRdO/9SwNjF/luxg5OSQETCRufXrCBmGLSVy4tx7I5uIQEljE
	KPH2Zz+U08wk8WbrKiCHg4NNQFti834DkAYRAWaJBVPPM4LUMAtMYJT4v+g9C0hCWMBR4sD8
	G4wgNouAqsSZfa/ZQWxeAXeJO0+ns0Ns05bY9nwi4wRG7gWMDKsYRVMLkguKk9JzjfSKE3OL
	S/PS9ZLzczcxggP8mfQOxlUNFocYBTgYlXh4LdvTgoRYE8uKK3MPMUpwMCuJ8KpPSA8S4k1J
	rKxKLcqPLyrNSS0+xJgMtH0is5Rocj4w+vJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Yah0oJJCe
	WJKanZpakFoEs4WJg1OqgTFr/Uut5dczeBdqOV7XSTW9ef1IyDaViOqMliQNhntaOhVCpmeN
	XGL+fznwS+TBpyMXlyjE+Ow+2icx93bvPo9794wNrqy3Y1y7Ks6k7N+vG6H/GNbH/JrwOy/+
	W0P3pKIPKU+leeSXL5w6c81cOYPdCoeWyT3/pThpUsmVaS9F1iZwsv5Py8pTYinOSDTUYi4q
	TgQANE+SwLQCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up improper definitions that update some status information.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/checkpoint.c |  8 ++------
 fs/f2fs/data.c       | 12 +++---------
 fs/f2fs/f2fs.h       | 14 +++++++++++++-
 fs/f2fs/gc.c         |  4 +---
 fs/f2fs/segment.c    | 10 ++++------
 5 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 6fb484c..b4a59cf 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -467,9 +467,7 @@ static int __add_dirty_inode(struct inode *inode, struct dir_inode_entry *new)
 			return -EEXIST;
 	}
 	list_add_tail(&new->list, head);
-#ifdef CONFIG_F2FS_STAT_FS
-	sbi->n_dirty_dirs++;
-#endif
+	stat_inc_dirty_dir(sbi);
 	return 0;
 }
 
@@ -531,9 +529,7 @@ void remove_dirty_dir_inode(struct inode *inode)
 		if (entry->inode == inode) {
 			list_del(&entry->list);
 			kmem_cache_free(inode_entry_slab, entry);
-#ifdef CONFIG_F2FS_STAT_FS
-			sbi->n_dirty_dirs--;
-#endif
+			stat_dec_dirty_dir(sbi);
 			break;
 		}
 	}
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 2535d3b..4d4718f 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -68,9 +68,6 @@ static int check_extent_cache(struct inode *inode, pgoff_t pgofs,
 					struct buffer_head *bh_result)
 {
 	struct f2fs_inode_info *fi = F2FS_I(inode);
-#ifdef CONFIG_F2FS_STAT_FS
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
-#endif
 	pgoff_t start_fofs, end_fofs;
 	block_t start_blkaddr;
 
@@ -80,9 +77,8 @@ static int check_extent_cache(struct inode *inode, pgoff_t pgofs,
 		return 0;
 	}
 
-#ifdef CONFIG_F2FS_STAT_FS
-	sbi->total_hit_ext++;
-#endif
+	stat_inc_hit_ext(inode->i_sb);
+
 	start_fofs = fi->ext.fofs;
 	end_fofs = fi->ext.fofs + fi->ext.len - 1;
 	start_blkaddr = fi->ext.blk_addr;
@@ -100,9 +96,7 @@ static int check_extent_cache(struct inode *inode, pgoff_t pgofs,
 		else
 			bh_result->b_size = UINT_MAX;
 
-#ifdef CONFIG_F2FS_STAT_FS
-		sbi->read_hit_ext++;
-#endif
+		stat_inc_hit_ext(inode->i_sb);
 		read_unlock(&fi->ext.ext_lock);
 		return 1;
 	}
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 2949275..d1fc93c 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1155,7 +1155,13 @@ static inline struct f2fs_stat_info *F2FS_STAT(struct f2fs_sb_info *sbi)
 	return (struct f2fs_stat_info*)sbi->stat_info;
 }
 
-#define stat_inc_call_count(si)	((si)->call_count++)
+#define stat_inc_call_count(si)		((si)->call_count++)
+#define stat_inc_bggc_count(sbi)	((sbi)->bg_gc++)
+#define stat_inc_dirty_dir(sbi)		((sbi)->n_dirty_dirs++)
+#define stat_dec_dirty_dir(sbi)		((sbi)->n_dirty_dirs--)
+#define stat_inc_hit_ext(sb)		((F2FS_SB(sb))->total_hit_ext++)
+#define stat_inc_alloc_type(sbi, curseg)				\
+		((sbi)->segment_count[(curseg)->alloc_type]++)
 
 #define stat_inc_seg_count(sbi, type)					\
 	do {								\
@@ -1184,12 +1190,18 @@ static inline struct f2fs_stat_info *F2FS_STAT(struct f2fs_sb_info *sbi)
 		si->node_blks += (blks);				\
 	} while (0)
 
+
 int f2fs_build_stats(struct f2fs_sb_info *);
 void f2fs_destroy_stats(struct f2fs_sb_info *);
 void __init f2fs_create_root_stats(void);
 void f2fs_destroy_root_stats(void);
 #else
 #define stat_inc_call_count(si)
+#define stat_inc_bggc_count(si)
+#define stat_inc_dirty_dir(sbi)
+#define stat_dec_dirty_dir(sbi)
+#define stat_inc_hit_ext(sb)
+#define stat_inc_alloc_type(sbi, curseg)
 #define stat_inc_seg_count(si, type)
 #define stat_inc_tot_blk_count(si, blks)
 #define stat_inc_data_blk_count(si, blks)
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 7914b92..cb286d7 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -77,9 +77,7 @@ static int gc_thread_func(void *data)
 		else
 			wait_ms = increase_sleep_time(gc_th, wait_ms);
 
-#ifdef CONFIG_F2FS_STAT_FS
-		sbi->bg_gc++;
-#endif
+		stat_inc_bggc_count(sbi);
 
 		/* if return value is not zero, no victim was selected */
 		if (f2fs_gc(sbi))
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 8ac1619..c9c276e 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -554,9 +554,8 @@ static void allocate_segment_by_default(struct f2fs_sb_info *sbi,
 		change_curseg(sbi, type, true);
 	else
 		new_curseg(sbi, type, false);
-#ifdef CONFIG_F2FS_STAT_FS
-	sbi->segment_count[curseg->alloc_type]++;
-#endif
+
+	stat_inc_alloc_type(sbi, curseg);
 }
 
 void allocate_new_segments(struct f2fs_sb_info *sbi)
@@ -811,9 +810,8 @@ static void do_write_page(struct f2fs_sb_info *sbi, struct page *page,
 
 	mutex_lock(&sit_i->sentry_lock);
 	__refresh_next_blkoff(sbi, curseg);
-#ifdef CONFIG_F2FS_STAT_FS
-	sbi->block_count[curseg->alloc_type]++;
-#endif
+
+	stat_inc_alloc_type(sbi, curseg);
 
 	/*
 	 * SIT information should be updated before segment allocation,
-- 
1.8.4.474.g128a96c

