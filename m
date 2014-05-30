Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400AbaE3B0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 21:26:42 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:8257 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325AbaE3B0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 21:26:39 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-fd-5387de4db59b
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
Subject: [PATCH v2 RESEND 4/4] staging: ion: optimize struct ion_system_heap
Date: Fri, 30 May 2014 10:26:30 +0900
Message-id: <1401413190-13514-4-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401413190-13514-1-git-send-email-heesub.shin@samsung.com>
References: <20140529204208.GA2120@kroah.com>
 <1401413190-13514-1-git-send-email-heesub.shin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t8zbV3fe+3BBnPuKFq8/3ufzWL7xm+s
	Fi8PaVqcuFhrcfDDfRaLPWd+sVs0L17PZnFw9hImizO/dS0u75rDZrF2/jY2ixuTCy1Odyxi
	deD12LZ7G6vH5b5eJo97+w6zeOycdZfd4861PWwe++euYffo27KK0ePzJrkAjigum5TUnMyy
	1CJ9uwSujBsb7rMW3BGo6DvVwtbA2MnXxcjJISFgIvFp70IWCFtM4sK99WxdjFwcQgLLGCWu
	rlzJBlO09PNGRojEdEaJmd1/oaramSQad18GynBwsAloSxzaFgzSICJgLNF/dhY7SA2zwGFm
	ia5Za8EmCQv4SPR3bGAFqWcRUJXYPSkaJMwr4C6xYeZVZohlchInj01mBbE5BTwkrn3/CdYq
	JJAtcWzBbLAjJARusUvs/HcWrIFFQEDi2+RDLCAzJQRkJTYdgJojKXFwxQ2WCYzCCxgZVjGK
	phYkFxQnpRcZ6RUn5haX5qXrJefnbmKERE7fDsabB6wPMSYDjZvILCWanA+MvLySeENjMyML
	UxNTYyNzSzPShJXEeRc9TAoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwFi1IyGLxfVJuO5z
	d6uTPR0mM2Xe/pYuncYf23qAj3FFA+P00ycv5P/5rzWt8fvkK09Zfjw/6HdilVTZjQWbmO6v
	ZXotO99fhdt8dljB9ZTTxS83qKs8VLK0WjdHYcnBG7cvVm0NnVr8M/P/1n/taZw+csd//Tvo
	1LGI7/Wc6DcvNl46dDximoGbEktxRqKhFnNRcSIAs6Ovd7ICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jQV3fe+3BBi/XyVi8/3ufzWL7xm+s
	Fi8PaVqcuFhrcfDDfRaLPWd+sVs0L17PZnFw9hImizO/dS0u75rDZrF2/jY2ixuTCy1Odyxi
	deD12LZ7G6vH5b5eJo97+w6zeOycdZfd4861PWwe++euYffo27KK0ePzJrkAjqgGRpuM1MSU
	1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoIOVFMoSc0qBQgGJ
	xcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBk3NtxnLbgjUNF3qoWtgbGTr4uRk0NCwERi
	6eeNjBC2mMSFe+vZuhi5OIQEpjNKzOz+C+W0M0k07r4MVMXBwSagLXFoWzBIg4iAsUT/2Vns
	IDXMAoeZJbpmrWUDSQgL+Ej0d2xgBalnEVCV2D0pGiTMK+AusWHmVWaIZXISJ49NZgWxOQU8
	JK59/wnWKiSQLXFswWzGCYy8CxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEx+UzqR2M
	KxssDjEKcDAq8fA2RrYHC7EmlhVX5h5ilOBgVhLhdTwMFOJNSaysSi3Kjy8qzUktPsSYDHTU
	RGYp0eR8YMrIK4k3NDYxM7I0MjM2MTc2Jk1YSZz3QKt1oJBAemJJanZqakFqEcwWJg5OqQbG
	bRHLna7fiOZ9EMXxqUEvWve0+N/8n8sVec7FlwptZil9cdpwtkrMpFAp1+LaP5Nyt3VK77C0
	C/h91/Pbyl0PeVbXfVDs/uv7ST6svUTwqNIUC0sJE/+Qm5vOvRMNcf8t+2TttQeKv+ensW3Z
	dlW4Vfr6XHEphsv3pzwtXHW613dDf7iYqm6sEktxRqKhFnNRcSIAu7XtCw8DAAA=
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
Reviewed-by: Mitchel Humpherys <mitchelh@codeaurora.org>
Tested-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_system_heap.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index e0a7e54..c826b4c 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -49,7 +49,7 @@ static inline unsigned int order_to_size(int order)
 
 struct ion_system_heap {
 	struct ion_heap heap;
-	struct ion_page_pool **pools;
+	struct ion_page_pool *pools[0];
 };
 
 static struct page *alloc_buffer_page(struct ion_system_heap *heap,
@@ -264,16 +264,15 @@ struct ion_heap *ion_system_heap_create(struct ion_platform_heap *unused)
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
@@ -292,8 +291,6 @@ struct ion_heap *ion_system_heap_create(struct ion_platform_heap *unused)
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

