Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbaL2RV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 12:21:26 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:52455 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbaL2RVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 12:21:12 -0500
From: Fabio Estevam <festevam@gmail.com>
To: vinod.koul@intel.com
Cc: linux-kernel@vger.kernel.org, shawn.guo@linaro.org, kernel@pengutronix.de,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 3/3] dmaengine: imx-sdma: Return a proper error code in platform_get_irq()
Date: Mon, 29 Dec 2014 15:20:53 -0200
Message-Id: <1419873653-14411-3-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419873653-14411-1-git-send-email-festevam@gmail.com>
References: <1419873653-14411-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

There is no need to return a 'fake' value upon platform_get_irq() failure.

Just propagate the real error instead.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/dma/imx-sdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 6ac61ba..18c0a13 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1483,7 +1483,7 @@ static int sdma_probe(struct platform_device *pdev)
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
-		return -EINVAL;
+		return irq;
 
 	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	sdma->regs = devm_ioremap_resource(&pdev->dev, iores);
-- 
1.9.1

