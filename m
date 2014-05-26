Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbaEZKHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 06:07:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:39915 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaEZKHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 06:07:02 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-c3-5383124446b6
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
Subject: [PATCH 3/9] staging: ion: use compound pages on high order pages for
 system heap
Date: Mon, 26 May 2014 19:04:55 +0900
Message-id: <1401098701-24049-3-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
References: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsVy+t8zbV0XoeZgg3+/RS3e/73PZrF94zdW
	i5eHNC0OfrjPYrHnzC92i+bF69ksDs5ewmRx5reuxeVdc9gs1s7fxmZxY3KhxemORawOPB7b
	dm9j9bjc18vkcW/fYRaPnbPusnvcubaHzWP/3DXsHn1bVjF6fN4kF8ARxWWTkpqTWZZapG+X
	wJWxY2Evc0ELX8WTBVvYGxibeLoYOTkkBEwkZh65wghhi0lcuLeerYuRi0NIYBmjxNO+U4ww
	RZ3/trFAJKYzSuxYtBiqqp1J4tv6W0AOBwebgLbEoW3BIA0iAsYS/WdnsYPUMAvMYZaYsvUC
	E0hCWCBa4uj3x+wgNouAqsSb7W+YQHp5Bdwl2pYWQiyTkzh5bDIriM0p4CEx8ckcFhBbCKjk
	9saHbBA119glNvzKhRgjIPFt8iEWkDESArISmw4wQ5RIShxccYNlAqPwAkaGVYyiqQXJBcVJ
	6UVGesWJucWleel6yfm5mxgh8dK3g/HmAetDjMlA4yYyS4km5wPjLa8k3tDYzMjC1MTU2Mjc
	0ow0YSVx3kUPk4KEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MEZfje8p6OB037B3ZuQ0U//r
	0urVBrPFY+cpyEpJ12Tce7Hr/iWNR5PTMp47G3Pc/nJf/9LpaIfqOc+nfJbrumqd9nB2zmWW
	SvVkS02hqPd/Yy61TZ+//s3tWz8EHggx7i15of7l/Z9Qq/m9ut3vnA6c9peXDyuUfsyyZ8XR
	sPYzDnHzd39+06XEUpyRaKjFXFScCADlncKorQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t9jQV0XoeZggykdghbv/95ns9i+8Rur
	xctDmhYHP9xnsdhz5he7RfPi9WwWB2cvYbI481vX4vKuOWwWa+dvY7O4MbnQ4nTHIlYHHo9t
	u7exelzu62XyuLfvMIvHzll32T3uXNvD5rF/7hp2j74tqxg9Pm+SC+CIamC0yUhNTEktUkjN
	S85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6VkmhLDGnFCgUkFhcrKRv
	h2lCaIibrgVMY4Sub0gQXI+RARpIWMeYsWNhL3NBC1/FkwVb2BsYm3i6GDk5JARMJDr/bWOB
	sMUkLtxbz9bFyMUhJDCdUWLHosVQTjuTxLf1t4AcDg42AW2JQ9uCQRpEBIwl+s/OYgepYRaY
	wywxZesFJpCEsEC0xNHvj9lBbBYBVYk3298wgfTyCrhLtC0thFgmJ3Hy2GRWEJtTwENi4pM5
	YEcIAZXc3viQbQIj7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwfH4THoH46oGi0OM
	AhyMSjy8B7ybgoVYE8uKK3MPMUpwMCuJ8GpxNgcL8aYkVlalFuXHF5XmpBYfYkwGOmois5Ro
	cj4wVeSVxBsam5gZWRqZGZuYGxuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA+Mc30mh
	5vKnzu36wVxyPCXeLGDhvxylf2l1i+d6GO/0O7Hv0iJbA+Yjil8DF++vPj11bXx1f9Chyefj
	z22bekOUa4VZa77xMWXGG9NyxNoEWaT+Gzbe9rq4YINK1InLTBFxUlaiVa9aH88UN31UrRQ+
	89Cv7fUHqjesObq/7kystsLM/Lhu9jwlluKMREMt5qLiRAC+Bu64CwMAAA==
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
index 1684780..0141b3b 100644
--- a/drivers/staging/android/ion/ion_page_pool.c
+++ b/drivers/staging/android/ion/ion_page_pool.c
@@ -112,6 +112,8 @@ void ion_page_pool_free(struct ion_page_pool *pool, struct page *page)
 {
 	int ret;
 
+	BUG_ON(pool->order != compound_order(page));
+
 	ret = ion_page_pool_add(pool, page);
 	if (ret)
 		ion_page_pool_free_pages(pool, page);
@@ -167,7 +169,7 @@ struct ion_page_pool *ion_page_pool_create(gfp_t gfp_mask, unsigned int order)
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

