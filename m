Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbaDNLm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:42:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45719 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754682AbaDNLms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:42:48 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <dan.j.williams@intel.com>, <vinod.koul@intel.com>, <nsekhar@ti.com>,
        <joelf@ti.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
Subject: [PATCH v3 05/10] dmaengine: edma: Set DMA_CYCLIC capability flag
Date: Mon, 14 Apr 2014 14:42:00 +0300
Message-ID: <1397475725-5036-6-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397475725-5036-1-git-send-email-peter.ujfalusi@ti.com>
References: <1397475725-5036-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Indicate that the edma dmaengine driver has support for cyclic mode.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/common/edma.c | 1 +
 drivers/dma/edma.c     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index 999266bf69b9..0b37f7734d0f 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -1574,6 +1574,7 @@ static struct edma_soc_info *edma_setup_info_from_dt(struct device *dev,
 		return ERR_PTR(ret);
 
 	dma_cap_set(DMA_SLAVE, edma_filter_info.dma_cap);
+	dma_cap_set(DMA_CYCLIC, edma_filter_info.dma_cap);
 	of_dma_controller_register(dev->of_node, of_dma_simple_xlate,
 				   &edma_filter_info);
 
diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 7891378a03f0..1dd9e8806975 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -891,6 +891,7 @@ static int edma_probe(struct platform_device *pdev)
 
 	dma_cap_zero(ecc->dma_slave.cap_mask);
 	dma_cap_set(DMA_SLAVE, ecc->dma_slave.cap_mask);
+	dma_cap_set(DMA_CYCLIC, ecc->dma_slave.cap_mask);
 
 	edma_dma_init(ecc, &ecc->dma_slave, &pdev->dev);
 
-- 
1.9.2

