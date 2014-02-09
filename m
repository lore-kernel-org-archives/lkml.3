Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbaBISzk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 13:55:40 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62412 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbaBISsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 13:48:30 -0500
From: Richard Weinberger <richard@nod.at>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-fbdev@vger.kernel.org (open list:FRAMEBUFFER LAYER),
        linux-kernel@vger.kernel.org (open list)
Cc: Richard Weinberger <richard@nod.at>
Subject: [PATCH 07/28] Remove CPU_PXA988
Date: Sun,  9 Feb 2014 19:47:45 +0100
Message-Id: <1391971686-9517-8-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1391971686-9517-1-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol is an orphan, get rid of it.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/video/mmp/Kconfig       |  2 +-
 drivers/video/mmp/hw/Kconfig    |  2 +-
 drivers/video/mmp/hw/mmp_ctrl.h | 32 --------------------------------
 3 files changed, 2 insertions(+), 34 deletions(-)

diff --git a/drivers/video/mmp/Kconfig b/drivers/video/mmp/Kconfig
index 969925d..f37bd6c 100644
--- a/drivers/video/mmp/Kconfig
+++ b/drivers/video/mmp/Kconfig
@@ -1,6 +1,6 @@
 menuconfig MMP_DISP
         tristate "Marvell MMP Display Subsystem support"
-        depends on CPU_PXA910 || CPU_MMP2 || CPU_PXA988
+        depends on CPU_PXA910 || CPU_MMP2
         help
 	  Marvell Display Subsystem support.
 
diff --git a/drivers/video/mmp/hw/Kconfig b/drivers/video/mmp/hw/Kconfig
index 57b03e2..95e8ec2 100644
--- a/drivers/video/mmp/hw/Kconfig
+++ b/drivers/video/mmp/hw/Kconfig
@@ -2,7 +2,7 @@ if MMP_DISP
 
 config MMP_DISP_CONTROLLER
 	bool "mmp display controller hw support"
-	depends on CPU_PXA910 || CPU_MMP2 || CPU_PXA988
+	depends on CPU_PXA910 || CPU_MMP2
 	default n
 	help
 		Marvell MMP display hw controller support
diff --git a/drivers/video/mmp/hw/mmp_ctrl.h b/drivers/video/mmp/hw/mmp_ctrl.h
index 53301cf..56fdeab 100644
--- a/drivers/video/mmp/hw/mmp_ctrl.h
+++ b/drivers/video/mmp/hw/mmp_ctrl.h
@@ -167,11 +167,7 @@ struct lcd_regs {
 				PN2_IOPAD_CONTROL) : LCD_TOP_CTRL)
 
 /* dither configure */
-#ifdef CONFIG_CPU_PXA988
-#define LCD_DITHER_CTRL				(0x01EC)
-#else
 #define LCD_DITHER_CTRL				(0x00A0)
-#endif
 
 #define DITHER_TBL_INDEX_SEL(s)		((s) << 16)
 #define DITHER_MODE2(m)				((m) << 12)
@@ -186,15 +182,6 @@ struct lcd_regs {
 #define DITHER_EN1					(1)
 
 /* dither table data was fixed by video bpp of input and output*/
-#ifdef CONFIG_CPU_PXA988
-#define DITHER_TB_4X4_INDEX0		(0x6e4ca280)
-#define DITHER_TB_4X4_INDEX1		(0x5d7f91b3)
-#define DITHER_TB_4X8_INDEX0		(0xb391a280)
-#define DITHER_TB_4X8_INDEX1		(0x7f5d6e4c)
-#define DITHER_TB_4X8_INDEX2		(0x80a291b3)
-#define DITHER_TB_4X8_INDEX3		(0x4c6e5d7f)
-#define LCD_DITHER_TBL_DATA		(0x01F0)
-#else
 #define DITHER_TB_4X4_INDEX0		(0x3b19f7d5)
 #define DITHER_TB_4X4_INDEX1		(0x082ac4e6)
 #define DITHER_TB_4X8_INDEX0		(0xf7d508e6)
@@ -202,7 +189,6 @@ struct lcd_regs {
 #define DITHER_TB_4X8_INDEX2		(0xc4e6d5f7)
 #define DITHER_TB_4X8_INDEX3		(0x082a193b)
 #define LCD_DITHER_TBL_DATA		(0x00A4)
-#endif
 
 /* Video Frame 0&1 start address registers */
 #define	LCD_SPU_DMA_START_ADDR_Y0	0x00C0
@@ -933,16 +919,9 @@ struct lcd_regs {
 #define LCD_PN2_SQULN2_CTRL			(0x02F0)
 #define ALL_LAYER_ALPHA_SEL			(0x02F4)
 
-/* pxa988 has different MASTER_CTRL from MMP3/MMP2 */
-#ifdef CONFIG_CPU_PXA988
-#define TIMING_MASTER_CONTROL			(0x01F4)
-#define MASTER_ENH(id)				(1 << ((id) + 5))
-#define MASTER_ENV(id)				(1 << ((id) + 6))
-#else
 #define TIMING_MASTER_CONTROL			(0x02F8)
 #define MASTER_ENH(id)				(1 << (id))
 #define MASTER_ENV(id)				(1 << ((id) + 4))
-#endif
 
 #define DSI_START_SEL_SHIFT(id)		(((id) << 1) + 8)
 #define timing_master_config(path, dsi_id, lcd_id) \
@@ -1312,19 +1291,8 @@ struct dsi_regs {
 #define	DSI_PHY_TIME_3_CFG_CSR_TIME_REQRDY_MASK		(0xff)
 #define	DSI_PHY_TIME_3_CFG_CSR_TIME_REQRDY_SHIFT	0
 
-/*
- * DSI timings
- * PXA988 has diffrent ESC CLK with MMP2/MMP3
- * it will be used in dsi_set_dphy() in pxa688_phy.c
- * as low power mode clock.
- */
-#ifdef CONFIG_CPU_PXA988
-#define DSI_ESC_CLK				52  /* Unit: Mhz */
-#define DSI_ESC_CLK_T				19  /* Unit: ns */
-#else
 #define DSI_ESC_CLK				66  /* Unit: Mhz */
 #define DSI_ESC_CLK_T				15  /* Unit: ns */
-#endif
 
 /* LVDS */
 /* LVDS_PHY_CTRL */
-- 
1.8.4.2

