Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab3KOFVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 00:21:37 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:40386 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab3KOFVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 00:21:23 -0500
X-AuditID: cbfee690-b7f3d6d000001c4a-ad-5285af4a16bb
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/5] f2fs: add key functions for small discards
Date: Fri, 15 Nov 2013 14:20:21 +0900
Message-id: <1384492824-32483-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1384492824-32483-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1384492824-32483-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t8zA12v9a1BBpfaZSyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyrjY8oCl4IZsRdfE
	v0wNjMckuhg5OSQETCTmHvrHDGGLSVy4t56ti5GLQ0hgGaPEjydzmGCKnndshUpMZ5R437WV
	CcJpZpJYP+UXaxcjBwebgLbE5v0GIA0iAswSC6aeZwSpYRaYwCjxf9F7FpAaYQF7iaf3pUFq
	WARUJW7O72QEsXkF3CW656xnhVimLbHt+USwOKeAh0TnxBNg1wkB1VxaNIkdZKaEwHc2iWMT
	/7NBDBKQ+Db5ENh8CQFZiU0HoL6RlDi44gbLBEbhBYwMqxhFUwuSC4qT0otM9IoTc4tL89L1
	kvNzNzFCQnbCDsZ7B6wPMSYDjZvILCWanA8M+bySeENjMyMLUxNTYyNzSzPShJXEedUeJQUJ
	CaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYORh1F611uNSwFf2NN1ixy0rc9bI9877duzQ2rRj
	IQ6neG9+P1XmJXvE93mJ15vX1WsTaxkMZkR/mKvJMWfBK/+Ztt/O/6ha2/Leb5/owsMbrDdY
	HZjO9i15BZdSyQ2/6EOTX4kqNPMbbWxZdt1kglJpmWo76/+O25+y2Wr2/MuS+Op4Zbr64hAl
	luKMREMt5qLiRACODOtcbwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jQV2v9a1BBi97JSyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8y42PKApeCGbEXXxL9MDYzHJLoYOTkkBEwknndsZYOwxSQu3FsPZHNxCAlM
	Z5R437WVCcJpZpJYP+UXaxcjBwebgLbE5v0GIA0iAswSC6aeZwSpYRaYwCjxf9F7FpAaYQF7
	iaf3pUFqWARUJW7O72QEsXkF3CW656xnhVimLbHt+USwOKeAh0TnxBPMILYQUM2lRZPYJzDy
	LmBkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHBHPpHcwrmqwOMQowMGoxMMbId0aJMSa
	WFZcmXuIUYKDWUmE91kCUIg3JbGyKrUoP76oNCe1+BBjMtBVE5mlRJPzgdGaVxJvaGxiZmRp
	ZGZhZGJuTpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MBV6qIZGzLbamdHDL7uW//6nU
	3fT9uZbFSZlpJZHlkQUX7kax/daZztzM5BJ7Uu/iv5kfGhbseLD+Q+6q3ysrj0tbLnqzYU/6
	qf1zsguZG1tOvd4TK6yv9+ngntP81dNmzJP8MG3HWb+cSdc4c36LcfR/2J77/8gDP7Efh+6u
	OZ+++nZxXJ9KlRJLcUaioRZzUXEiAMMtjXfMAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds key functions to activate the small discard feature.

Note that this procedure is conducted during the checkpoint only.

In flush_sit_entries(), when a new dirty sit entry is flushed, f2fs calls
add_discard_addrs() which searches candidates to be discarded.
The candidates should be marked *invalidated* and also previous checkpoint
recognizes it as *valid*.

At the end of a checkpoint procedure, f2fs throws discards based on the
discard entry list.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/segment.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 823526e..505a889 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -266,6 +266,47 @@ static void locate_dirty_segment(struct f2fs_sb_info *sbi, unsigned int segno)
 	mutex_unlock(&dirty_i->seglist_lock);
 }
 
+static void add_discard_addrs(struct f2fs_sb_info *sbi,
+			unsigned int segno, struct seg_entry *se)
+{
+	struct list_head *head = &SM_I(sbi)->discard_list;
+	struct discard_entry *new;
+	int entries = SIT_VBLOCK_MAP_SIZE / sizeof(unsigned long);
+	int max_blocks = sbi->blocks_per_seg;
+	unsigned long *cur_map = (unsigned long *)se->cur_valid_map;
+	unsigned long *ckpt_map = (unsigned long *)se->ckpt_valid_map;
+	unsigned long dmap[entries];
+	unsigned int start = 0, end = -1;
+	int i;
+
+	if (!test_opt(sbi, DISCARD))
+		return;
+
+	/* zero block will be discarded through the prefree list */
+	if (!se->valid_blocks || se->valid_blocks == max_blocks)
+		return;
+
+	/* SIT_VBLOCK_MAP_SIZE should be multiple of sizeof(unsigned long) */
+	for (i = 0; i < entries; i++)
+		dmap[i] = (cur_map[i] ^ ckpt_map[i]) & ckpt_map[i];
+
+	while (SM_I(sbi)->nr_discards <= SM_I(sbi)->max_discards) {
+		start = __find_rev_next_bit(dmap, max_blocks, end + 1);
+		if (start >= max_blocks)
+			break;
+
+		end = __find_rev_next_zero_bit(dmap, max_blocks, start + 1);
+
+		new = f2fs_kmem_cache_alloc(discard_entry_slab, GFP_NOFS);
+		INIT_LIST_HEAD(&new->list);
+		new->blkaddr = START_BLOCK(sbi, segno) + start;
+		new->len = end - start;
+
+		list_add_tail(&new->list, head);
+		SM_I(sbi)->nr_discards += end - start;
+	}
+}
+
 /*
  * Should call clear_prefree_segments after checkpoint is done.
  */
@@ -288,6 +329,9 @@ static void set_prefree_as_free_segments(struct f2fs_sb_info *sbi)
 
 void clear_prefree_segments(struct f2fs_sb_info *sbi)
 {
+	struct list_head *head = &(SM_I(sbi)->discard_list);
+	struct list_head *this, *next;
+	struct discard_entry *entry;
 	struct dirty_seglist_info *dirty_i = DIRTY_I(sbi);
 	unsigned long *prefree_map = dirty_i->dirty_segmap[PRE];
 	unsigned int total_segs = TOTAL_SEGS(sbi);
@@ -318,6 +362,18 @@ void clear_prefree_segments(struct f2fs_sb_info *sbi)
 				GFP_NOFS, 0);
 	}
 	mutex_unlock(&dirty_i->seglist_lock);
+
+	/* send small discards */
+	list_for_each_safe(this, next, head) {
+		entry = list_entry(this, struct discard_entry, list);
+		blkdev_issue_discard(sbi->sb->s_bdev,
+				entry->blkaddr << sbi->log_sectors_per_block,
+				(1 << sbi->log_sectors_per_block) * entry->len,
+				GFP_NOFS, 0);
+		list_del(&entry->list);
+		SM_I(sbi)->nr_discards -= entry->len;
+		kmem_cache_free(discard_entry_slab, entry);
+	}
 }
 
 static void __mark_sit_entry_dirty(struct f2fs_sb_info *sbi, unsigned int segno)
@@ -1469,6 +1525,10 @@ void flush_sit_entries(struct f2fs_sb_info *sbi)
 
 		sit_offset = SIT_ENTRY_OFFSET(sit_i, segno);
 
+		/* add discard candidates */
+		if (SM_I(sbi)->nr_discards < SM_I(sbi)->max_discards)
+			add_discard_addrs(sbi, segno, se);
+
 		if (flushed)
 			goto to_sit_page;
 
-- 
1.8.4.474.g128a96c

