Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbaKQNsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:48:10 -0500
Received: from down.free-electrons.com ([37.187.137.238]:49222 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753495AbaKQNp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:45:56 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v5 57/61] dmaengine: sirf: Declare slave capabilities for the generic code
Date: Mon, 17 Nov 2014 14:42:51 +0100
Message-Id: <1416231775-31252-58-git-send-email-maxime.ripard@free-electrons.com>
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
 drivers/dma/sirf-dma.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/dma/sirf-dma.c b/drivers/dma/sirf-dma.c
index eeb2af440b9f..2f56d3d66d5d 100644
--- a/drivers/dma/sirf-dma.c
+++ b/drivers/dma/sirf-dma.c
@@ -628,18 +628,6 @@ EXPORT_SYMBOL(sirfsoc_dma_filter_id);
 	BIT(DMA_SLAVE_BUSWIDTH_4_BYTES) | \
 	BIT(DMA_SLAVE_BUSWIDTH_8_BYTES))
 
-static int sirfsoc_dma_device_slave_caps(struct dma_chan *dchan,
-	struct dma_slave_caps *caps)
-{
-	caps->src_addr_widths = SIRFSOC_DMA_BUSWIDTHS;
-	caps->dst_addr_widths = SIRFSOC_DMA_BUSWIDTHS;
-	caps->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
-	caps->cmd_pause = true;
-	caps->cmd_terminate = true;
-
-	return 0;
-}
-
 static struct dma_chan *of_dma_sirfsoc_xlate(struct of_phandle_args *dma_spec,
 	struct of_dma *ofdma)
 {
@@ -726,7 +714,9 @@ static int sirfsoc_dma_probe(struct platform_device *op)
 	dma->device_tx_status = sirfsoc_dma_tx_status;
 	dma->device_prep_interleaved_dma = sirfsoc_dma_prep_interleaved;
 	dma->device_prep_dma_cyclic = sirfsoc_dma_prep_cyclic;
-	dma->device_slave_caps = sirfsoc_dma_device_slave_caps;
+	dma->src_addr_widths = SIRFSOC_DMA_BUSWIDTHS;
+	dma->dst_addr_widths = SIRFSOC_DMA_BUSWIDTHS;
+	dma->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
 
 	INIT_LIST_HEAD(&dma->channels);
 	dma_cap_set(DMA_SLAVE, dma->cap_mask);
-- 
2.1.1

