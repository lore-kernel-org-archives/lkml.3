Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251Ab3GaIuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 04:50:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22389 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480Ab3GaIuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 04:50:02 -0400
X-AuditID: cbfee68f-b7f436d000000f81-80-51f8cfb819bf
From: Joonyoung Shim <jy0922.shim@samsung.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, liuj97@gmail.com,
        kosaki.motohiro@gmail.com
Subject: [PATCH] Revert
 "mm/memory-hotplug: fix lowmem count overflow when offline pages"
Date: Wed, 31 Jul 2013 17:50:02 +0900
Message-id: <1375260602-2462-1-git-send-email-jy0922.shim@samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsWyRsSkRHfH+R+BBkcOqVjMWb+GzeLZFm6L
	y7vmsFncW/Of1aL5yEYmB1aPnbPusnts+jSJ3ePEjN8sHp83yQWwRHHZpKTmZJalFunbJXBl
	LOleyV5wgb3izvtlLA2M69i6GDk4JARMJK7d8+pi5AQyxSQu3FsPFObiEBJYyijx6GkfG0TC
	ROLgkXfMEIlFjBKL/syEqmplkpjcOAOsik1AT+LOtuNMILYI0KiPZy4zg9jMAlkSDzc8ALOF
	BaIlNj/4BGazCKhKrO/bxwpi8wq4SSyad44FYpuCxM/LJ6A2P2eTOP+4EqJeQOLb5EMsEFfL
	Smw6wAxRIilxcMUNlgmMggsYGVYxiqYWJBcUJ6UXGesVJ+YWl+al6yXn525iBAbl6X/P+ncw
	3j1gfYgxGWjcRGYp0eR8YFDnlcQbGpsZWZiamBobmVuakSasJM6r1mIdKCSQnliSmp2aWpBa
	FF9UmpNafIiRiYNTqoExcZX8/ejO8/NUD+gX/55hUGRgveFDQ74y0+KrBz44rss4JnqZs6y8
	jOXaow/nVp/ZNVXo4/+EJ02Pd3eJFCZJf75d+GBaX8Wzp/aTIjN+fJuQkK5Z18exdxFj8UzG
	1WnBb084N5QufKer4rXzauniNkU3fsUqNh3pXz9/Cb+f+/NL0r/nvLtClViKMxINtZiLihMB
	cyrCYmACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t9jAd0d538EGty/IGsxZ/0aNotnW7gt
	Lu+aw2Zxb81/VovmIxuZHFg9ds66y+6x6dMkdo8TM36zeHzeJBfAEtXAaJORmpiSWqSQmpec
	n5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtFdJoSwxpxQoFJBYXKykb4dp
	QmiIm64FTGOErm9IEFyPkQEaSFjDmLGkeyV7wQX2ijvvl7E0MK5j62Lk5JAQMJE4eOQdM4Qt
	JnHh3nqgOBeHkMAiRolFf2ZCOa1MEpMbZ4B1sAnoSdzZdpwJxBYB6vh45jJYN7NAlsTDDQ/A
	bGGBaInNDz6B2SwCqhLr+/axgti8Am4Si+adY4HYpiDx8/IJtgmM3AsYGVYxiqYWJBcUJ6Xn
	GuoVJ+YWl+al6yXn525iBIf9M6kdjCsbLA4xCnAwKvHwOlz4HijEmlhWXJl7iFGCg1lJhFc+
	6EegEG9KYmVValF+fFFpTmrxIcZkoO0TmaVEk/OBMZlXEm9obGJmZGlkbmhhZGxOmrCSOO+B
	VutAIYH0xJLU7NTUgtQimC1MHJxSDYzL1I6YrBE7qbN8e4Jz9AwJhiiPFRP5c9iK20uvnFuT
	/zQv7rSsv3OQwo9W1s9+D+Zy285ZmHjrWU832yLnGfbXnJ9x6fO1vhTR+fbupFyJcnY059ug
	fQsaOzmN+VyvWZ3w5mULVfyhsvRTR3pUrefsRyeesx5eunVu/rUzLSd2rfusfP7objklluKM
	REMt5qLiRACD6zIYvwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit cea27eb2a202959783f81254c48c250ddd80e129.

Fixed to adjust totalhigh_pages when hot-removing memory by commit
3dcc0571cd64816309765b7c7e4691a4cadf2ee7, so that commit occurs
duplicated decreasing of totalhigh_pages.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
The commit cea27eb2a202959783f81254c48c250ddd80e129 is only for stable,
is it right?

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

