Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268Ab3BTAH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 19:07:29 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:56031 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932655Ab3BTAH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 19:07:27 -0500
From: maxin.john@gmail.com
To: gregkh@linuxfoundation.org
Cc: djbw@fb.com, nicolas.ferre@atmel.com, vinod.koul@intel.com,
        rmk+kernel@arm.linux.org.uk, linus.walleij@linaro.org,
        jassisinghbrar@gmail.com, lars@metafoo.de, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        "Maxin B. John" <maxin.john@enea.com>
Subject: [PATCH] dma: Remove erroneous __exit and __exit_p() references
Date: Wed, 20 Feb 2013 02:07:04 +0200
Message-Id: <1361318824-22287-1-git-send-email-maxin.john@gmail.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Maxin B. John" <maxin.john@enea.com>

Removing the annotation with __exit and referencing with __exit_p()
present in dma driver module remove hooks.

Part of the __devexit and __devexit_p() purge.

Signed-off-by: Maxin B. John <maxin.john@enea.com>
---
 drivers/dma/at_hdmac.c      |    4 ++--
 drivers/dma/coh901318.c     |    4 ++--
 drivers/dma/imx-dma.c       |    4 ++--
 drivers/dma/imx-sdma.c      |    4 ++--
 drivers/dma/ipu/ipu_idmac.c |    4 ++--
 drivers/dma/txx9dmac.c      |    8 ++++----
 6 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 13a02f4..1dc7fac 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1407,7 +1407,7 @@ err_kfree:
 	return err;
 }
 
-static int __exit at_dma_remove(struct platform_device *pdev)
+static int at_dma_remove(struct platform_device *pdev)
 {
 	struct at_dma		*atdma = platform_get_drvdata(pdev);
 	struct dma_chan		*chan, *_chan;
@@ -1565,7 +1565,7 @@ static const struct dev_pm_ops at_dma_dev_pm_ops = {
 };
 
 static struct platform_driver at_dma_driver = {
-	.remove		= __exit_p(at_dma_remove),
+	.remove		= at_dma_remove,
 	.shutdown	= at_dma_shutdown,
 	.id_table	= atdma_devtypes,
 	.driver = {
diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index aa384e5..0b8b3c8 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -1544,7 +1544,7 @@ static int __init coh901318_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int __exit coh901318_remove(struct platform_device *pdev)
+static int coh901318_remove(struct platform_device *pdev)
 {
 	struct coh901318_base *base = platform_get_drvdata(pdev);
 
@@ -1556,7 +1556,7 @@ static int __exit coh901318_remove(struct platform_device *pdev)
 
 
 static struct platform_driver coh901318_driver = {
-	.remove = __exit_p(coh901318_remove),
+	.remove = coh901318_remove,
 	.driver = {
 		.name	= "coh901318",
 	},
diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index a7dcf78..bbf6d7f 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -1144,7 +1144,7 @@ err:
 	return ret;
 }
 
-static int __exit imxdma_remove(struct platform_device *pdev)
+static int imxdma_remove(struct platform_device *pdev)
 {
 	struct imxdma_engine *imxdma = platform_get_drvdata(pdev);
 
@@ -1161,7 +1161,7 @@ static struct platform_driver imxdma_driver = {
 		.name	= "imx-dma",
 	},
 	.id_table	= imx_dma_devtype,
-	.remove		= __exit_p(imxdma_remove),
+	.remove		= imxdma_remove,
 };
 
 static int __init imxdma_module_init(void)
diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index f082aa3..092867b 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1462,7 +1462,7 @@ err_irq:
 	return ret;
 }
 
-static int __exit sdma_remove(struct platform_device *pdev)
+static int sdma_remove(struct platform_device *pdev)
 {
 	return -EBUSY;
 }
@@ -1473,7 +1473,7 @@ static struct platform_driver sdma_driver = {
 		.of_match_table = sdma_dt_ids,
 	},
 	.id_table	= sdma_devtypes,
-	.remove		= __exit_p(sdma_remove),
+	.remove		= sdma_remove,
 };
 
 static int __init sdma_module_init(void)
diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index 6585537..d79717c 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -1756,7 +1756,7 @@ err_noirq:
 	return ret;
 }
 
-static int __exit ipu_remove(struct platform_device *pdev)
+static int ipu_remove(struct platform_device *pdev)
 {
 	struct ipu *ipu = platform_get_drvdata(pdev);
 
@@ -1781,7 +1781,7 @@ static struct platform_driver ipu_platform_driver = {
 		.name	= "ipu-core",
 		.owner	= THIS_MODULE,
 	},
-	.remove		= __exit_p(ipu_remove),
+	.remove		= ipu_remove,
 };
 
 static int __init ipu_init(void)
diff --git a/drivers/dma/txx9dmac.c b/drivers/dma/txx9dmac.c
index 913f55c..a59fb48 100644
--- a/drivers/dma/txx9dmac.c
+++ b/drivers/dma/txx9dmac.c
@@ -1190,7 +1190,7 @@ static int __init txx9dmac_chan_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int __exit txx9dmac_chan_remove(struct platform_device *pdev)
+static int txx9dmac_chan_remove(struct platform_device *pdev)
 {
 	struct txx9dmac_chan *dc = platform_get_drvdata(pdev);
 
@@ -1252,7 +1252,7 @@ static int __init txx9dmac_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int __exit txx9dmac_remove(struct platform_device *pdev)
+static int txx9dmac_remove(struct platform_device *pdev)
 {
 	struct txx9dmac_dev *ddev = platform_get_drvdata(pdev);
 
@@ -1299,14 +1299,14 @@ static const struct dev_pm_ops txx9dmac_dev_pm_ops = {
 };
 
 static struct platform_driver txx9dmac_chan_driver = {
-	.remove		= __exit_p(txx9dmac_chan_remove),
+	.remove		= txx9dmac_chan_remove,
 	.driver = {
 		.name	= "txx9dmac-chan",
 	},
 };
 
 static struct platform_driver txx9dmac_driver = {
-	.remove		= __exit_p(txx9dmac_remove),
+	.remove		= txx9dmac_remove,
 	.shutdown	= txx9dmac_shutdown,
 	.driver = {
 		.name	= "txx9dmac",
-- 
1.7.7

