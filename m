Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab3KOFVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 00:21:32 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:40386 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab3KOFVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 00:21:21 -0500
X-AuditID: cbfee690-b7f3d6d000001c4a-ac-5285af4ae72d
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/5] f2fs: add a slab cache entry for small discards
Date: Fri, 15 Nov 2013 14:20:20 +0900
Message-id: <1384492824-32483-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t8zA12v9a1BBmsfiVpc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXHv1jqmgslyFWc3
	nmBqYHwr0cXIySEhYCLx6FM7C4QtJnHh3no2EFtIYBmjxP4LgjA1n090MHUxcgHFpzNKPLu2
	kQ3CaWaSWD/lF2sXIwcHm4C2xOb9BiANIgLMEgumnmcEqWEWmMAo8X/RexaQGmEBF4mvc/lA
	algEVCWeztzECmLzCrhL/D59gBlimbbEtucTwXolBO6zSSzqeMQI0SAg8W3yIbA5EgKyEptg
	6iUlDq64wTKBUXABI8MqRtHUguSC4qT0IhO94sTc4tK8dL3k/NxNjJAAnLCD8d4B60OMyUDj
	JjJLiSbnAwM4ryTe0NjMyMLUxNTYyNzSjDRhJXFetUdJQUIC6YklqdmpqQWpRfFFpTmpxYcY
	mTg4pRoY+/Li7MoD1PvvvHgmvIE1l2+miBb/3eeCC93YhTrk0tg8nuezf/fcUhe45/G3fY/v
	7X5yrJF58srOh/kZf57OEvaKidtw9ku8AadCfIPpq1XXizYec9r5/WOrcE2gxKcXPW3f2Z+L
	VGqt311j8Kr72EHbyZbu+nsmrLr2UX/STPetBUtyXjzarMRSnJFoqMVcVJwIAA2cAVVWAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jQV2v9a1BBi3PBSyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8y4d2sdU8FkuYqzG08wNTC+lehi5OSQEDCR+HyigwnCFpO4cG89WxcjF4eQ
	wHRGiWfXNkI5zUwS66f8Yu1i5OBgE9CW2LzfAKRBRIBZYsHU84wgNcwCExgl/i96zwJSIyzg
	IvF1Lh9IDYuAqsTTmZtYQWxeAXeJ36cPMEMs05bY9nwi4wRG7gWMDKsYRVMLkguKk9JzjfSK
	E3OLS/PS9ZLzczcxggP8mfQOxlUNFocYBTgYlXh4I6Rbg4RYE8uKK3MPMUpwMCuJ8D5LAArx
	piRWVqUW5ccXleakFh9iTAbaPpFZSjQ5Hxh9eSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1DhQS
	SE8sSc1OTS1ILYLZwsTBKdXAuPLKyfZ36SlKRz/In2WNmx41Zf/9fdwz3H+WeDBKzTwq8i4l
	8fSld+t3sxwq3bfr8S2l/pvxiupZh5os1hoxTVDfVbnNpG8Tw9aaR06qLft9V/XYqf5v1un9
	7PuS/9fRHeYztvem8S4Sf8oktOS+XA27YCn3FKMZb57y39FR6YzTWdY/vTB1phJLcUaioRZz
	UXEiAA0EN/q0AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a slab cache entry for small discards.

Each entry consists of:

struct discard_entry {
	struct list_head list;	/* list head */
	block_t blkaddr;	/* block address to be discarded */
	int len;		/* # of consecutive blocks of the discard */
};

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h    | 14 ++++++++++++++
 fs/f2fs/segment.c | 20 ++++++++++++++++++++
 fs/f2fs/super.c   |  7 ++++++-
 3 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 89dc750..c73e3df 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -97,6 +97,13 @@ struct dir_inode_entry {
 	struct inode *inode;	/* vfs inode pointer */
 };
 
+/* for the list of blockaddresses to be discarded */
+struct discard_entry {
+	struct list_head list;	/* list head */
+	block_t blkaddr;	/* block address to be discarded */
+	int len;		/* # of consecutive blocks of the discard */
+};
+
 /* for the list of fsync inodes, used only during recovery */
 struct fsync_inode_entry {
 	struct list_head list;	/* list head */
@@ -308,6 +315,11 @@ struct f2fs_sm_info {
 
 	/* a threshold to reclaim prefree segments */
 	unsigned int rec_prefree_segments;
+
+	/* for small discard management */
+	struct list_head discard_list;		/* 4KB discard list */
+	int nr_discards;			/* # of discards in the list */
+	int max_discards;			/* max. discards to be issued */
 };
 
 /*
@@ -1079,6 +1091,8 @@ int lookup_journal_in_cursum(struct f2fs_summary_block *,
 void flush_sit_entries(struct f2fs_sb_info *);
 int build_segment_manager(struct f2fs_sb_info *);
 void destroy_segment_manager(struct f2fs_sb_info *);
+int __init create_segment_manager_caches(void);
+void destroy_segment_manager_caches(void);
 
 /*
  * checkpoint.c
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 67f1e5b..823526e 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -22,6 +22,8 @@
 
 #define __reverse_ffz(x) __reverse_ffs(~(x))
 
+static struct kmem_cache *discard_entry_slab;
+
 /*
  * __reverse_ffs is copied from include/asm-generic/bitops/__ffs.h since
  * MSB and LSB are reversed in a byte by f2fs_set_bit.
@@ -1798,6 +1800,10 @@ int build_segment_manager(struct f2fs_sb_info *sbi)
 	sm_info->ssa_blkaddr = le32_to_cpu(raw_super->ssa_blkaddr);
 	sm_info->rec_prefree_segments = DEF_RECLAIM_PREFREE_SEGMENTS;
 
+	INIT_LIST_HEAD(&sm_info->discard_list);
+	sm_info->nr_discards = 0;
+	sm_info->max_discards = 0;
+
 	err = build_sit_info(sbi);
 	if (err)
 		return err;
@@ -1913,3 +1919,17 @@ void destroy_segment_manager(struct f2fs_sb_info *sbi)
 	sbi->sm_info = NULL;
 	kfree(sm_info);
 }
+
+int __init create_segment_manager_caches(void)
+{
+	discard_entry_slab = f2fs_kmem_cache_create("discard_entry",
+			sizeof(struct discard_entry), NULL);
+	if (!discard_entry_slab)
+		return -ENOMEM;
+	return 0;
+}
+
+void destroy_segment_manager_caches(void)
+{
+	kmem_cache_destroy(discard_entry_slab);
+}
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index bafff72..e9aa3f7 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1078,9 +1078,12 @@ static int __init init_f2fs_fs(void)
 	err = create_node_manager_caches();
 	if (err)
 		goto free_inodecache;
-	err = create_gc_caches();
+	err = create_segment_manager_caches();
 	if (err)
 		goto free_node_manager_caches;
+	err = create_gc_caches();
+	if (err)
+		goto free_segment_manager_caches;
 	err = create_checkpoint_caches();
 	if (err)
 		goto free_gc_caches;
@@ -1102,6 +1105,8 @@ free_checkpoint_caches:
 	destroy_checkpoint_caches();
 free_gc_caches:
 	destroy_gc_caches();
+free_segment_manager_caches:
+	destroy_segment_manager_caches();
 free_node_manager_caches:
 	destroy_node_manager_caches();
 free_inodecache:
-- 
1.8.4.474.g128a96c

