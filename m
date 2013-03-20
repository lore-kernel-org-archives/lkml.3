Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881Ab3CTPp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:45:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47196 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932910Ab3CTPpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:45:25 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <rogerq@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 09/21] ARM: OMAP3: cm-t35: Adapt to ehci-omap changes
Date: Wed, 20 Mar 2013 17:44:48 +0200
Message-ID: <1363794300-31526-10-git-send-email-rogerq@ti.com>
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
 arch/arm/mach-omap2/board-cm-t35.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap2/board-cm-t35.c b/arch/arm/mach-omap2/board-cm-t35.c
index af2bb21..7fda3f5 100644
--- a/arch/arm/mach-omap2/board-cm-t35.c
+++ b/arch/arm/mach-omap2/board-cm-t35.c
@@ -419,15 +419,22 @@ static struct omap2_hsmmc_info mmc[] = {
 	{}	/* Terminator */
 };
 
+static struct usbhs_phy_data phy_data[] __initdata = {
+	{
+		.port = 1,
+		.reset_gpio = OMAP_MAX_GPIO_LINES + 6,
+		.vcc_gpio = -EINVAL,
+	},
+	{
+		.port = 2,
+		.reset_gpio = OMAP_MAX_GPIO_LINES + 7,
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
-	.reset_gpio_port[0]  = OMAP_MAX_GPIO_LINES + 6,
-	.reset_gpio_port[1]  = OMAP_MAX_GPIO_LINES + 7,
-	.reset_gpio_port[2]  = -EINVAL
 };
 
 static void  __init cm_t35_init_usbh(void)
@@ -444,6 +451,7 @@ static void  __init cm_t35_init_usbh(void)
 		msleep(1);
 	}
 
+	usbhs_init_phys(phy_data, ARRAY_SIZE(phy_data));
 	usbhs_init(&usbhs_bdata);
 }
 
-- 
1.7.4.1

