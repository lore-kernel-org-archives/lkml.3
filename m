Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbaE1GxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 02:53:22 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63449 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbaE1GxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 02:53:16 -0400
X-AuditID: cbfee690-b7fb56d000003439-21-538587dadb8f
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
Subject: [PATCH v2 5/9] staging: ion: remove order from struct page_info
Date: Wed, 28 May 2014 15:52:56 +0900
Message-id: <1401259980-26927-6-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401259980-26927-1-git-send-email-heesub.shin@samsung.com>
References: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
 <1401259980-26927-1-git-send-email-heesub.shin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsVy+t8zPd1b7a3BBs1r1C3e/73PZrF94zdW
	i5eHNC1OXKy1OPjhPovFnjO/2C2aF69nszg4ewmTxZnfuhaXd81hs1g7fxubxY3JhRanOxax
	OvB6bNu9jdXjcl8vk8e9fYdZPHbOusvucefaHjaP/XPXsHv0bVnF6PF5k1wARxSXTUpqTmZZ
	apG+XQJXRuO+c4wFzwQq3s99ydzA+I63i5GTQ0LARKL39TpmCFtM4sK99WxdjFwcQgLLGCW+
	bNzEDlP0/8o8FojEIkaJD0fmMIEkhATamSQOnDfsYuTgYBPQlji0LRgkLCJgLNF/dhY7SD2z
	wGFmia5Za9lAEsICHhKHdl9gBbFZBFQlTn/awAzSyyvgLtH8BuogOYmTxyazgoQ5gcq3vwmB
	WNvKKDH9+HNGEEdC4B67RMvcaYwQcwQkvk0+xALSICEgK7HpANQzkhIHV9xgmcAovICRYRWj
	aGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGSNxM2MF474D1IcZkoHETmaVEk/OBcZdXEm9obGZk
	YWpiamxkbmlGmrCSOK/ao6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYx9UZzT3p6unHVz
	V6XzsuRvs7/fz7e6cmhO2JNn6UGu7L9z4iRSu8/8Z7luPE1Nb3/1rRcq/d22ghNddywIiL/O
	WZJdrdWWrmKQxH32R2v7nmB270W/wiojlY09d79TmVlq9P/anRc8pT9/J3ZsOvmoePY6zjMy
	L3OLKq9viFl3RONOuENqkJcSS3FGoqEWc1FxIgBXGbdXsQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jAd1b7a3BBgdXKlu8/3ufzWL7xm+s
	Fi8PaVqcuFhrcfDDfRaLPWd+sVs0L17PZnFw9hImizO/dS0u75rDZrF2/jY2ixuTCy1Odyxi
	deD12LZ7G6vH5b5eJo97+w6zeOycdZfd4861PWwe++euYffo27KK0ePzJrkAjqgGRpuM1MSU
	1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoIOVFMoSc0qBQgGJ
	xcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBmN+84xFjwTqHg/9yVzA+M73i5GTg4JAROJ
	/1fmsUDYYhIX7q1n62Lk4hASWMQo8eHIHCaQhJBAO5PEgfOGXYwcHGwC2hKHtgWDhEUEjCX6
	z85iB6lnFjjMLNE1ay0bSEJYwEPi0O4LrCA2i4CqxOlPG5hBenkF3CWa30DtlZM4eWwyK0iY
	E6h8+5sQiLWtjBLTjz9nnMDIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcFQ+k9rB
	uLLB4hCjAAejEg/vgcUtwUKsiWXFlbmHGCU4mJVEeG8WtgYL8aYkVlalFuXHF5XmpBYfYkwG
	Omois5Rocj4wYeSVxBsam5gZWRqZGZuYGxuTJqwkznug1TpQSCA9sSQ1OzW1ILUIZgsTB6dU
	A+MeJY483dXVbPOO76pzXPqT7Q/PCrbmspfO+77U/pp6smLu/b/MO2Z3yH82PG2bfue25SzH
	e3971DZzrlDr6TGUOWCxdefJNyLrRe4bzJRSLDew5jDPsapdXPnGePWB09OEI6Xj85RfxWyM
	O1ByfKXJtA21ETv4O833nuu/0h+zpkbg+nyuRiMlluKMREMt5qLiRAB10osADgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ION system heap uses an internal data structure, struct page_info, for
tracking down the meta information of the pages allocated from the pool.
Now that the pool returns compound pages, we don't need to store page
order in struct page_info.

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
---
 drivers/staging/android/ion/ion_system_heap.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 48e6a58..73a2e67 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -53,7 +53,6 @@ struct ion_system_heap {
 
 struct page_info {
 	struct page *page;
-	unsigned int order;
 	struct list_head list;
 };
 
@@ -121,7 +120,6 @@ static struct page_info *alloc_largest_available(struct ion_system_heap *heap,
 			continue;
 
 		info->page = page;
-		info->order = orders[i];
 		return info;
 	}
 	kfree(info);
@@ -158,8 +156,8 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 		if (!info)
 			goto free_pages;
 		list_add_tail(&info->list, &pages);
-		size_remaining -= PAGE_SIZE << info->order;
-		max_order = info->order;
+		size_remaining -= PAGE_SIZE << compound_order(info->page);
+		max_order = compound_order(info->page);
 		i++;
 	}
 	table = kzalloc(sizeof(struct sg_table), GFP_KERNEL);
@@ -172,7 +170,7 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 	sg = table->sgl;
 	list_for_each_entry_safe(info, tmp_info, &pages, list) {
 		struct page *page = info->page;
-		sg_set_page(sg, page, PAGE_SIZE << info->order, 0);
+		sg_set_page(sg, page, PAGE_SIZE << compound_order(page), 0);
 		sg = sg_next(sg);
 		list_del(&info->list);
 		kfree(info);
@@ -185,7 +183,8 @@ free_table:
 	kfree(table);
 free_pages:
 	list_for_each_entry_safe(info, tmp_info, &pages, list) {
-		free_buffer_page(sys_heap, buffer, info->page, info->order);
+		free_buffer_page(sys_heap, buffer, info->page,
+						compound_order(info->page));
 		kfree(info);
 	}
 	return -ENOMEM;
-- 
1.9.1

