Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213Ab3CTPpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:45:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47214 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758028Ab3CTPpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:45:41 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <rogerq@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 17/21] ARM: OMAP3: overo: Adapt to ehci-omap changes
Date: Wed, 20 Mar 2013 17:44:56 +0200
Message-ID: <1363794300-31526-18-git-send-email-rogerq@ti.com>
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
 arch/arm/mach-omap2/board-overo.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap2/board-overo.c b/arch/arm/mach-omap2/board-overo.c
index 86bab51..ab79a44 100644
--- a/arch/arm/mach-omap2/board-overo.c
+++ b/arch/arm/mach-omap2/board-overo.c
@@ -458,14 +458,16 @@ static int __init overo_spi_init(void)
 	return 0;
 }
 
+static struct usbhs_phy_data phy_data[] __initdata = {
+	{
+		.port = 2,
+		.reset_gpio = OVERO_GPIO_USBH_NRESET,
+		.vcc_gpio = -EINVAL,
+	},
+};
+
 static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
-	.port_mode[0] = OMAP_USBHS_PORT_MODE_UNUSED,
 	.port_mode[1] = OMAP_EHCI_PORT_MODE_PHY,
-	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
-	.phy_reset  = true,
-	.reset_gpio_port[0]  = -EINVAL,
-	.reset_gpio_port[1]  = OVERO_GPIO_USBH_NRESET,
-	.reset_gpio_port[2]  = -EINVAL
 };
 
 #ifdef CONFIG_OMAP_MUX
@@ -502,6 +504,8 @@ static void __init overo_init(void)
 			ARRAY_SIZE(overo_nand_partitions), NAND_CS, 0, NULL);
 	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
+
+	usbhs_init_phys(phy_data, ARRAY_SIZE(phy_data));
 	usbhs_init(&usbhs_bdata);
 	overo_spi_init();
 	overo_init_smsc911x();
-- 
1.7.4.1

