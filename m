Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab3KOFWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 00:22:04 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:40386 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151Ab3KOFV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 00:21:29 -0500
X-AuditID: cbfee690-b7f3d6d000001c4a-b3-5285af4a98cc
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 5/5] f2fs: add a tracepoint for f2fs_issue_discard
Date: Fri, 15 Nov 2013 14:20:24 +0900
Message-id: <1384492824-32483-5-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1384492824-32483-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1384492824-32483-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t8zA12v9a1BBrM6tCyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyjiw9i9jwR6eiq4F
	j1kbGNdydTFyckgImEhc/D2LDcIWk7hwbz2QzcUhJLCMUWLD07ssMEUbPp0Fs4UEpjNK3P9W
	BVHUzCSxfsov1i5GDg42AW2JzfsNQGpEBJglFkw9zwhSwywwgVHi/6L3LCA1wgJOEmvf5YHU
	sAioSiycs4cJxOYVcJe48eA11C5tiW3PJzKC2JwCHhKdE08wQ+x1l7i0aBI7yEwJge9sEhu6
	u9ghBglIfJt8CGy+hICsxKYDzBBzJCUOrrjBMoFReAEjwypG0dSC5ILipPQiE73ixNzi0rx0
	veT83E2MkICdsIPx3gHrQ4zJQOMmMkuJJucDAz6vJN7Q2MzIwtTE1NjI3NKMNGElcV61R0lB
	QgLpiSWp2ampBalF8UWlOanFhxiZODilGhhFL/nOXBy6V114wqvOe7NYBRfKJQW0b7+30v34
	82lcEVLWQXMc9XIeF31zUV0Uf3rNlbSz177VlBv+1i/R65KSPrSgWoxX9KQ932PT+jcRlo0z
	fRR2n84T/PMlM/jv9+2H8zX+iTWn+lauXJrRftEg1ny+y7ZbDLteqr8I5ypK6ctwvRPD8UaJ
	pTgj0VCLuag4EQAN48rEbgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jQV2v9a1BBuueqFlc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5hxYO1fxoI9PBVdCx6zNjCu5epi5OSQEDCR2PDpLAuELSZx4d56NhBbSGA6
	o8T9b1VdjFxAdjOTxPopv1i7GDk42AS0JTbvNwCpERFgllgw9TwjSA2zwARGif+L3rOA1AgL
	OEmsfZcHUsMioCqxcM4eJhCbV8Bd4saD11C7tCW2PZ/ICGJzCnhIdE48wQyx113i0qJJ7BMY
	eRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI6HZ9I7GFc1WBxiFOBgVOLhjZBuDRJi
	TSwrrsw9xCjBwawkwvssASjEm5JYWZValB9fVJqTWnyIMRnoqonMUqLJ+cBYzSuJNzQ2MTOy
	NDKzMDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGxmLedSGKdSHr/l1WWMatfnK9
	T1zsnOTvNe+btzJesTWf32nQvMuqIvzJxf3WnZ88bP2c+/+UnDfpfinIzz6Nb9v9lUZPMtSk
	VGbmG31d331ugaOrS/K9u7KrA/l29idWLN/ktCg4+v59henBGzRmMB+NCXv0Nf+g1807x2zn
	3biuP/PzN838EiWW4oxEQy3mouJEAG6H26DLAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a tracepoint for f2fs_issue_discard.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/segment.c           |  1 +
 include/trace/events/f2fs.h | 23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index d021cf3..1f83999 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -274,6 +274,7 @@ static void f2fs_issue_discard(struct f2fs_sb_info *sbi,
 
 	blkdev_issue_discard(sbi->sb->s_bdev, sector_addr, sector_len,
 							GFP_NOFS, 0);
+	trace_f2fs_issue_discard(sbi->sb, blkstart, blklen);
 }
 
 static void add_discard_addrs(struct f2fs_sb_info *sbi,
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index e0dc355..47ee70d 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -727,6 +727,29 @@ TRACE_EVENT(f2fs_write_checkpoint,
 		__entry->msg)
 );
 
+TRACE_EVENT(f2fs_issue_discard,
+
+	TP_PROTO(struct super_block *sb, block_t blkstart, block_t blklen),
+
+	TP_ARGS(sb, blkstart, blklen),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(block_t, blkstart)
+		__field(block_t, blklen)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->blkstart = blkstart;
+		__entry->blklen = blklen;
+	),
+
+	TP_printk("dev = (%d,%d), blkstart = 0x%llx, blklen = 0x%llx",
+		show_dev(__entry),
+		(unsigned long long)__entry->blkstart,
+		(unsigned long long)__entry->blklen)
+);
 #endif /* _TRACE_F2FS_H */
 
  /* This part must be outside protection */
-- 
1.8.4.474.g128a96c

