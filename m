Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147Ab3KOFW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 00:22:27 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:40386 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab3KOFV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 00:21:27 -0500
X-AuditID: cbfee690-b7f3d6d000001c4a-b1-5285af4a57f5
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 4/5] f2fs: introduce f2fs_issue_discard() to clean up
Date: Fri, 15 Nov 2013 14:20:23 +0900
Message-id: <1384492824-32483-4-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1384492824-32483-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1384492824-32483-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t8zA12v9a1BBo/eqltc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlTFx5nvGgjX8FRvu
	rWFuYHzE08XIwSEhYCLx85lpFyMnkCkmceHeerYuRi4OIYFljBK31i5lhkiYSLzcuJMFIjGd
	UeLGkztMEE4zk8T6Kb9YQSaxCWhLbN5vANIgIsAssWDqeUaQGmaBCYwS/xe9ZwFJCAu4Spxv
	f88IYrMIqEps+vgcbAOvgLtE+6rLLBDbtCW2PZ8IVsMp4CHROfEEWI0QUM2lRZPYQYZKCHxn
	k/i2eC4bxCABiW+TD7FAvCMrsekA1NWSEgdX3GCZwCi8gJFhFaNoakFyQXFSepGJXnFibnFp
	Xrpecn7uJkZIyE7YwXjvgPUhxmSgcROZpUST84Ehn1cSb2hsZmRhamJqbGRuaUaasJI4r9qj
	pCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjAsPbvYu+PZDZFr42U9K75vW3p14eMKD8xc1
	Cl54d0vs2RRx1bbs3YawLom2LdWZPMc+bOTgSWsUl3F6ceTbqacL551uFNdbPevkgU1va4s/
	8txr2TR3o//dYqtUtTsnkqZMvpe2b39jvTKnVUmikKmjfHRhhMDihZ/6OdiL1+z8Izz7grZi
	DpsSS3FGoqEWc1FxIgBJkD4qbwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jQV2v9a1BBvNXqVhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5gxceZ7xoI1/BUb7q1hbmB8xNPFyMkhIWAi8XLjThYIW0ziwr31bF2MXBxC
	AtMZJW48ucME4TQzSayf8ou1i5GDg01AW2LzfgOQBhEBZokFU88zgtQwC0xglPi/6D3YJGEB
	V4nz7e8ZQWwWAVWJTR+fM4PYvALuEu2rLkNt05bY9nwiWA2ngIdE58QTYDVCQDWXFk1in8DI
	u4CRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcEw8k97BuKrB4hCjAAejEg9vhHRrkBBr
	YllxZe4hRgkOZiUR3mcJQCHelMTKqtSi/Pii0pzU4kOMyUBXTWSWEk3OB8ZrXkm8obGJmZGl
	kZmFkYm5OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwrq9aU2TeGimfW1DuczXk1Xy1
	X79tWzyzxLOPnox4/HuLoKn6Bp2LR103eba5HJNVrK2a1hsYYuR34bLFbdM5Jz2vnw+9HCxQ
	+aBf7pPer/0Z4Wf/73u3aUbDbgv3W3U6QY93FLrJJS20VVjIzrt3t6/SjelbJsz7dOoZQ9mC
	MFn3dN7WA5fuKrEUZyQaajEXFScCAKa+aVXNAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds f2fs_issue_discard() to clean up blkdev_issue_discard() flows.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/segment.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 505a889..d021cf3 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -266,6 +266,16 @@ static void locate_dirty_segment(struct f2fs_sb_info *sbi, unsigned int segno)
 	mutex_unlock(&dirty_i->seglist_lock);
 }
 
+static void f2fs_issue_discard(struct f2fs_sb_info *sbi,
+				block_t blkstart, block_t blklen)
+{
+	sector_t sector_addr = blkstart << sbi->log_sectors_per_block;
+	sector_t sector_len = blklen << sbi->log_sectors_per_block;
+
+	blkdev_issue_discard(sbi->sb->s_bdev, sector_addr, sector_len,
+							GFP_NOFS, 0);
+}
+
 static void add_discard_addrs(struct f2fs_sb_info *sbi,
 			unsigned int segno, struct seg_entry *se)
 {
@@ -354,22 +364,15 @@ void clear_prefree_segments(struct f2fs_sb_info *sbi)
 		if (!test_opt(sbi, DISCARD))
 			continue;
 
-		blkdev_issue_discard(sbi->sb->s_bdev,
-				START_BLOCK(sbi, start) <<
-				sbi->log_sectors_per_block,
-				(1 << (sbi->log_sectors_per_block +
-				sbi->log_blocks_per_seg)) * (end - start),
-				GFP_NOFS, 0);
+		f2fs_issue_discard(sbi, START_BLOCK(sbi, start),
+				(end - start) << sbi->log_blocks_per_seg);
 	}
 	mutex_unlock(&dirty_i->seglist_lock);
 
 	/* send small discards */
 	list_for_each_safe(this, next, head) {
 		entry = list_entry(this, struct discard_entry, list);
-		blkdev_issue_discard(sbi->sb->s_bdev,
-				entry->blkaddr << sbi->log_sectors_per_block,
-				(1 << sbi->log_sectors_per_block) * entry->len,
-				GFP_NOFS, 0);
+		f2fs_issue_discard(sbi, entry->blkaddr, entry->len);
 		list_del(&entry->list);
 		SM_I(sbi)->nr_discards -= entry->len;
 		kmem_cache_free(discard_entry_slab, entry);
-- 
1.8.4.474.g128a96c

