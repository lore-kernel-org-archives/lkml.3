Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321AbaJVPyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:54:16 -0400
Received: from down.free-electrons.com ([37.187.137.238]:54249 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755015AbaJVPqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:46:04 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 52/59] dmaengine: edma: Declare slave capabilities for the generic code
Date: Wed, 22 Oct 2014 17:44:06 +0200
Message-Id: <1413992653-21963-53-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the generic slave caps code can make use of the device assigned
capabilities, instead of relying on a callback to be implemented.

Make use of this code.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/edma.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 56735a0aa3a8..ea9c03122806 100644
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
@@ -998,7 +985,13 @@ static void edma_dma_init(struct edma_cc *ecc, struct dma_device *dma,
 	dma->device_pause = edma_dma_pause;
 	dma->device_resume = edma_dma_resume;
 	dma->device_terminate_all = edma_terminate_all;
-	dma->device_slave_caps = edma_dma_device_slave_caps;
+
+	dma->src_addr_widths = EDMA_DMA_BUSWIDTHS;
+	dma->dst_addr_widths = EDMA_DMA_BUSWIDTHS;
+	dma->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
+	dma->residue_granularity = DMA_RESIDUE_GRANULARITY_BURST;
+	dma->generic_slave_caps = true;
+
 	dma->dev = dev;
 
 	/*
-- 
2.1.1

