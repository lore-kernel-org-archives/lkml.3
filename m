Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965254Ab3DIIji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 04:39:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53458 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935660Ab3DIIje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 04:39:34 -0400
From: Roger Quadros <rogerq@ti.com>
To: <sameo@linux.intel.com>
CC: <balbi@ti.com>, <mark.rutland@arm.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 1/2] mfd: omap-usb-host: Remove PHY reset handling code
Date: Tue, 9 Apr 2013 11:39:17 +0300
Message-ID: <1365496758-16287-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1365496758-16287-1-git-send-email-rogerq@ti.com>
References: <20130409075457.GF24058@zurbaran>
 <1365496758-16287-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PHY reset GPIO handling will be done in the PHY driver

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/omap-usb-host.c |   28 ----------------------------
 1 files changed, 0 insertions(+), 28 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index eb5db28..138ee98 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -430,24 +430,10 @@ static unsigned omap_usbhs_rev2_hostconfig(struct usbhs_hcd_omap *omap,
 static void omap_usbhs_init(struct device *dev)
 {
 	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
-	struct usbhs_omap_platform_data	*pdata = omap->pdata;
 	unsigned			reg;
 
 	dev_dbg(dev, "starting TI HSUSB Controller\n");
 
-	if (pdata->phy_reset) {
-		if (gpio_is_valid(pdata->reset_gpio_port[0]))
-			devm_gpio_request_one(dev, pdata->reset_gpio_port[0],
-					 GPIOF_OUT_INIT_LOW, "USB1 PHY reset");
-
-		if (gpio_is_valid(pdata->reset_gpio_port[1]))
-			devm_gpio_request_one(dev, pdata->reset_gpio_port[1],
-					 GPIOF_OUT_INIT_LOW, "USB2 PHY reset");
-
-		/* Hold the PHY in RESET for enough time till DIR is high */
-		udelay(10);
-	}
-
 	pm_runtime_get_sync(dev);
 
 	reg = usbhs_read(omap->uhh_base, OMAP_UHH_HOSTCONFIG);
@@ -476,20 +462,6 @@ static void omap_usbhs_init(struct device *dev)
 	dev_dbg(dev, "UHH setup done, uhh_hostconfig=%x\n", reg);
 
 	pm_runtime_put_sync(dev);
-	if (pdata->phy_reset) {
-		/* Hold the PHY in RESET for enough time till
-		 * PHY is settled and ready
-		 */
-		udelay(10);
-
-		if (gpio_is_valid(pdata->reset_gpio_port[0]))
-			gpio_set_value_cansleep
-				(pdata->reset_gpio_port[0], 1);
-
-		if (gpio_is_valid(pdata->reset_gpio_port[1]))
-			gpio_set_value_cansleep
-				(pdata->reset_gpio_port[1], 1);
-	}
 }
 
 /**
-- 
1.7.4.1

