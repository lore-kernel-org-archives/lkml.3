Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbaKQNpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:45:54 -0500
Received: from down.free-electrons.com ([37.187.137.238]:49102 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752596AbaKQNpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:45:45 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v5 52/61] dmaengine: fsl-edma: Declare slave capabilities for the generic code
Date: Mon, 17 Nov 2014 14:42:46 +0100
Message-Id: <1416231775-31252-53-git-send-email-maxime.ripard@free-electrons.com>
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
 drivers/dma/fsl-edma.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/dma/fsl-edma.c b/drivers/dma/fsl-edma.c
index b5b7474f8859..1382332e7e49 100644
--- a/drivers/dma/fsl-edma.c
+++ b/drivers/dma/fsl-edma.c
@@ -784,18 +784,6 @@ static void fsl_edma_free_chan_resources(struct dma_chan *chan)
 	fsl_chan->tcd_pool = NULL;
 }
 
-static int fsl_dma_device_slave_caps(struct dma_chan *dchan,
-		struct dma_slave_caps *caps)
-{
-	caps->src_addr_widths = FSL_EDMA_BUSWIDTHS;
-	caps->dst_addr_widths = FSL_EDMA_BUSWIDTHS;
-	caps->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
-	caps->cmd_pause = true;
-	caps->cmd_terminate = true;
-
-	return 0;
-}
-
 static int
 fsl_edma_irq_init(struct platform_device *pdev, struct fsl_edma_engine *fsl_edma)
 {
@@ -926,7 +914,10 @@ static int fsl_edma_probe(struct platform_device *pdev)
 	fsl_edma->dma_dev.device_resume = fsl_edma_resume;
 	fsl_edma->dma_dev.device_terminate_all = fsl_edma_terminate_all;
 	fsl_edma->dma_dev.device_issue_pending = fsl_edma_issue_pending;
-	fsl_edma->dma_dev.device_slave_caps = fsl_dma_device_slave_caps;
+
+	fsl_edma->dma_dev.src_addr_widths = FSL_EDMA_BUSWIDTHS;
+	fsl_edma->dma_dev.dst_addr_widths = FSL_EDMA_BUSWIDTHS;
+	fsl_edma->dma_dev.directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
 
 	platform_set_drvdata(pdev, fsl_edma);
 
-- 
2.1.1

