Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbaJVPxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:53:33 -0400
Received: from down.free-electrons.com ([37.187.137.238]:54095 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755032AbaJVPqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:46:07 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 54/59] dmaengine: omap: Declare slave capabilities for the generic code
Date: Wed, 22 Oct 2014 17:44:08 +0200
Message-Id: <1413992653-21963-55-git-send-email-maxime.ripard@free-electrons.com>
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
 drivers/dma/omap-dma.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
index 90c0bdd53bb0..b66860a93ae4 100644
--- a/drivers/dma/omap-dma.c
+++ b/drivers/dma/omap-dma.c
@@ -1072,19 +1072,6 @@ static void omap_dma_free(struct omap_dmadev *od)
 				 BIT(DMA_SLAVE_BUSWIDTH_2_BYTES) | \
 				 BIT(DMA_SLAVE_BUSWIDTH_4_BYTES))
 
-static int omap_dma_device_slave_caps(struct dma_chan *dchan,
-				      struct dma_slave_caps *caps)
-{
-	caps->src_addr_widths = OMAP_DMA_BUSWIDTHS;
-	caps->dst_addr_widths = OMAP_DMA_BUSWIDTHS;
-	caps->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
-	caps->cmd_pause = true;
-	caps->cmd_terminate = true;
-	caps->residue_granularity = DMA_RESIDUE_GRANULARITY_BURST;
-
-	return 0;
-}
-
 static int omap_dma_probe(struct platform_device *pdev)
 {
 	struct omap_dmadev *od;
@@ -1118,7 +1105,11 @@ static int omap_dma_probe(struct platform_device *pdev)
 	od->ddev.device_pause = omap_dma_pause;
 	od->ddev.device_resume = omap_dma_resume;
 	od->ddev.device_terminate_all = omap_dma_terminate_all;
-	od->ddev.device_slave_caps = omap_dma_device_slave_caps;
+	od->ddev.src_addr_widths = OMAP_DMA_BUSWIDTHS;
+	od->ddev.dst_addr_widths = OMAP_DMA_BUSWIDTHS;
+	od->ddev.directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
+	od->ddev.residue_granularity = DMA_RESIDUE_GRANULARITY_BURST;
+	od->ddev.generic_slave_caps = true;
 	od->ddev.dev = &pdev->dev;
 	INIT_LIST_HEAD(&od->ddev.channels);
 	INIT_LIST_HEAD(&od->pending);
-- 
2.1.1

