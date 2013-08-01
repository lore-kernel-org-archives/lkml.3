Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab3HAWLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 18:11:41 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39816 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab3HAWLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 18:11:39 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 37/51] DMA-API: usb: use new
 dma_coerce_mask_and_coherent()
Message-Id: <E1V515T-0006tK-SU@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 23:11:11 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/usb/chipidea/ci_hdrc_imx.c |    4 +---
 drivers/usb/dwc3/dwc3-exynos.c     |    4 +---
 drivers/usb/host/ehci-atmel.c      |    4 +---
 drivers/usb/host/ehci-omap.c       |    4 +---
 drivers/usb/host/ehci-orion.c      |    4 +---
 drivers/usb/host/ehci-platform.c   |    5 ++---
 drivers/usb/host/ehci-s5p.c        |    4 +---
 drivers/usb/host/ehci-spear.c      |    4 +---
 drivers/usb/host/ehci-tegra.c      |    4 +---
 drivers/usb/host/ohci-at91.c       |    4 +---
 drivers/usb/host/ohci-exynos.c     |    4 +---
 drivers/usb/host/ohci-nxp.c        |    3 +--
 drivers/usb/host/ohci-octeon.c     |    3 +--
 drivers/usb/host/ohci-omap3.c      |    4 +---
 drivers/usb/host/ohci-pxa27x.c     |    4 +---
 drivers/usb/host/ohci-spear.c      |    4 +---
 drivers/usb/host/uhci-platform.c   |    4 +---
 17 files changed, 18 insertions(+), 49 deletions(-)

diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c b/drivers/usb/chipidea/ci_hdrc_imx.c
index 1c47edd..ed73337 100644
--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -157,9 +157,7 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
 
 	pdata.phy = data->phy;
 
-	if (!pdev->dev.dma_mask)
-		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
-	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	ret = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (ret)
 		goto err;
 
diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
index 7553ae4..71052a7 100644
--- a/drivers/usb/dwc3/dwc3-exynos.c
+++ b/drivers/usb/dwc3/dwc3-exynos.c
@@ -115,9 +115,7 @@ static int dwc3_exynos_probe(struct platform_device *pdev)
 	 * Since shared usb code relies on it, set it here for now.
 	 * Once we move to full device tree support this will vanish off.
 	 */
-	if (!dev->dma_mask)
-		dev->dma_mask = &dev->coherent_dma_mask;
-	ret = dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
+	ret = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(32));
 	if (ret)
 		goto err1;
 
diff --git a/drivers/usb/host/ehci-atmel.c b/drivers/usb/host/ehci-atmel.c
index 5831a88..8e7323e 100644
--- a/drivers/usb/host/ehci-atmel.c
+++ b/drivers/usb/host/ehci-atmel.c
@@ -90,9 +90,7 @@ static int ehci_atmel_drv_probe(struct platform_device *pdev)
 	 * Since shared usb code relies on it, set it here for now.
 	 * Once we have dma capability bindings this can go away.
 	 */
-	if (!pdev->dev.dma_mask)
-		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
-	retval = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	retval = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (retval)
 		goto fail_create_hcd;
 
diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 922e193..98d164d 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -144,9 +144,7 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 	 * Since shared usb code relies on it, set it here for now.
 	 * Once we have dma capability bindings this can go away.
 	 */
-	if (!dev->dma_mask)
-		dev->dma_mask = &dev->coherent_dma_mask;
-	ret = dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
+	ret = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(32));
 	if (ret)
 		return ret;
 
diff --git a/drivers/usb/host/ehci-orion.c b/drivers/usb/host/ehci-orion.c
index d7fbad0..3ab4cf2 100644
--- a/drivers/usb/host/ehci-orion.c
+++ b/drivers/usb/host/ehci-orion.c
@@ -180,9 +180,7 @@ static int ehci_orion_drv_probe(struct platform_device *pdev)
 	 * set. Since shared usb code relies on it, set it here for
 	 * now. Once we have dma capability bindings this can go away.
 	 */
-	if (!pdev->dev.dma_mask)
-		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
-	err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	err = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (err)
 		goto err1;
 
diff --git a/drivers/usb/host/ehci-platform.c b/drivers/usb/host/ehci-platform.c
index 2c6004e..b32731b 100644
--- a/drivers/usb/host/ehci-platform.c
+++ b/drivers/usb/host/ehci-platform.c
@@ -89,9 +89,8 @@ static int ehci_platform_probe(struct platform_device *dev)
 	 */
 	if (!dev->dev.platform_data)
 		dev->dev.platform_data = &ehci_platform_defaults;
-	if (!dev->dev.dma_mask)
-		dev->dev.dma_mask = &dev->dev.coherent_dma_mask;
-	err = dma_set_coherent_mask(&dev->dev, DMA_BIT_MASK(32));
+
+	err = dma_coerce_mask_and_coherent(&dev->dev, DMA_BIT_MASK(32));
 	if (err)
 		return err;
 
diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
index 97127db..788d786 100644
--- a/drivers/usb/host/ehci-s5p.c
+++ b/drivers/usb/host/ehci-s5p.c
@@ -89,9 +89,7 @@ static int s5p_ehci_probe(struct platform_device *pdev)
 	 * Since shared usb code relies on it, set it here for now.
 	 * Once we move to full device tree support this will vanish off.
 	 */
-	if (!pdev->dev.dma_mask)
-		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
-	err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	err = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (err)
 		return err;
 
diff --git a/drivers/usb/host/ehci-spear.c b/drivers/usb/host/ehci-spear.c
index 6839e15..ee6f9ff 100644
--- a/drivers/usb/host/ehci-spear.c
+++ b/drivers/usb/host/ehci-spear.c
@@ -81,9 +81,7 @@ static int spear_ehci_hcd_drv_probe(struct platform_device *pdev)
 	 * Since shared usb code relies on it, set it here for now.
 	 * Once we have dma capability bindings this can go away.
 	 */
-	if (!pdev->dev.dma_mask)
-		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
-	retval = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	retval = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (retval)
 		goto fail;
 
diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index ade3650..6ccd7ae 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -371,9 +371,7 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	 * Since shared usb code relies on it, set it here for now.
 	 * Once we have dma capability bindings this can go away.
 	 */
-	if (!pdev->dev.dma_mask)
-		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
-	err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	err = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (err)
 		return err;
 
diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
index e4a801d..e727edf 100644
--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -519,9 +519,7 @@ static int ohci_at91_of_init(struct platform_device *pdev)
 	 * Since shared usb code relies on it, set it here for now.
 	 * Once we have dma capability bindings this can go away.
 	 */
-	if (!pdev->dev.dma_mask)
-		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
-	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	ret = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (ret)
 		return ret;
 
diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
index 42d6730..29c02a4 100644
--- a/drivers/usb/host/ohci-exynos.c
+++ b/drivers/usb/host/ohci-exynos.c
@@ -114,9 +114,7 @@ static int exynos_ohci_probe(struct platform_device *pdev)
 	 * Since shared usb code relies on it, set it here for now.
 	 * Once we move to full device tree support this will vanish off.
 	 */
-	if (!pdev->dev.dma_mask)
-		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
-	err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	err = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (err)
 		return err;
 
diff --git a/drivers/usb/host/ohci-nxp.c b/drivers/usb/host/ohci-nxp.c
index 5f82db4..df3eb3e 100644
--- a/drivers/usb/host/ohci-nxp.c
+++ b/drivers/usb/host/ohci-nxp.c
@@ -226,8 +226,7 @@ static int usb_hcd_nxp_probe(struct platform_device *pdev)
 		return -EPROBE_DEFER;
 	}
 
-	pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
-	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	ret = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (ret)
 		goto fail_disable;
 
diff --git a/drivers/usb/host/ohci-octeon.c b/drivers/usb/host/ohci-octeon.c
index ac1dea1..6c16dce 100644
--- a/drivers/usb/host/ohci-octeon.c
+++ b/drivers/usb/host/ohci-octeon.c
@@ -127,8 +127,7 @@ static int ohci_octeon_drv_probe(struct platform_device *pdev)
 	}
 
 	/* Ohci is a 32-bit device. */
-	pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
-	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	ret = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (ret)
 		return ret;
 
diff --git a/drivers/usb/host/ohci-omap3.c b/drivers/usb/host/ohci-omap3.c
index e767a01..60e135c 100644
--- a/drivers/usb/host/ohci-omap3.c
+++ b/drivers/usb/host/ohci-omap3.c
@@ -166,9 +166,7 @@ static int ohci_hcd_omap3_probe(struct platform_device *pdev)
 	 * Since shared usb code relies on it, set it here for now.
 	 * Once we have dma capability bindings this can go away.
 	 */
-	if (!dev->dma_mask)
-		dev->dma_mask = &dev->coherent_dma_mask;
-	ret = dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
+	ret = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(32));
 	if (ret)
 		goto err_io;
 
diff --git a/drivers/usb/host/ohci-pxa27x.c b/drivers/usb/host/ohci-pxa27x.c
index 88c97db..35b5662 100644
--- a/drivers/usb/host/ohci-pxa27x.c
+++ b/drivers/usb/host/ohci-pxa27x.c
@@ -296,9 +296,7 @@ static int ohci_pxa_of_init(struct platform_device *pdev)
 	 * Since shared usb code relies on it, set it here for now.
 	 * Once we have dma capability bindings this can go away.
 	 */
-	if (!pdev->dev.dma_mask)
-		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
-	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	ret = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (ret)
 		return ret;
 
diff --git a/drivers/usb/host/ohci-spear.c b/drivers/usb/host/ohci-spear.c
index 195a0a1..075bb5e 100644
--- a/drivers/usb/host/ohci-spear.c
+++ b/drivers/usb/host/ohci-spear.c
@@ -111,9 +111,7 @@ static int spear_ohci_hcd_drv_probe(struct platform_device *pdev)
 	 * Since shared usb code relies on it, set it here for now.
 	 * Once we have dma capability bindings this can go away.
 	 */
-	if (!pdev->dev.dma_mask)
-		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
-	retval = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	retval = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (retval)
 		goto fail;
 
diff --git a/drivers/usb/host/uhci-platform.c b/drivers/usb/host/uhci-platform.c
index 048912d..f8548b7 100644
--- a/drivers/usb/host/uhci-platform.c
+++ b/drivers/usb/host/uhci-platform.c
@@ -75,9 +75,7 @@ static int uhci_hcd_platform_probe(struct platform_device *pdev)
 	 * Since shared usb code relies on it, set it here for now.
 	 * Once we have dma capability bindings this can go away.
 	 */
-	if (!pdev->dev.dma_mask)
-		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
-	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	ret = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (ret)
 		return ret;
 
-- 
1.7.4.4

