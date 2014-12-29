Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbaL2RVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 12:21:09 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:43886 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaL2RVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 12:21:07 -0500
From: Fabio Estevam <festevam@gmail.com>
To: vinod.koul@intel.com
Cc: linux-kernel@vger.kernel.org, shawn.guo@linaro.org, kernel@pengutronix.de,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 1/3] dmaengine: imx-sdma: Declare slave capabilities for the generic code
Date: Mon, 29 Dec 2014 15:20:51 -0200
Message-Id: <1419873653-14411-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Since ecc19d17868be9c ("dmaengine: Add a warning for drivers not using the
generic slave caps retrieval") the following warning is observed:

[    0.224981] ------------[ cut here ]------------
[    0.225013] WARNING: CPU: 0 PID: 1 at drivers/dma/dmaengine.c:830 dma_async_device_register+0x2a0/0x4c8()
[    0.225023] this driver doesn't support generic slave capabilities reporting

Declare the slave capabilities to avoid such warning.

Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/dma/imx-sdma.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index e3dd85a..facb4162 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1595,6 +1595,10 @@ static int sdma_probe(struct platform_device *pdev)
 	sdma->dma_device.device_prep_dma_cyclic = sdma_prep_dma_cyclic;
 	sdma->dma_device.device_config = sdma_config;
 	sdma->dma_device.device_terminate_all = sdma_disable_channel;
+	sdma->dma_device.src_addr_widths = BIT(DMA_SLAVE_BUSWIDTH_4_BYTES);
+	sdma->dma_device.dst_addr_widths = BIT(DMA_SLAVE_BUSWIDTH_4_BYTES);
+	sdma->dma_device.directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
+	sdma->dma_device.residue_granularity = DMA_RESIDUE_GRANULARITY_BURST;
 	sdma->dma_device.device_issue_pending = sdma_issue_pending;
 	sdma->dma_device.dev->dma_parms = &sdma->dma_parms;
 	dma_set_max_seg_size(sdma->dma_device.dev, 65535);
-- 
1.9.1

