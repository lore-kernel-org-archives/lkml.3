Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab3CLK0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:26:49 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36053 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932539Ab3CLK0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:26:20 -0400
From: Roger Quadros <rogerq@ti.com>
To: <sameo@linux.intel.com>
CC: <balbi@ti.com>, <b-cousson@ti.com>, <mark.rutland@arm.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <rogerq@ti.com>
Subject: [PATCH 5/6] mfd: omap-usb-tll: Add device tree support and binding information
Date: Tue, 12 Mar 2013 12:25:39 +0200
Message-ID: <1363083940-20050-6-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363083940-20050-1-git-send-email-rogerq@ti.com>
References: <1363083940-20050-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows the OMAP USB TLL module to be specified via device tree.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 .../devicetree/bindings/mfd/omap-usb-tll.txt       |   17 +++++++++++++++++
 drivers/mfd/omap-usb-tll.c                         |   10 ++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/omap-usb-tll.txt

diff --git a/Documentation/devicetree/bindings/mfd/omap-usb-tll.txt b/Documentation/devicetree/bindings/mfd/omap-usb-tll.txt
new file mode 100644
index 0000000..62fe697
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/omap-usb-tll.txt
@@ -0,0 +1,17 @@
+OMAP HS USB Host TLL (Transceiver-Less Interface)
+
+Required properties:
+
+- compatible : should be "ti,usbhs-tll"
+- reg : should contain one register range i.e. start and length
+- interrupts : should contain the TLL module's interrupt
+- ti,hwmod : must contain "usb_tll_hs"
+
+Example:
+
+	usbhstll: usbhstll@4a062000 {
+		compatible = "ti,usbhs-tll";
+		reg = <0x4a062000 0x1000>;
+		interrupts = <78>;
+		ti,hwmods = "usb_tll_hs";
+	  };
diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
index f7d2568..8f4d5a1 100644
--- a/drivers/mfd/omap-usb-tll.c
+++ b/drivers/mfd/omap-usb-tll.c
@@ -28,6 +28,7 @@
 #include <linux/err.h>
 #include <linux/pm_runtime.h>
 #include <linux/platform_data/usb-omap.h>
+#include <linux/of.h>
 
 #define USBTLL_DRIVER_NAME	"usbhs_tll"
 
@@ -311,10 +312,18 @@ static int usbtll_omap_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id usbtll_omap_dt_ids[] = {
+	{ .compatible = "ti,usbhs-tll" },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(of, usbtll_omap_dt_ids);
+
 static struct platform_driver usbtll_omap_driver = {
 	.driver = {
 		.name		= (char *)usbtll_driver_name,
 		.owner		= THIS_MODULE,
+		.of_match_table = of_match_ptr(usbtll_omap_dt_ids),
 	},
 	.probe		= usbtll_omap_probe,
 	.remove		= usbtll_omap_remove,
@@ -467,6 +476,7 @@ int omap_tll_disable(struct usbhs_omap_platform_data *pdata)
 EXPORT_SYMBOL_GPL(omap_tll_disable);
 
 MODULE_AUTHOR("Keshava Munegowda <keshava_mgowda@ti.com>");
+MODULE_AUTHOR("Roger Quadros <rogerq@ti.com>");
 MODULE_ALIAS("platform:" USBHS_DRIVER_NAME);
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("usb tll driver for TI OMAP EHCI and OHCI controllers");
-- 
1.7.4.1

