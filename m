Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243Ab3CTPsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:48:04 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54169 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758015Ab3CTPpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:45:39 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <rogerq@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 16/21] ARM: OMAP3: omap3touchbook: Adapt to ehci-omap changes
Date: Wed, 20 Mar 2013 17:44:55 +0200
Message-ID: <1363794300-31526-17-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363794300-31526-1-git-send-email-rogerq@ti.com>
References: <1363794300-31526-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use usbhs_init_phys() to register the PHY's RESET regulator
and the NOP PHY device.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/board-omap3touchbook.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3touchbook.c b/arch/arm/mach-omap2/board-omap3touchbook.c
index bcd44fb..7da48bc 100644
--- a/arch/arm/mach-omap2/board-omap3touchbook.c
+++ b/arch/arm/mach-omap2/board-omap3touchbook.c
@@ -305,21 +305,22 @@ static struct omap_board_mux board_mux[] __initdata = {
 };
 #endif
 
+static struct usbhs_phy_data phy_data[] __initdata = {
+	{
+		.port = 2,
+		.reset_gpio = 147,
+		.vcc_gpio = -EINVAL,
+	},
+};
+
 static struct platform_device *omap3_touchbook_devices[] __initdata = {
 	&leds_gpio,
 	&keys_gpio,
 };
 
 static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
-
 	.port_mode[0] = OMAP_EHCI_PORT_MODE_PHY,
 	.port_mode[1] = OMAP_EHCI_PORT_MODE_PHY,
-	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
-
-	.phy_reset  = true,
-	.reset_gpio_port[0]  = -EINVAL,
-	.reset_gpio_port[1]  = 147,
-	.reset_gpio_port[2]  = -EINVAL
 };
 
 static void omap3_touchbook_poweroff(void)
@@ -368,6 +369,8 @@ static void __init omap3_touchbook_init(void)
 	omap_ads7846_init(4, OMAP3_TS_GPIO, 310, &ads7846_pdata);
 	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
+
+	usbhs_init_phys(phy_data, ARRAY_SIZE(phy_data));
 	usbhs_init(&usbhs_bdata);
 	board_nand_init(omap3touchbook_nand_partitions,
 			ARRAY_SIZE(omap3touchbook_nand_partitions), NAND_CS,
-- 
1.7.4.1

