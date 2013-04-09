Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936187Ab3DIHHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 03:07:15 -0400
Received: from mail-da0-f54.google.com ([209.85.210.54]:35959 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600Ab3DIHHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 03:07:13 -0400
Date: Tue, 9 Apr 2013 15:07:00 +0800
From: Wang YanQing <udknight@gmail.com>
To: jkosina@suse.cz
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH][TRIVIAL]drivers: Fix a class of compiler warnings
Message-ID: <20130409070659.GA5919@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, jkosina@suse.cz,
	linux-kernel@vger.kernel.org, trivial@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the warnings look like below:
/linux/drivers/dma/timb_dma.c:801: warning: 'td_remove' defined but not used

I get the warning above when I compile 3.8.6 kernel,
then I fix it and others' same issue in kernel with
the help of perl, then I review and check the changes
one by one.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/dma/timb_dma.c             | 2 +-
 drivers/mfd/omap-usb-host.c        | 2 +-
 drivers/mfd/twl4030-madc.c         | 2 +-
 drivers/mmc/host/wmt-sdmmc.c       | 2 +-
 drivers/spi/spi-atmel.c            | 2 +-
 drivers/tty/serial/xilinx_uartps.c | 2 +-
 drivers/usb/gadget/mv_u3d_core.c   | 2 +-
 drivers/usb/gadget/mv_udc_core.c   | 2 +-
 drivers/usb/musb/blackfin.c        | 2 +-
 drivers/usb/otg/mv_otg.c           | 2 +-
 10 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index 952f823..f709279 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -798,7 +798,7 @@ err_release_region:
 
 }
 
-static int td_remove(struct platform_device *pdev)
+static int __exit td_remove(struct platform_device *pdev)
 {
 	struct timb_dma *td = platform_get_drvdata(pdev);
 	struct resource *iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 05164d7..8bf0eb5 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -654,7 +654,7 @@ end_probe:
  *
  * Reverses the effect of usbhs_omap_probe().
  */
-static int usbhs_omap_remove(struct platform_device *pdev)
+static int __exit usbhs_omap_remove(struct platform_device *pdev)
 {
 	struct usbhs_hcd_omap *omap = platform_get_drvdata(pdev);
 
diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
index 88ff9dc..86ba920 100644
--- a/drivers/mfd/twl4030-madc.c
+++ b/drivers/mfd/twl4030-madc.c
@@ -785,7 +785,7 @@ err_power:
 	return ret;
 }
 
-static int twl4030_madc_remove(struct platform_device *pdev)
+static int __exit twl4030_madc_remove(struct platform_device *pdev)
 {
 	struct twl4030_madc_data *madc = platform_get_drvdata(pdev);
 
diff --git a/drivers/mmc/host/wmt-sdmmc.c b/drivers/mmc/host/wmt-sdmmc.c
index 154f0e8..3e98508 100644
--- a/drivers/mmc/host/wmt-sdmmc.c
+++ b/drivers/mmc/host/wmt-sdmmc.c
@@ -892,7 +892,7 @@ fail1:
 	return ret;
 }
 
-static int wmt_mci_remove(struct platform_device *pdev)
+static int __exit wmt_mci_remove(struct platform_device *pdev)
 {
 	struct mmc_host *mmc;
 	struct wmt_mci_priv *priv;
diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index ab34497..1ab72fd 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -1009,7 +1009,7 @@ out_free:
 	return ret;
 }
 
-static int atmel_spi_remove(struct platform_device *pdev)
+static int __exit atmel_spi_remove(struct platform_device *pdev)
 {
 	struct spi_master	*master = platform_get_drvdata(pdev);
 	struct atmel_spi	*as = spi_master_get_devdata(master);
diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 9ab9103..98cfbfb 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -997,7 +997,7 @@ static int xuartps_probe(struct platform_device *pdev)
  *
  * Returns 0 on success, negative error otherwise
  **/
-static int xuartps_remove(struct platform_device *pdev)
+static int __exit xuartps_remove(struct platform_device *pdev)
 {
 	struct uart_port *port = dev_get_drvdata(&pdev->dev);
 	int rc = 0;
diff --git a/drivers/usb/gadget/mv_u3d_core.c b/drivers/usb/gadget/mv_u3d_core.c
index b5cea27..a4e1a19 100644
--- a/drivers/usb/gadget/mv_u3d_core.c
+++ b/drivers/usb/gadget/mv_u3d_core.c
@@ -1763,7 +1763,7 @@ static void mv_u3d_gadget_release(struct device *dev)
 	dev_dbg(dev, "%s\n", __func__);
 }
 
-static int mv_u3d_remove(struct platform_device *dev)
+static int __exit mv_u3d_remove(struct platform_device *dev)
 {
 	struct mv_u3d *u3d = platform_get_drvdata(dev);
 
diff --git a/drivers/usb/gadget/mv_udc_core.c b/drivers/usb/gadget/mv_udc_core.c
index 6e8b127..c2517ae 100644
--- a/drivers/usb/gadget/mv_udc_core.c
+++ b/drivers/usb/gadget/mv_udc_core.c
@@ -2128,7 +2128,7 @@ static void gadget_release(struct device *_dev)
 	complete(udc->done);
 }
 
-static int mv_udc_remove(struct platform_device *dev)
+static int __exit mv_udc_remove(struct platform_device *dev)
 {
 	struct mv_udc *udc = the_controller;
 	int clk_i;
diff --git a/drivers/usb/musb/blackfin.c b/drivers/usb/musb/blackfin.c
index dbb31b3..72c8c7c 100644
--- a/drivers/usb/musb/blackfin.c
+++ b/drivers/usb/musb/blackfin.c
@@ -510,7 +510,7 @@ err0:
 	return ret;
 }
 
-static int bfin_remove(struct platform_device *pdev)
+static int __exit bfin_remove(struct platform_device *pdev)
 {
 	struct bfin_glue		*glue = platform_get_drvdata(pdev);
 
diff --git a/drivers/usb/otg/mv_otg.c b/drivers/usb/otg/mv_otg.c
index eace975..d105b95 100644
--- a/drivers/usb/otg/mv_otg.c
+++ b/drivers/usb/otg/mv_otg.c
@@ -659,7 +659,7 @@ static struct attribute_group inputs_attr_group = {
 	.attrs = inputs_attrs,
 };
 
-int mv_otg_remove(struct platform_device *pdev)
+static int __exit mv_otg_remove(struct platform_device *pdev)
 {
 	struct mv_otg *mvotg = platform_get_drvdata(pdev);
 	int clk_i;
-- 
1.7.12.4.dirty
