Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbaL2RVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 12:21:33 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:63641 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbaL2RVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 12:21:30 -0500
From: Fabio Estevam <festevam@gmail.com>
To: vinod.koul@intel.com
Cc: linux-kernel@vger.kernel.org, shawn.guo@linaro.org, kernel@pengutronix.de,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH] dmaengine: mxs-dma: Declare slave capabilities for the generic code
Date: Mon, 29 Dec 2014 15:21:19 -0200
Message-Id: <1419873679-14463-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Since ecc19d17868be9c ("dmaengine: Add a warning for drivers not using the
generic slave caps retrieval") the following warning is observed:

[    0.113023] ------------[ cut here ]------------
[    0.113053] WARNING: CPU: 0 PID: 1 at drivers/dma/dmaengine.c:830 dma_async_device_register+0x2a0/0x4c8()
[    0.113063] this driver doesn't support generic slave capabilities reporting

Declare the slave capabilities to avoid such warning.

Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/dma/mxs-dma.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index 599ffb5..829ec68 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -848,6 +848,10 @@ static int __init mxs_dma_probe(struct platform_device *pdev)
 	mxs_dma->dma_device.device_pause = mxs_dma_pause_chan;
 	mxs_dma->dma_device.device_resume = mxs_dma_resume_chan;
 	mxs_dma->dma_device.device_terminate_all = mxs_dma_terminate_all;
+	mxs_dma->dma_device.src_addr_widths = BIT(DMA_SLAVE_BUSWIDTH_4_BYTES);
+	mxs_dma->dma_device.dst_addr_widths = BIT(DMA_SLAVE_BUSWIDTH_4_BYTES);
+	mxs_dma->dma_device.directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
+	mxs_dma->dma_device.residue_granularity = DMA_RESIDUE_GRANULARITY_BURST;
 	mxs_dma->dma_device.device_issue_pending = mxs_dma_enable_chan;
 
 	ret = dma_async_device_register(&mxs_dma->dma_device);
-- 
1.9.1

