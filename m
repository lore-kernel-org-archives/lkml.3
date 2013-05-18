Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab3ERJPq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 05:15:46 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:51016 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab3ERJPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 05:15:17 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tomi.valkeinen@ti.com, linux-fbdev@vger.kernel.org,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 2/4] fb: vt8500: Convert to use vendor register names
Date: Sat, 18 May 2013 21:15:12 +1200
Message-Id: <1368868514-18975-3-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1368868514-18975-1-git-send-email-linux@prisktech.co.nz>
References: <1368868514-18975-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change all the #defines to match the vendor defined names, and change the
references in wm8505fb.c and wmt_ge_rops.c.
Add all the missing register offsets as well to prevent churn in the future.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 drivers/video/wm8505fb.c    |  159 ++++++++++++++++--------
 drivers/video/wmt_ge_rops.c |  280 +++++++++++++++++++++++++++++++++----------
 2 files changed, 332 insertions(+), 107 deletions(-)

diff --git a/drivers/video/wm8505fb.c b/drivers/video/wm8505fb.c
index f824af8..167a9e2 100644
--- a/drivers/video/wm8505fb.c
+++ b/drivers/video/wm8505fb.c
@@ -38,29 +38,94 @@
 
 #define DRIVER_NAME "wm8505-fb"
 
-#define WMT_GOVR_COLORSPACE1	0x030
-#define WMT_GOVR_MIF_ENABLE	0x080
-#define WMT_GOVR_FBADDR		0x090
-#define WMT_GOVR_FBADDR1	0x094
-#define WMT_GOVR_XRES		0x098
-#define WMT_GOVR_XRES_VIRTUAL	0x09c
-#define WMT_GOVR_YPAN		0x0a0
-#define WMT_GOVR_XPAN		0x0a4
-#define WMT_GOVR_FHI		0x0a8
-#define WMT_GOVR_REG_UPDATE	0x0e4
-#define WMT_GOVR_TG		0x100
-#define WMT_GOVR_TIMING_H_ALL	0x108
-#define WMT_GOVR_TIMING_V_ALL	0x10c
-#define WMT_GOVR_TIMING_V_START	0x110
-#define WMT_GOVR_TIMING_V_END	0x114
-#define WMT_GOVR_TIMING_H_START	0x118
-#define WMT_GOVR_TIMING_H_END	0x11c
-#define WMT_GOVR_TIMING_V_SYNC	0x128
-#define WMT_GOVR_TIMING_H_SYNC	0x12c
-#define WMT_GOVR_DVO_SET	0x148
-#define WMT_GOVR_CONTRAST	0x1b8
-#define WMT_GOVR_BRGHTNESS	0x1bc
-#define WMT_GOVR_COLORSPACE	0x1e4
+#define REG_GOVRH_CUR_ADDR		0x0000
+#define REG_GOVRH_CUR_WIDTH		0x0004
+#define REG_GOVRH_CUR_FB_WIDTH		0x0008
+#define REG_GOVRH_CUR_VCROP		0x000C
+#define REG_GOVRH_CUR_HCROP		0x0010
+#define REG_GOVRH_CUR_HCOORD		0x0014
+#define REG_GOVRH_CUR_VCOORD		0x0018
+#define REG_GOVRH_CUR_STATUS		0x001C
+#define REG_GOVRH_CUR_COLOR_KEY		0x0020
+#define REG_GOVRH_DVO_PIX		0x0030
+#define REG_GOVRH_DVO_DLY_SEL		0x0034
+#define REG_GOVRH_INT			0x0038
+#define REG_GOVRH_DVO_BLANK_DATA	0x003C
+#define REG_GOVRH_DIRPATH		0x0040	/* WM8750+ */
+#define REG_GOVRH_MIF			0x0080
+#define REG_GOVRH_COLFMT		0x0084
+#define REG_GOVRH_SRCFMT		0x0088
+#define REG_GOVRH_DSTFMT		0x008C
+#define REG_GOVRH_YSA			0x0090
+#define REG_GOVRH_CSA			0x0094
+#define REG_GOVRH_PIXWID		0x0098
+#define REG_GOVRH_BUFWID		0x009C
+#define REG_GOVRH_VCROP			0x00A0
+#define REG_GOVRH_HCROP			0x00A4
+#define REG_GOVRH_FHI			0x00A8
+#define REG_GOVRH_COLFMT2		0x00AC
+#define REG_GOVRH_YSA2			0x00B0	/* WM8950 */
+#define REG_GOVRH_CSA2			0x00B4	/* WM8950 */
+#define REG_GOVRH_MIF_FRAME_MODE	0x00B8	/* WM8950 */
+#define REG_GOVRH_REG_STS		0x00E4
+#define REG_GOVRH_SWFLD			0x00E8
+#define REG_GOVRH_TG_ENABLE		0x0100
+#define REG_GOVRH_READ_CYC		0x0104
+#define REG_GOVRH_H_ALLPXL		0x0108
+#define REG_GOVRH_V_ALLLN		0x010C
+#define REG_GOVRH_ACTLN_BG		0x0110
+#define REG_GOVRH_ACTLN_END		0x0114
+#define REG_GOVRH_ACTPX_BG		0x0118
+#define REG_GOVRH_ACTPX_END		0x011C
+#define REG_GOVRH_VBIE_LINE		0x0120
+#define REG_GOVRH_PVBI_LINE		0x0124
+#define REG_GOVRH_HDMI_VBISW		0x0128
+#define REG_GOVRH_HDMI_HSYNW		0x012C
+#define REG_GOVRH_VSYNC_OFFSET		0x0130
+#define REG_GOVRH_FIELD_STATUS		0x0134
+#define REG_GOVRH_HDMI_3D		0x013C	/* WM8950 */
+#define REG_GOVRH_DVO_SET		0x0148
+#define REG_GOVRH_CB_ENABLE		0x0150
+#define REG_GOVRH_H_ALLPXL2		0x0158
+#define REG_GOVRH_V_ALLLN2		0x015C
+#define REG_GOVRH_ACTLN_BG2		0x0160
+#define REG_GOVRH_ACTLN_END2		0x0164
+#define REG_GOVRH_ACTPX_BG2		0x0168
+#define REG_GOVRH_ACTPX_END2		0x016C
+#define REG_GOVRH_VBIE_LINE2		0x0170
+#define REG_GOVRH_PVBI_LINE2		0x0174
+#define REG_GOVRH_HDMI_VBISW2		0x0178
+#define REG_GOVRH_HDMI_HSYNW2		0x017C
+#define REG_GOVRH_LVDS_CTRL		0x0180	/* WM8750+ */
+#define REG_GOVRH_LVDS_CTRL2		0x0184	/* WM8750+ */
+#define REG_GOVRH_DAC_LP_SENSE_VAL	0x0188	/* WM8750 */
+#define REG_GOVRH_DAC_TEST_MODE		0x018C	/* WM8750 */
+#define REG_GOVRH_VGA_HSYNW		0x0190	/* WM8750 */
+#define REG_GOVRH_VGA_VSYNW		0x0194	/* WM8750 */
+#define REG_GOVRH_VGA_SYNPOLAR		0x0198	/* WM8750 */
+#define REG_GOVRH_DAC_MOD		0x019C	/* WM8750 */
+#define REG_GOVRH_DAC_VAL		0x01A0	/* WM8750 */
+#define REG_GOVRH_DAC_CON		0x01A4	/* WM8750 */
+#define REG_GOVRH_DAC_TEST		0x01A8	/* WM8750 */
+#define REG_GOVRH_DAC_BTEST		0x01AC	/* WM8750 */
+#define REG_GOVRH_DAC_CTEST		0x01B0	/* WM8750 */
+#define REG_GOVRH_DAC_DBG		0x01B4	/* WM8750 */
+#define REG_GOVRH_CONTRAST		0x01B8
+#define REG_GOVRH_BRIGHTNESS		0x01BC
+#define REG_GOVRH_DMACSC_COEF0		0x01C0
+#define REG_GOVRH_DMACSC_COEF1		0x01C4
+#define REG_GOVRH_DMACSC_COEF2		0x01C8
+#define REG_GOVRH_DMACSC_COEF3		0x01CC
+#define REG_GOVRH_DMACSC_COEF4		0x01D0
+#define REG_GOVRH_DMACSC_COEF5		0x01D8
+#define REG_GOVRH_DMACSC_COEF6		0x01DC
+#define REG_GOVRH_CSC_MODE		0x01E0
+#define REG_GOVRH_YUVRGB		0x01E4
+#define REG_GOVRH_H264_INPUT_EN		0x01E8
+#define REG_GOVRH_DISP_EN		0x01EC	/* WM8750 */
+#define REG_GOVRH_HSCALE_UP		0x01F4
+#define REG_GOVRH_IGS_MODE		0x01F8
+#define REG_GOVRH_IGS_MODE2		0x01FC
 
 #define to_wm8505fb_info(__info) container_of(__info, \
 						struct wm8505fb_info, fb)
@@ -82,26 +147,26 @@ static int wm8505fb_init_hw(struct fb_info *info)
 		writel(0, fbi->regbase + i);
 
 	/* Set frame buffer address */
-	writel(fbi->fb.fix.smem_start, fbi->regbase + WMT_GOVR_FBADDR);
-	writel(fbi->fb.fix.smem_start, fbi->regbase + WMT_GOVR_FBADDR1);
+	writel(fbi->fb.fix.smem_start, fbi->regbase + REG_GOVRH_YSA);
+	writel(fbi->fb.fix.smem_start, fbi->regbase + REG_GOVRH_CSA);
 
 	/*
 	 * Set in-memory picture format to RGB
 	 * 0x31C sets the correct color mode (RGB565) for WM8650
 	 * Bit 8+9 (0x300) are ignored on WM8505 as reserved
 	 */
-	writel(0x31c,		       fbi->regbase + WMT_GOVR_COLORSPACE);
-	writel(1,		       fbi->regbase + WMT_GOVR_COLORSPACE1);
+	writel(0x31c,		       fbi->regbase + REG_GOVRH_YUVRGB);
+	writel(1,		       fbi->regbase + REG_GOVRH_DVO_PIX);
 
 	/* Virtual buffer size */
-	writel(info->var.xres,	       fbi->regbase + WMT_GOVR_XRES);
-	writel(info->var.xres_virtual, fbi->regbase + WMT_GOVR_XRES_VIRTUAL);
+	writel(info->var.xres,	       fbi->regbase + REG_GOVRH_PIXWID);
+	writel(info->var.xres_virtual, fbi->regbase + REG_GOVRH_BUFWID);
 
 	/* black magic ;) */
-	writel(0xf,		       fbi->regbase + WMT_GOVR_FHI);
-	writel(4,		       fbi->regbase + WMT_GOVR_DVO_SET);
-	writel(1,		       fbi->regbase + WMT_GOVR_MIF_ENABLE);
-	writel(1,		       fbi->regbase + WMT_GOVR_REG_UPDATE);
+	writel(0xf,		       fbi->regbase + REG_GOVRH_FHI);
+	writel(4,		       fbi->regbase + REG_GOVRH_DVO_SET);
+	writel(1,		       fbi->regbase + REG_GOVRH_MIF);
+	writel(1,		       fbi->regbase + REG_GOVRH_REG_STS);
 
 	return 0;
 }
@@ -120,19 +185,19 @@ static int wm8505fb_set_timing(struct fb_info *info)
 	int v_all = v_end + info->var.lower_margin;
 	int v_sync = info->var.vsync_len;
 
-	writel(0, fbi->regbase + WMT_GOVR_TG);
+	writel(0, fbi->regbase + REG_GOVRH_TG_ENABLE);
 
-	writel(h_start, fbi->regbase + WMT_GOVR_TIMING_H_START);
-	writel(h_end,   fbi->regbase + WMT_GOVR_TIMING_H_END);
-	writel(h_all,   fbi->regbase + WMT_GOVR_TIMING_H_ALL);
-	writel(h_sync,  fbi->regbase + WMT_GOVR_TIMING_H_SYNC);
+	writel(h_start, fbi->regbase + REG_GOVRH_ACTPX_BG);
+	writel(h_end,   fbi->regbase + REG_GOVRH_ACTPX_END);
+	writel(h_all,   fbi->regbase + REG_GOVRH_H_ALLPXL);
+	writel(h_sync,  fbi->regbase + REG_GOVRH_HDMI_HSYNW);
 
-	writel(v_start, fbi->regbase + WMT_GOVR_TIMING_V_START);
-	writel(v_end,   fbi->regbase + WMT_GOVR_TIMING_V_END);
-	writel(v_all,   fbi->regbase + WMT_GOVR_TIMING_V_ALL);
-	writel(v_sync,  fbi->regbase + WMT_GOVR_TIMING_V_SYNC);
+	writel(v_start, fbi->regbase + REG_GOVRH_ACTLN_BG);
+	writel(v_end,   fbi->regbase + REG_GOVRH_ACTLN_END);
+	writel(v_all,   fbi->regbase + REG_GOVRH_V_ALLLN);
+	writel(v_sync,  fbi->regbase + REG_GOVRH_HDMI_VBISW);
 
-	writel(1, fbi->regbase + WMT_GOVR_TG);
+	writel(1, fbi->regbase + REG_GOVRH_TG_ENABLE);
 
 	return 0;
 }
@@ -174,7 +239,7 @@ static int wm8505fb_set_par(struct fb_info *info)
 	wm8505fb_set_timing(info);
 
 	writel(fbi->contrast<<16 | fbi->contrast<<8 | fbi->contrast,
-		fbi->regbase + WMT_GOVR_CONTRAST);
+		fbi->regbase + REG_GOVRH_CONTRAST);
 
 	return 0;
 }
@@ -250,8 +315,8 @@ static int wm8505fb_pan_display(struct fb_var_screeninfo *var,
 {
 	struct wm8505fb_info *fbi = to_wm8505fb_info(info);
 
-	writel(var->xoffset, fbi->regbase + WMT_GOVR_XPAN);
-	writel(var->yoffset, fbi->regbase + WMT_GOVR_YPAN);
+	writel(var->xoffset, fbi->regbase + REG_GOVRH_VCROP);
+	writel(var->yoffset, fbi->regbase + REG_GOVRH_HCROP);
 	return 0;
 }
 
@@ -264,7 +329,7 @@ static int wm8505fb_blank(int blank, struct fb_info *info)
 		wm8505fb_set_timing(info);
 		break;
 	default:
-		writel(0,  fbi->regbase + WMT_GOVR_TIMING_V_SYNC);
+		writel(0,  fbi->regbase + REG_GOVRH_HDMI_VBISW);
 		break;
 	}
 
diff --git a/drivers/video/wmt_ge_rops.c b/drivers/video/wmt_ge_rops.c
index 4aaeb18..68de46a 100644
--- a/drivers/video/wmt_ge_rops.c
+++ b/drivers/video/wmt_ge_rops.c
@@ -20,29 +20,189 @@
 #include <linux/platform_device.h>
 #include "fb_draw.h"
 
-#define GE_COMMAND_OFF		0x00
-#define GE_DEPTH_OFF		0x04
-#define GE_HIGHCOLOR_OFF	0x08
-#define GE_ROPCODE_OFF		0x14
-#define GE_FIRE_OFF		0x18
-#define GE_SRCBASE_OFF		0x20
-#define GE_SRCDISPW_OFF		0x24
-#define GE_SRCDISPH_OFF		0x28
-#define GE_SRCAREAX_OFF		0x2c
-#define GE_SRCAREAY_OFF		0x30
-#define GE_SRCAREAW_OFF		0x34
-#define GE_SRCAREAH_OFF		0x38
-#define GE_DESTBASE_OFF		0x3c
-#define GE_DESTDISPW_OFF	0x40
-#define GE_DESTDISPH_OFF	0x44
-#define GE_DESTAREAX_OFF	0x48
-#define GE_DESTAREAY_OFF	0x4c
-#define GE_DESTAREAW_OFF	0x50
-#define GE_DESTAREAH_OFF	0x54
-#define GE_PAT0C_OFF		0x88	/* Pattern 0 color */
-#define GE_ENABLE_OFF		0xec
-#define GE_INTEN_OFF		0xf0
-#define GE_STATUS_OFF		0xf8
+#define GE_COMMAND		0x0000
+#define GE_COLOR_DEPTH		0x0004
+#define GE_HM_SEL		0x0008
+#define GE_PAT_TRAN_EN		0x000C
+#define GE_FONT_TRAN_EN		0x0010
+#define GE_ROP_CODE		0x0014
+#define GE_FIRE			0x0018
+#define GE_ROP_BG_CODE		0x001C
+#define GE_SRC_BADDR		0x0020
+#define GE_SRC_DISP_W		0x0024
+#define GE_SRC_DISP_H		0x0028
+#define GE_SRC_X_START		0x002C
+#define GE_SRC_Y_START		0x0030
+#define GE_SRC_WIDTH		0x0034
+#define GE_SRC_HEIGHT		0x0038
+#define GE_DES_BADDR		0x003C
+#define GE_DES_DISP_W		0x0040
+#define GE_DES_DISP_H		0x0044
+#define GE_DES_X_START		0x0048
+#define GE_DES_Y_START		0x004C
+#define GE_DES_WIDTH		0x0050
+#define GE_DES_HEIGHT		0x0054
+#define GE_FONT0_BUF		0x0058
+#define GE_FONT1_BUF		0x005C
+#define GE_FONT2_BUF		0x0060
+#define GE_FONT3_BUF		0x0064
+#define GE_PAT0_BUF		0x0068
+#define GE_PAT1_BUF		0x006C
+#define GE_PAT2_BUF		0x0070
+#define GE_PAT3_BUF		0x0074
+#define GE_PAT4_BUF		0x0078
+#define GE_PAT5_BUF		0x007C
+#define GE_PAT6_BUF		0x0080
+#define GE_PAT7_BUF		0x0084
+#define GE_PAT0_COLOR		0x0088
+#define GE_PAT1_COLOR		0x008C
+#define GE_PAT2_COLOR		0x0090
+#define GE_PAT3_COLOR		0x0094
+#define GE_PAT4_COLOR		0x0098
+#define GE_PAT5_COLOR		0x009C
+#define GE_PAT6_COLOR		0x00A0
+#define GE_PAT7_COLOR		0x00A4
+#define GE_PAT8_COLOR		0x00A8
+#define GE_PAT9_COLOR		0x00AC
+#define GE_PAT10_COLOR		0x00B0
+#define GE_PAT11_COLOR		0x00B4
+#define GE_PAT12_COLOR		0x00B8
+#define GE_PAT13_COLOR		0x00BC
+#define GE_PAT14_COLOR		0x00C0
+#define GE_PAT15_COLOR		0x00C4
+#define GE_CK_SEL		0x00C8
+#define GE_SRC_CK		0x00CC
+#define GE_DES_CK		0x00D0
+#define GE_ALPHA_SEL		0x00D4
+#define GE_BITBLT_ALPHA		0x00D8
+#define GE_DES_PATH_EN		0x00DC
+#define GE_ROTATE_MODE		0x00E0
+#define GE_MIRROR_MODE		0x00E4
+#define GE_GE_DELAY		0x00E8
+#define GE_ENABLE		0x00EC
+#define GE_INT_EN		0x00F0
+#define GE_INT_FLAG		0x00F4
+#define GE_STATUS		0x00F8
+#define GE_SWID			0x00FC
+#define GE_LN_X_START		0x0100
+#define GE_LN_X_END		0x0104
+#define GE_LN_Y_START		0x0108
+#define GE_LN_Y_END		0x0110
+#define GE_LN_TCK		0x0114
+#define GE_AMX_CSC_BYPASS	0x0118
+#define GE_C1_COEF		0x011C
+#define GE_LN_STL_TB		0x0120
+#define GE_LN_STL_RTN		0x0124
+#define GE_LN_STL_DATA		0x0128
+#define GE_LN_STL_APA		0x012C
+#define GE_BC_P1X		0x0130
+#define GE_BC_P1Y		0x0134
+#define GE_BC_P2X		0x0138
+#define GE_BC_P2Y		0x013C
+#define GE_BC_P3X		0x0140
+#define GE_BC_P3Y		0x0144
+#define GE_BC_COLOR		0x0148
+#define GE_BC_ALPHA		0x014C
+#define GE_BC_DELTA_T		0x0150
+#define GE_BC_L_STL		0x0154
+#define GE_BC_L_STL_RTN		0x0158
+#define GE_C2_COEF		0x015C
+#define GE_C3_COEF		0x0160
+#define GE_C4_COEF		0x0164
+#define GE_C5_COEF		0x0168
+#define GE_C6_COEF		0x016C
+#define GE_C7_COEF		0x0170
+#define GE_C8_COEF		0x0174
+#define GE_YUV2_Y_BADDR		0x0178
+#define GE_YUV2_C_BADDR		0x017C
+#define GE_VQ_EN		0x0180
+#define GE_VQ_SIZE		0x0184
+#define GE_VQ_UDPTR		0x0188
+#define GE_VQ_BASEADDR		0x018C
+#define GE_VQ_WRSIZE		0x0190
+#define GE_VQ_STADDRW		0x0194
+#define GE_VQ_THR		0x0198
+#define GE_VQ_YUV2_Y_FBW	0x019C
+#define GE_ROP4_EN		0x01A0
+#define GE_ALPHA_PLANE_EN	0x01A4
+#define GE_MASK_BADDR		0x01A8
+#define GE_MASK_DISP_W		0x01AC
+#define GE_MASK_DISP_H		0x01B0
+#define GE_MASK_X_START		0x01B4
+#define GE_MASK_Y_START		0x01B8
+#define GE_MASK_WIDTH		0x01BC
+#define GE_MASK_HEIGHT		0x01C0
+#define GE_DW_MASK_BADDR	0x01C4
+#define GE_ALPHA_PLANE_WBE	0x01C8
+#define GE_YUV2_C_FBW		0x01CC
+#define GE_ADAP_BLEND_EN	0x01D0
+#define GE_SRC_ALPHA_SEL	0x01D4
+#define GE_SRC_BLEND_APA	0x01D8
+#define GE_DES_ALPHA_SEL	0x01DC
+#define GE_DES_BLEND_APA	0x01E0
+#define GE_ADAP_CLAMP_EN	0x01E4
+#define GE_YUV2_C_BLEND_SEL	0x01E8
+#define GE_SRC_INDEP_MODE	0x01EC
+#define GE_C9_COEF		0x01F0
+#define GE_COEF_I		0x01F4
+#define GE_COEF_J		0x01F8
+#define GE_COEF_K		0x01FC
+#define GE_G1_CD		0x0200
+#define GE_G2_CD		0x0204
+#define GE_G1_FG_ADDR		0x0210
+#define GE_G1_BG_ADDR		0x0214
+#define GE_G1_FB_SEL		0x0218
+#define GE_G2_FG_ADDR		0x021C
+#define GE_G2_BG_ADDR		0x0220
+#define GE_G2_FB_SEL		0x0224
+#define GE_G1_X_START		0x0230
+#define GE_G1_X_END		0x0234
+#define GE_G1_Y_START		0x0238
+#define GE_G1_Y_END		0x023C
+#define GE_G2_X_START		0x0240
+#define GE_G2_X_END		0x0244
+#define GE_G2_Y_START		0x0248
+#define GE_G2_Y_END		0x024C
+#define GE_DISP_X_END		0x0250
+#define GE_DISP_Y_END		0x0254
+#define GE_AMX_CB		0x0258
+#define GE_G1_YUV_MODE_EN	0x025C
+#define GE_G2_YUV_MODE_EN	0x0260
+#define GE_G1_YUV_FMT_SEL	0x0264
+#define GE_G1_YUV_OUTP_SEL	0x0268
+#define GE_G2_YUV_FMT_SEL	0x026C
+#define GE_G2_YUV_OUTP_SEL	0x0270
+#define GE_AMX_CSC_CFG		0x0274
+#define GE_AMX_CSC_MODE		0x0278
+#define GE_AMX_Y_SUB_16_EN	0x027C
+#define GE_G1_YUV_ADDR		0x0280
+#define GE_G2_YUV_ADDR		0x0284
+#define GE_G1_CK_EN		0x0298
+#define GE_G2_CK_EN		0x029C
+#define GE_G1_C_KEY		0x02A0
+#define GE_G2_C_KEY		0x02A4
+#define GE_G1_AMX_EN		0x02A8
+#define GE_G2_AMX_EN		0x02AC
+#define GE_CK2_APA		0x02B0
+#define GE_AMX_CTL		0x02B4
+#define GE_CK_APA		0x02B8
+#define GE_FIX_APA		0x02BC
+#define GE_G1_AMX_HM		0x02C0
+#define GE_G2_AMX_HM		0x02C4
+#define GE_NH_DATA		0x02C8
+#define GE_VSYNC_STS		0x02CC
+#define GE_REG_UPD		0x02D0
+#define GE_REG_SEL		0x02D4
+#define GE_REG_AMX2_CTL		0x02D8
+#define GE_FIX2_APA		0x02DC
+#define GE_G1_H_SCALE		0x02E0
+#define GE_G2_H_SCALE		0x02E4
+#define GE_G1_FBW		0x02E8
+#define GE_G1_VCROP		0x02EC
+#define GE_G1_HCROP		0x02F0
+#define GE_G2_FBW		0x02F4
+#define GE_G2_VCROP		0x02F8
+#define GE_G2_HCROP		0x02FC
 
 static void __iomem *regbase;
 
@@ -65,20 +225,20 @@ void wmt_ge_fillrect(struct fb_info *p, const struct fb_fillrect *rect)
 		p->fbops->fb_sync(p);
 
 	writel(p->var.bits_per_pixel == 32 ? 3 :
-	      (p->var.bits_per_pixel == 8 ? 0 : 1), regbase + GE_DEPTH_OFF);
-	writel(p->var.bits_per_pixel == 15 ? 1 : 0, regbase + GE_HIGHCOLOR_OFF);
-	writel(p->fix.smem_start, regbase + GE_DESTBASE_OFF);
-	writel(p->var.xres_virtual - 1, regbase + GE_DESTDISPW_OFF);
-	writel(p->var.yres_virtual - 1, regbase + GE_DESTDISPH_OFF);
-	writel(rect->dx, regbase + GE_DESTAREAX_OFF);
-	writel(rect->dy, regbase + GE_DESTAREAY_OFF);
-	writel(rect->width - 1, regbase + GE_DESTAREAW_OFF);
-	writel(rect->height - 1, regbase + GE_DESTAREAH_OFF);
-
-	writel(pat, regbase + GE_PAT0C_OFF);
-	writel(1, regbase + GE_COMMAND_OFF);
-	writel(rect->rop == ROP_XOR ? 0x5a : 0xf0, regbase + GE_ROPCODE_OFF);
-	writel(1, regbase + GE_FIRE_OFF);
+	      (p->var.bits_per_pixel == 8 ? 0 : 1), regbase + GE_COLOR_DEPTH);
+	writel(p->var.bits_per_pixel == 15 ? 1 : 0, regbase + GE_HM_SEL);
+	writel(p->fix.smem_start, regbase + GE_DES_BADDR);
+	writel(p->var.xres_virtual - 1, regbase + GE_DES_DISP_W);
+	writel(p->var.yres_virtual - 1, regbase + GE_DES_DISP_H);
+	writel(rect->dx, regbase + GE_DES_X_START);
+	writel(rect->dy, regbase + GE_DES_Y_START);
+	writel(rect->width - 1, regbase + GE_DES_WIDTH);
+	writel(rect->height - 1, regbase + GE_DES_HEIGHT);
+
+	writel(pat, regbase + GE_PAT0_COLOR);
+	writel(1, regbase + GE_COMMAND);
+	writel(rect->rop == ROP_XOR ? 0x5a : 0xf0, regbase + GE_ROP_CODE);
+	writel(1, regbase + GE_FIRE);
 }
 EXPORT_SYMBOL_GPL(wmt_ge_fillrect);
 
@@ -91,34 +251,34 @@ void wmt_ge_copyarea(struct fb_info *p, const struct fb_copyarea *area)
 		p->fbops->fb_sync(p);
 
 	writel(p->var.bits_per_pixel > 16 ? 3 :
-	      (p->var.bits_per_pixel > 8 ? 1 : 0), regbase + GE_DEPTH_OFF);
-
-	writel(p->fix.smem_start, regbase + GE_SRCBASE_OFF);
-	writel(p->var.xres_virtual - 1, regbase + GE_SRCDISPW_OFF);
-	writel(p->var.yres_virtual - 1, regbase + GE_SRCDISPH_OFF);
-	writel(area->sx, regbase + GE_SRCAREAX_OFF);
-	writel(area->sy, regbase + GE_SRCAREAY_OFF);
-	writel(area->width - 1, regbase + GE_SRCAREAW_OFF);
-	writel(area->height - 1, regbase + GE_SRCAREAH_OFF);
-
-	writel(p->fix.smem_start, regbase + GE_DESTBASE_OFF);
-	writel(p->var.xres_virtual - 1, regbase + GE_DESTDISPW_OFF);
-	writel(p->var.yres_virtual - 1, regbase + GE_DESTDISPH_OFF);
-	writel(area->dx, regbase + GE_DESTAREAX_OFF);
-	writel(area->dy, regbase + GE_DESTAREAY_OFF);
-	writel(area->width - 1, regbase + GE_DESTAREAW_OFF);
-	writel(area->height - 1, regbase + GE_DESTAREAH_OFF);
-
-	writel(0xcc, regbase + GE_ROPCODE_OFF);
-	writel(1, regbase + GE_COMMAND_OFF);
-	writel(1, regbase + GE_FIRE_OFF);
+	      (p->var.bits_per_pixel > 8 ? 1 : 0), regbase + GE_COLOR_DEPTH);
+
+	writel(p->fix.smem_start, regbase + GE_SRC_BADDR);
+	writel(p->var.xres_virtual - 1, regbase + GE_SRC_DISP_W);
+	writel(p->var.yres_virtual - 1, regbase + GE_SRC_DISP_H);
+	writel(area->sx, regbase + GE_SRC_X_START);
+	writel(area->sy, regbase + GE_SRC_Y_START);
+	writel(area->width - 1, regbase + GE_SRC_WIDTH);
+	writel(area->height - 1, regbase + GE_SRC_HEIGHT);
+
+	writel(p->fix.smem_start, regbase + GE_DES_BADDR);
+	writel(p->var.xres_virtual - 1, regbase + GE_DES_DISP_W);
+	writel(p->var.yres_virtual - 1, regbase + GE_DES_DISP_H);
+	writel(area->dx, regbase + GE_DES_X_START);
+	writel(area->dy, regbase + GE_DES_Y_START);
+	writel(area->width - 1, regbase + GE_DES_WIDTH);
+	writel(area->height - 1, regbase + GE_DES_HEIGHT);
+
+	writel(0xcc, regbase + GE_ROP_CODE);
+	writel(1, regbase + GE_COMMAND);
+	writel(1, regbase + GE_FIRE);
 }
 EXPORT_SYMBOL_GPL(wmt_ge_copyarea);
 
 int wmt_ge_sync(struct fb_info *p)
 {
 	int loops = 5000000;
-	while ((readl(regbase + GE_STATUS_OFF) & 4) && --loops)
+	while ((readl(regbase + GE_STATUS) & 4) && --loops)
 		cpu_relax();
 	return loops > 0 ? 0 : -EBUSY;
 }
@@ -146,7 +306,7 @@ static int wmt_ge_rops_probe(struct platform_device *pdev)
 		return -EBUSY;
 	}
 
-	writel(1, regbase + GE_ENABLE_OFF);
+	writel(1, regbase + GE_ENABLE);
 	printk(KERN_INFO "Enabled support for WMT GE raster acceleration\n");
 
 	return 0;
-- 
1.7.9.5

