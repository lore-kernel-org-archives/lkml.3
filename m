Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbaE1Gyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 02:54:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:52414 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbaE1GxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 02:53:18 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-56-538587dc7129
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
Subject: [PATCH v2 8/9] staging: ion: shrink highmem pages on kswapd
Date: Wed, 28 May 2014 15:52:59 +0900
Message-id: <1401259980-26927-9-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401259980-26927-1-git-send-email-heesub.shin@samsung.com>
References: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
 <1401259980-26927-1-git-send-email-heesub.shin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsVy+t8zPd077a3BBrO7DSze/73PZrF94zdW
	i5eHNC1OXKy1OPjhPovFnjO/2C2aF69nszg4ewmTxZnfuhaXd81hs1g7fxubxY3JhRanOxax
	OvB6bNu9jdXjcl8vk8e9fYdZPHbOusvucefaHjaP/XPXsHv0bVnF6PF5k1wARxSXTUpqTmZZ
	apG+XQJXxsIvX1gLHvJVTNj5jrWBcTlPFyMnh4SAicT7a1NZIGwxiQv31rN1MXJxCAksY5Q4
	+msGM0zRsh9t7BCJRYwS/cdOMIEkhATamSS+n/LvYuTgYBPQlji0LRgkLCJgLNF/dhZYPbPA
	YWaJrllr2UASwgIuEtt2d4L1sgioSux6/oEJpJdXwF2ie7olxC45iZPHJrOChDkFPCS2vwmB
	WNvKKDH9+HNGEEdC4B67xN8Ds6DmCEh8m3yIBaRBQkBWYtMBqJslJQ6uuMEygVF4ASPDKkbR
	1ILkguKk9CJDveLE3OLSvHS95PzcTYyQuOndwXj7gPUhxmSgcROZpUST84Fxl1cSb2hsZmRh
	amJqbGRuaUaasJI4b9LDpCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjGYpSisKe+YefFSR
	ek1n2SdjvyaxZQf6rA2/V6qczNnRXt3TseHbxu95Ybedl5VeZVzyIGP3hqmqiyOfM6/s3L/v
	xaeV17VNIxJeTlp4s+fQh5avFh4P2DYFHf68RFYvMf7/PxuV7xYrLzencDenRRq/bbgZvcnw
	S9Diax2vD7Odm/6gMGbBoQNKLMUZiYZazEXFiQC+tz/KsQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jAd077a3BBguWa1u8/3ufzWL7xm+s
	Fi8PaVqcuFhrcfDDfRaLPWd+sVs0L17PZnFw9hImizO/dS0u75rDZrF2/jY2ixuTCy1Odyxi
	deD12LZ7G6vH5b5eJo97+w6zeOycdZfd4861PWwe++euYffo27KK0ePzJrkAjqgGRpuM1MSU
	1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoIOVFMoSc0qBQgGJ
	xcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBkLv3xhLXjIVzFh5zvWBsblPF2MnBwSAiYS
	y360sUPYYhIX7q1n62Lk4hASWMQo0X/sBBNIQkignUni+yn/LkYODjYBbYlD24JBwiICxhL9
	Z2exg9QzCxxmluiatZYNJCEs4CKxbXcnWC+LgKrErucfmEB6eQXcJbqnW0LskpM4eWwyK0iY
	U8BDYvubEIi1rYwS048/Z5zAyLuAkWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnBUPpPe
	wbiqweIQowAHoxIP74HFLcFCrIllxZW5hxglOJiVRHhvFrYGC/GmJFZWpRblxxeV5qQWH2JM
	BjpqIrOUaHI+MGHklcQbGpuYGVkamRmbmBsbkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwen
	VAOjVcsz//iqfJUPPopMU66+0gi7InNxh6tWMY/Q5l1L9sQsaKo+Gv5bcq7Cu9UyDBHXfxSI
	7VFZePfpx9Dqd1MtWVq/PDhuo7XLSVHvXcPdzDIdYT8lhQsCxyMPyria7tOrn73kzM8poUdU
	dmnHbXzx3W9iikeoepfGyZrEzazrOspmxZtFynxXYinOSDTUYi4qTgQAClk7CA4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ION system heap keeps pages in its pool for better performance. When the
system is under memory pressure, slab shrinker calls the callback
registered and then the pages pooled get freed.

When the shrinker is called, it checks gfp_mask and determines whether
the pages from highmem need to be freed or the pages from lowmem.
Usually, slab shrinker is invoked on kswapd context which gfp_mask is
always GFP_KERNEL, so only lowmem pages are released on kswapd context.
This means that highmem pages in the pool are never reclaimed until
direct reclaim occurs. This can be problematic when the page pool holds
excessive amounts of highmem.

For now, the shrinker callback cannot know exactly which zone should be
targeted for reclamation, as enough information are not passed to. Thus,
it makes sense to shrink both lowmem and highmem zone on kswapd context.

Reported-by: Wonseo Choi <wonseo.choi@samsung.com>
Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
---
 drivers/staging/android/ion/ion_page_pool.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion_page_pool.c b/drivers/staging/android/ion/ion_page_pool.c
index c1cea42b..5864f3d 100644
--- a/drivers/staging/android/ion/ion_page_pool.c
+++ b/drivers/staging/android/ion/ion_page_pool.c
@@ -21,6 +21,7 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/swap.h>
 #include "ion_priv.h"
 
 static void *ion_page_pool_alloc_pages(struct ion_page_pool *pool)
@@ -118,7 +119,10 @@ int ion_page_pool_shrink(struct ion_page_pool *pool, gfp_t gfp_mask,
 	int freed;
 	bool high;
 
-	high = !!(gfp_mask & __GFP_HIGHMEM);
+	if (current_is_kswapd())
+		high = 1;
+	else
+		high = !!(gfp_mask & __GFP_HIGHMEM);
 
 	if (nr_to_scan == 0)
 		return ion_page_pool_total(pool, high);
-- 
1.9.1

