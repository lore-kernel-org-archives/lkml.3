Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbaKDB7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 20:59:31 -0500
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:58395 "HELO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751278AbaKDB73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 20:59:29 -0500
From: Feng Kan <fkan@apm.com>
To: patches@apm.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        mathias.nyman@intel.com
Cc: Feng Kan <fkan@apm.com>, Bao Truong <btruong@apm.com>
Subject: [PATCH] usb:host:xhci-plat: 64-bit dma addressing support
Date: Mon,  3 Nov 2014 17:59:28 -0800
Message-Id: <1415066368-3829-1-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dma_addr_t to support 64-bit plaforms, which access beyond 32 bit
address range.

Signed-off-by: Bao Truong <btruong@apm.com>
Signed-off-by: Feng Kan <fkan@apm.com>
---
 drivers/usb/host/xhci-plat.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 01d1862..8cf83f0 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -97,13 +97,14 @@ static int xhci_plat_probe(struct platform_device *pdev)
 	}
 
 	/* Initialize dma_mask and coherent_dma_mask to 32-bits */
-	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	ret = dma_set_coherent_mask(&pdev->dev,
+					DMA_BIT_MASK(sizeof(dma_addr_t)*8));
 	if (ret)
 		return ret;
 	if (!pdev->dev.dma_mask)
 		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
 	else
-		dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
+		dma_set_mask(&pdev->dev, DMA_BIT_MASK(sizeof(dma_addr_t)*8));
 
 	hcd = usb_create_hcd(driver, &pdev->dev, dev_name(&pdev->dev));
 	if (!hcd)
-- 
1.9.1

