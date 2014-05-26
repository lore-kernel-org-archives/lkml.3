Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaEZKHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 06:07:06 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:36762 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaEZKHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 06:07:03 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-14-538312450735
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
Subject: [PATCH 4/9] staging: ion: remove struct ion_page_pool_item
Date: Mon, 26 May 2014 19:04:56 +0900
Message-id: <1401098701-24049-4-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
References: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsVy+t8zLV1XoeZgg/2PuC3e/73PZrF94zdW
	i5eHNC0OfrjPYrHnzC92i+bF69ksDs5ewmRx5reuxeVdc9gs1s7fxmZxY3KhxemORawOPB7b
	dm9j9bjc18vkcW/fYRaPnbPusnvcubaHzWP/3DXsHn1bVjF6fN4kF8ARxWWTkpqTWZZapG+X
	wJVxs/k0c8FnoYrHy/6xNDA+4e9i5OSQEDCReP1pIwuELSZx4d56ti5GLg4hgWWMEjf3zGaH
	Kfq3dgs7RGI6o8T5ltmsEE47k8S39beAWjg42AS0JQ5tCwZpEBEwlug/OwusgVlgDrPElK0X
	mEBqhAWcJU7MTQGpYRFQlfj/8gcbiM0r4C5x/MFJqCvkJE4em8wKYnMKeEhMfDIHLC4EVHN7
	40Ow6yQErrFLtL7/yA4xSEDi2+RDLCDzJQRkJTYdYIaYIylxcMUNlgmMwgsYGVYxiqYWJBcU
	J6UXGeoVJ+YWl+al6yXn525ihERM7w7G2wesDzEmA42byCwlmpwPjLi8knhDYzMjC1MTU2Mj
	c0sz0oSVxHmTHiYFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDU5/rCL2+96bM358dVNn5F
	OYz7chtuKOn90ZI7by0gs236m18TmjT85mx/tzGxs+NWxkkb9QPy8wXb5vivNX5hPMMy0i1o
	YoLHF1elawydZa/kveYJPOipcHq1XEg/LjlbyvhiyKUX69fJ/Bc+Jq//+6gDh8Gh3Vk/3oib
	/GKINmvXbdBZfV+JpTgj0VCLuag4EQCMBB1brgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t9jQV1XoeZggy8L2S3e/73PZrF94zdW
	i5eHNC0OfrjPYrHnzC92i+bF69ksDs5ewmRx5reuxeVdc9gs1s7fxmZxY3KhxemORawOPB7b
	dm9j9bjc18vkcW/fYRaPnbPusnvcubaHzWP/3DXsHn1bVjF6fN4kF8AR1cBok5GamJJapJCa
	l5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0rJJCWWJOKVAoILG4WEnf
	DtOE0BA3XQuYxghd35AguB4jAzSQsI4x42bzaeaCz0IVj5f9Y2lgfMLfxcjJISFgIvFv7RZ2
	CFtM4sK99WxdjFwcQgLTGSXOt8xmhXDamSS+rb8FlOHgYBPQlji0LRikQUTAWKL/7Cx2kBpm
	gTnMElO2XmACqREWcJY4MTcFpIZFQFXi/8sfbCA2r4C7xPEHJ1kglslJnDw2mRXE5hTwkJj4
	ZA5YXAio5vbGh2wTGHkXMDKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiOx2fSOxhXNVgc
	YhTgYFTi4T3g3RQsxJpYVlyZe4hRgoNZSYRXi7M5WIg3JbGyKrUoP76oNCe1+BBjMtBVE5ml
	RJPzgakiryTe0NjEzMjSyMzYxNzYmDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYuzy5
	5b9obJpwo+6Ic7B7W88RwcNVe1tafjztfHz4UcVLW5NJXbaFGrvkJta6p7RL+6ntEfm0u28v
	R+gMsagAL84JOSFzww/d41owKfXY9adzCnlj+/bcP3Z+/eUSrltTKgM2bc2ek2iTe7xmv+S/
	ebWHDLRWH1a5oP7BcI/r3AeTfp3denGLqxJLcUaioRZzUXEiACCgbMsLAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the order information is held on struct page itself, we do not
need to use extra data structure. This commit reduces unnecessary slab
usage for allocating small objects.

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
---
 drivers/staging/android/ion/ion_page_pool.c | 27 +++++----------------------
 1 file changed, 5 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/android/ion/ion_page_pool.c b/drivers/staging/android/ion/ion_page_pool.c
index 0141b3b..c1cea42b 100644
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

