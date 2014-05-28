Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbaE1Gyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 02:54:54 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56639 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbaE1GxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 02:53:18 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-3b-538587dd2234
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
Subject: [PATCH v2 9/9] staging: ion: optimize struct ion_system_heap
Date: Wed, 28 May 2014 15:53:00 +0900
Message-id: <1401259980-26927-10-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401259980-26927-1-git-send-email-heesub.shin@samsung.com>
References: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
 <1401259980-26927-1-git-send-email-heesub.shin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsVy+t8zPd277a3BBusXqFm8/3ufzWL7xm+s
	Fi8PaVqcuFhrcfDDfRaLPWd+sVs0L17PZnFw9hImizO/dS0u75rDZrF2/jY2ixuTCy1Odyxi
	deD12LZ7G6vH5b5eJo97+w6zeOycdZfd4861PWwe++euYffo27KK0ePzJrkAjigum5TUnMyy
	1CJ9uwSujANNHSwFn/grVhz4y9bAuJK3i5GTQ0LAROL38x8sELaYxIV769m6GLk4hASWMUq8
	2H+ECabo1Yb5YLaQwCJGiV9XYyGK2pkkutftBurm4GAT0JY4tC0YpEZEwFii/+wsdpAaZoHD
	zBJds9aygSSEBVwlGn7sYwSpZxFQldj40gkkzCvgIdG2+SMjxC45iZPHJrOClHACxbe/CYFY
	1cooMf34c0YQR0LgFrvEgTs/wA5iERCQ+Db5ENgNEgKyEpsOMEPMkZQ4uOIGywRG4QWMDKsY
	RVMLkguKk9KLjPSKE3OLS/PS9ZLzczcxQuKmbwfjzQPWhxiTgcZNZJYSTc4Hxl1eSbyhsZmR
	hamJqbGRuaUZacJK4ryLHiYFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDkLV+2PWailvyH
	tNyP4hN2v3hqoTAl8Pf22U8Vin5GzZq0OmBJ0Wr9b3+X7plRU9VzPsVdU6m87MIHq2qF8zbt
	lprzBXzvCutJ+JpummlysVfL3Z9zgsI9p8h2Vr237JFy7bNXbohY7Xb64B5Lw3kLP6z922vp
	4Ddj2yv3V8WPpb15DXydRDmUWIozEg21mIuKEwGdboFmsQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jAd277a3BBs9OK1q8/3ufzWL7xm+s
	Fi8PaVqcuFhrcfDDfRaLPWd+sVs0L17PZnFw9hImizO/dS0u75rDZrF2/jY2ixuTCy1Odyxi
	deD12LZ7G6vH5b5eJo97+w6zeOycdZfd4861PWwe++euYffo27KK0ePzJrkAjqgGRpuM1MSU
	1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoIOVFMoSc0qBQgGJ
	xcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBkHmjpYCj7xV6w48JetgXElbxcjJ4eEgInE
	qw3zmSBsMYkL99azgdhCAosYJX5dje1i5AKy25kkutftZuli5OBgE9CWOLQtGKRGRMBYov/s
	LHaQGmaBw8wSXbPWgjULC7hKNPzYxwhSzyKgKrHxpRNImFfAQ6Jt80dGiF1yEiePTWYFKeEE
	im9/EwKxqpVRYvrx54wTGHkXMDKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiOymfSOxhX
	NVgcYhTgYFTi4T2wuCVYiDWxrLgy9xCjBAezkgjvzcLWYCHelMTKqtSi/Pii0pzU4kOMyUBH
	TWSWEk3OByaMvJJ4Q2MTMyNLIzNjE3NjY9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpg
	jP3cZ9TgyMmgEKdafM1wk7Ju7+IlC6I/7jn+W27+o2eHdhjKeDY/D3xiyFfnZ8ZSz/Pii9G7
	rOZbW1YFrHvy4WTRi8cKhutr2y4lXlpXsG03s/b9uqsrdIR7XoXUzpcVUY9SeXXv2KJ/IVxz
	RfUy3xwve3q1+0nW7Zfil8VOrnliurQ3sMM8UomlOCPRUIu5qDgRAAsBlkMOAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct ion_system_heap has an array for storing pointers to page pools
and it is allocated separately from the containing structure. There is
no point in allocating those two small objects individually, bothering
slab allocator. Using a variable length array simplifies code lines and
reduces overhead to the slab.

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
---
 drivers/staging/android/ion/ion_system_heap.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index d78d589e..690d866 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -48,7 +48,7 @@ static inline unsigned int order_to_size(int order)
 
 struct ion_system_heap {
 	struct ion_heap heap;
-	struct ion_page_pool **pools;
+	struct ion_page_pool *pools[0];
 };
 
 static struct page *alloc_buffer_page(struct ion_system_heap *heap,
@@ -259,16 +259,15 @@ struct ion_heap *ion_system_heap_create(struct ion_platform_heap *unused)
 	struct ion_system_heap *heap;
 	int i;
 
-	heap = kzalloc(sizeof(struct ion_system_heap), GFP_KERNEL);
+	heap = kzalloc(sizeof(struct ion_system_heap) +
+			sizeof(struct ion_page_pool *) * num_orders,
+			GFP_KERNEL);
 	if (!heap)
 		return ERR_PTR(-ENOMEM);
 	heap->heap.ops = &system_heap_ops;
 	heap->heap.type = ION_HEAP_TYPE_SYSTEM;
 	heap->heap.flags = ION_HEAP_FLAG_DEFER_FREE;
-	heap->pools = kzalloc(sizeof(struct ion_page_pool *) * num_orders,
-			      GFP_KERNEL);
-	if (!heap->pools)
-		goto free_heap;
+
 	for (i = 0; i < num_orders; i++) {
 		struct ion_page_pool *pool;
 		gfp_t gfp_flags = low_order_gfp_flags;
@@ -287,8 +286,6 @@ struct ion_heap *ion_system_heap_create(struct ion_platform_heap *unused)
 destroy_pools:
 	while (i--)
 		ion_page_pool_destroy(heap->pools[i]);
-	kfree(heap->pools);
-free_heap:
 	kfree(heap);
 	return ERR_PTR(-ENOMEM);
 }
-- 
1.9.1

