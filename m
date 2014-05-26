Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaEZKGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 06:06:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48205 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaEZKGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 06:06:43 -0400
X-AuditID: cbfee690-b7fb56d000003439-d5-53831230f6fd
From: Heesub Shin <heesub.shin@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Sunghwan Yun <sunghwan.yun@samsung.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Heesub Shin <heesub.shin@samsung.com>
Subject: [PATCH 1/9] staging: ion: tidy up a bit
Date: Mon, 26 May 2014 19:04:53 +0900
Message-id: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42I5/e+Ztq6hUHOwwcrLTBbv/95ns9i+8Rur
	xctDmhYHP9xnsdhz5he7RfPi9WwWB2cvYbI481vX4vKuOWwWa+dvY7O4MbnQ4nTHIlYHHo9t
	u7exelzu62XyuLfvMIvHzll32T3uXNvD5rF/7hp2j74tqxg9Pm+SC+CI4rJJSc3JLEst0rdL
	4Mo4dPQXc8Ens4o7246wNTBe1+li5OSQEDCReLWrhRXCFpO4cG89WxcjF4eQwDJGiXvb7rHD
	FF29MIcRxBYSmM4osfAgO0RRO5PE/NnTWLoYOTjYBLQlDm0LBqkRETCW6D87C6yGWWAOs8SU
	rReYQBLCAgYSs26fALNZBFQlln19ALaZV8Bd4vXufSwQy+QkTh6bDHXRPnaJF/8zIOoFJL5N
	PgS2S0JAVmLTAWaIEkmJgytusExgFFzAyLCKUTS1ILmgOCm9yESvODG3uDQvXS85P3cTIyT8
	J+xgvHfA+hBjMtC4icxSosn5wPjJK4k3NDYzsjA1MTU2Mrc0I01YSZxX7VFSkJBAemJJanZq
	akFqUXxRaU5q8SFGJg5OqQZGMS6e7uAtbN+fLp9tN+WPg7FWmB3ju8qVLo2e1qylxmcUFlsa
	Gvlm/ZzhlC+46tDqlT2tOvpL9CYEJq03bhAtOKKkcv/CvzcKEuty3swo+jEvfV13SPDemYoT
	TqW+Ktjb/FdBXfWobcXcaYHXPnSGr3xdza33YEWjiceDB6v/ufl1MLwzeT1ViaU4I9FQi7mo
	OBEA8NRYEJUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t9jQV0DoeZgg0vvLC3e/73PZrF94zdW
	i5eHNC0OfrjPYrHnzC92i+bF69ksDs5ewmRx5reuxeVdc9gs1s7fxmZxY3KhxemORawOPB7b
	dm9j9bjc18vkcW/fYRaPnbPusnvcubaHzWP/3DXsHn1bVjF6fN4kF8AR1cBok5GamJJapJCa
	l5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0rJJCWWJOKVAoILG4WEnf
	DtOE0BA3XQuYxghd35AguB4jAzSQsI4x49DRX8wFn8wq7mw7wtbAeF2ni5GTQ0LAROLqhTmM
	ELaYxIV769lAbCGB6YwSCw+ydzFyAdntTBLzZ09j6WLk4GAT0JY4tC0YpEZEwFii/+wssBpm
	gTnMElO2XmACSQgLGEjMun0CzGYRUJVY9vUBK4jNK+Au8Xr3PhaIZXISJ49NZp3AyL2AkWEV
	o2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnB8PZPawbiyweIQowAHoxIP7wHvpmAh1sSy4src
	Q4wSHMxKIrxanM3BQrwpiZVVqUX58UWlOanFhxiTgbZPZJYSTc4Hxn5eSbyhsYmZkaWRmbGJ
	ubExacJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTAuXBP141iQ90Q/hSe/AqQde4uN+f1K
	/+7VSf/Mo912IIIteU7B7ikizxTO8PnI9+dKNL2uFat5qhSZKpBpI3Ytqp776+qvpcn8HzX5
	vNOVJ2fPnfGqdkHfbharS+9/H2xqOOLHHeA13/byvEWzj0nOr/h8Kn6i++zd7K2tz7cFZ3I/
	3X++8b0SS3FGoqEWc1FxIgBo1Obk8wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For aesthetics and readability, rename goto labels, remove
useless code lines, and clarify function return type.

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
---
 drivers/staging/android/ion/ion_page_pool.c   |  2 +-
 drivers/staging/android/ion/ion_priv.h        |  2 +-
 drivers/staging/android/ion/ion_system_heap.c | 57 ++++++++++++---------------
 3 files changed, 28 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/android/ion/ion_page_pool.c b/drivers/staging/android/ion/ion_page_pool.c
index ecb5fc3..ead4054 100644
--- a/drivers/staging/android/ion/ion_page_pool.c
+++ b/drivers/staging/android/ion/ion_page_pool.c
@@ -89,7 +89,7 @@ static struct page *ion_page_pool_remove(struct ion_page_pool *pool, bool high)
 	return page;
 }
 
-void *ion_page_pool_alloc(struct ion_page_pool *pool)
+struct page *ion_page_pool_alloc(struct ion_page_pool *pool)
 {
 	struct page *page = NULL;
 
diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index 1eba3f2..365c947 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -377,7 +377,7 @@ struct ion_page_pool {
 
 struct ion_page_pool *ion_page_pool_create(gfp_t gfp_mask, unsigned int order);
 void ion_page_pool_destroy(struct ion_page_pool *);
-void *ion_page_pool_alloc(struct ion_page_pool *);
+struct page *ion_page_pool_alloc(struct ion_page_pool *);
 void ion_page_pool_free(struct ion_page_pool *, struct page *);
 
 /** ion_page_pool_shrink - shrinks the size of the memory cached in the pool
diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index c923633..b554751 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -41,7 +41,7 @@ static int order_to_index(unsigned int order)
 	return -1;
 }
 
-static unsigned int order_to_size(int order)
+static inline unsigned int order_to_size(int order)
 {
 	return PAGE_SIZE << order;
 }
@@ -78,8 +78,6 @@ static struct page *alloc_buffer_page(struct ion_system_heap *heap,
 		ion_pages_sync_for_device(NULL, page, PAGE_SIZE << order,
 						DMA_BIDIRECTIONAL);
 	}
-	if (!page)
-		return NULL;
 
 	return page;
 }
@@ -124,7 +122,6 @@ static struct page_info *alloc_largest_available(struct ion_system_heap *heap,
 
 		info->page = page;
 		info->order = orders[i];
-		INIT_LIST_HEAD(&info->list);
 		return info;
 	}
 	kfree(info);
@@ -142,7 +139,6 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 							heap);
 	struct sg_table *table;
 	struct scatterlist *sg;
-	int ret;
 	struct list_head pages;
 	struct page_info *info, *tmp_info;
 	int i = 0;
@@ -160,24 +156,23 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 		info = alloc_largest_available(sys_heap, buffer, size_remaining,
 						max_order);
 		if (!info)
-			goto err;
+			goto free_pages;
 		list_add_tail(&info->list, &pages);
-		size_remaining -= (1 << info->order) * PAGE_SIZE;
+		size_remaining -= PAGE_SIZE << info->order;
 		max_order = info->order;
 		i++;
 	}
 	table = kzalloc(sizeof(struct sg_table), GFP_KERNEL);
 	if (!table)
-		goto err;
+		goto free_pages;
 
-	ret = sg_alloc_table(table, i, GFP_KERNEL);
-	if (ret)
-		goto err1;
+	if (sg_alloc_table(table, i, GFP_KERNEL))
+		goto free_table;
 
 	sg = table->sgl;
 	list_for_each_entry_safe(info, tmp_info, &pages, list) {
 		struct page *page = info->page;
-		sg_set_page(sg, page, (1 << info->order) * PAGE_SIZE, 0);
+		sg_set_page(sg, page, PAGE_SIZE << info->order, 0);
 		sg = sg_next(sg);
 		list_del(&info->list);
 		kfree(info);
@@ -185,9 +180,10 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 
 	buffer->priv_virt = table;
 	return 0;
-err1:
+
+free_table:
 	kfree(table);
-err:
+free_pages:
 	list_for_each_entry_safe(info, tmp_info, &pages, list) {
 		free_buffer_page(sys_heap, buffer, info->page, info->order);
 		kfree(info);
@@ -197,14 +193,12 @@ err:
 
 static void ion_system_heap_free(struct ion_buffer *buffer)
 {
-	struct ion_heap *heap = buffer->heap;
-	struct ion_system_heap *sys_heap = container_of(heap,
+	struct ion_system_heap *sys_heap = container_of(buffer->heap,
 							struct ion_system_heap,
 							heap);
 	struct sg_table *table = buffer->sg_table;
 	bool cached = ion_buffer_cached(buffer);
 	struct scatterlist *sg;
-	LIST_HEAD(pages);
 	int i;
 
 	/* uncached pages come from the page pools, zero them before returning
@@ -271,10 +265,10 @@ static int ion_system_heap_debug_show(struct ion_heap *heap, struct seq_file *s,
 		struct ion_page_pool *pool = sys_heap->pools[i];
 		seq_printf(s, "%d order %u highmem pages in pool = %lu total\n",
 			   pool->high_count, pool->order,
-			   (1 << pool->order) * PAGE_SIZE * pool->high_count);
+			   (PAGE_SIZE << pool->order) * pool->high_count);
 		seq_printf(s, "%d order %u lowmem pages in pool = %lu total\n",
 			   pool->low_count, pool->order,
-			   (1 << pool->order) * PAGE_SIZE * pool->low_count);
+			   (PAGE_SIZE << pool->order) * pool->low_count);
 	}
 	return 0;
 }
@@ -293,7 +287,7 @@ struct ion_heap *ion_system_heap_create(struct ion_platform_heap *unused)
 	heap->pools = kzalloc(sizeof(struct ion_page_pool *) * num_orders,
 			      GFP_KERNEL);
 	if (!heap->pools)
-		goto err_alloc_pools;
+		goto free_heap;
 	for (i = 0; i < num_orders; i++) {
 		struct ion_page_pool *pool;
 		gfp_t gfp_flags = low_order_gfp_flags;
@@ -302,18 +296,18 @@ struct ion_heap *ion_system_heap_create(struct ion_platform_heap *unused)
 			gfp_flags = high_order_gfp_flags;
 		pool = ion_page_pool_create(gfp_flags, orders[i]);
 		if (!pool)
-			goto err_create_pool;
+			goto destroy_pools;
 		heap->pools[i] = pool;
 	}
 
 	heap->heap.debug_show = ion_system_heap_debug_show;
 	return &heap->heap;
-err_create_pool:
-	for (i = 0; i < num_orders; i++)
-		if (heap->pools[i])
-			ion_page_pool_destroy(heap->pools[i]);
+
+destroy_pools:
+	while (i--)
+		ion_page_pool_destroy(heap->pools[i]);
 	kfree(heap->pools);
-err_alloc_pools:
+free_heap:
 	kfree(heap);
 	return ERR_PTR(-ENOMEM);
 }
@@ -359,12 +353,12 @@ static int ion_system_contig_heap_allocate(struct ion_heap *heap,
 	table = kzalloc(sizeof(struct sg_table), GFP_KERNEL);
 	if (!table) {
 		ret = -ENOMEM;
-		goto out;
+		goto free_pages;
 	}
 
 	ret = sg_alloc_table(table, 1, GFP_KERNEL);
 	if (ret)
-		goto out;
+		goto free_table;
 
 	sg_set_page(table->sgl, page, len, 0);
 
@@ -374,10 +368,12 @@ static int ion_system_contig_heap_allocate(struct ion_heap *heap,
 
 	return 0;
 
-out:
+free_table:
+	kfree(table);
+free_pages:
 	for (i = 0; i < len >> PAGE_SHIFT; i++)
 		__free_page(page + i);
-	kfree(table);
+
 	return ret;
 }
 
@@ -443,4 +439,3 @@ void ion_system_contig_heap_destroy(struct ion_heap *heap)
 {
 	kfree(heap);
 }
-
-- 
1.9.1

