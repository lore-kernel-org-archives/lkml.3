Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbaEZKH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 06:07:27 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48320 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbaEZKHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 06:07:15 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-ad-538312529976
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
Subject: [PATCH 8/9] staging: ion: shrink highmem pages on kswapd
Date: Mon, 26 May 2014 19:05:00 +0900
Message-id: <1401098701-24049-8-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
References: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsVy+t8zTd0goeZggzU3lCze/73PZrF94zdW
	i5eHNC0OfrjPYrHnzC92i+bF69ksDs5ewmRx5reuxeVdc9gs1s7fxmZxY3KhxemORawOPB7b
	dm9j9bjc18vkcW/fYRaPnbPusnvcubaHzWP/3DXsHn1bVjF6fN4kF8ARxWWTkpqTWZZapG+X
	wJWx8MsX1oKHfBUTdr5jbWBcztPFyMkhIWAicXfNJmYIW0ziwr31bCC2kMAyRonXj51gaj53
	vWHsYuQCik9nlDg5byoThNPOJPH95jIgh4ODTUBb4tC2YJAGEQFjif6zs9hBapgF5jBLTNl6
	gQkkISzgKLH011kWEJtFQFVi/stVjCA2r4C7RO+CJ+wQ2+QkTh6bzApicwp4SEx8MocF4iJ3
	idsbH7KBDJUQuMYu8W3nRmaIQQIS3yYfYgE5QkJAVmLTAahvJCUOrrjBMoFReAEjwypG0dSC
	5ILipPQiQ73ixNzi0rx0veT83E2MkIjp3cF4+4D1IcZkoHETmaVEk/OBEZdXEm9obGZkYWpi
	amxkbmlGmrCSOG/Sw6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYzrA9b8UxC38Ox0/Mp/
	sOnAviPiZ3s4/JhLiucd8xXd79XxU3HCdU+Wr3LRxxNy+g0vTT/L8D4037Wva7ZJgtnUaTZl
	r6dzyW6cnH4t1G2uW9yUDay/18+W/Virvbe96drs9erHtgnq37UL8ulY4pDuZTTNm4uZzbM+
	amoNT55Zk8f/OV7vvimxFGckGmoxFxUnAgBKlzlhrgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jQd0goeZgg43b5Sze/73PZrF94zdW
	i5eHNC0OfrjPYrHnzC92i+bF69ksDs5ewmRx5reuxeVdc9gs1s7fxmZxY3KhxemORawOPB7b
	dm9j9bjc18vkcW/fYRaPnbPusnvcubaHzWP/3DXsHn1bVjF6fN4kF8AR1cBok5GamJJapJCa
	l5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0rJJCWWJOKVAoILG4WEnf
	DtOE0BA3XQuYxghd35AguB4jAzSQsI4xY+GXL6wFD/kqJux8x9rAuJyni5GTQ0LAROJz1xtG
	CFtM4sK99WxdjFwcQgLTGSVOzpvKBOG0M0l8v7kMyOHgYBPQlji0LRikQUTAWKL/7Cx2kBpm
	gTnMElO2XmACSQgLOEos/XWWBcRmEVCVmP9yFdgGXgF3id4FT9ghtslJnDw2mRXE5hTwkJj4
	ZA5YvRBQze2ND9kmMPIuYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREckc+kdzCuarA4
	xCjAwajEw3vAuylYiDWxrLgy9xCjBAezkgivFmdzsBBvSmJlVWpRfnxRaU5q8SHGZKCrJjJL
	iSbnA5NFXkm8obGJmZGlkZmxibmxMWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwsl37
	6n3rrpFvX/BrM8uoNSYr85bvYL+olT7h43tm1RXnu3P+NkbMMt5c0XtM8vu7XF0fkSeqsS1l
	Vqptz9hnXf7wUrR1/pmkzv+PDK5eaNshcfOB1NWu2cr7JLSeqRyca9Rotv1c2VPrKDeXw9W/
	ikMYubNXv4x5o2115pfu75pL58L8vq/iV2Ipzkg01GIuKk4EAIfMcMgMAwAA
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

