Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbaJ1Viz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:38:55 -0400
Received: from down.free-electrons.com ([37.187.137.238]:37133 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755226AbaJ1Vay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:30:54 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v4 49/58] dmaengine: bcm2835: Declare slave capabilities for the generic code
Date: Tue, 28 Oct 2014 22:26:04 +0100
Message-Id: <1414531573-18807-50-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414531573-18807-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1414531573-18807-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the generic slave caps code can make use of the device assigned
capabilities, instead of relying on a callback to be implemented.

Make use of this code.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Acked-by: Stephen Warren <swarren@wwwdotorg.org>
---
 drivers/dma/bcm2835-dma.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/dma/bcm2835-dma.c b/drivers/dma/bcm2835-dma.c
index 243bb1ed6bfc..891183ff6d1b 100644
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
@@ -605,6 +593,9 @@ static int bcm2835_dma_probe(struct platform_device *pdev)
 	od->ddev.device_prep_dma_cyclic = bcm2835_dma_prep_dma_cyclic;
 	od->ddev.device_config = bcm2835_dma_slave_config;
 	od->ddev.device_terminate_all = bcm2835_dma_terminate_all;
+	od->ddev.src_addr_widths = BIT(DMA_SLAVE_BUSWIDTH_4_BYTES);
+	od->ddev.dst_addr_widths = BIT(DMA_SLAVE_BUSWIDTH_4_BYTES);
+	od->ddev.directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
 	od->ddev.dev = &pdev->dev;
 	INIT_LIST_HEAD(&od->ddev.channels);
 	spin_lock_init(&od->lock);
-- 
2.1.1

