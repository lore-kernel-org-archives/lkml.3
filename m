Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbaJFIj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 04:39:28 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:60285 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbaJFIjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 04:39:25 -0400
X-AuditID: cbfee68f-f791c6d000004834-00-5432553af641
From: Pintu Kumar <pintu.k@samsung.com>
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        john.stultz@linaro.org, rebecca@android.com, ccross@android.com,
        heesub.shin@samsung.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: cpgs@samsung.com, pintu.k@samsung.com, pintu_agarwal@yahoo.com,
        vishnu.ps@samsung.com, iqbal.ams@samsung.com
Subject: [PATCH 1/1] [ion]: system-heap use PAGE_ALLOC_COSTLY_ORDER for high
 order
Date: Mon, 06 Oct 2014 14:01:03 +0530
Message-id: <1412584263-22531-1-git-send-email-pintu.k@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsWyRsSkVtc61CjE4NR+Zos569ewWWzf+I3V
	4uUhTYs9Z36xWzQvXs9mcXD2EiaL2b8mMVmc+a1rcXnXHDaLvu+H2S2+vb3NbnFjcqHFlL67
	jA68Htt2b2P1uLfvMIvHnWt72DxOzPjN4rF/7hp2j74tqxg9Pm+S85g16zBTAEcUl01Kak5m
	WWqRvl0CV8apJ/OYChbyVHy/toC9gXEOVxcjJ4eEgInEnoN/2SFsMYkL99azdTFycQgJLGWU
	2NG3gBmmaNbVBUwQiemMEheevAfrEBLoYZJ4/9QUxGYTUJf48eY3I0iRiMBlRon1qx6AFTEL
	FEk0tS9nBbGFBUIk5qzbCRZnEVCVeHh2DxOIzSvgLHF9z2KgOAfQNgWJOZNsQOZICBxil/j6
	/DIzRL2AxLfJh1ggamQlNh2AOk5S4uCKGywTGAUXMDKsYhRNLUguKE5KLzLWK07MLS7NS9dL
	zs/dxAiMhdP/nvXvYLx7wPoQowAHoxIPb8QOwxAh1sSy4srcQ4ymQBsmMkuJJucDIy6vJN7Q
	2MzIwtTE1NjI3NJMSZx3odTPYCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MG25Nc2u8GTxB
	gUWgY9JKP2dNhrnuov8XVhnJhRicmPTqp065bEv8j5eFpvmfzxWm9y69lXj4iNyNkws4r+i8
	Uzy0LLjFpeXs051XLL46XQp/0lgU/P68zZSLs28yNZ3gm9Jp7Lrea5vKkXjJZK5krmevw593
	r/Y77nM9ybU964uVIkPvkyeCSizFGYmGWsxFxYkANWmvBoACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jQV2rUKMQgxsfLSzmrF/DZrF94zdW
	i5eHNC32nPnFbtG8eD2bxcHZS5gsZv+axGRx5reuxeVdc9gs+r4fZrf49vY2u8WNyYUWU/ru
	MjrwemzbvY3V496+wywed67tYfM4MeM3i8f+uWvYPfq2rGL0+LxJzmPWrMNMARxRDYw2GamJ
	KalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUAXKymUJeaUAoUC
	EouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgzTj2Zx1SwkKfi+7UF7A2Mc7i6GDk5JARM
	JGZdXcAEYYtJXLi3nq2LkYtDSGA6o8SFJ+/ZQRJCAj1MEu+fmoLYbALqEj/e/GYEKRIRuMwo
	sX7VA7AiZoEiiab25awgtrBAiMScdTvB4iwCqhIPz+4B28Ar4Cxxfc9ioDgH0DYFiTmTbCYw
	ci9gZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERxpz6R2MK5ssDjEKMDBqMTDG7HDMESI
	NbGsuDL3EKMEB7OSCG+oh1GIEG9KYmVValF+fFFpTmrxIUZToOUTmaVEk/OBSSCvJN7Q2MTc
	1NjU0sTCxMxSSZz3QKt1oJBAemJJanZqakFqEUwfEwenVAOjacuRum693pJZ/dpiM3Rz58m5
	VxvzXXu8XXGTHGfFxbKlC2TinDlNd7w0nB2Tw/2gd9d6swS1gAAbf8PQ1gWz2k9+8fCUeXBc
	ZMZj1a0f6/s0/5zo9JDR25SWoCUo/4nb6MvJ7aLhXgHLvzYl1+1qcziwb7Pmv+THV5McHNdc
	4Q7L1Oi1Y1RiKc5INNRiLipOBAA4JN4rygIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Android ion_system_heap uses allocation fallback mechanism
based on 8,4,0 order pages available in the system.
It changes gfp flags based on higher order allocation request.
This higher order value is hard-coded as 4, instead of using
the system defined higher order value.
Thus replacing this hard-coded value with PAGE_ALLOC_COSTLY_ORDER
which is defined as 3.
This will help mapping the higher order request in system heap with
the actual allocation request.

Signed-off-by: Pintu Kumar <pintu.k@samsung.com>
---
 drivers/staging/android/ion/ion_system_heap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index da2a63c..e6c393f 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -65,7 +65,7 @@ static struct page *alloc_buffer_page(struct ion_system_heap *heap,
 	} else {
 		gfp_t gfp_flags = low_order_gfp_flags;
 
-		if (order > 4)
+		if (order > PAGE_ALLOC_COSTLY_ORDER)
 			gfp_flags = high_order_gfp_flags;
 		page = alloc_pages(gfp_flags | __GFP_COMP, order);
 		if (!page)
@@ -276,7 +276,7 @@ struct ion_heap *ion_system_heap_create(struct ion_platform_heap *unused)
 		struct ion_page_pool *pool;
 		gfp_t gfp_flags = low_order_gfp_flags;
 
-		if (orders[i] > 4)
+		if (orders[i] > PAGE_ALLOC_COSTLY_ORDER)
 			gfp_flags = high_order_gfp_flags;
 		pool = ion_page_pool_create(gfp_flags, orders[i]);
 		if (!pool)
-- 
1.7.9.5

