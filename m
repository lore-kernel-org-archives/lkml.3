Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbaE1GxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 02:53:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:65381 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbaE1GxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 02:53:14 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-b5-538587d82a14
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
Subject: [PATCH v2 3/9] staging: ion: remove struct ion_page_pool_item
Date: Wed, 28 May 2014 15:52:54 +0900
Message-id: <1401259980-26927-4-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401259980-26927-1-git-send-email-heesub.shin@samsung.com>
References: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
 <1401259980-26927-1-git-send-email-heesub.shin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t8zPd0b7a3BBrOWM1m8/3ufzWL7xm+s
	Fi8PaVqcuFhrcfDDfRaLPWd+sVs0L17PZnFw9hImizO/dS0u75rDZrF2/jY2ixuTCy1Odyxi
	deD12LZ7G6vH5b5eJo97+w6zeOycdZfd4861PWwe++euYffo27KK0ePzJrkAjigum5TUnMyy
	1CJ9uwSujFmnVrAVvBGuOLn5AlMD4wmBLkZODgkBE4mFi24yQthiEhfurWcDsYUEljFKzJkt
	D1NzZ8tCpi5GLqD4IkaJOy3T2SGcdiaJk/NvAHVwcLAJaEsc2hYM0iAiYCzRf3YWWA2zwGFm
	ia5Za8GmCgu4SRx7/wdsG4uAqsTnxs3sIDavgLvEsabdrBDb5CROHpvMCjKTU8BDYvubEIhd
	rYwS048/ZwRxJATusUvMvnyJBWKQgMS3yYdYQBokBGQlNh1ghpgjKXFwxQ2WCYzCCxgZVjGK
	phYkFxQnpReZ6hUn5haX5qXrJefnbmKERM7EHYz3D1gfYkwGGjeRWUo0OR8YeXkl8YbGZkYW
	piamxkbmlmakCSuJ86Y/SgoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwDhv3syD2srB013X
	va7v9Hn3Iu+HSa7+dJ6Jd8WDj4jd2lfIvXfJFJ7K3sjf/kv3czNfMPpyVbTm0i7HeDVdRw7/
	Tx9MSr+vXGw9P/jJyzdRL39eb124MiF3YXSM7o6Z+UWXbrp9E+Nhnf3oY7zlu/ynxeZxjQeT
	W2ftYDW/eG/urg2FtlOf3J6qxFKckWioxVxUnAgAMajRqLICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jAd3r7a3BBnemWVu8/3ufzWL7xm+s
	Fi8PaVqcuFhrcfDDfRaLPWd+sVs0L17PZnFw9hImizO/dS0u75rDZrF2/jY2ixuTCy1Odyxi
	deD12LZ7G6vH5b5eJo97+w6zeOycdZfd4861PWwe++euYffo27KK0ePzJrkAjqgGRpuM1MSU
	1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoIOVFMoSc0qBQgGJ
	xcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBmzTq1gK3gjXHFy8wWmBsYTAl2MnBwSAiYS
	d7YsZIKwxSQu3FvP1sXIxSEksIhR4k7LdHYIp51J4uT8G0AZDg42AW2JQ9uCQRpEBIwl+s/O
	AqthFjjMLNE1ay0bSEJYwE3i2Ps/jCA2i4CqxOfGzewgNq+Au8Sxpt2sENvkJE4em8wKMpNT
	wENi+5sQiF2tjBLTjz9nnMDIu4CRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcGQ+k97B
	uKrB4hCjAAejEg/vgcUtwUKsiWXFlbmHGCU4mJVEeG8WtgYL8aYkVlalFuXHF5XmpBYfYkwG
	umois5Rocj4waeSVxBsam5gZWRqZGZuYGxuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dU
	A2N/tdamd0HvRfn/MTnYRl4o+nQ2bNpzyUkKLnWhMt+WVjGFr1lxaj3bPNZlm7SC2Bq7fn3f
	6PmcrXfRbaG/Lk9n8W348GzpNdl06Y6fegvU0jJ/182uurzUqPHE8e6pi7uMXobVGXY3OwVM
	TbZb7yH4ueyUUUd1V9DK7YubbpQdWVdsU3rnw14lluKMREMt5qLiRAClfLXaEAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The page pool uses an internal data structure, ion_page_pool_item, for
wrapping pooled pages and constructing a list. As the struct page
already provides ways for doing exactly the same thing, we do not need
to reinvent the wheel. This commit removes the data structure and slab
allocations for it.

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
---
 drivers/staging/android/ion/ion_page_pool.c | 27 +++++----------------------
 1 file changed, 5 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/android/ion/ion_page_pool.c b/drivers/staging/android/ion/ion_page_pool.c
index 1684780..111777c 100644
--- a/drivers/staging/android/ion/ion_page_pool.c
+++ b/drivers/staging/android/ion/ion_page_pool.c
@@ -23,11 +23,6 @@
 #include <linux/slab.h>
 #include "ion_priv.h"
 
-struct ion_page_pool_item {
-	struct page *page;
-	struct list_head list;
-};
-
 static void *ion_page_pool_alloc_pages(struct ion_page_pool *pool)
 {
 	struct page *page = alloc_pages(pool->gfp_mask, pool->order);
@@ -47,19 +42,12 @@ static void ion_page_pool_free_pages(struct ion_page_pool *pool,
 
 static int ion_page_pool_add(struct ion_page_pool *pool, struct page *page)
 {
-	struct ion_page_pool_item *item;
-
-	item = kmalloc(sizeof(struct ion_page_pool_item), GFP_KERNEL);
-	if (!item)
-		return -ENOMEM;
-
 	mutex_lock(&pool->mutex);
-	item->page = page;
 	if (PageHighMem(page)) {
-		list_add_tail(&item->list, &pool->high_items);
+		list_add_tail(&page->lru, &pool->high_items);
 		pool->high_count++;
 	} else {
-		list_add_tail(&item->list, &pool->low_items);
+		list_add_tail(&page->lru, &pool->low_items);
 		pool->low_count++;
 	}
 	mutex_unlock(&pool->mutex);
@@ -68,24 +56,19 @@ static int ion_page_pool_add(struct ion_page_pool *pool, struct page *page)
 
 static struct page *ion_page_pool_remove(struct ion_page_pool *pool, bool high)
 {
-	struct ion_page_pool_item *item;
 	struct page *page;
 
 	if (high) {
 		BUG_ON(!pool->high_count);
-		item = list_first_entry(&pool->high_items,
-					struct ion_page_pool_item, list);
+		page = list_first_entry(&pool->high_items, struct page, lru);
 		pool->high_count--;
 	} else {
 		BUG_ON(!pool->low_count);
-		item = list_first_entry(&pool->low_items,
-					struct ion_page_pool_item, list);
+		page = list_first_entry(&pool->low_items, struct page, lru);
 		pool->low_count--;
 	}
 
-	list_del(&item->list);
-	page = item->page;
-	kfree(item);
+	list_del(&page->lru);
 	return page;
 }
 
-- 
1.9.1

