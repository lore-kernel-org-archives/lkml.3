Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967016Ab3HIAo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 20:44:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:51619 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966931Ab3HIAo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 20:44:58 -0400
X-AuditID: cbfee68f-b7f436d000000f81-18-52043b86b3cc
From: Joonyoung Shim <jy0922.shim@samsung.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, liuj97@gmail.com,
        kosaki.motohiro@gmail.com, b.zolnierkie@samsung.com
Subject: [PATCH v2] Revert
 "mm/memory-hotplug: fix lowmem count overflow when offline pages"
Date: Fri, 09 Aug 2013 09:44:52 +0900
Message-id: <1376009092-9676-1-git-send-email-jy0922.shim@samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsWyRsSkWLfNmiXI4NxhQYs569ewWWycsZ7V
	4tkWbovLu+awWdxb85/VovnIRiYHNo+ds+6ye2z6NInd48SM3ywefVtWMXp83iQXwBrFZZOS
	mpNZllqkb5fAlXFugkLBPK6Kkz8msTYwnuToYuTkkBAwkbj54BgzhC0mceHeerYuRi4OIYGl
	jBKb/+5igyl63/CJGSKxiFFi2YNfLBBOK5PEu+W72EGq2AT0JO5sO84EYosAjfp45jJYB7NA
	C6PE7v8rwEYJC8RJHLwEsoODg0VAVWJtRy2IySvgJvHxuyHEMgWJn5dPgF0hIfCdTeLV6alg
	81kEBCS+TT7EAlIvISArsekA1NWSEgdX3GCZwCi4gJFhFaNoakFyQXFSepGxXnFibnFpXrpe
	cn7uJkZgoJ7+96x/B+PdA9aHGJOBxk1klhJNzgcGel5JvKGxmZGFqYmpsZG5pRlpwkrivGot
	1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGKfc/iRj9OGJmf21g7Pk3F59lZV0/C93poax
	XvJH4qw7HO8YlkZ2CQY1XZrUsVIpxsnuh9fkkpc/AySeVxj9KjjJ/rMlvmDVJMOtT+p0eu2d
	L9ZnV1jNE8sK5PQ41PU6eH9q/KUJxvUV7+bbK/9Q2iPyKESwnr13oRf7E2/hOdIvXq/W4Xmx
	X4mlOCPRUIu5qDgRAIujhGhqAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t9jAd02a5YggwVTWS3mrF/DZrFxxnpW
	i2dbuC0u75rDZnFvzX9Wi+YjG5kc2Dx2zrrL7rHp0yR2jxMzfrN49G1ZxejxeZNcAGtUA6NN
	RmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtAFSgpliTml
	QKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMcxMUCuZxVZz8MYm1gfEkRxcjJ4eE
	gInE+4ZPzBC2mMSFe+vZuhi5OIQEFjFKLHvwiwXCaWWSeLd8FztIFZuAnsSdbceZQGwRoI6P
	Zy4zgxQxC7QwSuz+v4INJCEsECdx8BLIKA4OFgFVibUdtSAmr4CbxMfvhhDLFCR+Xj7BNoGR
	ewEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Dh4Jr2DcVWDxSFGAQ5GJR5exe3MQUKs
	iWXFlbmHGCU4mJVEeF9kAYV4UxIrq1KL8uOLSnNSiw8xJgPtnsgsJZqcD4zRvJJ4Q2MTMyNL
	I3NDCyNjc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpg5Dv281+lksc35kfXObY4/+/y
	yHX5l+yqx7FnhcX5M6ftNR2+Mqyofny56NWnwLBDldddl0ifuOp84tmN/xc+3dB4/EqF91yd
	l/+++IvLFC/+ZJXd61JjNP1ZkOM5V8spe0vq+Gy/Ct1TmZtz+wp/ipeYqMtNOT2+E+fvt35a
	8/NAeZPuh208z5RYijMSDbWYi4oTAcCM7VfHAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit cea27eb2a202959783f81254c48c250ddd80e129
("mm/memory-hotplug: fix lowmem count overflow when offline pages").

The fixed bug by commit cea27eb was fixed to another way by commit
3dcc057 ("mm: correctly update zone->managed_pages"). The commit 3dcc057
enhances memory_hotplug.c to adjust totalhigh_pages when hot-removing
memory, for details please refer to:
http://marc.info/?l=linux-mm&m=136957578620221&w=2

So, if not revert commit cea27eb, currently causes duplicated decreasing
of totalhigh_pages.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
Changes v1 -> v2:
 - Update commit descriptions suggested by Bartlomiej.

 mm/page_alloc.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b100255..2b28216 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6274,10 +6274,6 @@ __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
 		list_del(&page->lru);
 		rmv_page_order(page);
 		zone->free_area[order].nr_free--;
-#ifdef CONFIG_HIGHMEM
-		if (PageHighMem(page))
-			totalhigh_pages -= 1 << order;
-#endif
 		for (i = 0; i < (1 << order); i++)
 			SetPageReserved((page+i));
 		pfn += (1 << order);
-- 
1.8.1.2

