Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241Ab3JMFK5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 01:10:57 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56113 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750845Ab3JMFK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 01:10:56 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] dma: misc: remove deprecated IRQF_DISABLED
Date: Sun, 13 Oct 2013 07:10:51 +0200
Message-Id: <1381641051-7287-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/dma/amba-pl08x.c | 3 +--
 drivers/dma/k3dma.c      | 2 +-
 drivers/dma/mmp_pdma.c   | 4 ++--
 drivers/dma/mmp_tdma.c   | 4 ++--
 drivers/dma/sh/shdmac.c  | 4 ++--
 5 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index fce46c5..9b50257 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -2133,8 +2133,7 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 	writel(0x000000FF, pl08x->base + PL080_ERR_CLEAR);
 	writel(0x000000FF, pl08x->base + PL080_TC_CLEAR);
 
-	ret = request_irq(adev->irq[0], pl08x_irq, IRQF_DISABLED,
-			  DRIVER_NAME, pl08x);
+	ret = request_irq(adev->irq[0], pl08x_irq, 0, DRIVER_NAME, pl08x);
 	if (ret) {
 		dev_err(&adev->dev, "%s failed to request interrupt %d\n",
 			__func__, adev->irq[0]);
diff --git a/drivers/dma/k3dma.c b/drivers/dma/k3dma.c
index a2c330f..da43062 100644
--- a/drivers/dma/k3dma.c
+++ b/drivers/dma/k3dma.c
@@ -693,7 +693,7 @@ static int k3_dma_probe(struct platform_device *op)
 
 	irq = platform_get_irq(op, 0);
 	ret = devm_request_irq(&op->dev, irq,
-			k3_dma_int_handler, IRQF_DISABLED, DRIVER_NAME, d);
+			k3_dma_int_handler, 0, DRIVER_NAME, d);
 	if (ret)
 		return ret;
 
diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
index ff8d7827..183c5ae 100644
--- a/drivers/dma/mmp_pdma.c
+++ b/drivers/dma/mmp_pdma.c
@@ -863,7 +863,7 @@ static int mmp_pdma_chan_init(struct mmp_pdma_device *pdev,
 
 	if (irq) {
 		ret = devm_request_irq(pdev->dev, irq,
-			mmp_pdma_chan_handler, IRQF_DISABLED, "pdma", phy);
+			mmp_pdma_chan_handler, 0, "pdma", phy);
 		if (ret) {
 			dev_err(pdev->dev, "channel request irq fail!\n");
 			return ret;
@@ -970,7 +970,7 @@ static int mmp_pdma_probe(struct platform_device *op)
 		/* all chan share one irq, demux inside */
 		irq = platform_get_irq(op, 0);
 		ret = devm_request_irq(pdev->dev, irq,
-			mmp_pdma_int_handler, IRQF_DISABLED, "pdma", pdev);
+			mmp_pdma_int_handler, 0, "pdma", pdev);
 		if (ret)
 			return ret;
 	}
diff --git a/drivers/dma/mmp_tdma.c b/drivers/dma/mmp_tdma.c
index 38cb517..ea5c3d2 100644
--- a/drivers/dma/mmp_tdma.c
+++ b/drivers/dma/mmp_tdma.c
@@ -324,7 +324,7 @@ static int mmp_tdma_alloc_chan_resources(struct dma_chan *chan)
 
 	if (tdmac->irq) {
 		ret = devm_request_irq(tdmac->dev, tdmac->irq,
-			mmp_tdma_chan_handler, IRQF_DISABLED, "tdma", tdmac);
+			mmp_tdma_chan_handler, 0, "tdma", tdmac);
 		if (ret)
 			return ret;
 	}
@@ -559,7 +559,7 @@ static int mmp_tdma_probe(struct platform_device *pdev)
 	if (irq_num != chan_num) {
 		irq = platform_get_irq(pdev, 0);
 		ret = devm_request_irq(&pdev->dev, irq,
-			mmp_tdma_int_handler, IRQF_DISABLED, "tdma", tdev);
+			mmp_tdma_int_handler, 0, "tdma", tdev);
 		if (ret)
 			return ret;
 	}
diff --git a/drivers/dma/sh/shdmac.c b/drivers/dma/sh/shdmac.c
index 1069e88..0d765c0 100644
--- a/drivers/dma/sh/shdmac.c
+++ b/drivers/dma/sh/shdmac.c
@@ -685,7 +685,7 @@ MODULE_DEVICE_TABLE(of, sh_dmae_of_match);
 static int sh_dmae_probe(struct platform_device *pdev)
 {
 	const struct sh_dmae_pdata *pdata;
-	unsigned long irqflags = IRQF_DISABLED,
+	unsigned long irqflags = 0,
 		chan_flag[SH_DMAE_MAX_CHANNELS] = {};
 	int errirq, chan_irq[SH_DMAE_MAX_CHANNELS];
 	int err, i, irq_cnt = 0, irqres = 0, irq_cap = 0;
@@ -838,7 +838,7 @@ static int sh_dmae_probe(struct platform_device *pdev)
 				    IORESOURCE_IRQ_SHAREABLE)
 					chan_flag[irq_cnt] = IRQF_SHARED;
 				else
-					chan_flag[irq_cnt] = IRQF_DISABLED;
+					chan_flag[irq_cnt] = 0;
 				dev_dbg(&pdev->dev,
 					"Found IRQ %d for channel %d\n",
 					i, irq_cnt);
-- 
1.8.1.2

