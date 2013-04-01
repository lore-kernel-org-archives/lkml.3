Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab3DAG6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:58:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:62386 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757966Ab3DAG5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:57:00 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-9e-51592fb91a3e
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 4/9] f2fs: allocate new segment aligned with sections
Date: Mon, 01 Apr 2013 15:55:55 +0900
Message-id: <1364799360-23145-4-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1364799360-23145-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1364799360-23145-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t8zfd2d+pGBBreei1hc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXFy1gKWgla2inN7
	DzE2MH5h6WLk5JAQMJE4uf0OM4QtJnHh3no2EFtIYBmjxK5bHl2MHGA1284XdzFyAYUXMUpc
	3fGBHcJpY5K4dHUTG0gRm4C2xOb9BiC9IgLMEgumnmcEqWEWmMAo8X/Re7BlwgKuEucv/Aar
	ZxFQleg/zQkS5hVwl9i3+SQ7xA26Eqv/PwezOQU8JD63fWSBuMdd4tS+1WwgMyUEvrNJTG5d
	ApZgERCQ+Db5EAvEobISmw5A/SIpcXDFDZYJjMILGBlWMYqmFiQXFCelFxnrFSfmFpfmpesl
	5+duYoSEa/8OxrsHrA8xJgONm8gsJZqcDwz3vJJ4Q2MzIwtTE1NjI3NLM9KElcR51VqsA4UE
	0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwnrIIr7htl+66+esViY+RF51Y1W7ssZFra0pPqiz7
	orHZWTu6vL32t0ftjOP77hW8f18TcSqld87eJwHzCm2MeVm4dv23cg/5/L4tU/TS7guC0oYi
	b5tOZXS4HC9bPPfyl/Xay7ReVPy0qjn+IvjhueZmPpXUma9DW970b+RhKHUKu338dKqIEktx
	RqKhFnNRcSIAgwD9Nm0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jAd2d+pGBBlv7BC2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8w4OWsBS0ErW8W5vYcYGxi/sHQxcnBICJhIbDtf3MXICWSKSVy4t56ti5GL
	Q0hgEaPE1R0f2CGcNiaJS1c3sYE0sAloS2zebwDSICLALLFg6nlGkBpmgQmMEv8XvWcBSQgL
	uEqcv/AbrJ5FQFWi/zQnSJhXwF1i3+aT7BDLdCVW/38OZnMKeEh8bvsI1ioEVHNq32q2CYy8
	CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEx8Mz6R2MqxosDjEKcDAq8fBGXIgIFGJN
	LCuuzD3EKMHBrCTC6/MNKMSbklhZlVqUH19UmpNafIgxGeioicxSosn5wFjNK4k3NDYxM7I0
	MrMwMjE3J01YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQbG9boP5xzdb/ql5NHKjVLO5zxj
	lC5wS652Fg/ZvHBd1YytxtcW959562fUF/g7Lvq6pvy/Nzv2ZPKfzRWxeHX1y78wI0OX11cv
	TH1wL8/h1AFx826W2odT9ipLlrsEv9CxPL5DLnERZ2be5O3BZza3mn9YnHrnc/wHvgIm+yfX
	mT8pPGHavWHTNSWW4oxEQy3mouJEAOvaR+nLAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When allocating a new segment under the LFS mode, we should keep the section
boundary.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/segment.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 179a13e..b3486f3 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -362,7 +362,8 @@ static void get_new_segment(struct f2fs_sb_info *sbi,
 	if (!new_sec && ((*newseg + 1) % sbi->segs_per_sec)) {
 		segno = find_next_zero_bit(free_i->free_segmap,
 					TOTAL_SEGS(sbi), *newseg + 1);
-		if (segno < TOTAL_SEGS(sbi))
+		if (segno - *newseg < sbi->segs_per_sec -
+					(*newseg % sbi->segs_per_sec))
 			goto got_it;
 	}
 find_other_zone:
-- 
1.8.1.3.566.gaa39828

