Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637AbaCSA0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 20:26:19 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10725 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354AbaCSA0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 20:26:15 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-96-5328e425eeea
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/5] f2fs: avoid small data writes by skipping writepages
Date: Wed, 19 Mar 2014 09:24:22 +0900
Message-id: <1395188665-4175-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1395188665-4175-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1395188665-4175-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t8zA13VJxrBBj/m6Vlc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlfH8XSNjwTSZiqmP
	vjM2MHaIdzFyckgImEhs2HuaDcIWk7hwbz2QzcUhJLCMUaK59SMrTNH0JxehEosYJbou/2GB
	cDqZJO7NXwDkcHCwCWhLbN5vANIgIsAssWDqeUaQGmaBCYwS/xe9ZwFJCAt4Shz4cQlsKouA
	qsSMnqfsIDavgJtE58n7LBDbtCW2PZ/ICGJzCrhLfLl7BiwuBFSz6/VxJpChEgLf2SQ+tMxk
	hhgkIPFt8iGwIyQEZCU2HWCGmCMpcXDFDZYJjMILGBlWMYqmFiQXFCelF5nqFSfmFpfmpesl
	5+duYoQE7cQdjPcPWB9iTAYaN5FZSjQ5Hxj0eSXxhsZmRhamJqbGRuaWZqQJK4nzpj9KChIS
	SE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAOF1y0SHVeclCZi9bCvn2+a3eUn55kneyVsDTz4ee
	3Qh4KcSX0bX5Zq5gfc3Fxbabzrm/46iYuG07n2LKV6O/v7+G2iy0frjix/8s4Qvh2Wclwvjt
	7+gdXszz5+b5h+cmLc441ybXcs10Bnva1VsV59y3Z0/P0T2beIF36aSPM1XLfogp7mZ9lajE
	UpyRaKjFXFScCABwHaFwcAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jAV3VJxrBBg+atSyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8x4/q6RsWCaTMXUR98ZGxg7xLsYOTkkBEwkpj+5yAZhi0lcuLceyObiEBJY
	xCjRdfkPC4TTySRxb/4CIIeDg01AW2LzfgOQBhEBZokFU88zgtQwC0xglPi/6D0LSEJYwFPi
	wI9LrCA2i4CqxIyep+wgNq+Am0TnyfssENu0JbY9n8gIYnMKuEt8uXsGLC4EVLPr9XGmCYy8
	CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEx8Qz6R2MqxosDjEKcDAq8fAeiNIIFmJN
	LCuuzD3EKMHBrCTCK3wXKMSbklhZlVqUH19UmpNafIgxGeiqicxSosn5wHjNK4k3NDYxM7I0
	MrMwMjE3J01YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQZGT4ZZQg5lS9Yxuh68Pincu68j
	2NUtbcM1S/srV07usjnZq2bW98rKpWty+oPMKG7FFRrTWybVG6+5l/8tWNjIXqk0dcdEi6jv
	rLN7Lsb2cEn37H41OTLrU+D6uSE5m+9/8/kudcHzM+d/33vc4aVuigFfsxV6O1i4+R4etRBc
	sbOlLuWEw3QlluKMREMt5qLiRAApEZOfzQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces nr_pages_to_skip(sbi, type) to determine writepages can
be skipped.
The dentry, node, and meta pages can be conrolled by F2FS without breaking the
FS consistency.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/checkpoint.c |  4 ++--
 fs/f2fs/data.c       |  4 ++++
 fs/f2fs/node.c       |  8 +-------
 fs/f2fs/segment.h    | 19 +++++++++++++++++++
 4 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 4c0e98d..1f52b70 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -187,7 +187,7 @@ static int f2fs_write_meta_pages(struct address_space *mapping,
 				struct writeback_control *wbc)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(mapping->host->i_sb);
-	int nrpages = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
+	int nrpages = nr_pages_to_skip(sbi, META);
 	long written;
 
 	if (wbc->for_kupdate)
@@ -682,7 +682,7 @@ retry:
 	inode = igrab(entry->inode);
 	spin_unlock(&sbi->dir_inode_lock);
 	if (inode) {
-		filemap_flush(inode->i_mapping);
+		filemap_fdatawrite(inode->i_mapping);
 		iput(inode);
 	} else {
 		/*
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 101b4cd..e3b7cfa 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -868,6 +868,10 @@ static int f2fs_write_data_pages(struct address_space *mapping,
 	if (!mapping->a_ops->writepage)
 		return 0;
 
+	if (S_ISDIR(inode->i_mode) && wbc->sync_mode == WB_SYNC_NONE &&
+			get_dirty_dents(inode) < nr_pages_to_skip(sbi, DATA))
+		return 0;
+
 	if (wbc->nr_to_write < MAX_DESIRED_PAGES_WP) {
 		desired_nrtw = MAX_DESIRED_PAGES_WP;
 		excess_nrtw = desired_nrtw - wbc->nr_to_write;
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 3e36240..cb514f1 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1198,12 +1198,6 @@ redirty_out:
 	return AOP_WRITEPAGE_ACTIVATE;
 }
 
-/*
- * It is very important to gather dirty pages and write at once, so that we can
- * submit a big bio without interfering other data writes.
- * Be default, 512 pages (2MB) * 3 node types, is more reasonable.
- */
-#define COLLECT_DIRTY_NODES	1536
 static int f2fs_write_node_pages(struct address_space *mapping,
 			    struct writeback_control *wbc)
 {
@@ -1214,7 +1208,7 @@ static int f2fs_write_node_pages(struct address_space *mapping,
 	f2fs_balance_fs_bg(sbi);
 
 	/* collect a number of dirty node pages and write together */
-	if (get_pages(sbi, F2FS_DIRTY_NODES) < COLLECT_DIRTY_NODES)
+	if (get_pages(sbi, F2FS_DIRTY_NODES) < nr_pages_to_skip(sbi, NODE))
 		return 0;
 
 	/* if mounting is failed, skip writing node pages */
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index c3d5e36..bbd9761 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -664,3 +664,22 @@ static inline unsigned int max_hw_blocks(struct f2fs_sb_info *sbi)
 	struct request_queue *q = bdev_get_queue(bdev);
 	return SECTOR_TO_BLOCK(sbi, queue_max_sectors(q));
 }
+
+/*
+ * It is very important to gather dirty pages and write at once, so that we can
+ * submit a big bio without interfering other data writes.
+ * By default, 512 pages for directory data,
+ * 512 pages (2MB) * 3 for three types of nodes, and
+ * max_bio_blocks for meta are set.
+ */
+static inline int nr_pages_to_skip(struct f2fs_sb_info *sbi, int type)
+{
+	if (type == DATA)
+		return sbi->blocks_per_seg;
+	else if (type == NODE)
+		return 3 * sbi->blocks_per_seg;
+	else if (type == META)
+		return MAX_BIO_BLOCKS(max_hw_blocks(sbi));
+	else
+		return 0;
+}
-- 
1.8.4.474.g128a96c

