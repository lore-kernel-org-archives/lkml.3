Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162700AbaDCI5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 04:57:38 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:59446 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162584AbaDCI5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 04:57:32 -0400
X-AuditID: cbfee68f-b7f156d00000276c-34-533d226286b0
From: Heesub Shin <heesub.shin@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Heesub Shin <heesub.shin@samsung.com>,
        Dongjun Shin <d.j.shin@samsung.com>,
        Sunghwan Yun <sunghwan.yun@samsung.com>
Subject: [PATCH 2/2] mm/compaction: fix to initialize free scanner properly
Date: Thu, 03 Apr 2014 17:57:04 +0900
Message-id: <1396515424-18794-2-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <1396515424-18794-1-git-send-email-heesub.shin@samsung.com>
References: <1396515424-18794-1-git-send-email-heesub.shin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t8zHd0kJdtggye/tC3mrF/DZnHiYq3F
	wdlLmCwu75rDZnFvzX9Wi8nvnjFanO5YxOrA7rHp0yR2jxMzfrN49G1Zxeix+XS1x+dNcgGs
	UVw2Kak5mWWpRfp2CVwZ7bM3MxXs5qz4OuccSwPjB/YuRk4OCQETiWXLjzFB2GISF+6tZ+ti
	5OIQEljGKDFj5SSgIg6wom/vYyHi0xkl1vb0skM47UwS3/8uYQUpYhPQlji0LRhkkIiArsSq
	57uYQWqYBU4zSkzuuMYKkhAW8JboWHiaGcRmEVCVeN11nQXE5hVwl9jzYQHUFQoSy76sBavh
	FPCQeP1gNlivEFDN51PzWSFq5rFLTHxQADFHQOLb5EMsEIfKSmw6wAxRIilxcMUNlgmMwgsY
	GVYxiqYWJBcUJ6UXGesVJ+YWl+al6yXn525ihAR4/w7GuwesDzEmA42byCwlmpwPjJC8knhD
	YzMjC1MTU2Mjc0sz0oSVxHnvP0wKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDo9ZF9usZM
	sQU3tLvWP5CS3G+pajP1/sL1ARys372S++a1mh7LnSlXdG7SLPOW9f3ND08tcz7MV1USk8ye
	s/L7mg1bO9umJt13ZkqIXb7yjotDzOX5b5rc7rOZ5e3qlaj+kz3jg3BS9LnXVh4qkycI3//+
	4OZU37t7PUK92nlTV/ZJlZi/5eZVYinOSDTUYi4qTgQAE+rrF4YCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jQd0kJdtgg6W7NSzmrF/DZnHiYq3F
	wdlLmCwu75rDZnFvzX9Wi8nvnjFanO5YxOrA7rHp0yR2jxMzfrN49G1Zxeix+XS1x+dNcgGs
	UQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAVygp
	lCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM9pnb2Yq2M1Z8XXOOZYGxg/s
	XYwcHBICJhLf3sd2MXICmWISF+6tZ+ti5OIQEpjOKLG2p5cdwmlnkvj+dwkrSAObgLbEoW3B
	IA0iAroSq57vYgapYRY4zSgxueMaK0hCWMBbomPhaWYQm0VAVeJ113UWEJtXwF1iz4cFTBDb
	FCSWfVkLVsMp4CHx+sFssF4hoJrPp+azTmDkXcDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/
	dxMjOIKeSe1gXNlgcYhRgINRiYfXQsomWIg1say4MvcQowQHs5II78UvQCHelMTKqtSi/Pii
	0pzU4kOMyUBXTWSWEk3OB0Z3Xkm8obGJmZGlkZmxibmxMWnCSuK8B1qtA4UE0hNLUrNTUwtS
	i2C2MHFwSjUw+r19cH/Wgu+8oZW21469rVZ1WsPw4H53leJRxs0hipUrJ8UrXDLMcnwS+v/9
	gatFUsvUdpmVJLTGbliTyB/AfO7vi+oQ56vr41don4jeFbUmR/Nc1+P7p4WybfLXtH7xv7f1
	Wwp/rmOt875JRnUzFvGzaxfuthPJ+Bnt+jhD4/fviWYCvCKvlFiKMxINtZiLihMB3Ey0MuQC	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free scanner does not works well on systems having zones which do not
span to pageblock-aligned boundary.

zone->compact_cached_free_pfn is reset when the migration and free
scanner across or compaction restarts. After the reset, if end_pfn of
the zone was not aligned to pageblock_nr_pages, free scanner tries to
isolate free pages from the middle of pageblock to the end, which can
be very small range.

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
Cc: Dongjun Shin <d.j.shin@samsung.com>
Cc: Sunghwan Yun <sunghwan.yun@samsung.com>
---
 mm/compaction.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 1ef9144..fefe1da 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -983,7 +983,7 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 	 */
 	cc->migrate_pfn = zone->compact_cached_migrate_pfn;
 	cc->free_pfn = zone->compact_cached_free_pfn;
-	if (cc->free_pfn < start_pfn || cc->free_pfn > end_pfn) {
+	if (cc->free_pfn < start_pfn || cc->free_pfn >= end_pfn) {
 		cc->free_pfn = end_pfn & ~(pageblock_nr_pages-1);
 		zone->compact_cached_free_pfn = cc->free_pfn;
 	}
-- 
1.8.3.2

