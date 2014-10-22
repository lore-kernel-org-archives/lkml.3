Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbaJVPxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:53:12 -0400
Received: from down.free-electrons.com ([37.187.137.238]:54235 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755060AbaJVPqH (ORCPT
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
Subject: [PATCH v3 55/59] dmaengine: pl330: Declare slave capabilities for the generic code
Date: Wed, 22 Oct 2014 17:44:09 +0200
Message-Id: <1413992653-21963-56-git-send-email-maxime.ripard@free-electrons.com>
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
 drivers/dma/pl330.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index bd0e47eefa34..b0bf5d240219 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2569,19 +2569,6 @@ static irqreturn_t pl330_irq_handler(int irq, void *data)
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
@@ -2701,7 +2688,11 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 	pd->device_config = pl330_config;
 	pd->device_terminate_all = pl330_terminate_all;
 	pd->device_issue_pending = pl330_issue_pending;
-	pd->device_slave_caps = pl330_dma_device_slave_caps;
+	pd->src_addr_widths = PL330_DMA_BUSWIDTHS;
+	pd->dst_addr_widths = PL330_DMA_BUSWIDTHS;
+	pd->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
+	pd->residue_granularity = DMA_RESIDUE_GRANULARITY_DESCRIPTOR;
+	pd->generic_slave_caps = true;
 
 	ret = dma_async_device_register(pd);
 	if (ret) {
-- 
2.1.1

