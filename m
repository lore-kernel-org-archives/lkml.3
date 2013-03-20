Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268Ab3CTPpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:45:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54175 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770Ab3CTPpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:45:46 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <rogerq@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 18/21] ARM: OMAP: zoom: Adapt to ehci-omap changes
Date: Wed, 20 Mar 2013 17:44:57 +0200
Message-ID: <1363794300-31526-19-git-send-email-rogerq@ti.com>
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
 arch/arm/mach-omap2/board-zoom.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap2/board-zoom.c b/arch/arm/mach-omap2/board-zoom.c
index 5e4d4c9..1a3dd86 100644
--- a/arch/arm/mach-omap2/board-zoom.c
+++ b/arch/arm/mach-omap2/board-zoom.c
@@ -92,14 +92,16 @@ static struct mtd_partition zoom_nand_partitions[] = {
 	},
 };
 
+static struct usbhs_phy_data phy_data[] __initdata = {
+	{
+		.port = 2,
+		.reset_gpio = ZOOM3_EHCI_RESET_GPIO,
+		.vcc_gpio = -EINVAL,
+	},
+};
+
 static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
-	.port_mode[0]		= OMAP_USBHS_PORT_MODE_UNUSED,
 	.port_mode[1]		= OMAP_EHCI_PORT_MODE_PHY,
-	.port_mode[2]		= OMAP_USBHS_PORT_MODE_UNUSED,
-	.phy_reset		= true,
-	.reset_gpio_port[0]	= -EINVAL,
-	.reset_gpio_port[1]	= ZOOM3_EHCI_RESET_GPIO,
-	.reset_gpio_port[2]	= -EINVAL,
 };
 
 static void __init omap_zoom_init(void)
@@ -109,6 +111,8 @@ static void __init omap_zoom_init(void)
 	} else if (machine_is_omap_zoom3()) {
 		omap3_mux_init(board_mux, OMAP_PACKAGE_CBP);
 		omap_mux_init_gpio(ZOOM3_EHCI_RESET_GPIO, OMAP_PIN_OUTPUT);
+
+		usbhs_init_phys(phy_data, ARRAY_SIZE(phy_data));
 		usbhs_init(&usbhs_bdata);
 	}
 
-- 
1.7.4.1

