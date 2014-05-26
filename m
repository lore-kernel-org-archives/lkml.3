Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbaEZKHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 06:07:21 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48320 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbaEZKHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 06:07:17 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-78-538312539d39
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
Subject: [PATCH 9/9] staging: ion: optimize struct ion_system_heap
Date: Mon, 26 May 2014 19:05:01 +0900
Message-id: <1401098701-24049-9-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
References: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsVy+t8zPd1goeZgg6X3dC3e/73PZrF94zdW
	i5eHNC0OfrjPYrHnzC92i+bF69ksDs5ewmRx5reuxeVdc9gs1s7fxmZxY3KhxemORawOPB7b
	dm9j9bjc18vkcW/fYRaPnbPusnvcubaHzWP/3DXsHn1bVjF6fN4kF8ARxWWTkpqTWZZapG+X
	wJVxoKmDpeATf8WKA3/ZGhhX8nYxcnJICJhIrOy9yQJhi0lcuLeerYuRi0NIYBmjxLn75xhh
	ii4vvMUOkZjOKLF+xi+oqnYmicU7DgBVcXCwCWhLHNoWDNIgImAs0X92FlgDs8AcZokpWy8w
	gSSEBZwktjbfYwWxWQRUJZb2HAHbwCvgLnF09QFWiG1yEiePTQazOQU8JCY+mQN2nhBQze2N
	D8EWSwhcY5dY+2kiM8QgAYlvkw+xgBwhISArsekAM8QcSYmDK26wTGAUXsDIsIpRNLUguaA4
	Kb3ISK84Mbe4NC9dLzk/dxMjJGb6djDePGB9iDEZaNxEZinR5HxgzOWVxBsamxlZmJqYGhuZ
	W5qRJqwkzrvoYVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkYOicCMlCtWfPq2IbO/7M1k
	Xh82i9lw08JTP38enfOzO7X7z9YVHUnPX+8If7qWe1LIX6cFCprWt6ysxM035IUrlyjw2mjZ
	/Fn8L3z7ri9z5SwPfevclaMf8SNzsd/0wtW31p84x/P8qpeXWZW76iLrrHnx8lyqWgZFfziK
	Z0k+8FryY1nYPA8lluKMREMt5qLiRACApTKMrwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jQd1goeZgg08bNS3e/73PZrF94zdW
	i5eHNC0OfrjPYrHnzC92i+bF69ksDs5ewmRx5reuxeVdc9gs1s7fxmZxY3KhxemORawOPB7b
	dm9j9bjc18vkcW/fYRaPnbPusnvcubaHzWP/3DXsHn1bVjF6fN4kF8AR1cBok5GamJJapJCa
	l5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0rJJCWWJOKVAoILG4WEnf
	DtOE0BA3XQuYxghd35AguB4jAzSQsI4x40BTB0vBJ/6KFQf+sjUwruTtYuTkkBAwkbi88BY7
	hC0mceHeerYuRi4OIYHpjBLrZ/yCctqZJBbvOMDYxcjBwSagLXFoWzBIg4iAsUT/2VnsIDXM
	AnOYJaZsvcAEkhAWcJLY2nyPFcRmEVCVWNpzhBHE5hVwlzi6+gArxDY5iZPHJoPZnAIeEhOf
	zGEBsYWAam5vfMg2gZF3ASPDKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgiHwmtYNxZYPF
	IUYBDkYlHt4D3k3BQqyJZcWVuYcYJTiYlUR4tTibg4V4UxIrq1KL8uOLSnNSiw8xJgNdNZFZ
	SjQ5H5gs8kriDY1NzIwsjcyMTcyNjUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBcd9u
	i4JvX8TP6NzvrDzYLXcgbaMyXxLLxozfko72Ztbz571gzO8omZvHdW6vc+HBXU6vFuene8/4
	lGC4dQWHtF2O3BWhGQpsir9DTq3vSD88O1alfCZTROKXNbfuN4hUqQT2Oj9weW3A5L+1/INx
	Xe0ESQtB8djJ0jozavdmOSoqfOPIlEtWYinOSDTUYi4qTgQAcyNYlgwDAAA=
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

