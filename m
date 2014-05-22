Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbaEVBh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 21:37:27 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:55751 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaEVBh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 21:37:26 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <537D54D3.9060908@lge.com>
Date: Thu, 22 May 2014 10:37:23 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
CC: =?EUC-KR?B?wMywx8ij?= <gunho.lee@lge.com>
Subject: [RFC] I found an errataum at drivers/base/dma-contiguous.c:294
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not a big deal but I think get_dev_cma_area is errataum of dev_get_cma_area.


diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
index b056661..6343f25 100644
--- a/drivers/base/dma-contiguous.c
+++ b/drivers/base/dma-contiguous.c
@@ -291,7 +291,7 @@ err:
  *
  * This function allocates memory buffer for specified device. It uses
  * device specific contiguous memory area if available or the default
- * global one. Requires architecture specific get_dev_cma_area() helper
+ * global one. Requires architecture specific dev_get_cma_area() helper
  * function.
  */
 struct page *dma_alloc_from_contiguous(struct device *dev, int count,


