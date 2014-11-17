Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbaKQNsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:48:38 -0500
Received: from down.free-electrons.com ([37.187.137.238]:49102 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752596AbaKQNpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:45:55 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v5 56/61] dmaengine: pl330: Declare slave capabilities for the generic code
Date: Mon, 17 Nov 2014 14:42:50 +0100
Message-Id: <1416231775-31252-57-git-send-email-maxime.ripard@free-electrons.com>
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
 drivers/dma/pl330.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index c2db237e455b..8063563618b3 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2581,19 +2581,6 @@ static irqreturn_t pl330_irq_handler(int irq, void *data)
 	BIT(DMA_SLAVE_BUSWIDTH_4_BYTES) | \
 	BIT(DMA_SLAVE_BUSWIDTH_8_BYTES)
 
-static int pl330_dma_device_slave_caps(struct dma_chan *dchan,
-	struct dma_slave_caps *caps)
-{
-	caps->src_addr_widths = PL330_DMA_BUSWIDTHS;
-	caps->dst_addr_widths = PL330_DMA_BUSWIDTHS;
-	caps->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
-	caps->cmd_pause = false;
-	caps->cmd_terminate = true;
-	caps->residue_granularity = DMA_RESIDUE_GRANULARITY_DESCRIPTOR;
-
-	return 0;
-}
-
 static int
 pl330_probe(struct amba_device *adev, const struct amba_id *id)
 {
@@ -2714,7 +2701,10 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 	pd->device_config = pl330_config;
 	pd->device_terminate_all = pl330_terminate_all;
 	pd->device_issue_pending = pl330_issue_pending;
-	pd->device_slave_caps = pl330_dma_device_slave_caps;
+	pd->src_addr_widths = PL330_DMA_BUSWIDTHS;
+	pd->dst_addr_widths = PL330_DMA_BUSWIDTHS;
+	pd->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
+	pd->residue_granularity = DMA_RESIDUE_GRANULARITY_DESCRIPTOR;
 
 	ret = dma_async_device_register(pd);
 	if (ret) {
-- 
2.1.1

