Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302AbaE3B0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 21:26:32 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:46288 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398AbaE3B0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 21:26:30 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-93-5387de4508d0
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
Subject: [PATCH v2 RESEND 2/4] staging: ion: remove struct page_info
Date: Fri, 30 May 2014 10:26:28 +0900
Message-id: <1401413190-13514-2-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401413190-13514-1-git-send-email-heesub.shin@samsung.com>
References: <20140529204208.GA2120@kroah.com>
 <1401413190-13514-1-git-send-email-heesub.shin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t8zXV3Xe+3BBtcfC1m8/3ufzWL7xm+s
	Fi8PaVqcuFhrcfDDfRaLPWd+sVs0L17PZnFw9hImizO/dS0u75rDZrF2/jY2ixuTCy1Odyxi
	deD12LZ7G6vH5b5eJo97+w6zeOycdZfd4861PWwe++euYffo27KK0ePzJrkAjigum5TUnMyy
	1CJ9uwSujN0357IXLJKv2NH9kr2Bcb1kFyMnh4SAiUTDkk9sELaYxIV764FsLg4hgWWMEqev
	NjDCFG2a0cMIkZjOKHFw5VMmCKedSWLPs8NALRwcbALaEoe2BYM0iAgYS/SfncUOUsMscJhZ
	omvWWrAVwgIuEse+vGQCsVkEVCW27f3BDtLLK+AucfhtNcQyOYmTxyazgticAh4S177/BGsV
	EsiWOLZgNtgREgK32CVWnd3NCDFHQOLb5EMsIHMkBGQlNh1ghpgjKXFwxQ2WCYzCCxgZVjGK
	phYkFxQnpRcZ6RUn5haX5qXrJefnbmKERE7fDsabB6wPMSYDjZvILCWanA+MvLySeENjMyML
	UxNTYyNzSzPShJXEeRc9TAoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwJi937z3pofO1aim
	/o8stt0P3vnqrfWc7S9pUawu/d9zPbvLpxtfLC7sEsj7sUjpX832NW2LeNy4t/Tu9ZxguvxG
	uU33yt1LXf0fKMnY1O869vXvFeMEpoUvAi6Eu/S/il1Zx/vA19svndV3W8aWNVP7sl0VjDuF
	r1syBNSmbc9fsz9hWkHybyWW4oxEQy3mouJEAH376cuyAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jQV3Xe+3BBs8v8lq8/3ufzWL7xm+s
	Fi8PaVqcuFhrcfDDfRaLPWd+sVs0L17PZnFw9hImizO/dS0u75rDZrF2/jY2ixuTCy1Odyxi
	deD12LZ7G6vH5b5eJo97+w6zeOycdZfd4861PWwe++euYffo27KK0ePzJrkAjqgGRpuM1MSU
	1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoIOVFMoSc0qBQgGJ
	xcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBm7b85lL1gkX7Gj+yV7A+N6yS5GTg4JAROJ
	TTN6GCFsMYkL99azdTFycQgJTGeUOLjyKROE084ksefZYaAMBwebgLbEoW3BIA0iAsYS/Wdn
	sYPUMAscZpbomrWWDSQhLOAicezLSyYQm0VAVWLb3h/sIL28Au4Sh99WQyyTkzh5bDIriM0p
	4CFx7ftPsFYhgWyJYwtmM05g5F3AyLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzgun0nt
	YFzZYHGIUYCDUYmHtzGyPViINbGsuDL3EKMEB7OSCK/jYaAQb0piZVVqUX58UWlOavEhxmSg
	oyYyS4km5wNTRl5JvKGxiZmRpZGZsYm5sTFpwkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1
	MDp8Vm2cvjDxQ8a0T7b89Rteidb2CZZ++R07fXpdgLvG9amrsz+mS/ivLmffcDBmK8P0yGe3
	xXV9V0jPmu/gYltlWnRVZdpCsd2lSVwrj/HJ34xnrGRe4LHF6kV12hzDy73Sc2cUSxlYnPsW
	NfHqg2VbXIzCHzi3mOWvr3+nY9V6RifDvFrivBJLcUaioRZzUXEiAHxQDv0PAwAA
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
Reviewed-by: Mitchel Humpherys <mitchelh@codeaurora.org>
Tested-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_system_heap.c | 47 +++++++++------------------
 1 file changed, 15 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 621b857..f3b9008 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -52,11 +52,6 @@ struct ion_system_heap {
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
@@ -98,19 +93,14 @@ static void free_buffer_page(struct ion_system_heap *heap,
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
@@ -121,10 +111,8 @@ static struct page_info *alloc_largest_available(struct ion_system_heap *heap,
 		if (!page)
 			continue;
 
-		info->page = page;
-		return info;
+		return page;
 	}
-	kfree(info);
 
 	return NULL;
 }
@@ -140,7 +128,7 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 	struct sg_table *table;
 	struct scatterlist *sg;
 	struct list_head pages;
-	struct page_info *info, *tmp_info;
+	struct page *page, *tmp_page;
 	int i = 0;
 	unsigned long size_remaining = PAGE_ALIGN(size);
 	unsigned int max_order = orders[0];
@@ -153,13 +141,13 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 
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
 	table = kmalloc(sizeof(struct sg_table), GFP_KERNEL);
@@ -170,12 +158,10 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
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
@@ -184,11 +170,8 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
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

