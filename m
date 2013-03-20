Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115Ab3CTPps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:45:48 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50594 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757461Ab3CTPpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:45:46 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <rogerq@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 06/21] ARM: OMAP3: 3630SDP: Adapt to ehci-omap changes
Date: Wed, 20 Mar 2013 17:44:45 +0200
Message-ID: <1363794300-31526-7-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363794300-31526-1-git-send-email-rogerq@ti.com>
References: <1363794300-31526-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use usbhs_init_phys() to register the PHY's RESET regulators
and the NOP PHY devices.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/board-3630sdp.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap2/board-3630sdp.c b/arch/arm/mach-omap2/board-3630sdp.c
index 67447bd..20d6d81 100644
--- a/arch/arm/mach-omap2/board-3630sdp.c
+++ b/arch/arm/mach-omap2/board-3630sdp.c
@@ -53,16 +53,23 @@ static void enable_board_wakeup_source(void)
 		OMAP_WAKEUP_EN | OMAP_PIN_INPUT_PULLUP);
 }
 
+static struct usbhs_phy_data phy_data[] __initdata = {
+	{
+		.port = 1,
+		.reset_gpio = 126,
+		.vcc_gpio = -EINVAL,
+	},
+	{
+		.port = 2,
+		.reset_gpio = 61,
+		.vcc_gpio = -EINVAL,
+	},
+};
+
 static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
 
 	.port_mode[0] = OMAP_EHCI_PORT_MODE_PHY,
 	.port_mode[1] = OMAP_EHCI_PORT_MODE_PHY,
-	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
-
-	.phy_reset  = true,
-	.reset_gpio_port[0]  = 126,
-	.reset_gpio_port[1]  = 61,
-	.reset_gpio_port[2]  = -EINVAL
 };
 
 #ifdef CONFIG_OMAP_MUX
@@ -199,6 +206,8 @@ static void __init omap_sdp_init(void)
 	board_smc91x_init();
 	board_flash_init(sdp_flash_partitions, chip_sel_sdp, NAND_BUSWIDTH_16);
 	enable_board_wakeup_source();
+
+	usbhs_init_phys(phy_data, ARRAY_SIZE(phy_data));
 	usbhs_init(&usbhs_bdata);
 }
 
-- 
1.7.4.1

