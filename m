Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbaEZKIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 06:08:42 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:36762 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbaEZKHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 06:07:06 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-85-538312481181
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
Subject: [PATCH 6/9] staging: ion: remove struct page_info
Date: Mon, 26 May 2014 19:04:58 +0900
Message-id: <1401098701-24049-6-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
References: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsVy+t8zbV0PoeZgg+U/pCze/73PZrF94zdW
	i5eHNC0OfrjPYrHnzC92i+bF69ksDs5ewmRx5reuxeVdc9gs1s7fxmZxY3KhxemORawOPB7b
	dm9j9bjc18vkcW/fYRaPnbPusnvcubaHzWP/3DXsHn1bVjF6fN4kF8ARxWWTkpqTWZZapG+X
	wJXR13GEuWCWXMWsh0fYGhi3S3QxcnJICJhITH13kw3CFpO4cG89kM3FISSwjFHi4ur7rDBF
	b1puskIkpjNKfNzTzw7htDNJPF7VyNTFyMHBJqAtcWhbMEiDiICxRP/ZWWA1zAJzmCWmbL3A
	BJIQFrCS6NvZCGazCKhKHLh1mx3E5hVwlzjYtgJqm5zEyWOTwWxOAQ+JiU/msIDYQkA1tzc+
	BDtPQuASu8SrZytZIQYJSHybfIgF5AgJAVmJTQeYIeZIShxccYNlAqPwAkaGVYyiqQXJBcVJ
	6UWmesWJucWleel6yfm5mxghMTNxB+P9A9aHGJOBxk1klhJNzgfGXF5JvKGxmZGFqYmpsZG5
	pRlpwkrivOmPkoKEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MEY2/pVJWzSxuu7oiRXVOiv3
	VeotSlbMtYnbZ+S4ZYPemyP5ui1Hn+1+ESvmmXzxNtOjLZ/Dgm7xdKW9Ysoq45h65I7CErGf
	WjnXJd1ybP9I7TN5F+ivGLShTLDqR/hWjZ6v1y6o2wrN/hPl/cg26e6hSRfqHJrbbB9U9rxb
	bHN95wvbCzMc9imxFGckGmoxFxUnAgB+fgWGrwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jQV0PoeZgg6k7xCze/73PZrF94zdW
	i5eHNC0OfrjPYrHnzC92i+bF69ksDs5ewmRx5reuxeVdc9gs1s7fxmZxY3KhxemORawOPB7b
	dm9j9bjc18vkcW/fYRaPnbPusnvcubaHzWP/3DXsHn1bVjF6fN4kF8AR1cBok5GamJJapJCa
	l5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0rJJCWWJOKVAoILG4WEnf
	DtOE0BA3XQuYxghd35AguB4jAzSQsI4xo6/jCHPBLLmKWQ+PsDUwbpfoYuTkkBAwkXjTcpMV
	whaTuHBvPVsXIxeHkMB0RomPe/rZIZx2JonHqxqZuhg5ONgEtCUObQsGaRARMJboPzsLrIZZ
	YA6zxJStF5hAEsICVhJ9OxvBbBYBVYkDt26zg9i8Au4SB9tWQG2Tkzh5bDKYzSngITHxyRwW
	EFsIqOb2xodsExh5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjshnUjsYVzZYHGIU
	4GBU4uE94N0ULMSaWFZcmXuIUYKDWUmEV4uzOViINyWxsiq1KD++qDQntfgQYzLQVROZpUST
	84HJIq8k3tDYxMzI0sjM2MTc2Jg0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGHukLltq
	VQSsv5vUzTnlkur6KIulos4rZy1Ivf+8dMPy3QxlngJBCcf5pTPfOou2qRxMsb+77RzDg8rW
	3G9BL2O4rrV71dw9Jc15ZQ9nX60L1/SUDclSB7t+RavX78ndZap0tezbr4ZjYb1SPFdvTl6U
	tyvHgT3xWNWb3YaLf52+sOXzicvB5UosxRmJhlrMRcWJAFq8SawMAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ION system heap uses a temporary list holding meta data on pages
allocated to build scatter/gather table. Now that the pages are compound
pages, we do not need to introduce a new data type redundantly.

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
---
 drivers/staging/android/ion/ion_system_heap.c | 47 +++++++++------------------
 1 file changed, 15 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 73a2e67..f0ae210 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -51,11 +51,6 @@ struct ion_system_heap {
 	struct ion_page_pool **pools;
 };
 
-struct page_info {
-	struct page *page;
-	struct list_head list;
-};
-
 static struct page *alloc_buffer_page(struct ion_system_heap *heap,
 				      struct ion_buffer *buffer,
 				      unsigned long order)
@@ -96,19 +91,14 @@ static void free_buffer_page(struct ion_system_heap *heap,
 }
 
 
-static struct page_info *alloc_largest_available(struct ion_system_heap *heap,
-						 struct ion_buffer *buffer,
-						 unsigned long size,
-						 unsigned int max_order)
+static struct page *alloc_largest_available(struct ion_system_heap *heap,
+					    struct ion_buffer *buffer,
+					    unsigned long size,
+					    unsigned int max_order)
 {
 	struct page *page;
-	struct page_info *info;
 	int i;
 
-	info = kmalloc(sizeof(struct page_info), GFP_KERNEL);
-	if (!info)
-		return NULL;
-
 	for (i = 0; i < num_orders; i++) {
 		if (size < order_to_size(orders[i]))
 			continue;
@@ -119,10 +109,8 @@ static struct page_info *alloc_largest_available(struct ion_system_heap *heap,
 		if (!page)
 			continue;
 
-		info->page = page;
-		return info;
+		return page;
 	}
-	kfree(info);
 
 	return NULL;
 }
@@ -138,7 +126,7 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 	struct sg_table *table;
 	struct scatterlist *sg;
 	struct list_head pages;
-	struct page_info *info, *tmp_info;
+	struct page *page, *tmp_page;
 	int i = 0;
 	unsigned long size_remaining = PAGE_ALIGN(size);
 	unsigned int max_order = orders[0];
@@ -151,13 +139,13 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 
 	INIT_LIST_HEAD(&pages);
 	while (size_remaining > 0) {
-		info = alloc_largest_available(sys_heap, buffer, size_remaining,
+		page = alloc_largest_available(sys_heap, buffer, size_remaining,
 						max_order);
-		if (!info)
+		if (!page)
 			goto free_pages;
-		list_add_tail(&info->list, &pages);
-		size_remaining -= PAGE_SIZE << compound_order(info->page);
-		max_order = compound_order(info->page);
+		list_add_tail(&page->lru, &pages);
+		size_remaining -= PAGE_SIZE << compound_order(page);
+		max_order = compound_order(page);
 		i++;
 	}
 	table = kzalloc(sizeof(struct sg_table), GFP_KERNEL);
@@ -168,12 +156,10 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 		goto free_table;
 
 	sg = table->sgl;
-	list_for_each_entry_safe(info, tmp_info, &pages, list) {
-		struct page *page = info->page;
+	list_for_each_entry_safe(page, tmp_page, &pages, lru) {
 		sg_set_page(sg, page, PAGE_SIZE << compound_order(page), 0);
 		sg = sg_next(sg);
-		list_del(&info->list);
-		kfree(info);
+		list_del(&page->lru);
 	}
 
 	buffer->priv_virt = table;
@@ -182,11 +168,8 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 free_table:
 	kfree(table);
 free_pages:
-	list_for_each_entry_safe(info, tmp_info, &pages, list) {
-		free_buffer_page(sys_heap, buffer, info->page,
-						compound_order(info->page));
-		kfree(info);
-	}
+	list_for_each_entry_safe(page, tmp_page, &pages, lru)
+		free_buffer_page(sys_heap, buffer, page, compound_order(page));
 	return -ENOMEM;
 }
 
-- 
1.9.1

