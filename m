Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab3APNyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 08:54:07 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:35157 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914Ab3APNyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 08:54:04 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>
Subject: [PATCH v2 01/11] ARM: OMAP: zoom-display: Remove the use of TWL4030_MODULE_PWM1
Date: Wed, 16 Jan 2013 14:53:49 +0100
Message-ID: <1358344439-23017-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1358344439-23017-1-git-send-email-peter.ujfalusi@ti.com>
References: <1358344439-23017-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the future proof TWL_MODULE_PWM module id instead to aim the twl-core
cleanup planed for 3.9 kernel cycle.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/board-zoom-display.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-omap2/board-zoom-display.c b/arch/arm/mach-omap2/board-zoom-display.c
index 1c7c834..8cef477 100644
--- a/arch/arm/mach-omap2/board-zoom-display.c
+++ b/arch/arm/mach-omap2/board-zoom-display.c
@@ -49,13 +49,13 @@ static void zoom_panel_disable_lcd(struct omap_dss_device *dssdev)
 {
 }
 
-/*
- * PWMA/B register offsets (TWL4030_MODULE_PWMA)
- */
+/* Register offsets in TWL4030_MODULE_INTBR */
 #define TWL_INTBR_PMBR1	0xD
 #define TWL_INTBR_GPBR1	0xC
-#define TWL_LED_PWMON	0x0
-#define TWL_LED_PWMOFF	0x1
+
+/* Register offsets in TWL_MODULE_PWM */
+#define TWL_LED_PWMON	0x3
+#define TWL_LED_PWMOFF	0x4
 
 static int zoom_set_bl_intensity(struct omap_dss_device *dssdev, int level)
 {
@@ -93,8 +93,8 @@ static int zoom_set_bl_intensity(struct omap_dss_device *dssdev, int level)
 	}
 
 	c = ((50 * (100 - level)) / 100) + 1;
-	twl_i2c_write_u8(TWL4030_MODULE_PWM1, 0x7F, TWL_LED_PWMOFF);
-	twl_i2c_write_u8(TWL4030_MODULE_PWM1, c, TWL_LED_PWMON);
+	twl_i2c_write_u8(TWL_MODULE_PWM, 0x7F, TWL_LED_PWMOFF);
+	twl_i2c_write_u8(TWL_MODULE_PWM, c, TWL_LED_PWMON);
 #else
 	pr_warn("Backlight not enabled\n");
 #endif
-- 
1.8.1

