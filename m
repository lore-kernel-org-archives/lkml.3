Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbaE1GxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 02:53:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:65381 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbaE1GxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 02:53:15 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-fd-538587d98bbf
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
Subject: [PATCH v2 4/9] staging: ion: use compound pages on high order pages
 for system heap
Date: Wed, 28 May 2014 15:52:55 +0900
Message-id: <1401259980-26927-5-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401259980-26927-1-git-send-email-heesub.shin@samsung.com>
References: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
 <1401259980-26927-1-git-send-email-heesub.shin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsVy+t8zPd1b7a3BBtd3M1q8/3ufzWL7xm+s
	Fi8PaVqcuFhrcfDDfRaLPWd+sVs0L17PZnFw9hImizO/dS0u75rDZrF2/jY2ixuTCy1Odyxi
	deD12LZ7G6vH5b5eJo97+w6zeOycdZfd4861PWwe++euYffo27KK0ePzJrkAjigum5TUnMyy
	1CJ9uwSujD+3TzMVNPNVPLlyia2BsZGni5GTQ0LAROLm7E8sELaYxIV769m6GLk4hASWMUos
	3LiCDaZo1ZR/UIlFjBIz119kgnDamSSWrXvO2sXIwcEmoC1xaFswSIOIgLFE/9lZ7CA1zAKH
	mSW6Zq0FmyQsECfRN38GM4jNIqAqsfPXS0YQm1fAXeLUpPusENvkJE4emww2k1PAQ2L7mxCI
	Xa2MEtOPP2cEcSQE7rFLrD32DWqQgMS3yYdYQBokBGQlNh1ghpgjKXFwxQ2WCYzCCxgZVjGK
	phYkFxQnpRcZ6RUn5haX5qXrJefnbmKExE7fDsabB6wPMSYDjZvILCWanA+MvbySeENjMyML
	UxNTYyNzSzPShJXEeRc9TAoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwBh1XsTlW8maWJNV
	pQ8fnxCx2ab8slPH41J/wqGNp673fHm9dEXac8GnR09ce5nknjKtxPiApdeNa+J1n5klIuVP
	aC0vmOFskfVb/fiqe7J8j7teTlVLvXB4e5TH6gtcL+dek/ydtMC+nufgilv8PlkX7sz5XvlQ
	StjDOlGBKWOqkJ54j3yI0xclluKMREMt5qLiRAAC6ufgswIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jAd2b7a3BBp8OWVm8/3ufzWL7xm+s
	Fi8PaVqcuFhrcfDDfRaLPWd+sVs0L17PZnFw9hImizO/dS0u75rDZrF2/jY2ixuTCy1Odyxi
	deD12LZ7G6vH5b5eJo97+w6zeOycdZfd4861PWwe++euYffo27KK0ePzJrkAjqgGRpuM1MSU
	1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoIOVFMoSc0qBQgGJ
	xcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBl/bp9mKmjmq3hy5RJbA2MjTxcjJ4eEgInE
	qin/2CBsMYkL99YD2VwcQgKLGCVmrr/IBOG0M0ksW/ectYuRg4NNQFvi0LZgkAYRAWOJ/rOz
	2EFqmAUOM0t0zVoLNklYIE6ib/4MZhCbRUBVYuevl4wgNq+Au8SpSfdZIbbJSZw8NhlsJqeA
	h8T2NyEQu1oZJaYff844gZF3ASPDKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgyHwmtYNx
	ZYPFIUYBDkYlHt4Di1uChVgTy4orcw8xSnAwK4nw3ixsDRbiTUmsrEotyo8vKs1JLT7EmAx0
	1URmKdHkfGDSyCuJNzQ2MTOyNDIzNjE3NiZNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkG
	xoWSi3U+rmLr2pv7SeDCha43R3XCvr7//eRXQft7zczttz+vWHrkvGupiEDX32bu1XZ5J37s
	2i/TOdPbi+FhkxgrS76B/pnWfW3rjUveztSra62NaZv/w3D5Bi79Tr23zr8jFpyaML3k/4E7
	DkkhN87OXSzTWDQxq1NY7fvuU2nHyn4GXC093qjEUpyRaKjFXFScCAAlWHcdEAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using compound pages relieves burden on tracking the meta information
which are currently stored in page_info.

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
---
 drivers/staging/android/ion/ion_page_pool.c   | 4 +++-
 drivers/staging/android/ion/ion_system_heap.c | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/ion/ion_page_pool.c b/drivers/staging/android/ion/ion_page_pool.c
index 111777c..c1cea42b 100644
--- a/drivers/staging/android/ion/ion_page_pool.c
+++ b/drivers/staging/android/ion/ion_page_pool.c
@@ -95,6 +95,8 @@ void ion_page_pool_free(struct ion_page_pool *pool, struct page *page)
 {
 	int ret;
 
+	BUG_ON(pool->order != compound_order(page));
+
 	ret = ion_page_pool_add(pool, page);
 	if (ret)
 		ion_page_pool_free_pages(pool, page);
@@ -150,7 +152,7 @@ struct ion_page_pool *ion_page_pool_create(gfp_t gfp_mask, unsigned int order)
 	pool->low_count = 0;
 	INIT_LIST_HEAD(&pool->low_items);
 	INIT_LIST_HEAD(&pool->high_items);
-	pool->gfp_mask = gfp_mask;
+	pool->gfp_mask = gfp_mask | __GFP_COMP;
 	pool->order = order;
 	mutex_init(&pool->mutex);
 	plist_node_init(&pool->list, order);
diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index b554751..48e6a58 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -72,7 +72,7 @@ static struct page *alloc_buffer_page(struct ion_system_heap *heap,
 
 		if (order > 4)
 			gfp_flags = high_order_gfp_flags;
-		page = alloc_pages(gfp_flags, order);
+		page = alloc_pages(gfp_flags | __GFP_COMP, order);
 		if (!page)
 			return NULL;
 		ion_pages_sync_for_device(NULL, page, PAGE_SIZE << order,
-- 
1.9.1

