Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbaJVPqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:46:08 -0400
Received: from down.free-electrons.com ([37.187.137.238]:54235 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754983AbaJVPqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:46:02 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        linux-rpi-kernel@lists.infradead.org
Subject: [PATCH v3 50/59] dmaengine: bcm2835: Declare slave capabilities for the generic code
Date: Wed, 22 Oct 2014 17:44:04 +0200
Message-Id: <1413992653-21963-51-git-send-email-maxime.ripard@free-electrons.com>
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
Acked-by: Stephen Warren <swarren@wwwdotorg.org>
---
 drivers/dma/bcm2835-dma.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/dma/bcm2835-dma.c b/drivers/dma/bcm2835-dma.c
index 243bb1ed6bfc..f4f200113e0f 100644
--- a/drivers/dma/bcm2835-dma.c
+++ b/drivers/dma/bcm2835-dma.c
@@ -552,18 +552,6 @@ static struct dma_chan *bcm2835_dma_xlate(struct of_phandle_args *spec,
 	return chan;
 }
 
-static int bcm2835_dma_device_slave_caps(struct dma_chan *dchan,
-	struct dma_slave_caps *caps)
-{
-	caps->src_addr_widths = BIT(DMA_SLAVE_BUSWIDTH_4_BYTES);
-	caps->dst_addr_widths = BIT(DMA_SLAVE_BUSWIDTH_4_BYTES);
-	caps->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
-	caps->cmd_pause = false;
-	caps->cmd_terminate = true;
-
-	return 0;
-}
-
 static int bcm2835_dma_probe(struct platform_device *pdev)
 {
 	struct bcm2835_dmadev *od;
@@ -605,6 +593,10 @@ static int bcm2835_dma_probe(struct platform_device *pdev)
 	od->ddev.device_prep_dma_cyclic = bcm2835_dma_prep_dma_cyclic;
 	od->ddev.device_config = bcm2835_dma_slave_config;
 	od->ddev.device_terminate_all = bcm2835_dma_terminate_all;
+	od->ddev.generic_slave_caps = true;
+	od->ddev.src_addr_widths = BIT(DMA_SLAVE_BUSWIDTH_4_BYTES);
+	od->ddev.dst_addr_widths = BIT(DMA_SLAVE_BUSWIDTH_4_BYTES);
+	od->ddev.directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
 	od->ddev.dev = &pdev->dev;
 	INIT_LIST_HEAD(&od->ddev.channels);
 	spin_lock_init(&od->lock);
-- 
2.1.1

