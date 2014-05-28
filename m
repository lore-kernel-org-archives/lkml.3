Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbaE1Gy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 02:54:59 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56639 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbaE1GxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 02:53:17 -0400
X-AuditID: cbfee690-b7fb56d000003439-28-538587db8607
From: Heesub Shin <heesub.shin@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Sunghwan Yun <sunghwan.yun@samsung.com>,
        Dongjun Shin <d.j.shin@samsung.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Heesub Shin <heesub.shin@samsung.com>
Subject: [PATCH v2 6/9] staging: ion: remove struct page_info
Date: Wed, 28 May 2014 15:52:57 +0900
Message-id: <1401259980-26927-7-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401259980-26927-1-git-send-email-heesub.shin@samsung.com>
References: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
 <1401259980-26927-1-git-send-email-heesub.shin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t8zPd3b7a3BBucbuS3e/73PZrF94zdW
	i5eHNC1OXKy1OPjhPovFnjO/2C2aF69nszg4ewmTxZnfuhaXd81hs1g7fxubxY3JhRanOxax
	OvB6bNu9jdXjcl8vk8e9fYdZPHbOusvucefaHjaP/XPXsHv0bVnF6PF5k1wARxSXTUpqTmZZ
	apG+XQJXxtv2E+wF2+UqHm86ydzAeE6ii5GTQ0LAROLG+h+MELaYxIV769m6GLk4hASWMUqc
	m97ECFN0ccUMRojEIkaJBT9fsoMkhATamSQOnDfsYuTgYBPQlji0LRgkLCJgLNF/dhY7SD2z
	wGFmia5Za9lAEsICthI/ZrxiArFZBFQlvs/9yQxi8wq4SxzousQKsUxO4uSxyawgMzkFPCS2
	vwmB2NvKKDH9+HOwIyQEHrFLXL7awQIxSEDi2+RDLCANEgKyEpsOMEPMkZQ4uOIGywRG4QWM
	DKsYRVMLkguKk9KLTPSKE3OLS/PS9ZLzczcxQiJnwg7GewesDzEmA42byCwlmpwPjLy8knhD
	YzMjC1MTU2Mjc0sz0oSVxHnVHiUFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDUX3Hi0Mbb
	L3/8vVzcKLe0ctWx3Re49lXP7+Hhe8BdMH1OReM11VnZNQV6195U720tE9fcYmPi+8pMlUXv
	/MHNosVtxaLK0V0bFY6dub3Ggu3swwcLtXr2xLpckXyg2XT76KQVYXnB10+3LK/9m9wXnffB
	7WLAe3Ov2S8FdvZyxqTc/5fpKl2rxFKckWioxVxUnAgA09bcHrICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jAd3b7a3BBrsvsFm8/3ufzWL7xm+s
	Fi8PaVqcuFhrcfDDfRaLPWd+sVs0L17PZnFw9hImizO/dS0u75rDZrF2/jY2ixuTCy1Odyxi
	deD12LZ7G6vH5b5eJo97+w6zeOycdZfd4861PWwe++euYffo27KK0ePzJrkAjqgGRpuM1MSU
	1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoIOVFMoSc0qBQgGJ
	xcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBlv20+wF2yXq3i86SRzA+M5iS5GTg4JAROJ
	iytmMELYYhIX7q1n62Lk4hASWMQoseDnS3aQhJBAO5PEgfOGXYwcHGwC2hKHtgWDhEUEjCX6
	z85iB6lnFjjMLNE1ay0bSEJYwFbix4xXTCA2i4CqxPe5P5lBbF4Bd4kDXZdYIZbJSZw8NpkV
	ZCangIfE9jchEHtbGSWmH3/OOIGRdwEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Lh8
	JrWDcWWDxSFGAQ5GJR7eA4tbgoVYE8uKK3MPMUpwMCuJ8N4sbA0W4k1JrKxKLcqPLyrNSS0+
	xJgMdNVEZinR5HxgysgriTc0NjEzsjQyMzYxNzYmTVhJnPdAq3WgkEB6YklqdmpqQWoRzBYm
	Dk6pBsbusy4tlq+2rtbuTzsRYske9N3C9M+TrBMOBxbk/kmbt+1AqL5by6x9uo4M2pv4VjJK
	L9VzPqbLdOqbyqrb67hOlu6xTWiRdAiV0TyxJ2vTc2anfZ2PNe/svtq68I/Tzq07KoTsPa4p
	NXlsYdghfjhgT8T7aOezu98/P3X41a/m4xybTiQatHxVYinOSDTUYi4qTgQAj6soiA8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ION system heap creates a temporary list of pages to build
scatter/gather table, introducing an internal data type, page_info. Now
that the order field has been removed from it, we do not need to depend
on such data type anymore.

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

