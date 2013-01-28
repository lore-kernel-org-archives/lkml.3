Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab3A1Lbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:31:48 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49683 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932150Ab3A1Lbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:31:44 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <linux@arm.linux.org.uk>, <sameo@linux.intel.com>, <balbi@ti.com>,
        <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 22/30] ARM: OMAP: devkit8000: Adapt to ehci-omap changes
Date: Mon, 28 Jan 2013 13:30:23 +0200
Message-ID: <1359372631-8180-23-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359372631-8180-1-git-send-email-rogerq@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add platform device for 'nop-usb-xceiv'. This will be used as a
PHY for HS USB Port 1, so provide binding information for it.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/board-devkit8000.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index 051ec0d..f0fd75a 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -32,6 +32,7 @@
 
 #include <linux/regulator/machine.h>
 #include <linux/i2c/twl.h>
+#include <linux/usb/phy.h>
 #include "id.h"
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -429,22 +430,21 @@ static void __init omap_dm9000_init(void)
 	eth_addr[5] = (odi.id_0 & 0x000000ff);
 }
 
+/* PHY device on HS USB Port 1 i.e. nop_usb_xceiv.1 */
+static struct platform_device hsusb1_phy_device = {
+	.name = "nop_usb_xceiv",
+	.id = 1,
+};
+
 static struct platform_device *devkit8000_devices[] __initdata = {
 	&leds_gpio,
 	&keys_gpio,
 	&omap_dm9000_dev,
+	&hsusb1_phy_device,
 };
 
 static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
-
 	.port_mode[0] = OMAP_EHCI_PORT_MODE_PHY,
-	.port_mode[1] = OMAP_USBHS_PORT_MODE_UNUSED,
-	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
-
-	.phy_reset  = true,
-	.reset_gpio_port[0]  = -EINVAL,
-	.reset_gpio_port[1]  = -EINVAL,
-	.reset_gpio_port[2]  = -EINVAL
 };
 
 #ifdef CONFIG_OMAP_MUX
@@ -623,6 +623,10 @@ static void __init devkit8000_init(void)
 	omap_ads7846_init(2, OMAP3_DEVKIT_TS_GPIO, 0, NULL);
 
 	usb_musb_init(NULL);
+
+	/* PHY on HSUSB Port 1 i.e. index 0 */
+	usb_bind_phy("ehci-omap.0", 0, "nop_usb_xceiv.1");
+
 	usbhs_init(&usbhs_bdata);
 	board_nand_init(devkit8000_nand_partitions,
 			ARRAY_SIZE(devkit8000_nand_partitions), NAND_CS,
-- 
1.7.4.1

