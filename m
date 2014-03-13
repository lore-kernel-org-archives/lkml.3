Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbaCMJZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:25:26 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:32913 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbaCMJT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:19:26 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <dmaengine@vger.kernel.org>
CC: <davinci-linux-open-source@linux.davincidsp.com>, <joelf@ti.com>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Tony Lindgren <tony@atomide.com>, <nsekhar@ti.com>,
        Jyri Sarha <jsarha@ti.com>, <mporter@linaro.org>,
        <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Subject: [PATCH 03/18] dma: edma: Set DMA_CYCLIC capability flag
Date: Thu, 13 Mar 2014 11:18:25 +0200
Message-ID: <1394702320-21743-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com>
References: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Indicate that the edma dmaengine driver has support for cyclic mode.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/common/edma.c | 1 +
 drivers/dma/edma.c     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index 41bca32409fc..86a8b263278f 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -1574,6 +1574,7 @@ static struct edma_soc_info *edma_setup_info_from_dt(struct device *dev,
 		return ERR_PTR(ret);
 
 	dma_cap_set(DMA_SLAVE, edma_filter_info.dma_cap);
+	dma_cap_set(DMA_CYCLIC, edma_filter_info.dma_cap);
 	of_dma_controller_register(dev->of_node, of_dma_simple_xlate,
 				   &edma_filter_info);
 
diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index b54cd2dedde0..86d6a3fb0d92 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -887,6 +887,7 @@ static int edma_probe(struct platform_device *pdev)
 
 	dma_cap_zero(ecc->dma_slave.cap_mask);
 	dma_cap_set(DMA_SLAVE, ecc->dma_slave.cap_mask);
+	dma_cap_set(DMA_CYCLIC, ecc->dma_slave.cap_mask);
 
 	edma_dma_init(ecc, &ecc->dma_slave, &pdev->dev);
 
-- 
1.9.0

