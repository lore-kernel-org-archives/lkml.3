Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbaKQNpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:45:51 -0500
Received: from down.free-electrons.com ([37.187.137.238]:49106 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753052AbaKQNpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:45:46 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v5 53/61] dmaengine: edma: Declare slave capabilities for the generic code
Date: Mon, 17 Nov 2014 14:42:47 +0100
Message-Id: <1416231775-31252-54-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the generic slave caps code can make use of the device assigned
capabilities, instead of relying on a callback to be implemented.

Make use of this code.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/edma.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 56735a0aa3a8..7aaa59048e2d 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -971,19 +971,6 @@ static void __init edma_chan_init(struct edma_cc *ecc,
 				 BIT(DMA_SLAVE_BUSWIDTH_3_BYTES) | \
 				 BIT(DMA_SLAVE_BUSWIDTH_4_BYTES))
 
-static int edma_dma_device_slave_caps(struct dma_chan *dchan,
-				      struct dma_slave_caps *caps)
-{
-	caps->src_addr_widths = EDMA_DMA_BUSWIDTHS;
-	caps->dst_addr_widths = EDMA_DMA_BUSWIDTHS;
-	caps->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
-	caps->cmd_pause = true;
-	caps->cmd_terminate = true;
-	caps->residue_granularity = DMA_RESIDUE_GRANULARITY_BURST;
-
-	return 0;
-}
-
 static void edma_dma_init(struct edma_cc *ecc, struct dma_device *dma,
 			  struct device *dev)
 {
@@ -998,7 +985,12 @@ static void edma_dma_init(struct edma_cc *ecc, struct dma_device *dma,
 	dma->device_pause = edma_dma_pause;
 	dma->device_resume = edma_dma_resume;
 	dma->device_terminate_all = edma_terminate_all;
-	dma->device_slave_caps = edma_dma_device_slave_caps;
+
+	dma->src_addr_widths = EDMA_DMA_BUSWIDTHS;
+	dma->dst_addr_widths = EDMA_DMA_BUSWIDTHS;
+	dma->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
+	dma->residue_granularity = DMA_RESIDUE_GRANULARITY_BURST;
+
 	dma->dev = dev;
 
 	/*
-- 
2.1.1

