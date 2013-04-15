Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab3DOLUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 07:20:16 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40558 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220Ab3DOLUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 07:20:14 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH] ARM: OMAP3: Beagle: Fix USB Host on beagle xM Ax/Bx
Date: Mon, 15 Apr 2013 14:20:08 +0300
Message-ID: <1366024808-4691-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Beagle xM Rev. Ax/Bx, the USB power enable GPIO logic is
reversed when compared to other revisions i.e. it is
active high instead of active low.

Use the beagle_config.usb_pwr_level flag correctly so that
the power regulator can be configured at runtime.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/board-omap3beagle.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index 5382215..21136b2 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -112,13 +112,13 @@ static u8 omap3_beagle_version;
  */
 static struct {
 	int mmc1_gpio_wp;
-	int usb_pwr_level;
+	bool usb_pwr_level;	/* 0 - Active Low, 1 - Active High */
 	int dvi_pd_gpio;
 	int usr_button_gpio;
 	int mmc_caps;
 } beagle_config = {
 	.mmc1_gpio_wp = -EINVAL,
-	.usb_pwr_level = GPIOF_OUT_INIT_LOW,
+	.usb_pwr_level = 0,
 	.dvi_pd_gpio = -EINVAL,
 	.usr_button_gpio = 4,
 	.mmc_caps = MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA,
@@ -178,7 +178,7 @@ static void __init omap3_beagle_init_rev(void)
 	case 0:
 		printk(KERN_INFO "OMAP3 Beagle Rev: xM Ax/Bx\n");
 		omap3_beagle_version = OMAP3BEAGLE_BOARD_XM;
-		beagle_config.usb_pwr_level = GPIOF_OUT_INIT_HIGH;
+		beagle_config.usb_pwr_level = 1;
 		beagle_config.mmc_caps &= ~MMC_CAP_8_BIT_DATA;
 		break;
 	case 2:
-- 
1.7.4.1

