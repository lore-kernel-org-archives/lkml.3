Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933909Ab3FSArY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 20:47:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:5564 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932860Ab3FSArD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 20:47:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,892,1363158000"; 
   d="scan'208";a="331828485"
From: Jon Mason <jon.mason@intel.com>
To: Dan Williams <djbw@fb.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dave Jiang <dave.jiang@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ioatdma: add DMA_PRIVATE capabilities flag
Date: Tue, 18 Jun 2013 17:46:53 -0700
Message-Id: <1371602813-19828-3-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371602813-19828-1-git-send-email-jon.mason@intel.com>
References: <1371602813-19828-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the DMA_PRIVATE dma_transaction_type in the capability mask.  This
enables the ability to get an exclusive ioatdma DMA channel for any
devices that requests one via the dma_request_channel function call.

Signed-off-by: Jon Mason <jon.mason@intel.com>
Acked-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/ioat/dma_v3.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index ca6ea9b..ac2aeef 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -1883,6 +1883,7 @@ int ioat3_dma_probe(struct ioatdma_device *device, int dca)
 		dma->copy_align = 6;
 
 	dma_cap_set(DMA_INTERRUPT, dma->cap_mask);
+	dma_cap_set(DMA_PRIVATE, dma->cap_mask);
 	dma->device_prep_dma_interrupt = ioat3_prep_interrupt_lock;
 
 	device->cap = readl(device->reg_base + IOAT_DMA_CAP_OFFSET);
-- 
1.7.9.5

