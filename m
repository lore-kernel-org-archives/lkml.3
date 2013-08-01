Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819Ab3HAWRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 18:17:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39834 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab3HAWRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 18:17:41 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 43/51] DMA-API: dma: edma.c: no need to explicitly
 initialize DMA masks
Message-Id: <E1V51BJ-0006u2-V3@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 23:17:13 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

register_platform_device_full() can setup the DMA mask provided the
appropriate member is set in struct platform_device_info.  So lets
make that be the case.  This avoids a direct reference to the DMA
masks by this driver.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/dma/edma.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 5f3e532..9c7d16b 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -620,11 +620,13 @@ static struct platform_device *pdev0, *pdev1;
 static const struct platform_device_info edma_dev_info0 = {
 	.name = "edma-dma-engine",
 	.id = 0,
+	.dma_mask = DMA_BIT_MASK(32),
 };
 
 static const struct platform_device_info edma_dev_info1 = {
 	.name = "edma-dma-engine",
 	.id = 1,
+	.dma_mask = DMA_BIT_MASK(32),
 };
 
 static int edma_init(void)
@@ -638,8 +640,6 @@ static int edma_init(void)
 			ret = PTR_ERR(pdev0);
 			goto out;
 		}
-		pdev0->dev.dma_mask = &pdev0->dev.coherent_dma_mask;
-		pdev0->dev.coherent_dma_mask = DMA_BIT_MASK(32);
 	}
 
 	if (EDMA_CTLRS == 2) {
@@ -649,8 +649,6 @@ static int edma_init(void)
 			platform_device_unregister(pdev0);
 			ret = PTR_ERR(pdev1);
 		}
-		pdev1->dev.dma_mask = &pdev1->dev.coherent_dma_mask;
-		pdev1->dev.coherent_dma_mask = DMA_BIT_MASK(32);
 	}
 
 out:
-- 
1.7.4.4

