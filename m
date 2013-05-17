Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab3EQRyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 13:54:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:56548 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756504Ab3EQRyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 13:54:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,694,1363158000"; 
   d="scan'208";a="304105863"
From: Jon Mason <jon.mason@intel.com>
To: Dan Williams <djbw@fb.com>
Cc: linux-kernel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH] dmatest: add ability to disable pq and xor
Date: Fri, 17 May 2013 10:54:03 -0700
Message-Id: <1368813243-29547-1-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmatest would create a thread to stress XOR and PQ, if the capability is
present in the hardware.  Add the ability to disable XOR and PQ by
disabling it if *_sources are set to zero.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/dma/dmatest.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index d8ce4ec..7de610d 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -904,11 +904,11 @@ static int dmatest_add_channel(struct dmatest_info *info,
 		cnt = dmatest_add_threads(info, dtc, DMA_MEMCPY);
 		thread_count += cnt > 0 ? cnt : 0;
 	}
-	if (dma_has_cap(DMA_XOR, dma_dev->cap_mask)) {
+	if (dma_has_cap(DMA_XOR, dma_dev->cap_mask) && xor_sources) {
 		cnt = dmatest_add_threads(info, dtc, DMA_XOR);
 		thread_count += cnt > 0 ? cnt : 0;
 	}
-	if (dma_has_cap(DMA_PQ, dma_dev->cap_mask)) {
+	if (dma_has_cap(DMA_PQ, dma_dev->cap_mask) && pq_sources) {
 		cnt = dmatest_add_threads(info, dtc, DMA_PQ);
 		thread_count += cnt > 0 ? cnt : 0;
 	}
-- 
1.7.9.5

