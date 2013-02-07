Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab3BGQDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:03:24 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49454 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932137Ab3BGQDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:03:19 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <b-cousson@ti.com>, <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <stern@rowland.harvard.edu>, <linux@arm.linux.org.uk>, <kishon@ti.com>,
        <mark.rutland@arm.com>, <rogerq@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH v2 04/14] mfd: omap-usb-tll: Add device tree support
Date: Thu, 7 Feb 2013 18:02:44 +0200
Message-ID: <1360252974-7912-5-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1360252974-7912-1-git-send-email-rogerq@ti.com>
References: <1360252974-7912-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable this driver to probe in device tree boot.

CC: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 .../devicetree/bindings/mfd/omap-usb-tll.txt       |   17 +++++++++++++++++
 drivers/mfd/omap-usb-tll.c                         |    9 +++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)
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
index f7d2568..f7afb22 100644
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
-- 
1.7.4.1

