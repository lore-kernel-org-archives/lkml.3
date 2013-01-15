Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab3AOLVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 06:21:36 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5198 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab3AOLV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 06:21:29 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 15 Jan 2013 03:20:27 -0800
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <amerilainen@nvidia.com>, <airlied@linux.ie>,
        <thierry.reding@avionic-design.de>
CC: <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Terje Bergstrom <tbergstrom@nvidia.com>
Subject: [PATCHv5 5/8] drm: tegra: Move drm to live under host1x
Date: Tue, 15 Jan 2013 13:26:19 +0200
Message-ID: <1358249182-17486-6-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358249182-17486-1-git-send-email-tbergstrom@nvidia.com>
References: <1358249182-17486-1-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make drm part of host1x driver.

Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
---
 drivers/gpu/drm/Kconfig            |    2 -
 drivers/gpu/drm/Makefile           |    1 -
 drivers/gpu/drm/tegra/Kconfig      |   23 -
 drivers/gpu/drm/tegra/Makefile     |    7 -
 drivers/gpu/drm/tegra/dc.c         |  833 -----------------------
 drivers/gpu/drm/tegra/dc.h         |  388 -----------
 drivers/gpu/drm/tegra/drm.c        |  115 ----
 drivers/gpu/drm/tegra/drm.h        |  216 ------
 drivers/gpu/drm/tegra/fb.c         |   56 --
 drivers/gpu/drm/tegra/hdmi.c       | 1321 ------------------------------------
 drivers/gpu/drm/tegra/hdmi.h       |  575 ----------------
 drivers/gpu/drm/tegra/host1x.c     |  327 ---------
 drivers/gpu/drm/tegra/output.c     |  272 --------
 drivers/gpu/drm/tegra/rgb.c        |  228 -------
 drivers/gpu/host1x/Kconfig         |    3 +
 drivers/gpu/host1x/Makefile        |    6 +
 drivers/gpu/host1x/drm/Kconfig     |   23 +
 drivers/gpu/host1x/drm/dc.c        |  833 +++++++++++++++++++++++
 drivers/gpu/host1x/drm/dc.h        |  388 +++++++++++
 drivers/gpu/host1x/drm/drm.c       |  115 ++++
 drivers/gpu/host1x/drm/drm.h       |  216 ++++++
 drivers/gpu/host1x/drm/fb.c        |   56 ++
 drivers/gpu/host1x/drm/hdmi.c      | 1321 ++++++++++++++++++++++++++++++++++++
 drivers/gpu/host1x/drm/hdmi.h      |  575 ++++++++++++++++
 drivers/gpu/host1x/drm/host1x.c    |  327 +++++++++
 drivers/gpu/host1x/drm/output.c    |  272 ++++++++
 drivers/gpu/host1x/drm/rgb.c       |  228 +++++++
 drivers/gpu/host1x/host1x_client.h |   25 +
 28 files changed, 4388 insertions(+), 4364 deletions(-)
 delete mode 100644 drivers/gpu/drm/tegra/Kconfig
 delete mode 100644 drivers/gpu/drm/tegra/Makefile
 delete mode 100644 drivers/gpu/drm/tegra/dc.c
 delete mode 100644 drivers/gpu/drm/tegra/dc.h
 delete mode 100644 drivers/gpu/drm/tegra/drm.c
 delete mode 100644 drivers/gpu/drm/tegra/drm.h
 delete mode 100644 drivers/gpu/drm/tegra/fb.c
 delete mode 100644 drivers/gpu/drm/tegra/hdmi.c
 delete mode 100644 drivers/gpu/drm/tegra/hdmi.h
 delete mode 100644 drivers/gpu/drm/tegra/host1x.c
 delete mode 100644 drivers/gpu/drm/tegra/output.c
 delete mode 100644 drivers/gpu/drm/tegra/rgb.c
 create mode 100644 drivers/gpu/host1x/drm/Kconfig
 create mode 100644 drivers/gpu/host1x/drm/dc.c
 create mode 100644 drivers/gpu/host1x/drm/dc.h
 create mode 100644 drivers/gpu/host1x/drm/drm.c
 create mode 100644 drivers/gpu/host1x/drm/drm.h
 create mode 100644 drivers/gpu/host1x/drm/fb.c
 create mode 100644 drivers/gpu/host1x/drm/hdmi.c
 create mode 100644 drivers/gpu/host1x/drm/hdmi.h
 create mode 100644 drivers/gpu/host1x/drm/host1x.c
 create mode 100644 drivers/gpu/host1x/drm/output.c
 create mode 100644 drivers/gpu/host1x/drm/rgb.c
 create mode 100644 drivers/gpu/host1x/host1x_client.h

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 983201b..18321b68b 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -210,5 +210,3 @@ source "drivers/gpu/drm/mgag200/Kconfig"
 source "drivers/gpu/drm/cirrus/Kconfig"
 
 source "drivers/gpu/drm/shmobile/Kconfig"
-
-source "drivers/gpu/drm/tegra/Kconfig"
diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
index 6f58c81..f54c72a 100644
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -49,5 +49,4 @@ obj-$(CONFIG_DRM_GMA500) += gma500/
 obj-$(CONFIG_DRM_UDL) += udl/
 obj-$(CONFIG_DRM_AST) += ast/
 obj-$(CONFIG_DRM_SHMOBILE) +=shmobile/
-obj-$(CONFIG_DRM_TEGRA) += tegra/
 obj-y			+= i2c/
diff --git a/drivers/gpu/drm/tegra/Kconfig b/drivers/gpu/drm/tegra/Kconfig
deleted file mode 100644
index be1daf7..0000000
--- a/drivers/gpu/drm/tegra/Kconfig
+++ /dev/null
@@ -1,23 +0,0 @@
-config DRM_TEGRA
-	tristate "NVIDIA Tegra DRM"
-	depends on DRM && OF && ARCH_TEGRA
-	select DRM_KMS_HELPER
-	select DRM_GEM_CMA_HELPER
-	select DRM_KMS_CMA_HELPER
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  Choose this option if you have an NVIDIA Tegra SoC.
-
-	  To compile this driver as a module, choose M here: the module
-	  will be called tegra-drm.
-
-if DRM_TEGRA
-
-config DRM_TEGRA_DEBUG
-	bool "NVIDIA Tegra DRM debug support"
-	help
-	  Say yes here to enable debugging support.
-
-endif
diff --git a/drivers/gpu/drm/tegra/Makefile b/drivers/gpu/drm/tegra/Makefile
deleted file mode 100644
index 80f73d1..0000000
--- a/drivers/gpu/drm/tegra/Makefile
+++ /dev/null
@@ -1,7 +0,0 @@
-ccflags-y := -Iinclude/drm
-ccflags-$(CONFIG_DRM_TEGRA_DEBUG) += -DDEBUG
-
-tegra-drm-y := drm.o fb.o dc.o host1x.o
-tegra-drm-y += output.o rgb.o hdmi.o
-
-obj-$(CONFIG_DRM_TEGRA) += tegra-drm.o
diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
deleted file mode 100644
index 656b2e3..0000000
--- a/drivers/gpu/drm/tegra/dc.c
+++ /dev/null
@@ -1,833 +0,0 @@
-/*
- * Copyright (C) 2012 Avionic Design GmbH
- * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/clk.h>
-#include <linux/debugfs.h>
-#include <linux/module.h>
-#include <linux/of.h>
-#include <linux/platform_device.h>
-
-#include <mach/clk.h>
-
-#include "drm.h"
-#include "dc.h"
-
-struct tegra_dc_window {
-	fixed20_12 x;
-	fixed20_12 y;
-	fixed20_12 w;
-	fixed20_12 h;
-	unsigned int outx;
-	unsigned int outy;
-	unsigned int outw;
-	unsigned int outh;
-	unsigned int stride;
-	unsigned int fmt;
-};
-
-static const struct drm_crtc_funcs tegra_crtc_funcs = {
-	.set_config = drm_crtc_helper_set_config,
-	.destroy = drm_crtc_cleanup,
-};
-
-static void tegra_crtc_dpms(struct drm_crtc *crtc, int mode)
-{
-}
-
-static bool tegra_crtc_mode_fixup(struct drm_crtc *crtc,
-				  const struct drm_display_mode *mode,
-				  struct drm_display_mode *adjusted)
-{
-	return true;
-}
-
-static inline u32 compute_dda_inc(fixed20_12 inf, unsigned int out, bool v,
-				  unsigned int bpp)
-{
-	fixed20_12 outf = dfixed_init(out);
-	u32 dda_inc;
-	int max;
-
-	if (v)
-		max = 15;
-	else {
-		switch (bpp) {
-		case 2:
-			max = 8;
-			break;
-
-		default:
-			WARN_ON_ONCE(1);
-			/* fallthrough */
-		case 4:
-			max = 4;
-			break;
-		}
-	}
-
-	outf.full = max_t(u32, outf.full - dfixed_const(1), dfixed_const(1));
-	inf.full -= dfixed_const(1);
-
-	dda_inc = dfixed_div(inf, outf);
-	dda_inc = min_t(u32, dda_inc, dfixed_const(max));
-
-	return dda_inc;
-}
-
-static inline u32 compute_initial_dda(fixed20_12 in)
-{
-	return dfixed_frac(in);
-}
-
-static int tegra_dc_set_timings(struct tegra_dc *dc,
-				struct drm_display_mode *mode)
-{
-	/* TODO: For HDMI compliance, h & v ref_to_sync should be set to 1 */
-	unsigned int h_ref_to_sync = 0;
-	unsigned int v_ref_to_sync = 0;
-	unsigned long value;
-
-	tegra_dc_writel(dc, 0x0, DC_DISP_DISP_TIMING_OPTIONS);
-
-	value = (v_ref_to_sync << 16) | h_ref_to_sync;
-	tegra_dc_writel(dc, value, DC_DISP_REF_TO_SYNC);
-
-	value = ((mode->vsync_end - mode->vsync_start) << 16) |
-		((mode->hsync_end - mode->hsync_start) <<  0);
-	tegra_dc_writel(dc, value, DC_DISP_SYNC_WIDTH);
-
-	value = ((mode->vtotal - mode->vsync_end) << 16) |
-		((mode->htotal - mode->hsync_end) <<  0);
-	tegra_dc_writel(dc, value, DC_DISP_BACK_PORCH);
-
-	value = ((mode->vsync_start - mode->vdisplay) << 16) |
-		((mode->hsync_start - mode->hdisplay) <<  0);
-	tegra_dc_writel(dc, value, DC_DISP_FRONT_PORCH);
-
-	value = (mode->vdisplay << 16) | mode->hdisplay;
-	tegra_dc_writel(dc, value, DC_DISP_ACTIVE);
-
-	return 0;
-}
-
-static int tegra_crtc_setup_clk(struct drm_crtc *crtc,
-				struct drm_display_mode *mode,
-				unsigned long *div)
-{
-	unsigned long pclk = mode->clock * 1000, rate;
-	struct tegra_dc *dc = to_tegra_dc(crtc);
-	struct tegra_output *output = NULL;
-	struct drm_encoder *encoder;
-	long err;
-
-	list_for_each_entry(encoder, &crtc->dev->mode_config.encoder_list, head)
-		if (encoder->crtc == crtc) {
-			output = encoder_to_output(encoder);
-			break;
-		}
-
-	if (!output)
-		return -ENODEV;
-
-	/*
-	 * This assumes that the display controller will divide its parent
-	 * clock by 2 to generate the pixel clock.
-	 */
-	err = tegra_output_setup_clock(output, dc->clk, pclk * 2);
-	if (err < 0) {
-		dev_err(dc->dev, "failed to setup clock: %ld\n", err);
-		return err;
-	}
-
-	rate = clk_get_rate(dc->clk);
-	*div = (rate * 2 / pclk) - 2;
-
-	DRM_DEBUG_KMS("rate: %lu, div: %lu\n", rate, *div);
-
-	return 0;
-}
-
-static int tegra_crtc_mode_set(struct drm_crtc *crtc,
-			       struct drm_display_mode *mode,
-			       struct drm_display_mode *adjusted,
-			       int x, int y, struct drm_framebuffer *old_fb)
-{
-	struct tegra_framebuffer *fb = to_tegra_fb(crtc->fb);
-	struct tegra_dc *dc = to_tegra_dc(crtc);
-	unsigned int h_dda, v_dda, bpp;
-	struct tegra_dc_window win;
-	unsigned long div, value;
-	int err;
-
-	err = tegra_crtc_setup_clk(crtc, mode, &div);
-	if (err) {
-		dev_err(dc->dev, "failed to setup clock for CRTC: %d\n", err);
-		return err;
-	}
-
-	/* program display mode */
-	tegra_dc_set_timings(dc, mode);
-
-	value = DE_SELECT_ACTIVE | DE_CONTROL_NORMAL;
-	tegra_dc_writel(dc, value, DC_DISP_DATA_ENABLE_OPTIONS);
-
-	value = tegra_dc_readl(dc, DC_COM_PIN_OUTPUT_POLARITY(1));
-	value &= ~LVS_OUTPUT_POLARITY_LOW;
-	value &= ~LHS_OUTPUT_POLARITY_LOW;
-	tegra_dc_writel(dc, value, DC_COM_PIN_OUTPUT_POLARITY(1));
-
-	value = DISP_DATA_FORMAT_DF1P1C | DISP_ALIGNMENT_MSB |
-		DISP_ORDER_RED_BLUE;
-	tegra_dc_writel(dc, value, DC_DISP_DISP_INTERFACE_CONTROL);
-
-	tegra_dc_writel(dc, 0x00010001, DC_DISP_SHIFT_CLOCK_OPTIONS);
-
-	value = SHIFT_CLK_DIVIDER(div) | PIXEL_CLK_DIVIDER_PCD1;
-	tegra_dc_writel(dc, value, DC_DISP_DISP_CLOCK_CONTROL);
-
-	/* setup window parameters */
-	memset(&win, 0, sizeof(win));
-	win.x.full = dfixed_const(0);
-	win.y.full = dfixed_const(0);
-	win.w.full = dfixed_const(mode->hdisplay);
-	win.h.full = dfixed_const(mode->vdisplay);
-	win.outx = 0;
-	win.outy = 0;
-	win.outw = mode->hdisplay;
-	win.outh = mode->vdisplay;
-
-	switch (crtc->fb->pixel_format) {
-	case DRM_FORMAT_XRGB8888:
-		win.fmt = WIN_COLOR_DEPTH_B8G8R8A8;
-		break;
-
-	case DRM_FORMAT_RGB565:
-		win.fmt = WIN_COLOR_DEPTH_B5G6R5;
-		break;
-
-	default:
-		win.fmt = WIN_COLOR_DEPTH_B8G8R8A8;
-		WARN_ON(1);
-		break;
-	}
-
-	bpp = crtc->fb->bits_per_pixel / 8;
-	win.stride = crtc->fb->pitches[0];
-
-	/* program window registers */
-	value = WINDOW_A_SELECT;
-	tegra_dc_writel(dc, value, DC_CMD_DISPLAY_WINDOW_HEADER);
-
-	tegra_dc_writel(dc, win.fmt, DC_WIN_COLOR_DEPTH);
-	tegra_dc_writel(dc, 0, DC_WIN_BYTE_SWAP);
-
-	value = V_POSITION(win.outy) | H_POSITION(win.outx);
-	tegra_dc_writel(dc, value, DC_WIN_POSITION);
-
-	value = V_SIZE(win.outh) | H_SIZE(win.outw);
-	tegra_dc_writel(dc, value, DC_WIN_SIZE);
-
-	value = V_PRESCALED_SIZE(dfixed_trunc(win.h)) |
-		H_PRESCALED_SIZE(dfixed_trunc(win.w) * bpp);
-	tegra_dc_writel(dc, value, DC_WIN_PRESCALED_SIZE);
-
-	h_dda = compute_dda_inc(win.w, win.outw, false, bpp);
-	v_dda = compute_dda_inc(win.h, win.outh, true, bpp);
-
-	value = V_DDA_INC(v_dda) | H_DDA_INC(h_dda);
-	tegra_dc_writel(dc, value, DC_WIN_DDA_INC);
-
-	h_dda = compute_initial_dda(win.x);
-	v_dda = compute_initial_dda(win.y);
-
-	tegra_dc_writel(dc, h_dda, DC_WIN_H_INITIAL_DDA);
-	tegra_dc_writel(dc, v_dda, DC_WIN_V_INITIAL_DDA);
-
-	tegra_dc_writel(dc, 0, DC_WIN_UV_BUF_STRIDE);
-	tegra_dc_writel(dc, 0, DC_WIN_BUF_STRIDE);
-
-	tegra_dc_writel(dc, fb->obj->paddr, DC_WINBUF_START_ADDR);
-	tegra_dc_writel(dc, win.stride, DC_WIN_LINE_STRIDE);
-	tegra_dc_writel(dc, dfixed_trunc(win.x) * bpp,
-			DC_WINBUF_ADDR_H_OFFSET);
-	tegra_dc_writel(dc, dfixed_trunc(win.y), DC_WINBUF_ADDR_V_OFFSET);
-
-	value = WIN_ENABLE;
-
-	if (bpp < 24)
-		value |= COLOR_EXPAND;
-
-	tegra_dc_writel(dc, value, DC_WIN_WIN_OPTIONS);
-
-	tegra_dc_writel(dc, 0xff00, DC_WIN_BLEND_NOKEY);
-	tegra_dc_writel(dc, 0xff00, DC_WIN_BLEND_1WIN);
-
-	return 0;
-}
-
-static void tegra_crtc_prepare(struct drm_crtc *crtc)
-{
-	struct tegra_dc *dc = to_tegra_dc(crtc);
-	unsigned int syncpt;
-	unsigned long value;
-
-	/* hardware initialization */
-	tegra_periph_reset_deassert(dc->clk);
-	usleep_range(10000, 20000);
-
-	if (dc->pipe)
-		syncpt = SYNCPT_VBLANK1;
-	else
-		syncpt = SYNCPT_VBLANK0;
-
-	/* initialize display controller */
-	tegra_dc_writel(dc, 0x00000100, DC_CMD_GENERAL_INCR_SYNCPT_CNTRL);
-	tegra_dc_writel(dc, 0x100 | syncpt, DC_CMD_CONT_SYNCPT_VSYNC);
-
-	value = WIN_A_UF_INT | WIN_B_UF_INT | WIN_C_UF_INT | WIN_A_OF_INT;
-	tegra_dc_writel(dc, value, DC_CMD_INT_TYPE);
-
-	value = WIN_A_UF_INT | WIN_B_UF_INT | WIN_C_UF_INT |
-		WIN_A_OF_INT | WIN_B_OF_INT | WIN_C_OF_INT;
-	tegra_dc_writel(dc, value, DC_CMD_INT_POLARITY);
-
-	value = PW0_ENABLE | PW1_ENABLE | PW2_ENABLE | PW3_ENABLE |
-		PW4_ENABLE | PM0_ENABLE | PM1_ENABLE;
-	tegra_dc_writel(dc, value, DC_CMD_DISPLAY_POWER_CONTROL);
-
-	value = tegra_dc_readl(dc, DC_CMD_DISPLAY_COMMAND);
-	value |= DISP_CTRL_MODE_C_DISPLAY;
-	tegra_dc_writel(dc, value, DC_CMD_DISPLAY_COMMAND);
-
-	/* initialize timer */
-	value = CURSOR_THRESHOLD(0) | WINDOW_A_THRESHOLD(0x20) |
-		WINDOW_B_THRESHOLD(0x20) | WINDOW_C_THRESHOLD(0x20);
-	tegra_dc_writel(dc, value, DC_DISP_DISP_MEM_HIGH_PRIORITY);
-
-	value = CURSOR_THRESHOLD(0) | WINDOW_A_THRESHOLD(1) |
-		WINDOW_B_THRESHOLD(1) | WINDOW_C_THRESHOLD(1);
-	tegra_dc_writel(dc, value, DC_DISP_DISP_MEM_HIGH_PRIORITY_TIMER);
-
-	value = VBLANK_INT | WIN_A_UF_INT | WIN_B_UF_INT | WIN_C_UF_INT;
-	tegra_dc_writel(dc, value, DC_CMD_INT_MASK);
-
-	value = VBLANK_INT | WIN_A_UF_INT | WIN_B_UF_INT | WIN_C_UF_INT;
-	tegra_dc_writel(dc, value, DC_CMD_INT_ENABLE);
-}
-
-static void tegra_crtc_commit(struct drm_crtc *crtc)
-{
-	struct tegra_dc *dc = to_tegra_dc(crtc);
-	unsigned long update_mask;
-	unsigned long value;
-
-	update_mask = GENERAL_ACT_REQ | WIN_A_ACT_REQ;
-
-	tegra_dc_writel(dc, update_mask << 8, DC_CMD_STATE_CONTROL);
-
-	value = tegra_dc_readl(dc, DC_CMD_INT_ENABLE);
-	value |= FRAME_END_INT;
-	tegra_dc_writel(dc, value, DC_CMD_INT_ENABLE);
-
-	value = tegra_dc_readl(dc, DC_CMD_INT_MASK);
-	value |= FRAME_END_INT;
-	tegra_dc_writel(dc, value, DC_CMD_INT_MASK);
-
-	tegra_dc_writel(dc, update_mask, DC_CMD_STATE_CONTROL);
-}
-
-static void tegra_crtc_load_lut(struct drm_crtc *crtc)
-{
-}
-
-static const struct drm_crtc_helper_funcs tegra_crtc_helper_funcs = {
-	.dpms = tegra_crtc_dpms,
-	.mode_fixup = tegra_crtc_mode_fixup,
-	.mode_set = tegra_crtc_mode_set,
-	.prepare = tegra_crtc_prepare,
-	.commit = tegra_crtc_commit,
-	.load_lut = tegra_crtc_load_lut,
-};
-
-static irqreturn_t tegra_drm_irq(int irq, void *data)
-{
-	struct tegra_dc *dc = data;
-	unsigned long status;
-
-	status = tegra_dc_readl(dc, DC_CMD_INT_STATUS);
-	tegra_dc_writel(dc, status, DC_CMD_INT_STATUS);
-
-	if (status & FRAME_END_INT) {
-		/*
-		dev_dbg(dc->dev, "%s(): frame end\n", __func__);
-		*/
-	}
-
-	if (status & VBLANK_INT) {
-		/*
-		dev_dbg(dc->dev, "%s(): vertical blank\n", __func__);
-		*/
-		drm_handle_vblank(dc->base.dev, dc->pipe);
-	}
-
-	if (status & (WIN_A_UF_INT | WIN_B_UF_INT | WIN_C_UF_INT)) {
-		/*
-		dev_dbg(dc->dev, "%s(): underflow\n", __func__);
-		*/
-	}
-
-	return IRQ_HANDLED;
-}
-
-static int tegra_dc_show_regs(struct seq_file *s, void *data)
-{
-	struct drm_info_node *node = s->private;
-	struct tegra_dc *dc = node->info_ent->data;
-
-#define DUMP_REG(name)						\
-	seq_printf(s, "%-40s %#05x %08lx\n", #name, name,	\
-		   tegra_dc_readl(dc, name))
-
-	DUMP_REG(DC_CMD_GENERAL_INCR_SYNCPT);
-	DUMP_REG(DC_CMD_GENERAL_INCR_SYNCPT_CNTRL);
-	DUMP_REG(DC_CMD_GENERAL_INCR_SYNCPT_ERROR);
-	DUMP_REG(DC_CMD_WIN_A_INCR_SYNCPT);
-	DUMP_REG(DC_CMD_WIN_A_INCR_SYNCPT_CNTRL);
-	DUMP_REG(DC_CMD_WIN_A_INCR_SYNCPT_ERROR);
-	DUMP_REG(DC_CMD_WIN_B_INCR_SYNCPT);
-	DUMP_REG(DC_CMD_WIN_B_INCR_SYNCPT_CNTRL);
-	DUMP_REG(DC_CMD_WIN_B_INCR_SYNCPT_ERROR);
-	DUMP_REG(DC_CMD_WIN_C_INCR_SYNCPT);
-	DUMP_REG(DC_CMD_WIN_C_INCR_SYNCPT_CNTRL);
-	DUMP_REG(DC_CMD_WIN_C_INCR_SYNCPT_ERROR);
-	DUMP_REG(DC_CMD_CONT_SYNCPT_VSYNC);
-	DUMP_REG(DC_CMD_DISPLAY_COMMAND_OPTION0);
-	DUMP_REG(DC_CMD_DISPLAY_COMMAND);
-	DUMP_REG(DC_CMD_SIGNAL_RAISE);
-	DUMP_REG(DC_CMD_DISPLAY_POWER_CONTROL);
-	DUMP_REG(DC_CMD_INT_STATUS);
-	DUMP_REG(DC_CMD_INT_MASK);
-	DUMP_REG(DC_CMD_INT_ENABLE);
-	DUMP_REG(DC_CMD_INT_TYPE);
-	DUMP_REG(DC_CMD_INT_POLARITY);
-	DUMP_REG(DC_CMD_SIGNAL_RAISE1);
-	DUMP_REG(DC_CMD_SIGNAL_RAISE2);
-	DUMP_REG(DC_CMD_SIGNAL_RAISE3);
-	DUMP_REG(DC_CMD_STATE_ACCESS);
-	DUMP_REG(DC_CMD_STATE_CONTROL);
-	DUMP_REG(DC_CMD_DISPLAY_WINDOW_HEADER);
-	DUMP_REG(DC_CMD_REG_ACT_CONTROL);
-	DUMP_REG(DC_COM_CRC_CONTROL);
-	DUMP_REG(DC_COM_CRC_CHECKSUM);
-	DUMP_REG(DC_COM_PIN_OUTPUT_ENABLE(0));
-	DUMP_REG(DC_COM_PIN_OUTPUT_ENABLE(1));
-	DUMP_REG(DC_COM_PIN_OUTPUT_ENABLE(2));
-	DUMP_REG(DC_COM_PIN_OUTPUT_ENABLE(3));
-	DUMP_REG(DC_COM_PIN_OUTPUT_POLARITY(0));
-	DUMP_REG(DC_COM_PIN_OUTPUT_POLARITY(1));
-	DUMP_REG(DC_COM_PIN_OUTPUT_POLARITY(2));
-	DUMP_REG(DC_COM_PIN_OUTPUT_POLARITY(3));
-	DUMP_REG(DC_COM_PIN_OUTPUT_DATA(0));
-	DUMP_REG(DC_COM_PIN_OUTPUT_DATA(1));
-	DUMP_REG(DC_COM_PIN_OUTPUT_DATA(2));
-	DUMP_REG(DC_COM_PIN_OUTPUT_DATA(3));
-	DUMP_REG(DC_COM_PIN_INPUT_ENABLE(0));
-	DUMP_REG(DC_COM_PIN_INPUT_ENABLE(1));
-	DUMP_REG(DC_COM_PIN_INPUT_ENABLE(2));
-	DUMP_REG(DC_COM_PIN_INPUT_ENABLE(3));
-	DUMP_REG(DC_COM_PIN_INPUT_DATA(0));
-	DUMP_REG(DC_COM_PIN_INPUT_DATA(1));
-	DUMP_REG(DC_COM_PIN_OUTPUT_SELECT(0));
-	DUMP_REG(DC_COM_PIN_OUTPUT_SELECT(1));
-	DUMP_REG(DC_COM_PIN_OUTPUT_SELECT(2));
-	DUMP_REG(DC_COM_PIN_OUTPUT_SELECT(3));
-	DUMP_REG(DC_COM_PIN_OUTPUT_SELECT(4));
-	DUMP_REG(DC_COM_PIN_OUTPUT_SELECT(5));
-	DUMP_REG(DC_COM_PIN_OUTPUT_SELECT(6));
-	DUMP_REG(DC_COM_PIN_MISC_CONTROL);
-	DUMP_REG(DC_COM_PIN_PM0_CONTROL);
-	DUMP_REG(DC_COM_PIN_PM0_DUTY_CYCLE);
-	DUMP_REG(DC_COM_PIN_PM1_CONTROL);
-	DUMP_REG(DC_COM_PIN_PM1_DUTY_CYCLE);
-	DUMP_REG(DC_COM_SPI_CONTROL);
-	DUMP_REG(DC_COM_SPI_START_BYTE);
-	DUMP_REG(DC_COM_HSPI_WRITE_DATA_AB);
-	DUMP_REG(DC_COM_HSPI_WRITE_DATA_CD);
-	DUMP_REG(DC_COM_HSPI_CS_DC);
-	DUMP_REG(DC_COM_SCRATCH_REGISTER_A);
-	DUMP_REG(DC_COM_SCRATCH_REGISTER_B);
-	DUMP_REG(DC_COM_GPIO_CTRL);
-	DUMP_REG(DC_COM_GPIO_DEBOUNCE_COUNTER);
-	DUMP_REG(DC_COM_CRC_CHECKSUM_LATCHED);
-	DUMP_REG(DC_DISP_DISP_SIGNAL_OPTIONS0);
-	DUMP_REG(DC_DISP_DISP_SIGNAL_OPTIONS1);
-	DUMP_REG(DC_DISP_DISP_WIN_OPTIONS);
-	DUMP_REG(DC_DISP_DISP_MEM_HIGH_PRIORITY);
-	DUMP_REG(DC_DISP_DISP_MEM_HIGH_PRIORITY_TIMER);
-	DUMP_REG(DC_DISP_DISP_TIMING_OPTIONS);
-	DUMP_REG(DC_DISP_REF_TO_SYNC);
-	DUMP_REG(DC_DISP_SYNC_WIDTH);
-	DUMP_REG(DC_DISP_BACK_PORCH);
-	DUMP_REG(DC_DISP_ACTIVE);
-	DUMP_REG(DC_DISP_FRONT_PORCH);
-	DUMP_REG(DC_DISP_H_PULSE0_CONTROL);
-	DUMP_REG(DC_DISP_H_PULSE0_POSITION_A);
-	DUMP_REG(DC_DISP_H_PULSE0_POSITION_B);
-	DUMP_REG(DC_DISP_H_PULSE0_POSITION_C);
-	DUMP_REG(DC_DISP_H_PULSE0_POSITION_D);
-	DUMP_REG(DC_DISP_H_PULSE1_CONTROL);
-	DUMP_REG(DC_DISP_H_PULSE1_POSITION_A);
-	DUMP_REG(DC_DISP_H_PULSE1_POSITION_B);
-	DUMP_REG(DC_DISP_H_PULSE1_POSITION_C);
-	DUMP_REG(DC_DISP_H_PULSE1_POSITION_D);
-	DUMP_REG(DC_DISP_H_PULSE2_CONTROL);
-	DUMP_REG(DC_DISP_H_PULSE2_POSITION_A);
-	DUMP_REG(DC_DISP_H_PULSE2_POSITION_B);
-	DUMP_REG(DC_DISP_H_PULSE2_POSITION_C);
-	DUMP_REG(DC_DISP_H_PULSE2_POSITION_D);
-	DUMP_REG(DC_DISP_V_PULSE0_CONTROL);
-	DUMP_REG(DC_DISP_V_PULSE0_POSITION_A);
-	DUMP_REG(DC_DISP_V_PULSE0_POSITION_B);
-	DUMP_REG(DC_DISP_V_PULSE0_POSITION_C);
-	DUMP_REG(DC_DISP_V_PULSE1_CONTROL);
-	DUMP_REG(DC_DISP_V_PULSE1_POSITION_A);
-	DUMP_REG(DC_DISP_V_PULSE1_POSITION_B);
-	DUMP_REG(DC_DISP_V_PULSE1_POSITION_C);
-	DUMP_REG(DC_DISP_V_PULSE2_CONTROL);
-	DUMP_REG(DC_DISP_V_PULSE2_POSITION_A);
-	DUMP_REG(DC_DISP_V_PULSE3_CONTROL);
-	DUMP_REG(DC_DISP_V_PULSE3_POSITION_A);
-	DUMP_REG(DC_DISP_M0_CONTROL);
-	DUMP_REG(DC_DISP_M1_CONTROL);
-	DUMP_REG(DC_DISP_DI_CONTROL);
-	DUMP_REG(DC_DISP_PP_CONTROL);
-	DUMP_REG(DC_DISP_PP_SELECT_A);
-	DUMP_REG(DC_DISP_PP_SELECT_B);
-	DUMP_REG(DC_DISP_PP_SELECT_C);
-	DUMP_REG(DC_DISP_PP_SELECT_D);
-	DUMP_REG(DC_DISP_DISP_CLOCK_CONTROL);
-	DUMP_REG(DC_DISP_DISP_INTERFACE_CONTROL);
-	DUMP_REG(DC_DISP_DISP_COLOR_CONTROL);
-	DUMP_REG(DC_DISP_SHIFT_CLOCK_OPTIONS);
-	DUMP_REG(DC_DISP_DATA_ENABLE_OPTIONS);
-	DUMP_REG(DC_DISP_SERIAL_INTERFACE_OPTIONS);
-	DUMP_REG(DC_DISP_LCD_SPI_OPTIONS);
-	DUMP_REG(DC_DISP_BORDER_COLOR);
-	DUMP_REG(DC_DISP_COLOR_KEY0_LOWER);
-	DUMP_REG(DC_DISP_COLOR_KEY0_UPPER);
-	DUMP_REG(DC_DISP_COLOR_KEY1_LOWER);
-	DUMP_REG(DC_DISP_COLOR_KEY1_UPPER);
-	DUMP_REG(DC_DISP_CURSOR_FOREGROUND);
-	DUMP_REG(DC_DISP_CURSOR_BACKGROUND);
-	DUMP_REG(DC_DISP_CURSOR_START_ADDR);
-	DUMP_REG(DC_DISP_CURSOR_START_ADDR_NS);
-	DUMP_REG(DC_DISP_CURSOR_POSITION);
-	DUMP_REG(DC_DISP_CURSOR_POSITION_NS);
-	DUMP_REG(DC_DISP_INIT_SEQ_CONTROL);
-	DUMP_REG(DC_DISP_SPI_INIT_SEQ_DATA_A);
-	DUMP_REG(DC_DISP_SPI_INIT_SEQ_DATA_B);
-	DUMP_REG(DC_DISP_SPI_INIT_SEQ_DATA_C);
-	DUMP_REG(DC_DISP_SPI_INIT_SEQ_DATA_D);
-	DUMP_REG(DC_DISP_DC_MCCIF_FIFOCTRL);
-	DUMP_REG(DC_DISP_MCCIF_DISPLAY0A_HYST);
-	DUMP_REG(DC_DISP_MCCIF_DISPLAY0B_HYST);
-	DUMP_REG(DC_DISP_MCCIF_DISPLAY1A_HYST);
-	DUMP_REG(DC_DISP_MCCIF_DISPLAY1B_HYST);
-	DUMP_REG(DC_DISP_DAC_CRT_CTRL);
-	DUMP_REG(DC_DISP_DISP_MISC_CONTROL);
-	DUMP_REG(DC_DISP_SD_CONTROL);
-	DUMP_REG(DC_DISP_SD_CSC_COEFF);
-	DUMP_REG(DC_DISP_SD_LUT(0));
-	DUMP_REG(DC_DISP_SD_LUT(1));
-	DUMP_REG(DC_DISP_SD_LUT(2));
-	DUMP_REG(DC_DISP_SD_LUT(3));
-	DUMP_REG(DC_DISP_SD_LUT(4));
-	DUMP_REG(DC_DISP_SD_LUT(5));
-	DUMP_REG(DC_DISP_SD_LUT(6));
-	DUMP_REG(DC_DISP_SD_LUT(7));
-	DUMP_REG(DC_DISP_SD_LUT(8));
-	DUMP_REG(DC_DISP_SD_FLICKER_CONTROL);
-	DUMP_REG(DC_DISP_DC_PIXEL_COUNT);
-	DUMP_REG(DC_DISP_SD_HISTOGRAM(0));
-	DUMP_REG(DC_DISP_SD_HISTOGRAM(1));
-	DUMP_REG(DC_DISP_SD_HISTOGRAM(2));
-	DUMP_REG(DC_DISP_SD_HISTOGRAM(3));
-	DUMP_REG(DC_DISP_SD_HISTOGRAM(4));
-	DUMP_REG(DC_DISP_SD_HISTOGRAM(5));
-	DUMP_REG(DC_DISP_SD_HISTOGRAM(6));
-	DUMP_REG(DC_DISP_SD_HISTOGRAM(7));
-	DUMP_REG(DC_DISP_SD_BL_TF(0));
-	DUMP_REG(DC_DISP_SD_BL_TF(1));
-	DUMP_REG(DC_DISP_SD_BL_TF(2));
-	DUMP_REG(DC_DISP_SD_BL_TF(3));
-	DUMP_REG(DC_DISP_SD_BL_CONTROL);
-	DUMP_REG(DC_DISP_SD_HW_K_VALUES);
-	DUMP_REG(DC_DISP_SD_MAN_K_VALUES);
-	DUMP_REG(DC_WIN_WIN_OPTIONS);
-	DUMP_REG(DC_WIN_BYTE_SWAP);
-	DUMP_REG(DC_WIN_BUFFER_CONTROL);
-	DUMP_REG(DC_WIN_COLOR_DEPTH);
-	DUMP_REG(DC_WIN_POSITION);
-	DUMP_REG(DC_WIN_SIZE);
-	DUMP_REG(DC_WIN_PRESCALED_SIZE);
-	DUMP_REG(DC_WIN_H_INITIAL_DDA);
-	DUMP_REG(DC_WIN_V_INITIAL_DDA);
-	DUMP_REG(DC_WIN_DDA_INC);
-	DUMP_REG(DC_WIN_LINE_STRIDE);
-	DUMP_REG(DC_WIN_BUF_STRIDE);
-	DUMP_REG(DC_WIN_UV_BUF_STRIDE);
-	DUMP_REG(DC_WIN_BUFFER_ADDR_MODE);
-	DUMP_REG(DC_WIN_DV_CONTROL);
-	DUMP_REG(DC_WIN_BLEND_NOKEY);
-	DUMP_REG(DC_WIN_BLEND_1WIN);
-	DUMP_REG(DC_WIN_BLEND_2WIN_X);
-	DUMP_REG(DC_WIN_BLEND_2WIN_Y);
-	DUMP_REG(DC_WIN_BLEND32WIN_XY);
-	DUMP_REG(DC_WIN_HP_FETCH_CONTROL);
-	DUMP_REG(DC_WINBUF_START_ADDR);
-	DUMP_REG(DC_WINBUF_START_ADDR_NS);
-	DUMP_REG(DC_WINBUF_START_ADDR_U);
-	DUMP_REG(DC_WINBUF_START_ADDR_U_NS);
-	DUMP_REG(DC_WINBUF_START_ADDR_V);
-	DUMP_REG(DC_WINBUF_START_ADDR_V_NS);
-	DUMP_REG(DC_WINBUF_ADDR_H_OFFSET);
-	DUMP_REG(DC_WINBUF_ADDR_H_OFFSET_NS);
-	DUMP_REG(DC_WINBUF_ADDR_V_OFFSET);
-	DUMP_REG(DC_WINBUF_ADDR_V_OFFSET_NS);
-	DUMP_REG(DC_WINBUF_UFLOW_STATUS);
-	DUMP_REG(DC_WINBUF_AD_UFLOW_STATUS);
-	DUMP_REG(DC_WINBUF_BD_UFLOW_STATUS);
-	DUMP_REG(DC_WINBUF_CD_UFLOW_STATUS);
-
-#undef DUMP_REG
-
-	return 0;
-}
-
-static struct drm_info_list debugfs_files[] = {
-	{ "regs", tegra_dc_show_regs, 0, NULL },
-};
-
-static int tegra_dc_debugfs_init(struct tegra_dc *dc, struct drm_minor *minor)
-{
-	unsigned int i;
-	char *name;
-	int err;
-
-	name = kasprintf(GFP_KERNEL, "dc.%d", dc->pipe);
-	dc->debugfs = debugfs_create_dir(name, minor->debugfs_root);
-	kfree(name);
-
-	if (!dc->debugfs)
-		return -ENOMEM;
-
-	dc->debugfs_files = kmemdup(debugfs_files, sizeof(debugfs_files),
-				    GFP_KERNEL);
-	if (!dc->debugfs_files) {
-		err = -ENOMEM;
-		goto remove;
-	}
-
-	for (i = 0; i < ARRAY_SIZE(debugfs_files); i++)
-		dc->debugfs_files[i].data = dc;
-
-	err = drm_debugfs_create_files(dc->debugfs_files,
-				       ARRAY_SIZE(debugfs_files),
-				       dc->debugfs, minor);
-	if (err < 0)
-		goto free;
-
-	dc->minor = minor;
-
-	return 0;
-
-free:
-	kfree(dc->debugfs_files);
-	dc->debugfs_files = NULL;
-remove:
-	debugfs_remove(dc->debugfs);
-	dc->debugfs = NULL;
-
-	return err;
-}
-
-static int tegra_dc_debugfs_exit(struct tegra_dc *dc)
-{
-	drm_debugfs_remove_files(dc->debugfs_files, ARRAY_SIZE(debugfs_files),
-				 dc->minor);
-	dc->minor = NULL;
-
-	kfree(dc->debugfs_files);
-	dc->debugfs_files = NULL;
-
-	debugfs_remove(dc->debugfs);
-	dc->debugfs = NULL;
-
-	return 0;
-}
-
-static int tegra_dc_drm_init(struct host1x_client *client,
-			     struct drm_device *drm)
-{
-	struct tegra_dc *dc = host1x_client_to_dc(client);
-	int err;
-
-	dc->pipe = drm->mode_config.num_crtc;
-
-	drm_crtc_init(drm, &dc->base, &tegra_crtc_funcs);
-	drm_mode_crtc_set_gamma_size(&dc->base, 256);
-	drm_crtc_helper_add(&dc->base, &tegra_crtc_helper_funcs);
-
-	err = tegra_dc_rgb_init(drm, dc);
-	if (err < 0 && err != -ENODEV) {
-		dev_err(dc->dev, "failed to initialize RGB output: %d\n", err);
-		return err;
-	}
-
-	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
-		err = tegra_dc_debugfs_init(dc, drm->primary);
-		if (err < 0)
-			dev_err(dc->dev, "debugfs setup failed: %d\n", err);
-	}
-
-	err = devm_request_irq(dc->dev, dc->irq, tegra_drm_irq, 0,
-			       dev_name(dc->dev), dc);
-	if (err < 0) {
-		dev_err(dc->dev, "failed to request IRQ#%u: %d\n", dc->irq,
-			err);
-		return err;
-	}
-
-	return 0;
-}
-
-static int tegra_dc_drm_exit(struct host1x_client *client)
-{
-	struct tegra_dc *dc = host1x_client_to_dc(client);
-	int err;
-
-	devm_free_irq(dc->dev, dc->irq, dc);
-
-	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
-		err = tegra_dc_debugfs_exit(dc);
-		if (err < 0)
-			dev_err(dc->dev, "debugfs cleanup failed: %d\n", err);
-	}
-
-	err = tegra_dc_rgb_exit(dc);
-	if (err) {
-		dev_err(dc->dev, "failed to shutdown RGB output: %d\n", err);
-		return err;
-	}
-
-	return 0;
-}
-
-static const struct host1x_client_ops dc_client_ops = {
-	.drm_init = tegra_dc_drm_init,
-	.drm_exit = tegra_dc_drm_exit,
-};
-
-static int tegra_dc_probe(struct platform_device *pdev)
-{
-	struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
-	struct resource *regs;
-	struct tegra_dc *dc;
-	int err;
-
-	dc = devm_kzalloc(&pdev->dev, sizeof(*dc), GFP_KERNEL);
-	if (!dc)
-		return -ENOMEM;
-
-	INIT_LIST_HEAD(&dc->list);
-	dc->dev = &pdev->dev;
-
-	dc->clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(dc->clk)) {
-		dev_err(&pdev->dev, "failed to get clock\n");
-		return PTR_ERR(dc->clk);
-	}
-
-	err = clk_prepare_enable(dc->clk);
-	if (err < 0)
-		return err;
-
-	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!regs) {
-		dev_err(&pdev->dev, "failed to get registers\n");
-		return -ENXIO;
-	}
-
-	dc->regs = devm_request_and_ioremap(&pdev->dev, regs);
-	if (!dc->regs) {
-		dev_err(&pdev->dev, "failed to remap registers\n");
-		return -ENXIO;
-	}
-
-	dc->irq = platform_get_irq(pdev, 0);
-	if (dc->irq < 0) {
-		dev_err(&pdev->dev, "failed to get IRQ\n");
-		return -ENXIO;
-	}
-
-	INIT_LIST_HEAD(&dc->client.list);
-	dc->client.ops = &dc_client_ops;
-	dc->client.dev = &pdev->dev;
-
-	err = tegra_dc_rgb_probe(dc);
-	if (err < 0 && err != -ENODEV) {
-		dev_err(&pdev->dev, "failed to probe RGB output: %d\n", err);
-		return err;
-	}
-
-	err = host1x_register_client(host1x, &dc->client);
-	if (err < 0) {
-		dev_err(&pdev->dev, "failed to register host1x client: %d\n",
-			err);
-		return err;
-	}
-
-	platform_set_drvdata(pdev, dc);
-
-	return 0;
-}
-
-static int tegra_dc_remove(struct platform_device *pdev)
-{
-	struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
-	struct tegra_dc *dc = platform_get_drvdata(pdev);
-	int err;
-
-	err = host1x_unregister_client(host1x, &dc->client);
-	if (err < 0) {
-		dev_err(&pdev->dev, "failed to unregister host1x client: %d\n",
-			err);
-		return err;
-	}
-
-	clk_disable_unprepare(dc->clk);
-
-	return 0;
-}
-
-static struct of_device_id tegra_dc_of_match[] = {
-	{ .compatible = "nvidia,tegra30-dc", },
-	{ .compatible = "nvidia,tegra20-dc", },
-	{ },
-};
-
-struct platform_driver tegra_dc_driver = {
-	.driver = {
-		.name = "tegra-dc",
-		.owner = THIS_MODULE,
-		.of_match_table = tegra_dc_of_match,
-	},
-	.probe = tegra_dc_probe,
-	.remove = tegra_dc_remove,
-};
diff --git a/drivers/gpu/drm/tegra/dc.h b/drivers/gpu/drm/tegra/dc.h
deleted file mode 100644
index 99977b5..0000000
--- a/drivers/gpu/drm/tegra/dc.h
+++ /dev/null
@@ -1,388 +0,0 @@
-/*
- * Copyright (C) 2012 Avionic Design GmbH
- * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef TEGRA_DC_H
-#define TEGRA_DC_H 1
-
-#define DC_CMD_GENERAL_INCR_SYNCPT		0x000
-#define DC_CMD_GENERAL_INCR_SYNCPT_CNTRL	0x001
-#define DC_CMD_GENERAL_INCR_SYNCPT_ERROR	0x002
-#define DC_CMD_WIN_A_INCR_SYNCPT		0x008
-#define DC_CMD_WIN_A_INCR_SYNCPT_CNTRL		0x009
-#define DC_CMD_WIN_A_INCR_SYNCPT_ERROR		0x00a
-#define DC_CMD_WIN_B_INCR_SYNCPT		0x010
-#define DC_CMD_WIN_B_INCR_SYNCPT_CNTRL		0x011
-#define DC_CMD_WIN_B_INCR_SYNCPT_ERROR		0x012
-#define DC_CMD_WIN_C_INCR_SYNCPT		0x018
-#define DC_CMD_WIN_C_INCR_SYNCPT_CNTRL		0x019
-#define DC_CMD_WIN_C_INCR_SYNCPT_ERROR		0x01a
-#define DC_CMD_CONT_SYNCPT_VSYNC		0x028
-#define DC_CMD_DISPLAY_COMMAND_OPTION0		0x031
-#define DC_CMD_DISPLAY_COMMAND			0x032
-#define DISP_CTRL_MODE_STOP (0 << 5)
-#define DISP_CTRL_MODE_C_DISPLAY (1 << 5)
-#define DISP_CTRL_MODE_NC_DISPLAY (2 << 5)
-#define DC_CMD_SIGNAL_RAISE			0x033
-#define DC_CMD_DISPLAY_POWER_CONTROL		0x036
-#define PW0_ENABLE (1 <<  0)
-#define PW1_ENABLE (1 <<  2)
-#define PW2_ENABLE (1 <<  4)
-#define PW3_ENABLE (1 <<  6)
-#define PW4_ENABLE (1 <<  8)
-#define PM0_ENABLE (1 << 16)
-#define PM1_ENABLE (1 << 18)
-
-#define DC_CMD_INT_STATUS			0x037
-#define DC_CMD_INT_MASK				0x038
-#define DC_CMD_INT_ENABLE			0x039
-#define DC_CMD_INT_TYPE				0x03a
-#define DC_CMD_INT_POLARITY			0x03b
-#define CTXSW_INT     (1 << 0)
-#define FRAME_END_INT (1 << 1)
-#define VBLANK_INT    (1 << 2)
-#define WIN_A_UF_INT  (1 << 8)
-#define WIN_B_UF_INT  (1 << 9)
-#define WIN_C_UF_INT  (1 << 10)
-#define WIN_A_OF_INT  (1 << 14)
-#define WIN_B_OF_INT  (1 << 15)
-#define WIN_C_OF_INT  (1 << 16)
-
-#define DC_CMD_SIGNAL_RAISE1			0x03c
-#define DC_CMD_SIGNAL_RAISE2			0x03d
-#define DC_CMD_SIGNAL_RAISE3			0x03e
-
-#define DC_CMD_STATE_ACCESS			0x040
-
-#define DC_CMD_STATE_CONTROL			0x041
-#define GENERAL_ACT_REQ (1 <<  0)
-#define WIN_A_ACT_REQ   (1 <<  1)
-#define WIN_B_ACT_REQ   (1 <<  2)
-#define WIN_C_ACT_REQ   (1 <<  3)
-#define GENERAL_UPDATE  (1 <<  8)
-#define WIN_A_UPDATE    (1 <<  9)
-#define WIN_B_UPDATE    (1 << 10)
-#define WIN_C_UPDATE    (1 << 11)
-#define NC_HOST_TRIG    (1 << 24)
-
-#define DC_CMD_DISPLAY_WINDOW_HEADER		0x042
-#define WINDOW_A_SELECT (1 << 4)
-#define WINDOW_B_SELECT (1 << 5)
-#define WINDOW_C_SELECT (1 << 6)
-
-#define DC_CMD_REG_ACT_CONTROL			0x043
-
-#define DC_COM_CRC_CONTROL			0x300
-#define DC_COM_CRC_CHECKSUM			0x301
-#define DC_COM_PIN_OUTPUT_ENABLE(x) (0x302 + (x))
-#define DC_COM_PIN_OUTPUT_POLARITY(x) (0x306 + (x))
-#define LVS_OUTPUT_POLARITY_LOW (1 << 28)
-#define LHS_OUTPUT_POLARITY_LOW (1 << 30)
-#define DC_COM_PIN_OUTPUT_DATA(x) (0x30a + (x))
-#define DC_COM_PIN_INPUT_ENABLE(x) (0x30e + (x))
-#define DC_COM_PIN_INPUT_DATA(x) (0x312 + (x))
-#define DC_COM_PIN_OUTPUT_SELECT(x) (0x314 + (x))
-
-#define DC_COM_PIN_MISC_CONTROL			0x31b
-#define DC_COM_PIN_PM0_CONTROL			0x31c
-#define DC_COM_PIN_PM0_DUTY_CYCLE		0x31d
-#define DC_COM_PIN_PM1_CONTROL			0x31e
-#define DC_COM_PIN_PM1_DUTY_CYCLE		0x31f
-
-#define DC_COM_SPI_CONTROL			0x320
-#define DC_COM_SPI_START_BYTE			0x321
-#define DC_COM_HSPI_WRITE_DATA_AB		0x322
-#define DC_COM_HSPI_WRITE_DATA_CD		0x323
-#define DC_COM_HSPI_CS_DC			0x324
-#define DC_COM_SCRATCH_REGISTER_A		0x325
-#define DC_COM_SCRATCH_REGISTER_B		0x326
-#define DC_COM_GPIO_CTRL			0x327
-#define DC_COM_GPIO_DEBOUNCE_COUNTER		0x328
-#define DC_COM_CRC_CHECKSUM_LATCHED		0x329
-
-#define DC_DISP_DISP_SIGNAL_OPTIONS0		0x400
-#define H_PULSE_0_ENABLE (1 <<  8)
-#define H_PULSE_1_ENABLE (1 << 10)
-#define H_PULSE_2_ENABLE (1 << 12)
-
-#define DC_DISP_DISP_SIGNAL_OPTIONS1		0x401
-
-#define DC_DISP_DISP_WIN_OPTIONS		0x402
-#define HDMI_ENABLE (1 << 30)
-
-#define DC_DISP_DISP_MEM_HIGH_PRIORITY		0x403
-#define CURSOR_THRESHOLD(x)   (((x) & 0x03) << 24)
-#define WINDOW_A_THRESHOLD(x) (((x) & 0x7f) << 16)
-#define WINDOW_B_THRESHOLD(x) (((x) & 0x7f) <<  8)
-#define WINDOW_C_THRESHOLD(x) (((x) & 0xff) <<  0)
-
-#define DC_DISP_DISP_MEM_HIGH_PRIORITY_TIMER	0x404
-#define CURSOR_DELAY(x)   (((x) & 0x3f) << 24)
-#define WINDOW_A_DELAY(x) (((x) & 0x3f) << 16)
-#define WINDOW_B_DELAY(x) (((x) & 0x3f) <<  8)
-#define WINDOW_C_DELAY(x) (((x) & 0x3f) <<  0)
-
-#define DC_DISP_DISP_TIMING_OPTIONS		0x405
-#define VSYNC_H_POSITION(x) ((x) & 0xfff)
-
-#define DC_DISP_REF_TO_SYNC			0x406
-#define DC_DISP_SYNC_WIDTH			0x407
-#define DC_DISP_BACK_PORCH			0x408
-#define DC_DISP_ACTIVE				0x409
-#define DC_DISP_FRONT_PORCH			0x40a
-#define DC_DISP_H_PULSE0_CONTROL		0x40b
-#define DC_DISP_H_PULSE0_POSITION_A		0x40c
-#define DC_DISP_H_PULSE0_POSITION_B		0x40d
-#define DC_DISP_H_PULSE0_POSITION_C		0x40e
-#define DC_DISP_H_PULSE0_POSITION_D		0x40f
-#define DC_DISP_H_PULSE1_CONTROL		0x410
-#define DC_DISP_H_PULSE1_POSITION_A		0x411
-#define DC_DISP_H_PULSE1_POSITION_B		0x412
-#define DC_DISP_H_PULSE1_POSITION_C		0x413
-#define DC_DISP_H_PULSE1_POSITION_D		0x414
-#define DC_DISP_H_PULSE2_CONTROL		0x415
-#define DC_DISP_H_PULSE2_POSITION_A		0x416
-#define DC_DISP_H_PULSE2_POSITION_B		0x417
-#define DC_DISP_H_PULSE2_POSITION_C		0x418
-#define DC_DISP_H_PULSE2_POSITION_D		0x419
-#define DC_DISP_V_PULSE0_CONTROL		0x41a
-#define DC_DISP_V_PULSE0_POSITION_A		0x41b
-#define DC_DISP_V_PULSE0_POSITION_B		0x41c
-#define DC_DISP_V_PULSE0_POSITION_C		0x41d
-#define DC_DISP_V_PULSE1_CONTROL		0x41e
-#define DC_DISP_V_PULSE1_POSITION_A		0x41f
-#define DC_DISP_V_PULSE1_POSITION_B		0x420
-#define DC_DISP_V_PULSE1_POSITION_C		0x421
-#define DC_DISP_V_PULSE2_CONTROL		0x422
-#define DC_DISP_V_PULSE2_POSITION_A		0x423
-#define DC_DISP_V_PULSE3_CONTROL		0x424
-#define DC_DISP_V_PULSE3_POSITION_A		0x425
-#define DC_DISP_M0_CONTROL			0x426
-#define DC_DISP_M1_CONTROL			0x427
-#define DC_DISP_DI_CONTROL			0x428
-#define DC_DISP_PP_CONTROL			0x429
-#define DC_DISP_PP_SELECT_A			0x42a
-#define DC_DISP_PP_SELECT_B			0x42b
-#define DC_DISP_PP_SELECT_C			0x42c
-#define DC_DISP_PP_SELECT_D			0x42d
-
-#define PULSE_MODE_NORMAL    (0 << 3)
-#define PULSE_MODE_ONE_CLOCK (1 << 3)
-#define PULSE_POLARITY_HIGH  (0 << 4)
-#define PULSE_POLARITY_LOW   (1 << 4)
-#define PULSE_QUAL_ALWAYS    (0 << 6)
-#define PULSE_QUAL_VACTIVE   (2 << 6)
-#define PULSE_QUAL_VACTIVE1  (3 << 6)
-#define PULSE_LAST_START_A   (0 << 8)
-#define PULSE_LAST_END_A     (1 << 8)
-#define PULSE_LAST_START_B   (2 << 8)
-#define PULSE_LAST_END_B     (3 << 8)
-#define PULSE_LAST_START_C   (4 << 8)
-#define PULSE_LAST_END_C     (5 << 8)
-#define PULSE_LAST_START_D   (6 << 8)
-#define PULSE_LAST_END_D     (7 << 8)
-
-#define PULSE_START(x) (((x) & 0xfff) <<  0)
-#define PULSE_END(x)   (((x) & 0xfff) << 16)
-
-#define DC_DISP_DISP_CLOCK_CONTROL		0x42e
-#define PIXEL_CLK_DIVIDER_PCD1  (0 << 8)
-#define PIXEL_CLK_DIVIDER_PCD1H (1 << 8)
-#define PIXEL_CLK_DIVIDER_PCD2  (2 << 8)
-#define PIXEL_CLK_DIVIDER_PCD3  (3 << 8)
-#define PIXEL_CLK_DIVIDER_PCD4  (4 << 8)
-#define PIXEL_CLK_DIVIDER_PCD6  (5 << 8)
-#define PIXEL_CLK_DIVIDER_PCD8  (6 << 8)
-#define PIXEL_CLK_DIVIDER_PCD9  (7 << 8)
-#define PIXEL_CLK_DIVIDER_PCD12 (8 << 8)
-#define PIXEL_CLK_DIVIDER_PCD16 (9 << 8)
-#define PIXEL_CLK_DIVIDER_PCD18 (10 << 8)
-#define PIXEL_CLK_DIVIDER_PCD24 (11 << 8)
-#define PIXEL_CLK_DIVIDER_PCD13 (12 << 8)
-#define SHIFT_CLK_DIVIDER(x)    ((x) & 0xff)
-
-#define DC_DISP_DISP_INTERFACE_CONTROL		0x42f
-#define DISP_DATA_FORMAT_DF1P1C    (0 << 0)
-#define DISP_DATA_FORMAT_DF1P2C24B (1 << 0)
-#define DISP_DATA_FORMAT_DF1P2C18B (2 << 0)
-#define DISP_DATA_FORMAT_DF1P2C16B (3 << 0)
-#define DISP_DATA_FORMAT_DF2S      (4 << 0)
-#define DISP_DATA_FORMAT_DF3S      (5 << 0)
-#define DISP_DATA_FORMAT_DFSPI     (6 << 0)
-#define DISP_DATA_FORMAT_DF1P3C24B (7 << 0)
-#define DISP_DATA_FORMAT_DF1P3C18B (8 << 0)
-#define DISP_ALIGNMENT_MSB         (0 << 8)
-#define DISP_ALIGNMENT_LSB         (1 << 8)
-#define DISP_ORDER_RED_BLUE        (0 << 9)
-#define DISP_ORDER_BLUE_RED        (1 << 9)
-
-#define DC_DISP_DISP_COLOR_CONTROL		0x430
-#define BASE_COLOR_SIZE666     (0 << 0)
-#define BASE_COLOR_SIZE111     (1 << 0)
-#define BASE_COLOR_SIZE222     (2 << 0)
-#define BASE_COLOR_SIZE333     (3 << 0)
-#define BASE_COLOR_SIZE444     (4 << 0)
-#define BASE_COLOR_SIZE555     (5 << 0)
-#define BASE_COLOR_SIZE565     (6 << 0)
-#define BASE_COLOR_SIZE332     (7 << 0)
-#define BASE_COLOR_SIZE888     (8 << 0)
-#define DITHER_CONTROL_DISABLE (0 << 8)
-#define DITHER_CONTROL_ORDERED (2 << 8)
-#define DITHER_CONTROL_ERRDIFF (3 << 8)
-
-#define DC_DISP_SHIFT_CLOCK_OPTIONS		0x431
-
-#define DC_DISP_DATA_ENABLE_OPTIONS		0x432
-#define DE_SELECT_ACTIVE_BLANK  (0 << 0)
-#define DE_SELECT_ACTIVE        (1 << 0)
-#define DE_SELECT_ACTIVE_IS     (2 << 0)
-#define DE_CONTROL_ONECLK       (0 << 2)
-#define DE_CONTROL_NORMAL       (1 << 2)
-#define DE_CONTROL_EARLY_EXT    (2 << 2)
-#define DE_CONTROL_EARLY        (3 << 2)
-#define DE_CONTROL_ACTIVE_BLANK (4 << 2)
-
-#define DC_DISP_SERIAL_INTERFACE_OPTIONS	0x433
-#define DC_DISP_LCD_SPI_OPTIONS			0x434
-#define DC_DISP_BORDER_COLOR			0x435
-#define DC_DISP_COLOR_KEY0_LOWER		0x436
-#define DC_DISP_COLOR_KEY0_UPPER		0x437
-#define DC_DISP_COLOR_KEY1_LOWER		0x438
-#define DC_DISP_COLOR_KEY1_UPPER		0x439
-
-#define DC_DISP_CURSOR_FOREGROUND		0x43c
-#define DC_DISP_CURSOR_BACKGROUND		0x43d
-
-#define DC_DISP_CURSOR_START_ADDR		0x43e
-#define DC_DISP_CURSOR_START_ADDR_NS		0x43f
-
-#define DC_DISP_CURSOR_POSITION			0x440
-#define DC_DISP_CURSOR_POSITION_NS		0x441
-
-#define DC_DISP_INIT_SEQ_CONTROL		0x442
-#define DC_DISP_SPI_INIT_SEQ_DATA_A		0x443
-#define DC_DISP_SPI_INIT_SEQ_DATA_B		0x444
-#define DC_DISP_SPI_INIT_SEQ_DATA_C		0x445
-#define DC_DISP_SPI_INIT_SEQ_DATA_D		0x446
-
-#define DC_DISP_DC_MCCIF_FIFOCTRL		0x480
-#define DC_DISP_MCCIF_DISPLAY0A_HYST		0x481
-#define DC_DISP_MCCIF_DISPLAY0B_HYST		0x482
-#define DC_DISP_MCCIF_DISPLAY1A_HYST		0x483
-#define DC_DISP_MCCIF_DISPLAY1B_HYST		0x484
-
-#define DC_DISP_DAC_CRT_CTRL			0x4c0
-#define DC_DISP_DISP_MISC_CONTROL		0x4c1
-#define DC_DISP_SD_CONTROL			0x4c2
-#define DC_DISP_SD_CSC_COEFF			0x4c3
-#define DC_DISP_SD_LUT(x)			(0x4c4 + (x))
-#define DC_DISP_SD_FLICKER_CONTROL		0x4cd
-#define DC_DISP_DC_PIXEL_COUNT			0x4ce
-#define DC_DISP_SD_HISTOGRAM(x)			(0x4cf + (x))
-#define DC_DISP_SD_BL_PARAMETERS		0x4d7
-#define DC_DISP_SD_BL_TF(x)			(0x4d8 + (x))
-#define DC_DISP_SD_BL_CONTROL			0x4dc
-#define DC_DISP_SD_HW_K_VALUES			0x4dd
-#define DC_DISP_SD_MAN_K_VALUES			0x4de
-
-#define DC_WIN_WIN_OPTIONS			0x700
-#define COLOR_EXPAND (1 <<  6)
-#define WIN_ENABLE   (1 << 30)
-
-#define DC_WIN_BYTE_SWAP			0x701
-#define BYTE_SWAP_NOSWAP  (0 << 0)
-#define BYTE_SWAP_SWAP2   (1 << 0)
-#define BYTE_SWAP_SWAP4   (2 << 0)
-#define BYTE_SWAP_SWAP4HW (3 << 0)
-
-#define DC_WIN_BUFFER_CONTROL			0x702
-#define BUFFER_CONTROL_HOST  (0 << 0)
-#define BUFFER_CONTROL_VI    (1 << 0)
-#define BUFFER_CONTROL_EPP   (2 << 0)
-#define BUFFER_CONTROL_MPEGE (3 << 0)
-#define BUFFER_CONTROL_SB2D  (4 << 0)
-
-#define DC_WIN_COLOR_DEPTH			0x703
-#define WIN_COLOR_DEPTH_P1              0
-#define WIN_COLOR_DEPTH_P2              1
-#define WIN_COLOR_DEPTH_P4              2
-#define WIN_COLOR_DEPTH_P8              3
-#define WIN_COLOR_DEPTH_B4G4R4A4        4
-#define WIN_COLOR_DEPTH_B5G5R5A         5
-#define WIN_COLOR_DEPTH_B5G6R5          6
-#define WIN_COLOR_DEPTH_AB5G5R5         7
-#define WIN_COLOR_DEPTH_B8G8R8A8       12
-#define WIN_COLOR_DEPTH_R8G8B8A8       13
-#define WIN_COLOR_DEPTH_B6x2G6x2R6x2A8 14
-#define WIN_COLOR_DEPTH_R6x2G6x2B6x2A8 15
-#define WIN_COLOR_DEPTH_YCbCr422       16
-#define WIN_COLOR_DEPTH_YUV422         17
-#define WIN_COLOR_DEPTH_YCbCr420P      18
-#define WIN_COLOR_DEPTH_YUV420P        19
-#define WIN_COLOR_DEPTH_YCbCr422P      20
-#define WIN_COLOR_DEPTH_YUV422P        21
-#define WIN_COLOR_DEPTH_YCbCr422R      22
-#define WIN_COLOR_DEPTH_YUV422R        23
-#define WIN_COLOR_DEPTH_YCbCr422RA     24
-#define WIN_COLOR_DEPTH_YUV422RA       25
-
-#define DC_WIN_POSITION				0x704
-#define H_POSITION(x) (((x) & 0x1fff) <<  0)
-#define V_POSITION(x) (((x) & 0x1fff) << 16)
-
-#define DC_WIN_SIZE				0x705
-#define H_SIZE(x) (((x) & 0x1fff) <<  0)
-#define V_SIZE(x) (((x) & 0x1fff) << 16)
-
-#define DC_WIN_PRESCALED_SIZE			0x706
-#define H_PRESCALED_SIZE(x) (((x) & 0x7fff) <<  0)
-#define V_PRESCALED_SIZE(x) (((x) & 0x1fff) << 16)
-
-#define DC_WIN_H_INITIAL_DDA			0x707
-#define DC_WIN_V_INITIAL_DDA			0x708
-#define DC_WIN_DDA_INC				0x709
-#define H_DDA_INC(x) (((x) & 0xffff) <<  0)
-#define V_DDA_INC(x) (((x) & 0xffff) << 16)
-
-#define DC_WIN_LINE_STRIDE			0x70a
-#define DC_WIN_BUF_STRIDE			0x70b
-#define DC_WIN_UV_BUF_STRIDE			0x70c
-#define DC_WIN_BUFFER_ADDR_MODE			0x70d
-#define DC_WIN_DV_CONTROL			0x70e
-
-#define DC_WIN_BLEND_NOKEY			0x70f
-#define DC_WIN_BLEND_1WIN			0x710
-#define DC_WIN_BLEND_2WIN_X			0x711
-#define DC_WIN_BLEND_2WIN_Y			0x712
-#define DC_WIN_BLEND32WIN_XY			0x713
-
-#define DC_WIN_HP_FETCH_CONTROL			0x714
-
-#define DC_WINBUF_START_ADDR			0x800
-#define DC_WINBUF_START_ADDR_NS			0x801
-#define DC_WINBUF_START_ADDR_U			0x802
-#define DC_WINBUF_START_ADDR_U_NS		0x803
-#define DC_WINBUF_START_ADDR_V			0x804
-#define DC_WINBUF_START_ADDR_V_NS		0x805
-
-#define DC_WINBUF_ADDR_H_OFFSET			0x806
-#define DC_WINBUF_ADDR_H_OFFSET_NS		0x807
-#define DC_WINBUF_ADDR_V_OFFSET			0x808
-#define DC_WINBUF_ADDR_V_OFFSET_NS		0x809
-
-#define DC_WINBUF_UFLOW_STATUS			0x80a
-
-#define DC_WINBUF_AD_UFLOW_STATUS		0xbca
-#define DC_WINBUF_BD_UFLOW_STATUS		0xdca
-#define DC_WINBUF_CD_UFLOW_STATUS		0xfca
-
-/* synchronization points */
-#define SYNCPT_VBLANK0 26
-#define SYNCPT_VBLANK1 27
-
-#endif /* TEGRA_DC_H */
diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
deleted file mode 100644
index 3a503c9..0000000
--- a/drivers/gpu/drm/tegra/drm.c
+++ /dev/null
@@ -1,115 +0,0 @@
-/*
- * Copyright (C) 2012 Avionic Design GmbH
- * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/of_address.h>
-#include <linux/of_platform.h>
-
-#include <mach/clk.h>
-#include <linux/dma-mapping.h>
-#include <asm/dma-iommu.h>
-
-#include "drm.h"
-
-#define DRIVER_NAME "tegra"
-#define DRIVER_DESC "NVIDIA Tegra graphics"
-#define DRIVER_DATE "20120330"
-#define DRIVER_MAJOR 0
-#define DRIVER_MINOR 0
-#define DRIVER_PATCHLEVEL 0
-
-static int tegra_drm_load(struct drm_device *drm, unsigned long flags)
-{
-	struct device *dev = drm->dev;
-	struct host1x *host1x;
-	int err;
-
-	host1x = dev_get_drvdata(dev);
-	drm->dev_private = host1x;
-	host1x->drm = drm;
-
-	drm_mode_config_init(drm);
-
-	err = host1x_drm_init(host1x, drm);
-	if (err < 0)
-		return err;
-
-	err = tegra_drm_fb_init(drm);
-	if (err < 0)
-		return err;
-
-	drm_kms_helper_poll_init(drm);
-
-	return 0;
-}
-
-static int tegra_drm_unload(struct drm_device *drm)
-{
-	drm_kms_helper_poll_fini(drm);
-	tegra_drm_fb_exit(drm);
-
-	drm_mode_config_cleanup(drm);
-
-	return 0;
-}
-
-static int tegra_drm_open(struct drm_device *drm, struct drm_file *filp)
-{
-	return 0;
-}
-
-static void tegra_drm_lastclose(struct drm_device *drm)
-{
-	struct host1x *host1x = drm->dev_private;
-
-	drm_fbdev_cma_restore_mode(host1x->fbdev);
-}
-
-static struct drm_ioctl_desc tegra_drm_ioctls[] = {
-};
-
-static const struct file_operations tegra_drm_fops = {
-	.owner = THIS_MODULE,
-	.open = drm_open,
-	.release = drm_release,
-	.unlocked_ioctl = drm_ioctl,
-	.mmap = drm_gem_cma_mmap,
-	.poll = drm_poll,
-	.fasync = drm_fasync,
-	.read = drm_read,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl = drm_compat_ioctl,
-#endif
-	.llseek = noop_llseek,
-};
-
-struct drm_driver tegra_drm_driver = {
-	.driver_features = DRIVER_BUS_PLATFORM | DRIVER_MODESET | DRIVER_GEM,
-	.load = tegra_drm_load,
-	.unload = tegra_drm_unload,
-	.open = tegra_drm_open,
-	.lastclose = tegra_drm_lastclose,
-
-	.gem_free_object = drm_gem_cma_free_object,
-	.gem_vm_ops = &drm_gem_cma_vm_ops,
-	.dumb_create = drm_gem_cma_dumb_create,
-	.dumb_map_offset = drm_gem_cma_dumb_map_offset,
-	.dumb_destroy = drm_gem_cma_dumb_destroy,
-
-	.ioctls = tegra_drm_ioctls,
-	.num_ioctls = ARRAY_SIZE(tegra_drm_ioctls),
-	.fops = &tegra_drm_fops,
-
-	.name = DRIVER_NAME,
-	.desc = DRIVER_DESC,
-	.date = DRIVER_DATE,
-	.major = DRIVER_MAJOR,
-	.minor = DRIVER_MINOR,
-	.patchlevel = DRIVER_PATCHLEVEL,
-};
diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
deleted file mode 100644
index 741b5dc..0000000
--- a/drivers/gpu/drm/tegra/drm.h
+++ /dev/null
@@ -1,216 +0,0 @@
-/*
- * Copyright (C) 2012 Avionic Design GmbH
- * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef TEGRA_DRM_H
-#define TEGRA_DRM_H 1
-
-#include <drm/drmP.h>
-#include <drm/drm_crtc_helper.h>
-#include <drm/drm_edid.h>
-#include <drm/drm_fb_helper.h>
-#include <drm/drm_gem_cma_helper.h>
-#include <drm/drm_fb_cma_helper.h>
-#include <drm/drm_fixed.h>
-
-struct tegra_framebuffer {
-	struct drm_framebuffer base;
-	struct drm_gem_cma_object *obj;
-};
-
-static inline struct tegra_framebuffer *to_tegra_fb(struct drm_framebuffer *fb)
-{
-	return container_of(fb, struct tegra_framebuffer, base);
-}
-
-struct host1x {
-	struct drm_device *drm;
-	struct device *dev;
-	void __iomem *regs;
-	struct clk *clk;
-	int syncpt;
-	int irq;
-
-	struct mutex drm_clients_lock;
-	struct list_head drm_clients;
-	struct list_head drm_active;
-
-	struct mutex clients_lock;
-	struct list_head clients;
-
-	struct drm_fbdev_cma *fbdev;
-	struct tegra_framebuffer fb;
-};
-
-struct host1x_client;
-
-struct host1x_client_ops {
-	int (*drm_init)(struct host1x_client *client, struct drm_device *drm);
-	int (*drm_exit)(struct host1x_client *client);
-};
-
-struct host1x_client {
-	struct host1x *host1x;
-	struct device *dev;
-
-	const struct host1x_client_ops *ops;
-
-	struct list_head list;
-};
-
-extern int host1x_drm_init(struct host1x *host1x, struct drm_device *drm);
-extern int host1x_drm_exit(struct host1x *host1x);
-
-extern int host1x_register_client(struct host1x *host1x,
-				  struct host1x_client *client);
-extern int host1x_unregister_client(struct host1x *host1x,
-				    struct host1x_client *client);
-
-struct tegra_output;
-
-struct tegra_dc {
-	struct host1x_client client;
-
-	struct host1x *host1x;
-	struct device *dev;
-
-	struct drm_crtc base;
-	int pipe;
-
-	struct clk *clk;
-
-	void __iomem *regs;
-	int irq;
-
-	struct tegra_output *rgb;
-
-	struct list_head list;
-
-	struct drm_info_list *debugfs_files;
-	struct drm_minor *minor;
-	struct dentry *debugfs;
-};
-
-static inline struct tegra_dc *host1x_client_to_dc(struct host1x_client *client)
-{
-	return container_of(client, struct tegra_dc, client);
-}
-
-static inline struct tegra_dc *to_tegra_dc(struct drm_crtc *crtc)
-{
-	return container_of(crtc, struct tegra_dc, base);
-}
-
-static inline void tegra_dc_writel(struct tegra_dc *dc, unsigned long value,
-				   unsigned long reg)
-{
-	writel(value, dc->regs + (reg << 2));
-}
-
-static inline unsigned long tegra_dc_readl(struct tegra_dc *dc,
-					   unsigned long reg)
-{
-	return readl(dc->regs + (reg << 2));
-}
-
-struct tegra_output_ops {
-	int (*enable)(struct tegra_output *output);
-	int (*disable)(struct tegra_output *output);
-	int (*setup_clock)(struct tegra_output *output, struct clk *clk,
-			   unsigned long pclk);
-	int (*check_mode)(struct tegra_output *output,
-			  struct drm_display_mode *mode,
-			  enum drm_mode_status *status);
-};
-
-enum tegra_output_type {
-	TEGRA_OUTPUT_RGB,
-	TEGRA_OUTPUT_HDMI,
-};
-
-struct tegra_output {
-	struct device_node *of_node;
-	struct device *dev;
-
-	const struct tegra_output_ops *ops;
-	enum tegra_output_type type;
-
-	struct i2c_adapter *ddc;
-	const struct edid *edid;
-	unsigned int hpd_irq;
-	int hpd_gpio;
-
-	struct drm_encoder encoder;
-	struct drm_connector connector;
-};
-
-static inline struct tegra_output *encoder_to_output(struct drm_encoder *e)
-{
-	return container_of(e, struct tegra_output, encoder);
-}
-
-static inline struct tegra_output *connector_to_output(struct drm_connector *c)
-{
-	return container_of(c, struct tegra_output, connector);
-}
-
-static inline int tegra_output_enable(struct tegra_output *output)
-{
-	if (output && output->ops && output->ops->enable)
-		return output->ops->enable(output);
-
-	return output ? -ENOSYS : -EINVAL;
-}
-
-static inline int tegra_output_disable(struct tegra_output *output)
-{
-	if (output && output->ops && output->ops->disable)
-		return output->ops->disable(output);
-
-	return output ? -ENOSYS : -EINVAL;
-}
-
-static inline int tegra_output_setup_clock(struct tegra_output *output,
-					   struct clk *clk, unsigned long pclk)
-{
-	if (output && output->ops && output->ops->setup_clock)
-		return output->ops->setup_clock(output, clk, pclk);
-
-	return output ? -ENOSYS : -EINVAL;
-}
-
-static inline int tegra_output_check_mode(struct tegra_output *output,
-					  struct drm_display_mode *mode,
-					  enum drm_mode_status *status)
-{
-	if (output && output->ops && output->ops->check_mode)
-		return output->ops->check_mode(output, mode, status);
-
-	return output ? -ENOSYS : -EINVAL;
-}
-
-/* from rgb.c */
-extern int tegra_dc_rgb_probe(struct tegra_dc *dc);
-extern int tegra_dc_rgb_init(struct drm_device *drm, struct tegra_dc *dc);
-extern int tegra_dc_rgb_exit(struct tegra_dc *dc);
-
-/* from output.c */
-extern int tegra_output_parse_dt(struct tegra_output *output);
-extern int tegra_output_init(struct drm_device *drm, struct tegra_output *output);
-extern int tegra_output_exit(struct tegra_output *output);
-
-/* from fb.c */
-extern int tegra_drm_fb_init(struct drm_device *drm);
-extern void tegra_drm_fb_exit(struct drm_device *drm);
-
-extern struct platform_driver tegra_host1x_driver;
-extern struct platform_driver tegra_hdmi_driver;
-extern struct platform_driver tegra_dc_driver;
-extern struct drm_driver tegra_drm_driver;
-
-#endif /* TEGRA_DRM_H */
diff --git a/drivers/gpu/drm/tegra/fb.c b/drivers/gpu/drm/tegra/fb.c
deleted file mode 100644
index 97993c6..0000000
--- a/drivers/gpu/drm/tegra/fb.c
+++ /dev/null
@@ -1,56 +0,0 @@
-/*
- * Copyright (C) 2012 Avionic Design GmbH
- * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include "drm.h"
-
-static void tegra_drm_fb_output_poll_changed(struct drm_device *drm)
-{
-	struct host1x *host1x = drm->dev_private;
-
-	drm_fbdev_cma_hotplug_event(host1x->fbdev);
-}
-
-static const struct drm_mode_config_funcs tegra_drm_mode_funcs = {
-	.fb_create = drm_fb_cma_create,
-	.output_poll_changed = tegra_drm_fb_output_poll_changed,
-};
-
-int tegra_drm_fb_init(struct drm_device *drm)
-{
-	struct host1x *host1x = drm->dev_private;
-	struct drm_fbdev_cma *fbdev;
-
-	drm->mode_config.min_width = 0;
-	drm->mode_config.min_height = 0;
-
-	drm->mode_config.max_width = 4096;
-	drm->mode_config.max_height = 4096;
-
-	drm->mode_config.funcs = &tegra_drm_mode_funcs;
-
-	fbdev = drm_fbdev_cma_init(drm, 32, drm->mode_config.num_crtc,
-				   drm->mode_config.num_connector);
-	if (IS_ERR(fbdev))
-		return PTR_ERR(fbdev);
-
-#ifndef CONFIG_FRAMEBUFFER_CONSOLE
-	drm_fbdev_cma_restore_mode(fbdev);
-#endif
-
-	host1x->fbdev = fbdev;
-
-	return 0;
-}
-
-void tegra_drm_fb_exit(struct drm_device *drm)
-{
-	struct host1x *host1x = drm->dev_private;
-
-	drm_fbdev_cma_fini(host1x->fbdev);
-}
diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
deleted file mode 100644
index e060c7e..0000000
--- a/drivers/gpu/drm/tegra/hdmi.c
+++ /dev/null
@@ -1,1321 +0,0 @@
-/*
- * Copyright (C) 2012 Avionic Design GmbH
- * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/clk.h>
-#include <linux/debugfs.h>
-#include <linux/gpio.h>
-#include <linux/module.h>
-#include <linux/of.h>
-#include <linux/platform_device.h>
-#include <linux/regulator/consumer.h>
-
-#include <mach/clk.h>
-
-#include "hdmi.h"
-#include "drm.h"
-#include "dc.h"
-
-struct tegra_hdmi {
-	struct host1x_client client;
-	struct tegra_output output;
-	struct device *dev;
-
-	struct regulator *vdd;
-	struct regulator *pll;
-
-	void __iomem *regs;
-	unsigned int irq;
-
-	struct clk *clk_parent;
-	struct clk *clk;
-
-	unsigned int audio_source;
-	unsigned int audio_freq;
-	bool stereo;
-	bool dvi;
-
-	struct drm_info_list *debugfs_files;
-	struct drm_minor *minor;
-	struct dentry *debugfs;
-};
-
-static inline struct tegra_hdmi *
-host1x_client_to_hdmi(struct host1x_client *client)
-{
-	return container_of(client, struct tegra_hdmi, client);
-}
-
-static inline struct tegra_hdmi *to_hdmi(struct tegra_output *output)
-{
-	return container_of(output, struct tegra_hdmi, output);
-}
-
-#define HDMI_AUDIOCLK_FREQ 216000000
-#define HDMI_REKEY_DEFAULT 56
-
-enum {
-	AUTO = 0,
-	SPDIF,
-	HDA,
-};
-
-static inline unsigned long tegra_hdmi_readl(struct tegra_hdmi *hdmi,
-					     unsigned long reg)
-{
-	return readl(hdmi->regs + (reg << 2));
-}
-
-static inline void tegra_hdmi_writel(struct tegra_hdmi *hdmi, unsigned long val,
-				     unsigned long reg)
-{
-	writel(val, hdmi->regs + (reg << 2));
-}
-
-struct tegra_hdmi_audio_config {
-	unsigned int pclk;
-	unsigned int n;
-	unsigned int cts;
-	unsigned int aval;
-};
-
-static const struct tegra_hdmi_audio_config tegra_hdmi_audio_32k[] = {
-	{  25200000, 4096,  25200, 24000 },
-	{  27000000, 4096,  27000, 24000 },
-	{  74250000, 4096,  74250, 24000 },
-	{ 148500000, 4096, 148500, 24000 },
-	{         0,    0,      0,     0 },
-};
-
-static const struct tegra_hdmi_audio_config tegra_hdmi_audio_44_1k[] = {
-	{  25200000, 5880,  26250, 25000 },
-	{  27000000, 5880,  28125, 25000 },
-	{  74250000, 4704,  61875, 20000 },
-	{ 148500000, 4704, 123750, 20000 },
-	{         0,    0,      0,     0 },
-};
-
-static const struct tegra_hdmi_audio_config tegra_hdmi_audio_48k[] = {
-	{  25200000, 6144,  25200, 24000 },
-	{  27000000, 6144,  27000, 24000 },
-	{  74250000, 6144,  74250, 24000 },
-	{ 148500000, 6144, 148500, 24000 },
-	{         0,    0,      0,     0 },
-};
-
-static const struct tegra_hdmi_audio_config tegra_hdmi_audio_88_2k[] = {
-	{  25200000, 11760,  26250, 25000 },
-	{  27000000, 11760,  28125, 25000 },
-	{  74250000,  9408,  61875, 20000 },
-	{ 148500000,  9408, 123750, 20000 },
-	{         0,     0,      0,     0 },
-};
-
-static const struct tegra_hdmi_audio_config tegra_hdmi_audio_96k[] = {
-	{  25200000, 12288,  25200, 24000 },
-	{  27000000, 12288,  27000, 24000 },
-	{  74250000, 12288,  74250, 24000 },
-	{ 148500000, 12288, 148500, 24000 },
-	{         0,     0,      0,     0 },
-};
-
-static const struct tegra_hdmi_audio_config tegra_hdmi_audio_176_4k[] = {
-	{  25200000, 23520,  26250, 25000 },
-	{  27000000, 23520,  28125, 25000 },
-	{  74250000, 18816,  61875, 20000 },
-	{ 148500000, 18816, 123750, 20000 },
-	{         0,     0,      0,     0 },
-};
-
-static const struct tegra_hdmi_audio_config tegra_hdmi_audio_192k[] = {
-	{  25200000, 24576,  25200, 24000 },
-	{  27000000, 24576,  27000, 24000 },
-	{  74250000, 24576,  74250, 24000 },
-	{ 148500000, 24576, 148500, 24000 },
-	{         0,     0,      0,     0 },
-};
-
-struct tmds_config {
-	unsigned int pclk;
-	u32 pll0;
-	u32 pll1;
-	u32 pe_current;
-	u32 drive_current;
-};
-
-static const struct tmds_config tegra2_tmds_config[] = {
-	{ /* slow pixel clock modes */
-		.pclk = 27000000,
-		.pll0 = SOR_PLL_BG_V17_S(3) | SOR_PLL_ICHPMP(1) |
-			SOR_PLL_RESISTORSEL | SOR_PLL_VCOCAP(0) |
-			SOR_PLL_TX_REG_LOAD(3),
-		.pll1 = SOR_PLL_TMDS_TERM_ENABLE,
-		.pe_current = PE_CURRENT0(PE_CURRENT_0_0_mA) |
-			PE_CURRENT1(PE_CURRENT_0_0_mA) |
-			PE_CURRENT2(PE_CURRENT_0_0_mA) |
-			PE_CURRENT3(PE_CURRENT_0_0_mA),
-		.drive_current = DRIVE_CURRENT_LANE0(DRIVE_CURRENT_7_125_mA) |
-			DRIVE_CURRENT_LANE1(DRIVE_CURRENT_7_125_mA) |
-			DRIVE_CURRENT_LANE2(DRIVE_CURRENT_7_125_mA) |
-			DRIVE_CURRENT_LANE3(DRIVE_CURRENT_7_125_mA),
-	},
-	{ /* high pixel clock modes */
-		.pclk = UINT_MAX,
-		.pll0 = SOR_PLL_BG_V17_S(3) | SOR_PLL_ICHPMP(1) |
-			SOR_PLL_RESISTORSEL | SOR_PLL_VCOCAP(1) |
-			SOR_PLL_TX_REG_LOAD(3),
-		.pll1 = SOR_PLL_TMDS_TERM_ENABLE | SOR_PLL_PE_EN,
-		.pe_current = PE_CURRENT0(PE_CURRENT_6_0_mA) |
-			PE_CURRENT1(PE_CURRENT_6_0_mA) |
-			PE_CURRENT2(PE_CURRENT_6_0_mA) |
-			PE_CURRENT3(PE_CURRENT_6_0_mA),
-		.drive_current = DRIVE_CURRENT_LANE0(DRIVE_CURRENT_7_125_mA) |
-			DRIVE_CURRENT_LANE1(DRIVE_CURRENT_7_125_mA) |
-			DRIVE_CURRENT_LANE2(DRIVE_CURRENT_7_125_mA) |
-			DRIVE_CURRENT_LANE3(DRIVE_CURRENT_7_125_mA),
-	},
-};
-
-static const struct tmds_config tegra3_tmds_config[] = {
-	{ /* 480p modes */
-		.pclk = 27000000,
-		.pll0 = SOR_PLL_BG_V17_S(3) | SOR_PLL_ICHPMP(1) |
-			SOR_PLL_RESISTORSEL | SOR_PLL_VCOCAP(0) |
-			SOR_PLL_TX_REG_LOAD(0),
-		.pll1 = SOR_PLL_TMDS_TERM_ENABLE,
-		.pe_current = PE_CURRENT0(PE_CURRENT_0_0_mA) |
-			PE_CURRENT1(PE_CURRENT_0_0_mA) |
-			PE_CURRENT2(PE_CURRENT_0_0_mA) |
-			PE_CURRENT3(PE_CURRENT_0_0_mA),
-		.drive_current = DRIVE_CURRENT_LANE0(DRIVE_CURRENT_5_250_mA) |
-			DRIVE_CURRENT_LANE1(DRIVE_CURRENT_5_250_mA) |
-			DRIVE_CURRENT_LANE2(DRIVE_CURRENT_5_250_mA) |
-			DRIVE_CURRENT_LANE3(DRIVE_CURRENT_5_250_mA),
-	}, { /* 720p modes */
-		.pclk = 74250000,
-		.pll0 = SOR_PLL_BG_V17_S(3) | SOR_PLL_ICHPMP(1) |
-			SOR_PLL_RESISTORSEL | SOR_PLL_VCOCAP(1) |
-			SOR_PLL_TX_REG_LOAD(0),
-		.pll1 = SOR_PLL_TMDS_TERM_ENABLE | SOR_PLL_PE_EN,
-		.pe_current = PE_CURRENT0(PE_CURRENT_5_0_mA) |
-			PE_CURRENT1(PE_CURRENT_5_0_mA) |
-			PE_CURRENT2(PE_CURRENT_5_0_mA) |
-			PE_CURRENT3(PE_CURRENT_5_0_mA),
-		.drive_current = DRIVE_CURRENT_LANE0(DRIVE_CURRENT_5_250_mA) |
-			DRIVE_CURRENT_LANE1(DRIVE_CURRENT_5_250_mA) |
-			DRIVE_CURRENT_LANE2(DRIVE_CURRENT_5_250_mA) |
-			DRIVE_CURRENT_LANE3(DRIVE_CURRENT_5_250_mA),
-	}, { /* 1080p modes */
-		.pclk = UINT_MAX,
-		.pll0 = SOR_PLL_BG_V17_S(3) | SOR_PLL_ICHPMP(1) |
-			SOR_PLL_RESISTORSEL | SOR_PLL_VCOCAP(3) |
-			SOR_PLL_TX_REG_LOAD(0),
-		.pll1 = SOR_PLL_TMDS_TERM_ENABLE | SOR_PLL_PE_EN,
-		.pe_current = PE_CURRENT0(PE_CURRENT_5_0_mA) |
-			PE_CURRENT1(PE_CURRENT_5_0_mA) |
-			PE_CURRENT2(PE_CURRENT_5_0_mA) |
-			PE_CURRENT3(PE_CURRENT_5_0_mA),
-		.drive_current = DRIVE_CURRENT_LANE0(DRIVE_CURRENT_5_250_mA) |
-			DRIVE_CURRENT_LANE1(DRIVE_CURRENT_5_250_mA) |
-			DRIVE_CURRENT_LANE2(DRIVE_CURRENT_5_250_mA) |
-			DRIVE_CURRENT_LANE3(DRIVE_CURRENT_5_250_mA),
-	},
-};
-
-static const struct tegra_hdmi_audio_config *
-tegra_hdmi_get_audio_config(unsigned int audio_freq, unsigned int pclk)
-{
-	const struct tegra_hdmi_audio_config *table;
-
-	switch (audio_freq) {
-	case 32000:
-		table = tegra_hdmi_audio_32k;
-		break;
-
-	case 44100:
-		table = tegra_hdmi_audio_44_1k;
-		break;
-
-	case 48000:
-		table = tegra_hdmi_audio_48k;
-		break;
-
-	case 88200:
-		table = tegra_hdmi_audio_88_2k;
-		break;
-
-	case 96000:
-		table = tegra_hdmi_audio_96k;
-		break;
-
-	case 176400:
-		table = tegra_hdmi_audio_176_4k;
-		break;
-
-	case 192000:
-		table = tegra_hdmi_audio_192k;
-		break;
-
-	default:
-		return NULL;
-	}
-
-	while (table->pclk) {
-		if (table->pclk == pclk)
-			return table;
-
-		table++;
-	}
-
-	return NULL;
-}
-
-static void tegra_hdmi_setup_audio_fs_tables(struct tegra_hdmi *hdmi)
-{
-	const unsigned int freqs[] = {
-		32000, 44100, 48000, 88200, 96000, 176400, 192000
-	};
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(freqs); i++) {
-		unsigned int f = freqs[i];
-		unsigned int eight_half;
-		unsigned long value;
-		unsigned int delta;
-
-		if (f > 96000)
-			delta = 2;
-		else if (f > 480000)
-			delta = 6;
-		else
-			delta = 9;
-
-		eight_half = (8 * HDMI_AUDIOCLK_FREQ) / (f * 128);
-		value = AUDIO_FS_LOW(eight_half - delta) |
-			AUDIO_FS_HIGH(eight_half + delta);
-		tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_AUDIO_FS(i));
-	}
-}
-
-static int tegra_hdmi_setup_audio(struct tegra_hdmi *hdmi, unsigned int pclk)
-{
-	struct device_node *node = hdmi->dev->of_node;
-	const struct tegra_hdmi_audio_config *config;
-	unsigned int offset = 0;
-	unsigned long value;
-
-	switch (hdmi->audio_source) {
-	case HDA:
-		value = AUDIO_CNTRL0_SOURCE_SELECT_HDAL;
-		break;
-
-	case SPDIF:
-		value = AUDIO_CNTRL0_SOURCE_SELECT_SPDIF;
-		break;
-
-	default:
-		value = AUDIO_CNTRL0_SOURCE_SELECT_AUTO;
-		break;
-	}
-
-	if (of_device_is_compatible(node, "nvidia,tegra30-hdmi")) {
-		value |= AUDIO_CNTRL0_ERROR_TOLERANCE(6) |
-			 AUDIO_CNTRL0_FRAMES_PER_BLOCK(0xc0);
-		tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_AUDIO_CNTRL0);
-	} else {
-		value |= AUDIO_CNTRL0_INJECT_NULLSMPL;
-		tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_SOR_AUDIO_CNTRL0);
-
-		value = AUDIO_CNTRL0_ERROR_TOLERANCE(6) |
-			AUDIO_CNTRL0_FRAMES_PER_BLOCK(0xc0);
-		tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_AUDIO_CNTRL0);
-	}
-
-	config = tegra_hdmi_get_audio_config(hdmi->audio_freq, pclk);
-	if (!config) {
-		dev_err(hdmi->dev, "cannot set audio to %u at %u pclk\n",
-			hdmi->audio_freq, pclk);
-		return -EINVAL;
-	}
-
-	tegra_hdmi_writel(hdmi, 0, HDMI_NV_PDISP_HDMI_ACR_CTRL);
-
-	value = AUDIO_N_RESETF | AUDIO_N_GENERATE_ALTERNATE |
-		AUDIO_N_VALUE(config->n - 1);
-	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_AUDIO_N);
-
-	tegra_hdmi_writel(hdmi, ACR_SUBPACK_N(config->n) | ACR_ENABLE,
-			  HDMI_NV_PDISP_HDMI_ACR_0441_SUBPACK_HIGH);
-
-	value = ACR_SUBPACK_CTS(config->cts);
-	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_HDMI_ACR_0441_SUBPACK_LOW);
-
-	value = SPARE_HW_CTS | SPARE_FORCE_SW_CTS | SPARE_CTS_RESET_VAL(1);
-	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_HDMI_SPARE);
-
-	value = tegra_hdmi_readl(hdmi, HDMI_NV_PDISP_AUDIO_N);
-	value &= ~AUDIO_N_RESETF;
-	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_AUDIO_N);
-
-	if (of_device_is_compatible(node, "nvidia,tegra30-hdmi")) {
-		switch (hdmi->audio_freq) {
-		case 32000:
-			offset = HDMI_NV_PDISP_SOR_AUDIO_AVAL_0320;
-			break;
-
-		case 44100:
-			offset = HDMI_NV_PDISP_SOR_AUDIO_AVAL_0441;
-			break;
-
-		case 48000:
-			offset = HDMI_NV_PDISP_SOR_AUDIO_AVAL_0480;
-			break;
-
-		case 88200:
-			offset = HDMI_NV_PDISP_SOR_AUDIO_AVAL_0882;
-			break;
-
-		case 96000:
-			offset = HDMI_NV_PDISP_SOR_AUDIO_AVAL_0960;
-			break;
-
-		case 176400:
-			offset = HDMI_NV_PDISP_SOR_AUDIO_AVAL_1764;
-			break;
-
-		case 192000:
-			offset = HDMI_NV_PDISP_SOR_AUDIO_AVAL_1920;
-			break;
-		}
-
-		tegra_hdmi_writel(hdmi, config->aval, offset);
-	}
-
-	tegra_hdmi_setup_audio_fs_tables(hdmi);
-
-	return 0;
-}
-
-static void tegra_hdmi_write_infopack(struct tegra_hdmi *hdmi,
-				      unsigned int offset, u8 type,
-				      u8 version, void *data, size_t size)
-{
-	unsigned long value;
-	u8 *ptr = data;
-	u32 subpack[2];
-	size_t i;
-	u8 csum;
-
-	/* first byte of data is the checksum */
-	csum = type + version + size - 1;
-
-	for (i = 1; i < size; i++)
-		csum += ptr[i];
-
-	ptr[0] = 0x100 - csum;
-
-	value = INFOFRAME_HEADER_TYPE(type) |
-		INFOFRAME_HEADER_VERSION(version) |
-		INFOFRAME_HEADER_LEN(size - 1);
-	tegra_hdmi_writel(hdmi, value, offset);
-
-	/* The audio inforame only has one set of subpack registers.  The hdmi
-	 * block pads the rest of the data as per the spec so we have to fixup
-	 * the length before filling in the subpacks.
-	 */
-	if (offset == HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_HEADER)
-		size = 6;
-
-	/* each subpack 7 bytes devided into:
-	 *   subpack_low - bytes 0 - 3
-	 *   subpack_high - bytes 4 - 6 (with byte 7 padded to 0x00)
-	 */
-	for (i = 0; i < size; i++) {
-		size_t index = i % 7;
-
-		if (index == 0)
-			memset(subpack, 0x0, sizeof(subpack));
-
-		((u8 *)subpack)[index] = ptr[i];
-
-		if (index == 6 || (i + 1 == size)) {
-			unsigned int reg = offset + 1 + (i / 7) * 2;
-
-			tegra_hdmi_writel(hdmi, subpack[0], reg);
-			tegra_hdmi_writel(hdmi, subpack[1], reg + 1);
-		}
-	}
-}
-
-static void tegra_hdmi_setup_avi_infoframe(struct tegra_hdmi *hdmi,
-					   struct drm_display_mode *mode)
-{
-	struct hdmi_avi_infoframe frame;
-	unsigned int h_front_porch;
-	unsigned int hsize = 16;
-	unsigned int vsize = 9;
-
-	if (hdmi->dvi) {
-		tegra_hdmi_writel(hdmi, 0,
-				  HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_CTRL);
-		return;
-	}
-
-	h_front_porch = mode->hsync_start - mode->hdisplay;
-	memset(&frame, 0, sizeof(frame));
-	frame.r = HDMI_AVI_R_SAME;
-
-	switch (mode->vdisplay) {
-	case 480:
-		if (mode->hdisplay == 640) {
-			frame.m = HDMI_AVI_M_4_3;
-			frame.vic = 1;
-		} else {
-			frame.m = HDMI_AVI_M_16_9;
-			frame.vic = 3;
-		}
-		break;
-
-	case 576:
-		if (((hsize * 10) / vsize) > 14) {
-			frame.m = HDMI_AVI_M_16_9;
-			frame.vic = 18;
-		} else {
-			frame.m = HDMI_AVI_M_4_3;
-			frame.vic = 17;
-		}
-		break;
-
-	case 720:
-	case 1470: /* stereo mode */
-		frame.m = HDMI_AVI_M_16_9;
-
-		if (h_front_porch == 110)
-			frame.vic = 4;
-		else
-			frame.vic = 19;
-		break;
-
-	case 1080:
-	case 2205: /* stereo mode */
-		frame.m = HDMI_AVI_M_16_9;
-
-		switch (h_front_porch) {
-		case 88:
-			frame.vic = 16;
-			break;
-
-		case 528:
-			frame.vic = 31;
-			break;
-
-		default:
-			frame.vic = 32;
-			break;
-		}
-		break;
-
-	default:
-		frame.m = HDMI_AVI_M_16_9;
-		frame.vic = 0;
-		break;
-	}
-
-	tegra_hdmi_write_infopack(hdmi, HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_HEADER,
-				  HDMI_INFOFRAME_TYPE_AVI, HDMI_AVI_VERSION,
-				  &frame, sizeof(frame));
-
-	tegra_hdmi_writel(hdmi, INFOFRAME_CTRL_ENABLE,
-			  HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_CTRL);
-}
-
-static void tegra_hdmi_setup_audio_infoframe(struct tegra_hdmi *hdmi)
-{
-	struct hdmi_audio_infoframe frame;
-
-	if (hdmi->dvi) {
-		tegra_hdmi_writel(hdmi, 0,
-				  HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_CTRL);
-		return;
-	}
-
-	memset(&frame, 0, sizeof(frame));
-	frame.cc = HDMI_AUDIO_CC_2;
-
-	tegra_hdmi_write_infopack(hdmi,
-				  HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_HEADER,
-				  HDMI_INFOFRAME_TYPE_AUDIO,
-				  HDMI_AUDIO_VERSION,
-				  &frame, sizeof(frame));
-
-	tegra_hdmi_writel(hdmi, INFOFRAME_CTRL_ENABLE,
-			  HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_CTRL);
-}
-
-static void tegra_hdmi_setup_stereo_infoframe(struct tegra_hdmi *hdmi)
-{
-	struct hdmi_stereo_infoframe frame;
-	unsigned long value;
-
-	if (!hdmi->stereo) {
-		value = tegra_hdmi_readl(hdmi, HDMI_NV_PDISP_HDMI_GENERIC_CTRL);
-		value &= ~GENERIC_CTRL_ENABLE;
-		tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_HDMI_GENERIC_CTRL);
-		return;
-	}
-
-	memset(&frame, 0, sizeof(frame));
-	frame.regid0 = 0x03;
-	frame.regid1 = 0x0c;
-	frame.regid2 = 0x00;
-	frame.hdmi_video_format = 2;
-
-	/* TODO: 74 MHz limit? */
-	if (1) {
-		frame._3d_structure = 0;
-	} else {
-		frame._3d_structure = 8;
-		frame._3d_ext_data = 0;
-	}
-
-	tegra_hdmi_write_infopack(hdmi, HDMI_NV_PDISP_HDMI_GENERIC_HEADER,
-				  HDMI_INFOFRAME_TYPE_VENDOR,
-				  HDMI_VENDOR_VERSION, &frame, 6);
-
-	value = tegra_hdmi_readl(hdmi, HDMI_NV_PDISP_HDMI_GENERIC_CTRL);
-	value |= GENERIC_CTRL_ENABLE;
-	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_HDMI_GENERIC_CTRL);
-}
-
-static void tegra_hdmi_setup_tmds(struct tegra_hdmi *hdmi,
-				  const struct tmds_config *tmds)
-{
-	unsigned long value;
-
-	tegra_hdmi_writel(hdmi, tmds->pll0, HDMI_NV_PDISP_SOR_PLL0);
-	tegra_hdmi_writel(hdmi, tmds->pll1, HDMI_NV_PDISP_SOR_PLL1);
-	tegra_hdmi_writel(hdmi, tmds->pe_current, HDMI_NV_PDISP_PE_CURRENT);
-
-	value = tmds->drive_current | DRIVE_CURRENT_FUSE_OVERRIDE;
-	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_SOR_LANE_DRIVE_CURRENT);
-}
-
-static int tegra_output_hdmi_enable(struct tegra_output *output)
-{
-	unsigned int h_sync_width, h_front_porch, h_back_porch, i, rekey;
-	struct tegra_dc *dc = to_tegra_dc(output->encoder.crtc);
-	struct drm_display_mode *mode = &dc->base.mode;
-	struct tegra_hdmi *hdmi = to_hdmi(output);
-	struct device_node *node = hdmi->dev->of_node;
-	unsigned int pulse_start, div82, pclk;
-	const struct tmds_config *tmds;
-	unsigned int num_tmds;
-	unsigned long value;
-	int retries = 1000;
-	int err;
-
-	pclk = mode->clock * 1000;
-	h_sync_width = mode->hsync_end - mode->hsync_start;
-	h_back_porch = mode->htotal - mode->hsync_end;
-	h_front_porch = mode->hsync_start - mode->hdisplay;
-
-	err = regulator_enable(hdmi->vdd);
-	if (err < 0) {
-		dev_err(hdmi->dev, "failed to enable VDD regulator: %d\n", err);
-		return err;
-	}
-
-	err = regulator_enable(hdmi->pll);
-	if (err < 0) {
-		dev_err(hdmi->dev, "failed to enable PLL regulator: %d\n", err);
-		return err;
-	}
-
-	/*
-	 * This assumes that the display controller will divide its parent
-	 * clock by 2 to generate the pixel clock.
-	 */
-	err = tegra_output_setup_clock(output, hdmi->clk, pclk * 2);
-	if (err < 0) {
-		dev_err(hdmi->dev, "failed to setup clock: %d\n", err);
-		return err;
-	}
-
-	err = clk_set_rate(hdmi->clk, pclk);
-	if (err < 0)
-		return err;
-
-	err = clk_enable(hdmi->clk);
-	if (err < 0) {
-		dev_err(hdmi->dev, "failed to enable clock: %d\n", err);
-		return err;
-	}
-
-	tegra_periph_reset_assert(hdmi->clk);
-	usleep_range(1000, 2000);
-	tegra_periph_reset_deassert(hdmi->clk);
-
-	tegra_dc_writel(dc, VSYNC_H_POSITION(1),
-			DC_DISP_DISP_TIMING_OPTIONS);
-	tegra_dc_writel(dc, DITHER_CONTROL_DISABLE | BASE_COLOR_SIZE888,
-			DC_DISP_DISP_COLOR_CONTROL);
-
-	/* video_preamble uses h_pulse2 */
-	pulse_start = 1 + h_sync_width + h_back_porch - 10;
-
-	tegra_dc_writel(dc, H_PULSE_2_ENABLE, DC_DISP_DISP_SIGNAL_OPTIONS0);
-
-	value = PULSE_MODE_NORMAL | PULSE_POLARITY_HIGH | PULSE_QUAL_VACTIVE |
-		PULSE_LAST_END_A;
-	tegra_dc_writel(dc, value, DC_DISP_H_PULSE2_CONTROL);
-
-	value = PULSE_START(pulse_start) | PULSE_END(pulse_start + 8);
-	tegra_dc_writel(dc, value, DC_DISP_H_PULSE2_POSITION_A);
-
-	value = VSYNC_WINDOW_END(0x210) | VSYNC_WINDOW_START(0x200) |
-		VSYNC_WINDOW_ENABLE;
-	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_HDMI_VSYNC_WINDOW);
-
-	if (dc->pipe)
-		value = HDMI_SRC_DISPLAYB;
-	else
-		value = HDMI_SRC_DISPLAYA;
-
-	if ((mode->hdisplay == 720) && ((mode->vdisplay == 480) ||
-					(mode->vdisplay == 576)))
-		tegra_hdmi_writel(hdmi,
-				  value | ARM_VIDEO_RANGE_FULL,
-				  HDMI_NV_PDISP_INPUT_CONTROL);
-	else
-		tegra_hdmi_writel(hdmi,
-				  value | ARM_VIDEO_RANGE_LIMITED,
-				  HDMI_NV_PDISP_INPUT_CONTROL);
-
-	div82 = clk_get_rate(hdmi->clk) / 1000000 * 4;
-	value = SOR_REFCLK_DIV_INT(div82 >> 2) | SOR_REFCLK_DIV_FRAC(div82);
-	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_SOR_REFCLK);
-
-	if (!hdmi->dvi) {
-		err = tegra_hdmi_setup_audio(hdmi, pclk);
-		if (err < 0)
-			hdmi->dvi = true;
-	}
-
-	if (of_device_is_compatible(node, "nvidia,tegra20-hdmi")) {
-		/*
-		 * TODO: add ELD support
-		 */
-	}
-
-	rekey = HDMI_REKEY_DEFAULT;
-	value = HDMI_CTRL_REKEY(rekey);
-	value |= HDMI_CTRL_MAX_AC_PACKET((h_sync_width + h_back_porch +
-					  h_front_porch - rekey - 18) / 32);
-
-	if (!hdmi->dvi)
-		value |= HDMI_CTRL_ENABLE;
-
-	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_HDMI_CTRL);
-
-	if (hdmi->dvi)
-		tegra_hdmi_writel(hdmi, 0x0,
-				  HDMI_NV_PDISP_HDMI_GENERIC_CTRL);
-	else
-		tegra_hdmi_writel(hdmi, GENERIC_CTRL_AUDIO,
-				  HDMI_NV_PDISP_HDMI_GENERIC_CTRL);
-
-	tegra_hdmi_setup_avi_infoframe(hdmi, mode);
-	tegra_hdmi_setup_audio_infoframe(hdmi);
-	tegra_hdmi_setup_stereo_infoframe(hdmi);
-
-	/* TMDS CONFIG */
-	if (of_device_is_compatible(node, "nvidia,tegra30-hdmi")) {
-		num_tmds = ARRAY_SIZE(tegra3_tmds_config);
-		tmds = tegra3_tmds_config;
-	} else {
-		num_tmds = ARRAY_SIZE(tegra2_tmds_config);
-		tmds = tegra2_tmds_config;
-	}
-
-	for (i = 0; i < num_tmds; i++) {
-		if (pclk <= tmds[i].pclk) {
-			tegra_hdmi_setup_tmds(hdmi, &tmds[i]);
-			break;
-		}
-	}
-
-	tegra_hdmi_writel(hdmi,
-			  SOR_SEQ_CTL_PU_PC(0) |
-			  SOR_SEQ_PU_PC_ALT(0) |
-			  SOR_SEQ_PD_PC(8) |
-			  SOR_SEQ_PD_PC_ALT(8),
-			  HDMI_NV_PDISP_SOR_SEQ_CTL);
-
-	value = SOR_SEQ_INST_WAIT_TIME(1) |
-		SOR_SEQ_INST_WAIT_UNITS_VSYNC |
-		SOR_SEQ_INST_HALT |
-		SOR_SEQ_INST_PIN_A_LOW |
-		SOR_SEQ_INST_PIN_B_LOW |
-		SOR_SEQ_INST_DRIVE_PWM_OUT_LO;
-
-	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_SOR_SEQ_INST(0));
-	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_SOR_SEQ_INST(8));
-
-	value = 0x1c800;
-	value &= ~SOR_CSTM_ROTCLK(~0);
-	value |= SOR_CSTM_ROTCLK(2);
-	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_SOR_CSTM);
-
-	tegra_dc_writel(dc, DISP_CTRL_MODE_STOP, DC_CMD_DISPLAY_COMMAND);
-	tegra_dc_writel(dc, GENERAL_ACT_REQ << 8, DC_CMD_STATE_CONTROL);
-	tegra_dc_writel(dc, GENERAL_ACT_REQ, DC_CMD_STATE_CONTROL);
-
-	/* start SOR */
-	tegra_hdmi_writel(hdmi,
-			  SOR_PWR_NORMAL_STATE_PU |
-			  SOR_PWR_NORMAL_START_NORMAL |
-			  SOR_PWR_SAFE_STATE_PD |
-			  SOR_PWR_SETTING_NEW_TRIGGER,
-			  HDMI_NV_PDISP_SOR_PWR);
-	tegra_hdmi_writel(hdmi,
-			  SOR_PWR_NORMAL_STATE_PU |
-			  SOR_PWR_NORMAL_START_NORMAL |
-			  SOR_PWR_SAFE_STATE_PD |
-			  SOR_PWR_SETTING_NEW_DONE,
-			  HDMI_NV_PDISP_SOR_PWR);
-
-	do {
-		BUG_ON(--retries < 0);
-		value = tegra_hdmi_readl(hdmi, HDMI_NV_PDISP_SOR_PWR);
-	} while (value & SOR_PWR_SETTING_NEW_PENDING);
-
-	value = SOR_STATE_ASY_CRCMODE_COMPLETE |
-		SOR_STATE_ASY_OWNER_HEAD0 |
-		SOR_STATE_ASY_SUBOWNER_BOTH |
-		SOR_STATE_ASY_PROTOCOL_SINGLE_TMDS_A |
-		SOR_STATE_ASY_DEPOL_POS;
-
-	/* setup sync polarities */
-	if (mode->flags & DRM_MODE_FLAG_PHSYNC)
-		value |= SOR_STATE_ASY_HSYNCPOL_POS;
-
-	if (mode->flags & DRM_MODE_FLAG_NHSYNC)
-		value |= SOR_STATE_ASY_HSYNCPOL_NEG;
-
-	if (mode->flags & DRM_MODE_FLAG_PVSYNC)
-		value |= SOR_STATE_ASY_VSYNCPOL_POS;
-
-	if (mode->flags & DRM_MODE_FLAG_NVSYNC)
-		value |= SOR_STATE_ASY_VSYNCPOL_NEG;
-
-	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_SOR_STATE2);
-
-	value = SOR_STATE_ASY_HEAD_OPMODE_AWAKE | SOR_STATE_ASY_ORMODE_NORMAL;
-	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_SOR_STATE1);
-
-	tegra_hdmi_writel(hdmi, 0, HDMI_NV_PDISP_SOR_STATE0);
-	tegra_hdmi_writel(hdmi, SOR_STATE_UPDATE, HDMI_NV_PDISP_SOR_STATE0);
-	tegra_hdmi_writel(hdmi, value | SOR_STATE_ATTACHED,
-			  HDMI_NV_PDISP_SOR_STATE1);
-	tegra_hdmi_writel(hdmi, 0, HDMI_NV_PDISP_SOR_STATE0);
-
-	tegra_dc_writel(dc, HDMI_ENABLE, DC_DISP_DISP_WIN_OPTIONS);
-
-	value = PW0_ENABLE | PW1_ENABLE | PW2_ENABLE | PW3_ENABLE |
-		PW4_ENABLE | PM0_ENABLE | PM1_ENABLE;
-	tegra_dc_writel(dc, value, DC_CMD_DISPLAY_POWER_CONTROL);
-
-	value = DISP_CTRL_MODE_C_DISPLAY;
-	tegra_dc_writel(dc, value, DC_CMD_DISPLAY_COMMAND);
-
-	tegra_dc_writel(dc, GENERAL_ACT_REQ << 8, DC_CMD_STATE_CONTROL);
-	tegra_dc_writel(dc, GENERAL_ACT_REQ, DC_CMD_STATE_CONTROL);
-
-	/* TODO: add HDCP support */
-
-	return 0;
-}
-
-static int tegra_output_hdmi_disable(struct tegra_output *output)
-{
-	struct tegra_hdmi *hdmi = to_hdmi(output);
-
-	tegra_periph_reset_assert(hdmi->clk);
-	clk_disable(hdmi->clk);
-	regulator_disable(hdmi->pll);
-	regulator_disable(hdmi->vdd);
-
-	return 0;
-}
-
-static int tegra_output_hdmi_setup_clock(struct tegra_output *output,
-					 struct clk *clk, unsigned long pclk)
-{
-	struct tegra_hdmi *hdmi = to_hdmi(output);
-	struct clk *base;
-	int err;
-
-	err = clk_set_parent(clk, hdmi->clk_parent);
-	if (err < 0) {
-		dev_err(output->dev, "failed to set parent: %d\n", err);
-		return err;
-	}
-
-	base = clk_get_parent(hdmi->clk_parent);
-
-	/*
-	 * This assumes that the parent clock is pll_d_out0 or pll_d2_out
-	 * respectively, each of which divides the base pll_d by 2.
-	 */
-	err = clk_set_rate(base, pclk * 2);
-	if (err < 0)
-		dev_err(output->dev,
-			"failed to set base clock rate to %lu Hz\n",
-			pclk * 2);
-
-	return 0;
-}
-
-static int tegra_output_hdmi_check_mode(struct tegra_output *output,
-					struct drm_display_mode *mode,
-					enum drm_mode_status *status)
-{
-	struct tegra_hdmi *hdmi = to_hdmi(output);
-	unsigned long pclk = mode->clock * 1000;
-	struct clk *parent;
-	long err;
-
-	parent = clk_get_parent(hdmi->clk_parent);
-
-	err = clk_round_rate(parent, pclk * 4);
-	if (err < 0)
-		*status = MODE_NOCLOCK;
-	else
-		*status = MODE_OK;
-
-	return 0;
-}
-
-static const struct tegra_output_ops hdmi_ops = {
-	.enable = tegra_output_hdmi_enable,
-	.disable = tegra_output_hdmi_disable,
-	.setup_clock = tegra_output_hdmi_setup_clock,
-	.check_mode = tegra_output_hdmi_check_mode,
-};
-
-static int tegra_hdmi_show_regs(struct seq_file *s, void *data)
-{
-	struct drm_info_node *node = s->private;
-	struct tegra_hdmi *hdmi = node->info_ent->data;
-
-#define DUMP_REG(name)						\
-	seq_printf(s, "%-56s %#05x %08lx\n", #name, name,	\
-		tegra_hdmi_readl(hdmi, name))
-
-	DUMP_REG(HDMI_CTXSW);
-	DUMP_REG(HDMI_NV_PDISP_SOR_STATE0);
-	DUMP_REG(HDMI_NV_PDISP_SOR_STATE1);
-	DUMP_REG(HDMI_NV_PDISP_SOR_STATE2);
-	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_AN_MSB);
-	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_AN_LSB);
-	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_CN_MSB);
-	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_CN_LSB);
-	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_AKSV_MSB);
-	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_AKSV_LSB);
-	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_BKSV_MSB);
-	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_BKSV_LSB);
-	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_CKSV_MSB);
-	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_CKSV_LSB);
-	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_DKSV_MSB);
-	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_DKSV_LSB);
-	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_CTRL);
-	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_CMODE);
-	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_MPRIME_MSB);
-	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_MPRIME_LSB);
-	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_SPRIME_MSB);
-	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_SPRIME_LSB2);
-	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_SPRIME_LSB1);
-	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_RI);
-	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_CS_MSB);
-	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_CS_LSB);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_AUDIO_EMU0);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_AUDIO_EMU_RDATA0);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_AUDIO_EMU1);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_AUDIO_EMU2);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_CTRL);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_STATUS);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_HEADER);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_SUBPACK0_LOW);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_SUBPACK0_HIGH);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_CTRL);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_STATUS);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_HEADER);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_SUBPACK0_LOW);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_SUBPACK0_HIGH);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_SUBPACK1_LOW);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_SUBPACK1_HIGH);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_CTRL);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_STATUS);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_HEADER);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK0_LOW);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK0_HIGH);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK1_LOW);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK1_HIGH);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK2_LOW);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK2_HIGH);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK3_LOW);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK3_HIGH);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_CTRL);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_0320_SUBPACK_LOW);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_0320_SUBPACK_HIGH);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_0441_SUBPACK_LOW);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_0441_SUBPACK_HIGH);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_0882_SUBPACK_LOW);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_0882_SUBPACK_HIGH);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_1764_SUBPACK_LOW);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_1764_SUBPACK_HIGH);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_0480_SUBPACK_LOW);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_0480_SUBPACK_HIGH);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_0960_SUBPACK_LOW);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_0960_SUBPACK_HIGH);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_1920_SUBPACK_LOW);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_1920_SUBPACK_HIGH);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_CTRL);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_VSYNC_KEEPOUT);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_VSYNC_WINDOW);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_GCP_CTRL);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_GCP_STATUS);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_GCP_SUBPACK);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_CHANNEL_STATUS1);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_CHANNEL_STATUS2);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_EMU0);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_EMU1);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_EMU1_RDATA);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_SPARE);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_SPDIF_CHN_STATUS1);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_SPDIF_CHN_STATUS2);
-	DUMP_REG(HDMI_NV_PDISP_HDMI_HDCPRIF_ROM_CTRL);
-	DUMP_REG(HDMI_NV_PDISP_SOR_CAP);
-	DUMP_REG(HDMI_NV_PDISP_SOR_PWR);
-	DUMP_REG(HDMI_NV_PDISP_SOR_TEST);
-	DUMP_REG(HDMI_NV_PDISP_SOR_PLL0);
-	DUMP_REG(HDMI_NV_PDISP_SOR_PLL1);
-	DUMP_REG(HDMI_NV_PDISP_SOR_PLL2);
-	DUMP_REG(HDMI_NV_PDISP_SOR_CSTM);
-	DUMP_REG(HDMI_NV_PDISP_SOR_LVDS);
-	DUMP_REG(HDMI_NV_PDISP_SOR_CRCA);
-	DUMP_REG(HDMI_NV_PDISP_SOR_CRCB);
-	DUMP_REG(HDMI_NV_PDISP_SOR_BLANK);
-	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_CTL);
-	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(0));
-	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(1));
-	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(2));
-	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(3));
-	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(4));
-	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(5));
-	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(6));
-	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(7));
-	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(8));
-	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(9));
-	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(10));
-	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(11));
-	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(12));
-	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(13));
-	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(14));
-	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(15));
-	DUMP_REG(HDMI_NV_PDISP_SOR_VCRCA0);
-	DUMP_REG(HDMI_NV_PDISP_SOR_VCRCA1);
-	DUMP_REG(HDMI_NV_PDISP_SOR_CCRCA0);
-	DUMP_REG(HDMI_NV_PDISP_SOR_CCRCA1);
-	DUMP_REG(HDMI_NV_PDISP_SOR_EDATAA0);
-	DUMP_REG(HDMI_NV_PDISP_SOR_EDATAA1);
-	DUMP_REG(HDMI_NV_PDISP_SOR_COUNTA0);
-	DUMP_REG(HDMI_NV_PDISP_SOR_COUNTA1);
-	DUMP_REG(HDMI_NV_PDISP_SOR_DEBUGA0);
-	DUMP_REG(HDMI_NV_PDISP_SOR_DEBUGA1);
-	DUMP_REG(HDMI_NV_PDISP_SOR_TRIG);
-	DUMP_REG(HDMI_NV_PDISP_SOR_MSCHECK);
-	DUMP_REG(HDMI_NV_PDISP_SOR_LANE_DRIVE_CURRENT);
-	DUMP_REG(HDMI_NV_PDISP_AUDIO_DEBUG0);
-	DUMP_REG(HDMI_NV_PDISP_AUDIO_DEBUG1);
-	DUMP_REG(HDMI_NV_PDISP_AUDIO_DEBUG2);
-	DUMP_REG(HDMI_NV_PDISP_AUDIO_FS(0));
-	DUMP_REG(HDMI_NV_PDISP_AUDIO_FS(1));
-	DUMP_REG(HDMI_NV_PDISP_AUDIO_FS(2));
-	DUMP_REG(HDMI_NV_PDISP_AUDIO_FS(3));
-	DUMP_REG(HDMI_NV_PDISP_AUDIO_FS(4));
-	DUMP_REG(HDMI_NV_PDISP_AUDIO_FS(5));
-	DUMP_REG(HDMI_NV_PDISP_AUDIO_FS(6));
-	DUMP_REG(HDMI_NV_PDISP_AUDIO_PULSE_WIDTH);
-	DUMP_REG(HDMI_NV_PDISP_AUDIO_THRESHOLD);
-	DUMP_REG(HDMI_NV_PDISP_AUDIO_CNTRL0);
-	DUMP_REG(HDMI_NV_PDISP_AUDIO_N);
-	DUMP_REG(HDMI_NV_PDISP_HDCPRIF_ROM_TIMING);
-	DUMP_REG(HDMI_NV_PDISP_SOR_REFCLK);
-	DUMP_REG(HDMI_NV_PDISP_CRC_CONTROL);
-	DUMP_REG(HDMI_NV_PDISP_INPUT_CONTROL);
-	DUMP_REG(HDMI_NV_PDISP_SCRATCH);
-	DUMP_REG(HDMI_NV_PDISP_PE_CURRENT);
-	DUMP_REG(HDMI_NV_PDISP_KEY_CTRL);
-	DUMP_REG(HDMI_NV_PDISP_KEY_DEBUG0);
-	DUMP_REG(HDMI_NV_PDISP_KEY_DEBUG1);
-	DUMP_REG(HDMI_NV_PDISP_KEY_DEBUG2);
-	DUMP_REG(HDMI_NV_PDISP_KEY_HDCP_KEY_0);
-	DUMP_REG(HDMI_NV_PDISP_KEY_HDCP_KEY_1);
-	DUMP_REG(HDMI_NV_PDISP_KEY_HDCP_KEY_2);
-	DUMP_REG(HDMI_NV_PDISP_KEY_HDCP_KEY_3);
-	DUMP_REG(HDMI_NV_PDISP_KEY_HDCP_KEY_TRIG);
-	DUMP_REG(HDMI_NV_PDISP_KEY_SKEY_INDEX);
-	DUMP_REG(HDMI_NV_PDISP_SOR_AUDIO_CNTRL0);
-	DUMP_REG(HDMI_NV_PDISP_SOR_AUDIO_HDA_ELD_BUFWR);
-	DUMP_REG(HDMI_NV_PDISP_SOR_AUDIO_HDA_PRESENSE);
-
-#undef DUMP_REG
-
-	return 0;
-}
-
-static struct drm_info_list debugfs_files[] = {
-	{ "regs", tegra_hdmi_show_regs, 0, NULL },
-};
-
-static int tegra_hdmi_debugfs_init(struct tegra_hdmi *hdmi,
-				   struct drm_minor *minor)
-{
-	unsigned int i;
-	int err;
-
-	hdmi->debugfs = debugfs_create_dir("hdmi", minor->debugfs_root);
-	if (!hdmi->debugfs)
-		return -ENOMEM;
-
-	hdmi->debugfs_files = kmemdup(debugfs_files, sizeof(debugfs_files),
-				      GFP_KERNEL);
-	if (!hdmi->debugfs_files) {
-		err = -ENOMEM;
-		goto remove;
-	}
-
-	for (i = 0; i < ARRAY_SIZE(debugfs_files); i++)
-		hdmi->debugfs_files[i].data = hdmi;
-
-	err = drm_debugfs_create_files(hdmi->debugfs_files,
-				       ARRAY_SIZE(debugfs_files),
-				       hdmi->debugfs, minor);
-	if (err < 0)
-		goto free;
-
-	hdmi->minor = minor;
-
-	return 0;
-
-free:
-	kfree(hdmi->debugfs_files);
-	hdmi->debugfs_files = NULL;
-remove:
-	debugfs_remove(hdmi->debugfs);
-	hdmi->debugfs = NULL;
-
-	return err;
-}
-
-static int tegra_hdmi_debugfs_exit(struct tegra_hdmi *hdmi)
-{
-	drm_debugfs_remove_files(hdmi->debugfs_files, ARRAY_SIZE(debugfs_files),
-				 hdmi->minor);
-	hdmi->minor = NULL;
-
-	kfree(hdmi->debugfs_files);
-	hdmi->debugfs_files = NULL;
-
-	debugfs_remove(hdmi->debugfs);
-	hdmi->debugfs = NULL;
-
-	return 0;
-}
-
-static int tegra_hdmi_drm_init(struct host1x_client *client,
-			       struct drm_device *drm)
-{
-	struct tegra_hdmi *hdmi = host1x_client_to_hdmi(client);
-	int err;
-
-	hdmi->output.type = TEGRA_OUTPUT_HDMI;
-	hdmi->output.dev = client->dev;
-	hdmi->output.ops = &hdmi_ops;
-
-	err = tegra_output_init(drm, &hdmi->output);
-	if (err < 0) {
-		dev_err(client->dev, "output setup failed: %d\n", err);
-		return err;
-	}
-
-	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
-		err = tegra_hdmi_debugfs_init(hdmi, drm->primary);
-		if (err < 0)
-			dev_err(client->dev, "debugfs setup failed: %d\n", err);
-	}
-
-	return 0;
-}
-
-static int tegra_hdmi_drm_exit(struct host1x_client *client)
-{
-	struct tegra_hdmi *hdmi = host1x_client_to_hdmi(client);
-	int err;
-
-	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
-		err = tegra_hdmi_debugfs_exit(hdmi);
-		if (err < 0)
-			dev_err(client->dev, "debugfs cleanup failed: %d\n",
-				err);
-	}
-
-	err = tegra_output_disable(&hdmi->output);
-	if (err < 0) {
-		dev_err(client->dev, "output failed to disable: %d\n", err);
-		return err;
-	}
-
-	err = tegra_output_exit(&hdmi->output);
-	if (err < 0) {
-		dev_err(client->dev, "output cleanup failed: %d\n", err);
-		return err;
-	}
-
-	return 0;
-}
-
-static const struct host1x_client_ops hdmi_client_ops = {
-	.drm_init = tegra_hdmi_drm_init,
-	.drm_exit = tegra_hdmi_drm_exit,
-};
-
-static int tegra_hdmi_probe(struct platform_device *pdev)
-{
-	struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
-	struct tegra_hdmi *hdmi;
-	struct resource *regs;
-	int err;
-
-	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
-	if (!hdmi)
-		return -ENOMEM;
-
-	hdmi->dev = &pdev->dev;
-	hdmi->audio_source = AUTO;
-	hdmi->audio_freq = 44100;
-	hdmi->stereo = false;
-	hdmi->dvi = false;
-
-	hdmi->clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(hdmi->clk)) {
-		dev_err(&pdev->dev, "failed to get clock\n");
-		return PTR_ERR(hdmi->clk);
-	}
-
-	err = clk_prepare(hdmi->clk);
-	if (err < 0)
-		return err;
-
-	hdmi->clk_parent = devm_clk_get(&pdev->dev, "parent");
-	if (IS_ERR(hdmi->clk_parent))
-		return PTR_ERR(hdmi->clk_parent);
-
-	err = clk_prepare(hdmi->clk_parent);
-	if (err < 0)
-		return err;
-
-	err = clk_set_parent(hdmi->clk, hdmi->clk_parent);
-	if (err < 0) {
-		dev_err(&pdev->dev, "failed to setup clocks: %d\n", err);
-		return err;
-	}
-
-	hdmi->vdd = devm_regulator_get(&pdev->dev, "vdd");
-	if (IS_ERR(hdmi->vdd)) {
-		dev_err(&pdev->dev, "failed to get VDD regulator\n");
-		return PTR_ERR(hdmi->vdd);
-	}
-
-	hdmi->pll = devm_regulator_get(&pdev->dev, "pll");
-	if (IS_ERR(hdmi->pll)) {
-		dev_err(&pdev->dev, "failed to get PLL regulator\n");
-		return PTR_ERR(hdmi->pll);
-	}
-
-	hdmi->output.dev = &pdev->dev;
-
-	err = tegra_output_parse_dt(&hdmi->output);
-	if (err < 0)
-		return err;
-
-	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!regs)
-		return -ENXIO;
-
-	hdmi->regs = devm_request_and_ioremap(&pdev->dev, regs);
-	if (!hdmi->regs)
-		return -EADDRNOTAVAIL;
-
-	err = platform_get_irq(pdev, 0);
-	if (err < 0)
-		return err;
-
-	hdmi->irq = err;
-
-	hdmi->client.ops = &hdmi_client_ops;
-	INIT_LIST_HEAD(&hdmi->client.list);
-	hdmi->client.dev = &pdev->dev;
-
-	err = host1x_register_client(host1x, &hdmi->client);
-	if (err < 0) {
-		dev_err(&pdev->dev, "failed to register host1x client: %d\n",
-			err);
-		return err;
-	}
-
-	platform_set_drvdata(pdev, hdmi);
-
-	return 0;
-}
-
-static int tegra_hdmi_remove(struct platform_device *pdev)
-{
-	struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
-	struct tegra_hdmi *hdmi = platform_get_drvdata(pdev);
-	int err;
-
-	err = host1x_unregister_client(host1x, &hdmi->client);
-	if (err < 0) {
-		dev_err(&pdev->dev, "failed to unregister host1x client: %d\n",
-			err);
-		return err;
-	}
-
-	clk_unprepare(hdmi->clk_parent);
-	clk_unprepare(hdmi->clk);
-
-	return 0;
-}
-
-static struct of_device_id tegra_hdmi_of_match[] = {
-	{ .compatible = "nvidia,tegra30-hdmi", },
-	{ .compatible = "nvidia,tegra20-hdmi", },
-	{ },
-};
-
-struct platform_driver tegra_hdmi_driver = {
-	.driver = {
-		.name = "tegra-hdmi",
-		.owner = THIS_MODULE,
-		.of_match_table = tegra_hdmi_of_match,
-	},
-	.probe = tegra_hdmi_probe,
-	.remove = tegra_hdmi_remove,
-};
diff --git a/drivers/gpu/drm/tegra/hdmi.h b/drivers/gpu/drm/tegra/hdmi.h
deleted file mode 100644
index 1477f36..0000000
--- a/drivers/gpu/drm/tegra/hdmi.h
+++ /dev/null
@@ -1,575 +0,0 @@
-/*
- * Copyright (C) 2012 Avionic Design GmbH
- * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef TEGRA_HDMI_H
-#define TEGRA_HDMI_H 1
-
-#define HDMI_INFOFRAME_TYPE_VENDOR   0x81
-#define HDMI_INFOFRAME_TYPE_AVI      0x82
-#define HDMI_INFOFRAME_TYPE_SPD      0x83
-#define HDMI_INFOFRAME_TYPE_AUDIO    0x84
-#define HDMI_INFOFRAME_TYPE_MPEG_SRC 0x85
-#define HDMI_INFOFRAME_TYPE_NTSC_VBI 0x86
-
-/* all fields little endian */
-struct hdmi_avi_infoframe {
-	/* PB0 */
-	u8 csum;
-
-	/* PB1 */
-	unsigned s:2; /* scan information */
-	unsigned b:2; /* bar info data valid */
-	unsigned a:1; /* active info present */
-	unsigned y:2; /* RGB or YCbCr */
-	unsigned res1:1;
-
-	/* PB2 */
-	unsigned r:4; /* active format aspect ratio */
-	unsigned m:2; /* picture aspect ratio */
-	unsigned c:2; /* colorimetry */
-
-	/* PB3 */
-	unsigned sc:2;  /* scan information */
-	unsigned q:2;   /* quantization range */
-	unsigned ec:3;  /* extended colorimetry */
-	unsigned itc:1; /* it content */
-
-	/* PB4 */
-	unsigned vic:7; /* video format id code */
-	unsigned res4:1;
-
-	/* PB5 */
-	unsigned pr:4; /* pixel repetition factor */
-	unsigned cn:2; /* it content type*/
-	unsigned yq:2; /* ycc quantization range */
-
-	/* PB6-7 */
-	u16 top_bar_end_line;
-
-	/* PB8-9 */
-	u16 bot_bar_start_line;
-
-	/* PB10-11 */
-	u16 left_bar_end_pixel;
-
-	/* PB12-13 */
-	u16 right_bar_start_pixel;
-} __packed;
-
-#define HDMI_AVI_VERSION 0x02
-
-#define HDMI_AVI_Y_RGB       0x0
-#define HDMI_AVI_Y_YCBCR_422 0x1
-#define HDMI_AVI_Y_YCBCR_444 0x2
-
-#define HDMI_AVI_B_VERT  0x1
-#define HDMI_AVI_B_HORIZ 0x2
-
-#define HDMI_AVI_S_NONE      0x0
-#define HDMI_AVI_S_OVERSCAN  0x1
-#define HDMI_AVI_S_UNDERSCAN 0x2
-
-#define HDMI_AVI_C_NONE     0x0
-#define HDMI_AVI_C_SMPTE    0x1
-#define HDMI_AVI_C_ITU_R    0x2
-#define HDMI_AVI_C_EXTENDED 0x4
-
-#define HDMI_AVI_M_4_3  0x1
-#define HDMI_AVI_M_16_9 0x2
-
-#define HDMI_AVI_R_SAME        0x8
-#define HDMI_AVI_R_4_3_CENTER  0x9
-#define HDMI_AVI_R_16_9_CENTER 0xa
-#define HDMI_AVI_R_14_9_CENTER 0xb
-
-/* all fields little endian */
-struct hdmi_audio_infoframe {
-	/* PB0 */
-	u8 csum;
-
-	/* PB1 */
-	unsigned cc:3; /* channel count */
-	unsigned res1:1;
-	unsigned ct:4; /* coding type */
-
-	/* PB2 */
-	unsigned ss:2; /* sample size */
-	unsigned sf:3; /* sample frequency */
-	unsigned res2:3;
-
-	/* PB3 */
-	unsigned cxt:5; /* coding extention type */
-	unsigned res3:3;
-
-	/* PB4 */
-	u8 ca; /* channel/speaker allocation */
-
-	/* PB5 */
-	unsigned res5:3;
-	unsigned lsv:4; /* level shift value */
-	unsigned dm_inh:1; /* downmix inhibit */
-
-	/* PB6-10 reserved */
-	u8 res6;
-	u8 res7;
-	u8 res8;
-	u8 res9;
-	u8 res10;
-} __packed;
-
-#define HDMI_AUDIO_VERSION 0x01
-
-#define HDMI_AUDIO_CC_STREAM 0x0 /* specified by audio stream */
-#define HDMI_AUDIO_CC_2      0x1
-#define HDMI_AUDIO_CC_3      0x2
-#define HDMI_AUDIO_CC_4      0x3
-#define HDMI_AUDIO_CC_5      0x4
-#define HDMI_AUDIO_CC_6      0x5
-#define HDMI_AUDIO_CC_7      0x6
-#define HDMI_AUDIO_CC_8      0x7
-
-#define HDMI_AUDIO_CT_STREAM  0x0 /* specified by audio stream */
-#define HDMI_AUDIO_CT_PCM     0x1
-#define HDMI_AUDIO_CT_AC3     0x2
-#define HDMI_AUDIO_CT_MPEG1   0x3
-#define HDMI_AUDIO_CT_MP3     0x4
-#define HDMI_AUDIO_CT_MPEG2   0x5
-#define HDMI_AUDIO_CT_AAC_LC  0x6
-#define HDMI_AUDIO_CT_DTS     0x7
-#define HDMI_AUDIO_CT_ATRAC   0x8
-#define HDMI_AUDIO_CT_DSD     0x9
-#define HDMI_AUDIO_CT_E_AC3   0xa
-#define HDMI_AUDIO_CT_DTS_HD  0xb
-#define HDMI_AUDIO_CT_MLP     0xc
-#define HDMI_AUDIO_CT_DST     0xd
-#define HDMI_AUDIO_CT_WMA_PRO 0xe
-#define HDMI_AUDIO_CT_CXT     0xf
-
-#define HDMI_AUDIO_SF_STREAM 0x0 /* specified by audio stream */
-#define HDMI_AUIDO_SF_32K    0x1
-#define HDMI_AUDIO_SF_44_1K  0x2
-#define HDMI_AUDIO_SF_48K    0x3
-#define HDMI_AUDIO_SF_88_2K  0x4
-#define HDMI_AUDIO_SF_96K    0x5
-#define HDMI_AUDIO_SF_176_4K 0x6
-#define HDMI_AUDIO_SF_192K   0x7
-
-#define HDMI_AUDIO_SS_STREAM 0x0 /* specified by audio stream */
-#define HDMI_AUDIO_SS_16BIT  0x1
-#define HDMI_AUDIO_SS_20BIT  0x2
-#define HDMI_AUDIO_SS_24BIT  0x3
-
-#define HDMI_AUDIO_CXT_CT            0x0 /* refer to coding in CT */
-#define HDMI_AUDIO_CXT_HE_AAC        0x1
-#define HDMI_AUDIO_CXT_HE_AAC_V2     0x2
-#define HDMI_AUDIO_CXT_MPEG_SURROUND 0x3
-
-/* all fields little endian */
-struct hdmi_stereo_infoframe {
-	/* PB0 */
-	u8 csum;
-
-	/* PB1 */
-	u8 regid0;
-
-	/* PB2 */
-	u8 regid1;
-
-	/* PB3 */
-	u8 regid2;
-
-	/* PB4 */
-	unsigned res1:5;
-	unsigned hdmi_video_format:3;
-
-	/* PB5 */
-	unsigned res2:4;
-	unsigned _3d_structure:4;
-
-	/* PB6*/
-	unsigned res3:4;
-	unsigned _3d_ext_data:4;
-} __packed;
-
-#define HDMI_VENDOR_VERSION 0x01
-
-/* register definitions */
-#define HDMI_CTXSW						0x00
-
-#define HDMI_NV_PDISP_SOR_STATE0				0x01
-#define SOR_STATE_UPDATE (1 << 0)
-
-#define HDMI_NV_PDISP_SOR_STATE1				0x02
-#define SOR_STATE_ASY_HEAD_OPMODE_AWAKE (2 << 0)
-#define SOR_STATE_ASY_ORMODE_NORMAL     (1 << 2)
-#define SOR_STATE_ATTACHED              (1 << 3)
-
-#define HDMI_NV_PDISP_SOR_STATE2				0x03
-#define SOR_STATE_ASY_OWNER_NONE         (0 <<  0)
-#define SOR_STATE_ASY_OWNER_HEAD0        (1 <<  0)
-#define SOR_STATE_ASY_SUBOWNER_NONE      (0 <<  4)
-#define SOR_STATE_ASY_SUBOWNER_SUBHEAD0  (1 <<  4)
-#define SOR_STATE_ASY_SUBOWNER_SUBHEAD1  (2 <<  4)
-#define SOR_STATE_ASY_SUBOWNER_BOTH      (3 <<  4)
-#define SOR_STATE_ASY_CRCMODE_ACTIVE     (0 <<  6)
-#define SOR_STATE_ASY_CRCMODE_COMPLETE   (1 <<  6)
-#define SOR_STATE_ASY_CRCMODE_NON_ACTIVE (2 <<  6)
-#define SOR_STATE_ASY_PROTOCOL_SINGLE_TMDS_A (1 << 8)
-#define SOR_STATE_ASY_PROTOCOL_CUSTOM        (15 << 8)
-#define SOR_STATE_ASY_HSYNCPOL_POS       (0 << 12)
-#define SOR_STATE_ASY_HSYNCPOL_NEG       (1 << 12)
-#define SOR_STATE_ASY_VSYNCPOL_POS       (0 << 13)
-#define SOR_STATE_ASY_VSYNCPOL_NEG       (1 << 13)
-#define SOR_STATE_ASY_DEPOL_POS          (0 << 14)
-#define SOR_STATE_ASY_DEPOL_NEG          (1 << 14)
-
-#define HDMI_NV_PDISP_RG_HDCP_AN_MSB				0x04
-#define HDMI_NV_PDISP_RG_HDCP_AN_LSB				0x05
-#define HDMI_NV_PDISP_RG_HDCP_CN_MSB				0x06
-#define HDMI_NV_PDISP_RG_HDCP_CN_LSB				0x07
-#define HDMI_NV_PDISP_RG_HDCP_AKSV_MSB				0x08
-#define HDMI_NV_PDISP_RG_HDCP_AKSV_LSB				0x09
-#define HDMI_NV_PDISP_RG_HDCP_BKSV_MSB				0x0a
-#define HDMI_NV_PDISP_RG_HDCP_BKSV_LSB				0x0b
-#define HDMI_NV_PDISP_RG_HDCP_CKSV_MSB				0x0c
-#define HDMI_NV_PDISP_RG_HDCP_CKSV_LSB				0x0d
-#define HDMI_NV_PDISP_RG_HDCP_DKSV_MSB				0x0e
-#define HDMI_NV_PDISP_RG_HDCP_DKSV_LSB				0x0f
-#define HDMI_NV_PDISP_RG_HDCP_CTRL				0x10
-#define HDMI_NV_PDISP_RG_HDCP_CMODE				0x11
-#define HDMI_NV_PDISP_RG_HDCP_MPRIME_MSB			0x12
-#define HDMI_NV_PDISP_RG_HDCP_MPRIME_LSB			0x13
-#define HDMI_NV_PDISP_RG_HDCP_SPRIME_MSB			0x14
-#define HDMI_NV_PDISP_RG_HDCP_SPRIME_LSB2			0x15
-#define HDMI_NV_PDISP_RG_HDCP_SPRIME_LSB1			0x16
-#define HDMI_NV_PDISP_RG_HDCP_RI				0x17
-#define HDMI_NV_PDISP_RG_HDCP_CS_MSB				0x18
-#define HDMI_NV_PDISP_RG_HDCP_CS_LSB				0x19
-#define HDMI_NV_PDISP_HDMI_AUDIO_EMU0				0x1a
-#define HDMI_NV_PDISP_HDMI_AUDIO_EMU_RDATA0			0x1b
-#define HDMI_NV_PDISP_HDMI_AUDIO_EMU1				0x1c
-#define HDMI_NV_PDISP_HDMI_AUDIO_EMU2				0x1d
-
-#define HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_CTRL			0x1e
-#define HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_STATUS		0x1f
-#define HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_HEADER		0x20
-#define HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_SUBPACK0_LOW		0x21
-#define HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_SUBPACK0_HIGH	0x22
-#define HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_CTRL			0x23
-#define HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_STATUS			0x24
-#define HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_HEADER			0x25
-#define HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_SUBPACK0_LOW		0x26
-#define HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_SUBPACK0_HIGH		0x27
-#define HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_SUBPACK1_LOW		0x28
-#define HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_SUBPACK1_HIGH		0x29
-
-#define INFOFRAME_CTRL_ENABLE (1 << 0)
-
-#define INFOFRAME_HEADER_TYPE(x)    (((x) & 0xff) <<  0)
-#define INFOFRAME_HEADER_VERSION(x) (((x) & 0xff) <<  8)
-#define INFOFRAME_HEADER_LEN(x)     (((x) & 0x0f) << 16)
-
-#define HDMI_NV_PDISP_HDMI_GENERIC_CTRL				0x2a
-#define GENERIC_CTRL_ENABLE (1 <<  0)
-#define GENERIC_CTRL_OTHER  (1 <<  4)
-#define GENERIC_CTRL_SINGLE (1 <<  8)
-#define GENERIC_CTRL_HBLANK (1 << 12)
-#define GENERIC_CTRL_AUDIO  (1 << 16)
-
-#define HDMI_NV_PDISP_HDMI_GENERIC_STATUS			0x2b
-#define HDMI_NV_PDISP_HDMI_GENERIC_HEADER			0x2c
-#define HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK0_LOW			0x2d
-#define HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK0_HIGH		0x2e
-#define HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK1_LOW			0x2f
-#define HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK1_HIGH		0x30
-#define HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK2_LOW			0x31
-#define HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK2_HIGH		0x32
-#define HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK3_LOW			0x33
-#define HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK3_HIGH		0x34
-
-#define HDMI_NV_PDISP_HDMI_ACR_CTRL				0x35
-#define HDMI_NV_PDISP_HDMI_ACR_0320_SUBPACK_LOW			0x36
-#define HDMI_NV_PDISP_HDMI_ACR_0320_SUBPACK_HIGH		0x37
-#define HDMI_NV_PDISP_HDMI_ACR_0441_SUBPACK_LOW			0x38
-#define HDMI_NV_PDISP_HDMI_ACR_0441_SUBPACK_HIGH		0x39
-#define HDMI_NV_PDISP_HDMI_ACR_0882_SUBPACK_LOW			0x3a
-#define HDMI_NV_PDISP_HDMI_ACR_0882_SUBPACK_HIGH		0x3b
-#define HDMI_NV_PDISP_HDMI_ACR_1764_SUBPACK_LOW			0x3c
-#define HDMI_NV_PDISP_HDMI_ACR_1764_SUBPACK_HIGH		0x3d
-#define HDMI_NV_PDISP_HDMI_ACR_0480_SUBPACK_LOW			0x3e
-#define HDMI_NV_PDISP_HDMI_ACR_0480_SUBPACK_HIGH		0x3f
-#define HDMI_NV_PDISP_HDMI_ACR_0960_SUBPACK_LOW			0x40
-#define HDMI_NV_PDISP_HDMI_ACR_0960_SUBPACK_HIGH		0x41
-#define HDMI_NV_PDISP_HDMI_ACR_1920_SUBPACK_LOW			0x42
-#define HDMI_NV_PDISP_HDMI_ACR_1920_SUBPACK_HIGH		0x43
-
-#define ACR_SUBPACK_CTS(x) (((x) & 0xffffff) << 8)
-#define ACR_SUBPACK_N(x)   (((x) & 0xffffff) << 0)
-#define ACR_ENABLE         (1 << 31)
-
-#define HDMI_NV_PDISP_HDMI_CTRL					0x44
-#define HDMI_CTRL_REKEY(x)         (((x) & 0x7f) <<  0)
-#define HDMI_CTRL_MAX_AC_PACKET(x) (((x) & 0x1f) << 16)
-#define HDMI_CTRL_ENABLE           (1 << 30)
-
-#define HDMI_NV_PDISP_HDMI_VSYNC_KEEPOUT			0x45
-#define HDMI_NV_PDISP_HDMI_VSYNC_WINDOW				0x46
-#define VSYNC_WINDOW_END(x)   (((x) & 0x3ff) <<  0)
-#define VSYNC_WINDOW_START(x) (((x) & 0x3ff) << 16)
-#define VSYNC_WINDOW_ENABLE   (1 << 31)
-
-#define HDMI_NV_PDISP_HDMI_GCP_CTRL				0x47
-#define HDMI_NV_PDISP_HDMI_GCP_STATUS				0x48
-#define HDMI_NV_PDISP_HDMI_GCP_SUBPACK				0x49
-#define HDMI_NV_PDISP_HDMI_CHANNEL_STATUS1			0x4a
-#define HDMI_NV_PDISP_HDMI_CHANNEL_STATUS2			0x4b
-#define HDMI_NV_PDISP_HDMI_EMU0					0x4c
-#define HDMI_NV_PDISP_HDMI_EMU1					0x4d
-#define HDMI_NV_PDISP_HDMI_EMU1_RDATA				0x4e
-
-#define HDMI_NV_PDISP_HDMI_SPARE				0x4f
-#define SPARE_HW_CTS           (1 << 0)
-#define SPARE_FORCE_SW_CTS     (1 << 1)
-#define SPARE_CTS_RESET_VAL(x) (((x) & 0x7) << 16)
-
-#define HDMI_NV_PDISP_HDMI_SPDIF_CHN_STATUS1			0x50
-#define HDMI_NV_PDISP_HDMI_SPDIF_CHN_STATUS2			0x51
-#define HDMI_NV_PDISP_HDMI_HDCPRIF_ROM_CTRL			0x53
-#define HDMI_NV_PDISP_SOR_CAP					0x54
-#define HDMI_NV_PDISP_SOR_PWR					0x55
-#define SOR_PWR_NORMAL_STATE_PD     (0 <<  0)
-#define SOR_PWR_NORMAL_STATE_PU     (1 <<  0)
-#define SOR_PWR_NORMAL_START_NORMAL (0 <<  1)
-#define SOR_PWR_NORMAL_START_ALT    (1 <<  1)
-#define SOR_PWR_SAFE_STATE_PD       (0 << 16)
-#define SOR_PWR_SAFE_STATE_PU       (1 << 16)
-#define SOR_PWR_SETTING_NEW_DONE    (0 << 31)
-#define SOR_PWR_SETTING_NEW_PENDING (1 << 31)
-#define SOR_PWR_SETTING_NEW_TRIGGER (1 << 31)
-
-#define HDMI_NV_PDISP_SOR_TEST					0x56
-#define HDMI_NV_PDISP_SOR_PLL0					0x57
-#define SOR_PLL_PWR            (1 << 0)
-#define SOR_PLL_PDBG           (1 << 1)
-#define SOR_PLL_VCAPD          (1 << 2)
-#define SOR_PLL_PDPORT         (1 << 3)
-#define SOR_PLL_RESISTORSEL    (1 << 4)
-#define SOR_PLL_PULLDOWN       (1 << 5)
-#define SOR_PLL_VCOCAP(x)      (((x) & 0xf) <<  8)
-#define SOR_PLL_BG_V17_S(x)    (((x) & 0xf) << 12)
-#define SOR_PLL_FILTER(x)      (((x) & 0xf) << 16)
-#define SOR_PLL_ICHPMP(x)      (((x) & 0xf) << 24)
-#define SOR_PLL_TX_REG_LOAD(x) (((x) & 0xf) << 28)
-
-#define HDMI_NV_PDISP_SOR_PLL1					0x58
-#define SOR_PLL_TMDS_TERM_ENABLE (1 << 8)
-#define SOR_PLL_TMDS_TERMADJ(x)  (((x) & 0xf) <<  9)
-#define SOR_PLL_LOADADJ(x)       (((x) & 0xf) << 20)
-#define SOR_PLL_PE_EN            (1 << 28)
-#define SOR_PLL_HALF_FULL_PE     (1 << 29)
-#define SOR_PLL_S_D_PIN_PE       (1 << 30)
-
-#define HDMI_NV_PDISP_SOR_PLL2					0x59
-
-#define HDMI_NV_PDISP_SOR_CSTM					0x5a
-#define SOR_CSTM_ROTCLK(x) (((x) & 0xf) << 24)
-
-#define HDMI_NV_PDISP_SOR_LVDS					0x5b
-#define HDMI_NV_PDISP_SOR_CRCA					0x5c
-#define HDMI_NV_PDISP_SOR_CRCB					0x5d
-#define HDMI_NV_PDISP_SOR_BLANK					0x5e
-#define HDMI_NV_PDISP_SOR_SEQ_CTL				0x5f
-#define SOR_SEQ_CTL_PU_PC(x) (((x) & 0xf) <<  0)
-#define SOR_SEQ_PU_PC_ALT(x) (((x) & 0xf) <<  4)
-#define SOR_SEQ_PD_PC(x)     (((x) & 0xf) <<  8)
-#define SOR_SEQ_PD_PC_ALT(x) (((x) & 0xf) << 12)
-#define SOR_SEQ_PC(x)        (((x) & 0xf) << 16)
-#define SOR_SEQ_STATUS       (1 << 28)
-#define SOR_SEQ_SWITCH       (1 << 30)
-
-#define HDMI_NV_PDISP_SOR_SEQ_INST(x)				(0x60 + (x))
-
-#define SOR_SEQ_INST_WAIT_TIME(x)     (((x) & 0x3ff) << 0)
-#define SOR_SEQ_INST_WAIT_UNITS_VSYNC (2 << 12)
-#define SOR_SEQ_INST_HALT             (1 << 15)
-#define SOR_SEQ_INST_PIN_A_LOW        (0 << 21)
-#define SOR_SEQ_INST_PIN_A_HIGH       (1 << 21)
-#define SOR_SEQ_INST_PIN_B_LOW        (0 << 22)
-#define SOR_SEQ_INST_PIN_B_HIGH       (1 << 22)
-#define SOR_SEQ_INST_DRIVE_PWM_OUT_LO (1 << 23)
-
-#define HDMI_NV_PDISP_SOR_VCRCA0				0x72
-#define HDMI_NV_PDISP_SOR_VCRCA1				0x73
-#define HDMI_NV_PDISP_SOR_CCRCA0				0x74
-#define HDMI_NV_PDISP_SOR_CCRCA1				0x75
-#define HDMI_NV_PDISP_SOR_EDATAA0				0x76
-#define HDMI_NV_PDISP_SOR_EDATAA1				0x77
-#define HDMI_NV_PDISP_SOR_COUNTA0				0x78
-#define HDMI_NV_PDISP_SOR_COUNTA1				0x79
-#define HDMI_NV_PDISP_SOR_DEBUGA0				0x7a
-#define HDMI_NV_PDISP_SOR_DEBUGA1				0x7b
-#define HDMI_NV_PDISP_SOR_TRIG					0x7c
-#define HDMI_NV_PDISP_SOR_MSCHECK				0x7d
-
-#define HDMI_NV_PDISP_SOR_LANE_DRIVE_CURRENT			0x7e
-#define DRIVE_CURRENT_LANE0(x)      (((x) & 0x3f) <<  0)
-#define DRIVE_CURRENT_LANE1(x)      (((x) & 0x3f) <<  8)
-#define DRIVE_CURRENT_LANE2(x)      (((x) & 0x3f) << 16)
-#define DRIVE_CURRENT_LANE3(x)      (((x) & 0x3f) << 24)
-#define DRIVE_CURRENT_FUSE_OVERRIDE (1 << 31)
-
-#define DRIVE_CURRENT_1_500_mA  0x00
-#define DRIVE_CURRENT_1_875_mA  0x01
-#define DRIVE_CURRENT_2_250_mA  0x02
-#define DRIVE_CURRENT_2_625_mA  0x03
-#define DRIVE_CURRENT_3_000_mA  0x04
-#define DRIVE_CURRENT_3_375_mA  0x05
-#define DRIVE_CURRENT_3_750_mA  0x06
-#define DRIVE_CURRENT_4_125_mA  0x07
-#define DRIVE_CURRENT_4_500_mA  0x08
-#define DRIVE_CURRENT_4_875_mA  0x09
-#define DRIVE_CURRENT_5_250_mA  0x0a
-#define DRIVE_CURRENT_5_625_mA  0x0b
-#define DRIVE_CURRENT_6_000_mA  0x0c
-#define DRIVE_CURRENT_6_375_mA  0x0d
-#define DRIVE_CURRENT_6_750_mA  0x0e
-#define DRIVE_CURRENT_7_125_mA  0x0f
-#define DRIVE_CURRENT_7_500_mA  0x10
-#define DRIVE_CURRENT_7_875_mA  0x11
-#define DRIVE_CURRENT_8_250_mA  0x12
-#define DRIVE_CURRENT_8_625_mA  0x13
-#define DRIVE_CURRENT_9_000_mA  0x14
-#define DRIVE_CURRENT_9_375_mA  0x15
-#define DRIVE_CURRENT_9_750_mA  0x16
-#define DRIVE_CURRENT_10_125_mA 0x17
-#define DRIVE_CURRENT_10_500_mA 0x18
-#define DRIVE_CURRENT_10_875_mA 0x19
-#define DRIVE_CURRENT_11_250_mA 0x1a
-#define DRIVE_CURRENT_11_625_mA 0x1b
-#define DRIVE_CURRENT_12_000_mA 0x1c
-#define DRIVE_CURRENT_12_375_mA 0x1d
-#define DRIVE_CURRENT_12_750_mA 0x1e
-#define DRIVE_CURRENT_13_125_mA 0x1f
-#define DRIVE_CURRENT_13_500_mA 0x20
-#define DRIVE_CURRENT_13_875_mA 0x21
-#define DRIVE_CURRENT_14_250_mA 0x22
-#define DRIVE_CURRENT_14_625_mA 0x23
-#define DRIVE_CURRENT_15_000_mA 0x24
-#define DRIVE_CURRENT_15_375_mA 0x25
-#define DRIVE_CURRENT_15_750_mA 0x26
-#define DRIVE_CURRENT_16_125_mA 0x27
-#define DRIVE_CURRENT_16_500_mA 0x28
-#define DRIVE_CURRENT_16_875_mA 0x29
-#define DRIVE_CURRENT_17_250_mA 0x2a
-#define DRIVE_CURRENT_17_625_mA 0x2b
-#define DRIVE_CURRENT_18_000_mA 0x2c
-#define DRIVE_CURRENT_18_375_mA 0x2d
-#define DRIVE_CURRENT_18_750_mA 0x2e
-#define DRIVE_CURRENT_19_125_mA 0x2f
-#define DRIVE_CURRENT_19_500_mA 0x30
-#define DRIVE_CURRENT_19_875_mA 0x31
-#define DRIVE_CURRENT_20_250_mA 0x32
-#define DRIVE_CURRENT_20_625_mA 0x33
-#define DRIVE_CURRENT_21_000_mA 0x34
-#define DRIVE_CURRENT_21_375_mA 0x35
-#define DRIVE_CURRENT_21_750_mA 0x36
-#define DRIVE_CURRENT_22_125_mA 0x37
-#define DRIVE_CURRENT_22_500_mA 0x38
-#define DRIVE_CURRENT_22_875_mA 0x39
-#define DRIVE_CURRENT_23_250_mA 0x3a
-#define DRIVE_CURRENT_23_625_mA 0x3b
-#define DRIVE_CURRENT_24_000_mA 0x3c
-#define DRIVE_CURRENT_24_375_mA 0x3d
-#define DRIVE_CURRENT_24_750_mA 0x3e
-
-#define HDMI_NV_PDISP_AUDIO_DEBUG0				0x7f
-#define HDMI_NV_PDISP_AUDIO_DEBUG1				0x80
-#define HDMI_NV_PDISP_AUDIO_DEBUG2				0x81
-
-#define HDMI_NV_PDISP_AUDIO_FS(x)				(0x82 + (x))
-#define AUDIO_FS_LOW(x)  (((x) & 0xfff) <<  0)
-#define AUDIO_FS_HIGH(x) (((x) & 0xfff) << 16)
-
-#define HDMI_NV_PDISP_AUDIO_PULSE_WIDTH				0x89
-#define HDMI_NV_PDISP_AUDIO_THRESHOLD				0x8a
-#define HDMI_NV_PDISP_AUDIO_CNTRL0				0x8b
-#define AUDIO_CNTRL0_ERROR_TOLERANCE(x)  (((x) & 0xff) << 0)
-#define AUDIO_CNTRL0_SOURCE_SELECT_AUTO  (0 << 20)
-#define AUDIO_CNTRL0_SOURCE_SELECT_SPDIF (1 << 20)
-#define AUDIO_CNTRL0_SOURCE_SELECT_HDAL  (2 << 20)
-#define AUDIO_CNTRL0_FRAMES_PER_BLOCK(x) (((x) & 0xff) << 24)
-
-#define HDMI_NV_PDISP_AUDIO_N					0x8c
-#define AUDIO_N_VALUE(x)           (((x) & 0xfffff) << 0)
-#define AUDIO_N_RESETF             (1 << 20)
-#define AUDIO_N_GENERATE_NORMAL    (0 << 24)
-#define AUDIO_N_GENERATE_ALTERNATE (1 << 24)
-
-#define HDMI_NV_PDISP_HDCPRIF_ROM_TIMING			0x94
-#define HDMI_NV_PDISP_SOR_REFCLK				0x95
-#define SOR_REFCLK_DIV_INT(x)  (((x) & 0xff) << 8)
-#define SOR_REFCLK_DIV_FRAC(x) (((x) & 0x03) << 6)
-
-#define HDMI_NV_PDISP_CRC_CONTROL				0x96
-#define HDMI_NV_PDISP_INPUT_CONTROL				0x97
-#define HDMI_SRC_DISPLAYA       (0 << 0)
-#define HDMI_SRC_DISPLAYB       (1 << 0)
-#define ARM_VIDEO_RANGE_FULL    (0 << 1)
-#define ARM_VIDEO_RANGE_LIMITED (1 << 1)
-
-#define HDMI_NV_PDISP_SCRATCH					0x98
-#define HDMI_NV_PDISP_PE_CURRENT				0x99
-#define PE_CURRENT0(x) (((x) & 0xf) << 0)
-#define PE_CURRENT1(x) (((x) & 0xf) << 8)
-#define PE_CURRENT2(x) (((x) & 0xf) << 16)
-#define PE_CURRENT3(x) (((x) & 0xf) << 24)
-
-#define PE_CURRENT_0_0_mA 0x0
-#define PE_CURRENT_0_5_mA 0x1
-#define PE_CURRENT_1_0_mA 0x2
-#define PE_CURRENT_1_5_mA 0x3
-#define PE_CURRENT_2_0_mA 0x4
-#define PE_CURRENT_2_5_mA 0x5
-#define PE_CURRENT_3_0_mA 0x6
-#define PE_CURRENT_3_5_mA 0x7
-#define PE_CURRENT_4_0_mA 0x8
-#define PE_CURRENT_4_5_mA 0x9
-#define PE_CURRENT_5_0_mA 0xa
-#define PE_CURRENT_5_5_mA 0xb
-#define PE_CURRENT_6_0_mA 0xc
-#define PE_CURRENT_6_5_mA 0xd
-#define PE_CURRENT_7_0_mA 0xe
-#define PE_CURRENT_7_5_mA 0xf
-
-#define HDMI_NV_PDISP_KEY_CTRL					0x9a
-#define HDMI_NV_PDISP_KEY_DEBUG0				0x9b
-#define HDMI_NV_PDISP_KEY_DEBUG1				0x9c
-#define HDMI_NV_PDISP_KEY_DEBUG2				0x9d
-#define HDMI_NV_PDISP_KEY_HDCP_KEY_0				0x9e
-#define HDMI_NV_PDISP_KEY_HDCP_KEY_1				0x9f
-#define HDMI_NV_PDISP_KEY_HDCP_KEY_2				0xa0
-#define HDMI_NV_PDISP_KEY_HDCP_KEY_3				0xa1
-#define HDMI_NV_PDISP_KEY_HDCP_KEY_TRIG				0xa2
-#define HDMI_NV_PDISP_KEY_SKEY_INDEX				0xa3
-
-#define HDMI_NV_PDISP_SOR_AUDIO_CNTRL0				0xac
-#define AUDIO_CNTRL0_INJECT_NULLSMPL (1 << 29)
-#define HDMI_NV_PDISP_SOR_AUDIO_HDA_ELD_BUFWR			0xbc
-#define HDMI_NV_PDISP_SOR_AUDIO_HDA_PRESENSE			0xbd
-
-#define HDMI_NV_PDISP_SOR_AUDIO_AVAL_0320    0xbf
-#define HDMI_NV_PDISP_SOR_AUDIO_AVAL_0441    0xc0
-#define HDMI_NV_PDISP_SOR_AUDIO_AVAL_0882    0xc1
-#define HDMI_NV_PDISP_SOR_AUDIO_AVAL_1764    0xc2
-#define HDMI_NV_PDISP_SOR_AUDIO_AVAL_0480    0xc3
-#define HDMI_NV_PDISP_SOR_AUDIO_AVAL_0960    0xc4
-#define HDMI_NV_PDISP_SOR_AUDIO_AVAL_1920    0xc5
-#define HDMI_NV_PDISP_SOR_AUDIO_AVAL_DEFAULT 0xc5
-
-#endif /* TEGRA_HDMI_H */
diff --git a/drivers/gpu/drm/tegra/host1x.c b/drivers/gpu/drm/tegra/host1x.c
deleted file mode 100644
index 5d17b11..0000000
--- a/drivers/gpu/drm/tegra/host1x.c
+++ /dev/null
@@ -1,327 +0,0 @@
-/*
- * Copyright (C) 2012 Avionic Design GmbH
- * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/clk.h>
-#include <linux/err.h>
-#include <linux/module.h>
-#include <linux/of.h>
-#include <linux/platform_device.h>
-
-#include "drm.h"
-
-struct host1x_drm_client {
-	struct host1x_client *client;
-	struct device_node *np;
-	struct list_head list;
-};
-
-static int host1x_add_drm_client(struct host1x *host1x, struct device_node *np)
-{
-	struct host1x_drm_client *client;
-
-	client = kzalloc(sizeof(*client), GFP_KERNEL);
-	if (!client)
-		return -ENOMEM;
-
-	INIT_LIST_HEAD(&client->list);
-	client->np = of_node_get(np);
-
-	list_add_tail(&client->list, &host1x->drm_clients);
-
-	return 0;
-}
-
-static int host1x_activate_drm_client(struct host1x *host1x,
-				      struct host1x_drm_client *drm,
-				      struct host1x_client *client)
-{
-	mutex_lock(&host1x->drm_clients_lock);
-	list_del_init(&drm->list);
-	list_add_tail(&drm->list, &host1x->drm_active);
-	drm->client = client;
-	mutex_unlock(&host1x->drm_clients_lock);
-
-	return 0;
-}
-
-static int host1x_remove_drm_client(struct host1x *host1x,
-				    struct host1x_drm_client *client)
-{
-	mutex_lock(&host1x->drm_clients_lock);
-	list_del_init(&client->list);
-	mutex_unlock(&host1x->drm_clients_lock);
-
-	of_node_put(client->np);
-	kfree(client);
-
-	return 0;
-}
-
-static int host1x_parse_dt(struct host1x *host1x)
-{
-	static const char * const compat[] = {
-		"nvidia,tegra20-dc",
-		"nvidia,tegra20-hdmi",
-		"nvidia,tegra30-dc",
-		"nvidia,tegra30-hdmi",
-	};
-	unsigned int i;
-	int err;
-
-	for (i = 0; i < ARRAY_SIZE(compat); i++) {
-		struct device_node *np;
-
-		for_each_child_of_node(host1x->dev->of_node, np) {
-			if (of_device_is_compatible(np, compat[i]) &&
-			    of_device_is_available(np)) {
-				err = host1x_add_drm_client(host1x, np);
-				if (err < 0)
-					return err;
-			}
-		}
-	}
-
-	return 0;
-}
-
-static int tegra_host1x_probe(struct platform_device *pdev)
-{
-	struct host1x *host1x;
-	struct resource *regs;
-	int err;
-
-	host1x = devm_kzalloc(&pdev->dev, sizeof(*host1x), GFP_KERNEL);
-	if (!host1x)
-		return -ENOMEM;
-
-	mutex_init(&host1x->drm_clients_lock);
-	INIT_LIST_HEAD(&host1x->drm_clients);
-	INIT_LIST_HEAD(&host1x->drm_active);
-	mutex_init(&host1x->clients_lock);
-	INIT_LIST_HEAD(&host1x->clients);
-	host1x->dev = &pdev->dev;
-
-	err = host1x_parse_dt(host1x);
-	if (err < 0) {
-		dev_err(&pdev->dev, "failed to parse DT: %d\n", err);
-		return err;
-	}
-
-	host1x->clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(host1x->clk))
-		return PTR_ERR(host1x->clk);
-
-	err = clk_prepare_enable(host1x->clk);
-	if (err < 0)
-		return err;
-
-	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!regs) {
-		err = -ENXIO;
-		goto err;
-	}
-
-	err = platform_get_irq(pdev, 0);
-	if (err < 0)
-		goto err;
-
-	host1x->syncpt = err;
-
-	err = platform_get_irq(pdev, 1);
-	if (err < 0)
-		goto err;
-
-	host1x->irq = err;
-
-	host1x->regs = devm_request_and_ioremap(&pdev->dev, regs);
-	if (!host1x->regs) {
-		err = -EADDRNOTAVAIL;
-		goto err;
-	}
-
-	platform_set_drvdata(pdev, host1x);
-
-	return 0;
-
-err:
-	clk_disable_unprepare(host1x->clk);
-	return err;
-}
-
-static int tegra_host1x_remove(struct platform_device *pdev)
-{
-	struct host1x *host1x = platform_get_drvdata(pdev);
-
-	clk_disable_unprepare(host1x->clk);
-
-	return 0;
-}
-
-int host1x_drm_init(struct host1x *host1x, struct drm_device *drm)
-{
-	struct host1x_client *client;
-
-	mutex_lock(&host1x->clients_lock);
-
-	list_for_each_entry(client, &host1x->clients, list) {
-		if (client->ops && client->ops->drm_init) {
-			int err = client->ops->drm_init(client, drm);
-			if (err < 0) {
-				dev_err(host1x->dev,
-					"DRM setup failed for %s: %d\n",
-					dev_name(client->dev), err);
-				return err;
-			}
-		}
-	}
-
-	mutex_unlock(&host1x->clients_lock);
-
-	return 0;
-}
-
-int host1x_drm_exit(struct host1x *host1x)
-{
-	struct platform_device *pdev = to_platform_device(host1x->dev);
-	struct host1x_client *client;
-
-	if (!host1x->drm)
-		return 0;
-
-	mutex_lock(&host1x->clients_lock);
-
-	list_for_each_entry_reverse(client, &host1x->clients, list) {
-		if (client->ops && client->ops->drm_exit) {
-			int err = client->ops->drm_exit(client);
-			if (err < 0) {
-				dev_err(host1x->dev,
-					"DRM cleanup failed for %s: %d\n",
-					dev_name(client->dev), err);
-				return err;
-			}
-		}
-	}
-
-	mutex_unlock(&host1x->clients_lock);
-
-	drm_platform_exit(&tegra_drm_driver, pdev);
-	host1x->drm = NULL;
-
-	return 0;
-}
-
-int host1x_register_client(struct host1x *host1x, struct host1x_client *client)
-{
-	struct host1x_drm_client *drm, *tmp;
-	int err;
-
-	mutex_lock(&host1x->clients_lock);
-	list_add_tail(&client->list, &host1x->clients);
-	mutex_unlock(&host1x->clients_lock);
-
-	list_for_each_entry_safe(drm, tmp, &host1x->drm_clients, list)
-		if (drm->np == client->dev->of_node)
-			host1x_activate_drm_client(host1x, drm, client);
-
-	if (list_empty(&host1x->drm_clients)) {
-		struct platform_device *pdev = to_platform_device(host1x->dev);
-
-		err = drm_platform_init(&tegra_drm_driver, pdev);
-		if (err < 0) {
-			dev_err(host1x->dev, "drm_platform_init(): %d\n", err);
-			return err;
-		}
-	}
-
-	client->host1x = host1x;
-
-	return 0;
-}
-
-int host1x_unregister_client(struct host1x *host1x,
-			     struct host1x_client *client)
-{
-	struct host1x_drm_client *drm, *tmp;
-	int err;
-
-	list_for_each_entry_safe(drm, tmp, &host1x->drm_active, list) {
-		if (drm->client == client) {
-			err = host1x_drm_exit(host1x);
-			if (err < 0) {
-				dev_err(host1x->dev, "host1x_drm_exit(): %d\n",
-					err);
-				return err;
-			}
-
-			host1x_remove_drm_client(host1x, drm);
-			break;
-		}
-	}
-
-	mutex_lock(&host1x->clients_lock);
-	list_del_init(&client->list);
-	mutex_unlock(&host1x->clients_lock);
-
-	return 0;
-}
-
-static struct of_device_id tegra_host1x_of_match[] = {
-	{ .compatible = "nvidia,tegra30-host1x", },
-	{ .compatible = "nvidia,tegra20-host1x", },
-	{ },
-};
-MODULE_DEVICE_TABLE(of, tegra_host1x_of_match);
-
-struct platform_driver tegra_host1x_driver = {
-	.driver = {
-		.name = "tegra-host1x",
-		.owner = THIS_MODULE,
-		.of_match_table = tegra_host1x_of_match,
-	},
-	.probe = tegra_host1x_probe,
-	.remove = tegra_host1x_remove,
-};
-
-static int __init tegra_host1x_init(void)
-{
-	int err;
-
-	err = platform_driver_register(&tegra_host1x_driver);
-	if (err < 0)
-		return err;
-
-	err = platform_driver_register(&tegra_dc_driver);
-	if (err < 0)
-		goto unregister_host1x;
-
-	err = platform_driver_register(&tegra_hdmi_driver);
-	if (err < 0)
-		goto unregister_dc;
-
-	return 0;
-
-unregister_dc:
-	platform_driver_unregister(&tegra_dc_driver);
-unregister_host1x:
-	platform_driver_unregister(&tegra_host1x_driver);
-	return err;
-}
-module_init(tegra_host1x_init);
-
-static void __exit tegra_host1x_exit(void)
-{
-	platform_driver_unregister(&tegra_hdmi_driver);
-	platform_driver_unregister(&tegra_dc_driver);
-	platform_driver_unregister(&tegra_host1x_driver);
-}
-module_exit(tegra_host1x_exit);
-
-MODULE_AUTHOR("Thierry Reding <thierry.reding@avionic-design.de>");
-MODULE_DESCRIPTION("NVIDIA Tegra DRM driver");
-MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/drm/tegra/output.c b/drivers/gpu/drm/tegra/output.c
deleted file mode 100644
index 8140fc6..0000000
--- a/drivers/gpu/drm/tegra/output.c
+++ /dev/null
@@ -1,272 +0,0 @@
-/*
- * Copyright (C) 2012 Avionic Design GmbH
- * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/of_gpio.h>
-#include <linux/of_i2c.h>
-
-#include "drm.h"
-
-static int tegra_connector_get_modes(struct drm_connector *connector)
-{
-	struct tegra_output *output = connector_to_output(connector);
-	struct edid *edid = NULL;
-	int err = 0;
-
-	if (output->edid)
-		edid = kmemdup(output->edid, sizeof(*edid), GFP_KERNEL);
-	else if (output->ddc)
-		edid = drm_get_edid(connector, output->ddc);
-
-	drm_mode_connector_update_edid_property(connector, edid);
-
-	if (edid) {
-		err = drm_add_edid_modes(connector, edid);
-		kfree(edid);
-	}
-
-	return err;
-}
-
-static int tegra_connector_mode_valid(struct drm_connector *connector,
-				      struct drm_display_mode *mode)
-{
-	struct tegra_output *output = connector_to_output(connector);
-	enum drm_mode_status status = MODE_OK;
-	int err;
-
-	err = tegra_output_check_mode(output, mode, &status);
-	if (err < 0)
-		return MODE_ERROR;
-
-	return status;
-}
-
-static struct drm_encoder *
-tegra_connector_best_encoder(struct drm_connector *connector)
-{
-	struct tegra_output *output = connector_to_output(connector);
-
-	return &output->encoder;
-}
-
-static const struct drm_connector_helper_funcs connector_helper_funcs = {
-	.get_modes = tegra_connector_get_modes,
-	.mode_valid = tegra_connector_mode_valid,
-	.best_encoder = tegra_connector_best_encoder,
-};
-
-static enum drm_connector_status
-tegra_connector_detect(struct drm_connector *connector, bool force)
-{
-	struct tegra_output *output = connector_to_output(connector);
-	enum drm_connector_status status = connector_status_unknown;
-
-	if (gpio_is_valid(output->hpd_gpio)) {
-		if (gpio_get_value(output->hpd_gpio) == 0)
-			status = connector_status_disconnected;
-		else
-			status = connector_status_connected;
-	} else {
-		if (connector->connector_type == DRM_MODE_CONNECTOR_LVDS)
-			status = connector_status_connected;
-	}
-
-	return status;
-}
-
-static void tegra_connector_destroy(struct drm_connector *connector)
-{
-	drm_sysfs_connector_remove(connector);
-	drm_connector_cleanup(connector);
-}
-
-static const struct drm_connector_funcs connector_funcs = {
-	.dpms = drm_helper_connector_dpms,
-	.detect = tegra_connector_detect,
-	.fill_modes = drm_helper_probe_single_connector_modes,
-	.destroy = tegra_connector_destroy,
-};
-
-static void tegra_encoder_destroy(struct drm_encoder *encoder)
-{
-	drm_encoder_cleanup(encoder);
-}
-
-static const struct drm_encoder_funcs encoder_funcs = {
-	.destroy = tegra_encoder_destroy,
-};
-
-static void tegra_encoder_dpms(struct drm_encoder *encoder, int mode)
-{
-}
-
-static bool tegra_encoder_mode_fixup(struct drm_encoder *encoder,
-				     const struct drm_display_mode *mode,
-				     struct drm_display_mode *adjusted)
-{
-	return true;
-}
-
-static void tegra_encoder_prepare(struct drm_encoder *encoder)
-{
-}
-
-static void tegra_encoder_commit(struct drm_encoder *encoder)
-{
-}
-
-static void tegra_encoder_mode_set(struct drm_encoder *encoder,
-				   struct drm_display_mode *mode,
-				   struct drm_display_mode *adjusted)
-{
-	struct tegra_output *output = encoder_to_output(encoder);
-	int err;
-
-	err = tegra_output_enable(output);
-	if (err < 0)
-		dev_err(encoder->dev->dev, "tegra_output_enable(): %d\n", err);
-}
-
-static const struct drm_encoder_helper_funcs encoder_helper_funcs = {
-	.dpms = tegra_encoder_dpms,
-	.mode_fixup = tegra_encoder_mode_fixup,
-	.prepare = tegra_encoder_prepare,
-	.commit = tegra_encoder_commit,
-	.mode_set = tegra_encoder_mode_set,
-};
-
-static irqreturn_t hpd_irq(int irq, void *data)
-{
-	struct tegra_output *output = data;
-
-	drm_helper_hpd_irq_event(output->connector.dev);
-
-	return IRQ_HANDLED;
-}
-
-int tegra_output_parse_dt(struct tegra_output *output)
-{
-	enum of_gpio_flags flags;
-	struct device_node *ddc;
-	size_t size;
-	int err;
-
-	if (!output->of_node)
-		output->of_node = output->dev->of_node;
-
-	output->edid = of_get_property(output->of_node, "nvidia,edid", &size);
-
-	ddc = of_parse_phandle(output->of_node, "nvidia,ddc-i2c-bus", 0);
-	if (ddc) {
-		output->ddc = of_find_i2c_adapter_by_node(ddc);
-		if (!output->ddc) {
-			err = -EPROBE_DEFER;
-			of_node_put(ddc);
-			return err;
-		}
-
-		of_node_put(ddc);
-	}
-
-	if (!output->edid && !output->ddc)
-		return -ENODEV;
-
-	output->hpd_gpio = of_get_named_gpio_flags(output->of_node,
-						   "nvidia,hpd-gpio", 0,
-						   &flags);
-
-	return 0;
-}
-
-int tegra_output_init(struct drm_device *drm, struct tegra_output *output)
-{
-	int connector, encoder, err;
-
-	if (gpio_is_valid(output->hpd_gpio)) {
-		unsigned long flags;
-
-		err = gpio_request_one(output->hpd_gpio, GPIOF_DIR_IN,
-				       "HDMI hotplug detect");
-		if (err < 0) {
-			dev_err(output->dev, "gpio_request_one(): %d\n", err);
-			return err;
-		}
-
-		err = gpio_to_irq(output->hpd_gpio);
-		if (err < 0) {
-			dev_err(output->dev, "gpio_to_irq(): %d\n", err);
-			goto free_hpd;
-		}
-
-		output->hpd_irq = err;
-
-		flags = IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING |
-			IRQF_ONESHOT;
-
-		err = request_threaded_irq(output->hpd_irq, NULL, hpd_irq,
-					   flags, "hpd", output);
-		if (err < 0) {
-			dev_err(output->dev, "failed to request IRQ#%u: %d\n",
-				output->hpd_irq, err);
-			goto free_hpd;
-		}
-
-		output->connector.polled = DRM_CONNECTOR_POLL_HPD;
-	}
-
-	switch (output->type) {
-	case TEGRA_OUTPUT_RGB:
-		connector = DRM_MODE_CONNECTOR_LVDS;
-		encoder = DRM_MODE_ENCODER_LVDS;
-		break;
-
-	case TEGRA_OUTPUT_HDMI:
-		connector = DRM_MODE_CONNECTOR_HDMIA;
-		encoder = DRM_MODE_ENCODER_TMDS;
-		break;
-
-	default:
-		connector = DRM_MODE_CONNECTOR_Unknown;
-		encoder = DRM_MODE_ENCODER_NONE;
-		break;
-	}
-
-	drm_connector_init(drm, &output->connector, &connector_funcs,
-			   connector);
-	drm_connector_helper_add(&output->connector, &connector_helper_funcs);
-
-	drm_encoder_init(drm, &output->encoder, &encoder_funcs, encoder);
-	drm_encoder_helper_add(&output->encoder, &encoder_helper_funcs);
-
-	drm_mode_connector_attach_encoder(&output->connector, &output->encoder);
-	drm_sysfs_connector_add(&output->connector);
-
-	output->encoder.possible_crtcs = 0x3;
-
-	return 0;
-
-free_hpd:
-	gpio_free(output->hpd_gpio);
-
-	return err;
-}
-
-int tegra_output_exit(struct tegra_output *output)
-{
-	if (gpio_is_valid(output->hpd_gpio)) {
-		free_irq(output->hpd_irq, output);
-		gpio_free(output->hpd_gpio);
-	}
-
-	if (output->ddc)
-		put_device(&output->ddc->dev);
-
-	return 0;
-}
diff --git a/drivers/gpu/drm/tegra/rgb.c b/drivers/gpu/drm/tegra/rgb.c
deleted file mode 100644
index ed4416f..0000000
--- a/drivers/gpu/drm/tegra/rgb.c
+++ /dev/null
@@ -1,228 +0,0 @@
-/*
- * Copyright (C) 2012 Avionic Design GmbH
- * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/clk.h>
-#include <linux/module.h>
-#include <linux/of.h>
-#include <linux/platform_device.h>
-
-#include "drm.h"
-#include "dc.h"
-
-struct tegra_rgb {
-	struct tegra_output output;
-	struct clk *clk_parent;
-	struct clk *clk;
-};
-
-static inline struct tegra_rgb *to_rgb(struct tegra_output *output)
-{
-	return container_of(output, struct tegra_rgb, output);
-}
-
-struct reg_entry {
-	unsigned long offset;
-	unsigned long value;
-};
-
-static const struct reg_entry rgb_enable[] = {
-	{ DC_COM_PIN_OUTPUT_ENABLE(0),   0x00000000 },
-	{ DC_COM_PIN_OUTPUT_ENABLE(1),   0x00000000 },
-	{ DC_COM_PIN_OUTPUT_ENABLE(2),   0x00000000 },
-	{ DC_COM_PIN_OUTPUT_ENABLE(3),   0x00000000 },
-	{ DC_COM_PIN_OUTPUT_POLARITY(0), 0x00000000 },
-	{ DC_COM_PIN_OUTPUT_POLARITY(1), 0x01000000 },
-	{ DC_COM_PIN_OUTPUT_POLARITY(2), 0x00000000 },
-	{ DC_COM_PIN_OUTPUT_POLARITY(3), 0x00000000 },
-	{ DC_COM_PIN_OUTPUT_DATA(0),     0x00000000 },
-	{ DC_COM_PIN_OUTPUT_DATA(1),     0x00000000 },
-	{ DC_COM_PIN_OUTPUT_DATA(2),     0x00000000 },
-	{ DC_COM_PIN_OUTPUT_DATA(3),     0x00000000 },
-	{ DC_COM_PIN_OUTPUT_SELECT(0),   0x00000000 },
-	{ DC_COM_PIN_OUTPUT_SELECT(1),   0x00000000 },
-	{ DC_COM_PIN_OUTPUT_SELECT(2),   0x00000000 },
-	{ DC_COM_PIN_OUTPUT_SELECT(3),   0x00000000 },
-	{ DC_COM_PIN_OUTPUT_SELECT(4),   0x00210222 },
-	{ DC_COM_PIN_OUTPUT_SELECT(5),   0x00002200 },
-	{ DC_COM_PIN_OUTPUT_SELECT(6),   0x00020000 },
-};
-
-static const struct reg_entry rgb_disable[] = {
-	{ DC_COM_PIN_OUTPUT_SELECT(6),   0x00000000 },
-	{ DC_COM_PIN_OUTPUT_SELECT(5),   0x00000000 },
-	{ DC_COM_PIN_OUTPUT_SELECT(4),   0x00000000 },
-	{ DC_COM_PIN_OUTPUT_SELECT(3),   0x00000000 },
-	{ DC_COM_PIN_OUTPUT_SELECT(2),   0x00000000 },
-	{ DC_COM_PIN_OUTPUT_SELECT(1),   0x00000000 },
-	{ DC_COM_PIN_OUTPUT_SELECT(0),   0x00000000 },
-	{ DC_COM_PIN_OUTPUT_DATA(3),     0xaaaaaaaa },
-	{ DC_COM_PIN_OUTPUT_DATA(2),     0xaaaaaaaa },
-	{ DC_COM_PIN_OUTPUT_DATA(1),     0xaaaaaaaa },
-	{ DC_COM_PIN_OUTPUT_DATA(0),     0xaaaaaaaa },
-	{ DC_COM_PIN_OUTPUT_POLARITY(3), 0x00000000 },
-	{ DC_COM_PIN_OUTPUT_POLARITY(2), 0x00000000 },
-	{ DC_COM_PIN_OUTPUT_POLARITY(1), 0x00000000 },
-	{ DC_COM_PIN_OUTPUT_POLARITY(0), 0x00000000 },
-	{ DC_COM_PIN_OUTPUT_ENABLE(3),   0x55555555 },
-	{ DC_COM_PIN_OUTPUT_ENABLE(2),   0x55555555 },
-	{ DC_COM_PIN_OUTPUT_ENABLE(1),   0x55150005 },
-	{ DC_COM_PIN_OUTPUT_ENABLE(0),   0x55555555 },
-};
-
-static void tegra_dc_write_regs(struct tegra_dc *dc,
-				const struct reg_entry *table,
-				unsigned int num)
-{
-	unsigned int i;
-
-	for (i = 0; i < num; i++)
-		tegra_dc_writel(dc, table[i].value, table[i].offset);
-}
-
-static int tegra_output_rgb_enable(struct tegra_output *output)
-{
-	struct tegra_dc *dc = to_tegra_dc(output->encoder.crtc);
-
-	tegra_dc_write_regs(dc, rgb_enable, ARRAY_SIZE(rgb_enable));
-
-	return 0;
-}
-
-static int tegra_output_rgb_disable(struct tegra_output *output)
-{
-	struct tegra_dc *dc = to_tegra_dc(output->encoder.crtc);
-
-	tegra_dc_write_regs(dc, rgb_disable, ARRAY_SIZE(rgb_disable));
-
-	return 0;
-}
-
-static int tegra_output_rgb_setup_clock(struct tegra_output *output,
-					struct clk *clk, unsigned long pclk)
-{
-	struct tegra_rgb *rgb = to_rgb(output);
-
-	return clk_set_parent(clk, rgb->clk_parent);
-}
-
-static int tegra_output_rgb_check_mode(struct tegra_output *output,
-				       struct drm_display_mode *mode,
-				       enum drm_mode_status *status)
-{
-	/*
-	 * FIXME: For now, always assume that the mode is okay. There are
-	 * unresolved issues with clk_round_rate(), which doesn't always
-	 * reliably report whether a frequency can be set or not.
-	 */
-
-	*status = MODE_OK;
-
-	return 0;
-}
-
-static const struct tegra_output_ops rgb_ops = {
-	.enable = tegra_output_rgb_enable,
-	.disable = tegra_output_rgb_disable,
-	.setup_clock = tegra_output_rgb_setup_clock,
-	.check_mode = tegra_output_rgb_check_mode,
-};
-
-int tegra_dc_rgb_probe(struct tegra_dc *dc)
-{
-	struct device_node *np;
-	struct tegra_rgb *rgb;
-	int err;
-
-	np = of_get_child_by_name(dc->dev->of_node, "rgb");
-	if (!np || !of_device_is_available(np))
-		return -ENODEV;
-
-	rgb = devm_kzalloc(dc->dev, sizeof(*rgb), GFP_KERNEL);
-	if (!rgb)
-		return -ENOMEM;
-
-	rgb->clk = devm_clk_get(dc->dev, NULL);
-	if (IS_ERR(rgb->clk)) {
-		dev_err(dc->dev, "failed to get clock\n");
-		return PTR_ERR(rgb->clk);
-	}
-
-	rgb->clk_parent = devm_clk_get(dc->dev, "parent");
-	if (IS_ERR(rgb->clk_parent)) {
-		dev_err(dc->dev, "failed to get parent clock\n");
-		return PTR_ERR(rgb->clk_parent);
-	}
-
-	err = clk_set_parent(rgb->clk, rgb->clk_parent);
-	if (err < 0) {
-		dev_err(dc->dev, "failed to set parent clock: %d\n", err);
-		return err;
-	}
-
-	rgb->output.dev = dc->dev;
-	rgb->output.of_node = np;
-
-	err = tegra_output_parse_dt(&rgb->output);
-	if (err < 0)
-		return err;
-
-	dc->rgb = &rgb->output;
-
-	return 0;
-}
-
-int tegra_dc_rgb_init(struct drm_device *drm, struct tegra_dc *dc)
-{
-	struct tegra_rgb *rgb = to_rgb(dc->rgb);
-	int err;
-
-	if (!dc->rgb)
-		return -ENODEV;
-
-	rgb->output.type = TEGRA_OUTPUT_RGB;
-	rgb->output.ops = &rgb_ops;
-
-	err = tegra_output_init(dc->base.dev, &rgb->output);
-	if (err < 0) {
-		dev_err(dc->dev, "output setup failed: %d\n", err);
-		return err;
-	}
-
-	/*
-	 * By default, outputs can be associated with each display controller.
-	 * RGB outputs are an exception, so we make sure they can be attached
-	 * to only their parent display controller.
-	 */
-	rgb->output.encoder.possible_crtcs = 1 << dc->pipe;
-
-	return 0;
-}
-
-int tegra_dc_rgb_exit(struct tegra_dc *dc)
-{
-	if (dc->rgb) {
-		int err;
-
-		err = tegra_output_disable(dc->rgb);
-		if (err < 0) {
-			dev_err(dc->dev, "output failed to disable: %d\n", err);
-			return err;
-		}
-
-		err = tegra_output_exit(dc->rgb);
-		if (err < 0) {
-			dev_err(dc->dev, "output cleanup failed: %d\n", err);
-			return err;
-		}
-
-		dc->rgb = NULL;
-	}
-
-	return 0;
-}
diff --git a/drivers/gpu/host1x/Kconfig b/drivers/gpu/host1x/Kconfig
index 57680a6..558b660 100644
--- a/drivers/gpu/host1x/Kconfig
+++ b/drivers/gpu/host1x/Kconfig
@@ -1,4 +1,5 @@
 config TEGRA_HOST1X
+	depends on DRM
 	tristate "Tegra host1x driver"
 	help
 	  Driver for the Tegra host1x hardware.
@@ -26,4 +27,6 @@ config TEGRA_HOST1X_FIREWALL
 
 	  If unsure, choose Y.
 
+source "drivers/gpu/host1x/drm/Kconfig"
+
 endif
diff --git a/drivers/gpu/host1x/Makefile b/drivers/gpu/host1x/Makefile
index 697d49a..ffc8bf1 100644
--- a/drivers/gpu/host1x/Makefile
+++ b/drivers/gpu/host1x/Makefile
@@ -12,4 +12,10 @@ host1x-y = \
 	hw/host1x01.o
 
 host1x-$(CONFIG_TEGRA_HOST1X_CMA) += cma.o
+
+ccflags-y += -Iinclude/drm
+ccflags-$(CONFIG_DRM_TEGRA_DEBUG) += -DDEBUG
+
+host1x-$(CONFIG_DRM_TEGRA) += drm/drm.o drm/fb.o drm/dc.o drm/host1x.o
+host1x-$(CONFIG_DRM_TEGRA) += drm/output.o drm/rgb.o drm/hdmi.o
 obj-$(CONFIG_TEGRA_HOST1X) += host1x.o
diff --git a/drivers/gpu/host1x/drm/Kconfig b/drivers/gpu/host1x/drm/Kconfig
new file mode 100644
index 0000000..be1daf7
--- /dev/null
+++ b/drivers/gpu/host1x/drm/Kconfig
@@ -0,0 +1,23 @@
+config DRM_TEGRA
+	tristate "NVIDIA Tegra DRM"
+	depends on DRM && OF && ARCH_TEGRA
+	select DRM_KMS_HELPER
+	select DRM_GEM_CMA_HELPER
+	select DRM_KMS_CMA_HELPER
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  Choose this option if you have an NVIDIA Tegra SoC.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called tegra-drm.
+
+if DRM_TEGRA
+
+config DRM_TEGRA_DEBUG
+	bool "NVIDIA Tegra DRM debug support"
+	help
+	  Say yes here to enable debugging support.
+
+endif
diff --git a/drivers/gpu/host1x/drm/dc.c b/drivers/gpu/host1x/drm/dc.c
new file mode 100644
index 0000000..656b2e3
--- /dev/null
+++ b/drivers/gpu/host1x/drm/dc.c
@@ -0,0 +1,833 @@
+/*
+ * Copyright (C) 2012 Avionic Design GmbH
+ * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk.h>
+#include <linux/debugfs.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+
+#include <mach/clk.h>
+
+#include "drm.h"
+#include "dc.h"
+
+struct tegra_dc_window {
+	fixed20_12 x;
+	fixed20_12 y;
+	fixed20_12 w;
+	fixed20_12 h;
+	unsigned int outx;
+	unsigned int outy;
+	unsigned int outw;
+	unsigned int outh;
+	unsigned int stride;
+	unsigned int fmt;
+};
+
+static const struct drm_crtc_funcs tegra_crtc_funcs = {
+	.set_config = drm_crtc_helper_set_config,
+	.destroy = drm_crtc_cleanup,
+};
+
+static void tegra_crtc_dpms(struct drm_crtc *crtc, int mode)
+{
+}
+
+static bool tegra_crtc_mode_fixup(struct drm_crtc *crtc,
+				  const struct drm_display_mode *mode,
+				  struct drm_display_mode *adjusted)
+{
+	return true;
+}
+
+static inline u32 compute_dda_inc(fixed20_12 inf, unsigned int out, bool v,
+				  unsigned int bpp)
+{
+	fixed20_12 outf = dfixed_init(out);
+	u32 dda_inc;
+	int max;
+
+	if (v)
+		max = 15;
+	else {
+		switch (bpp) {
+		case 2:
+			max = 8;
+			break;
+
+		default:
+			WARN_ON_ONCE(1);
+			/* fallthrough */
+		case 4:
+			max = 4;
+			break;
+		}
+	}
+
+	outf.full = max_t(u32, outf.full - dfixed_const(1), dfixed_const(1));
+	inf.full -= dfixed_const(1);
+
+	dda_inc = dfixed_div(inf, outf);
+	dda_inc = min_t(u32, dda_inc, dfixed_const(max));
+
+	return dda_inc;
+}
+
+static inline u32 compute_initial_dda(fixed20_12 in)
+{
+	return dfixed_frac(in);
+}
+
+static int tegra_dc_set_timings(struct tegra_dc *dc,
+				struct drm_display_mode *mode)
+{
+	/* TODO: For HDMI compliance, h & v ref_to_sync should be set to 1 */
+	unsigned int h_ref_to_sync = 0;
+	unsigned int v_ref_to_sync = 0;
+	unsigned long value;
+
+	tegra_dc_writel(dc, 0x0, DC_DISP_DISP_TIMING_OPTIONS);
+
+	value = (v_ref_to_sync << 16) | h_ref_to_sync;
+	tegra_dc_writel(dc, value, DC_DISP_REF_TO_SYNC);
+
+	value = ((mode->vsync_end - mode->vsync_start) << 16) |
+		((mode->hsync_end - mode->hsync_start) <<  0);
+	tegra_dc_writel(dc, value, DC_DISP_SYNC_WIDTH);
+
+	value = ((mode->vtotal - mode->vsync_end) << 16) |
+		((mode->htotal - mode->hsync_end) <<  0);
+	tegra_dc_writel(dc, value, DC_DISP_BACK_PORCH);
+
+	value = ((mode->vsync_start - mode->vdisplay) << 16) |
+		((mode->hsync_start - mode->hdisplay) <<  0);
+	tegra_dc_writel(dc, value, DC_DISP_FRONT_PORCH);
+
+	value = (mode->vdisplay << 16) | mode->hdisplay;
+	tegra_dc_writel(dc, value, DC_DISP_ACTIVE);
+
+	return 0;
+}
+
+static int tegra_crtc_setup_clk(struct drm_crtc *crtc,
+				struct drm_display_mode *mode,
+				unsigned long *div)
+{
+	unsigned long pclk = mode->clock * 1000, rate;
+	struct tegra_dc *dc = to_tegra_dc(crtc);
+	struct tegra_output *output = NULL;
+	struct drm_encoder *encoder;
+	long err;
+
+	list_for_each_entry(encoder, &crtc->dev->mode_config.encoder_list, head)
+		if (encoder->crtc == crtc) {
+			output = encoder_to_output(encoder);
+			break;
+		}
+
+	if (!output)
+		return -ENODEV;
+
+	/*
+	 * This assumes that the display controller will divide its parent
+	 * clock by 2 to generate the pixel clock.
+	 */
+	err = tegra_output_setup_clock(output, dc->clk, pclk * 2);
+	if (err < 0) {
+		dev_err(dc->dev, "failed to setup clock: %ld\n", err);
+		return err;
+	}
+
+	rate = clk_get_rate(dc->clk);
+	*div = (rate * 2 / pclk) - 2;
+
+	DRM_DEBUG_KMS("rate: %lu, div: %lu\n", rate, *div);
+
+	return 0;
+}
+
+static int tegra_crtc_mode_set(struct drm_crtc *crtc,
+			       struct drm_display_mode *mode,
+			       struct drm_display_mode *adjusted,
+			       int x, int y, struct drm_framebuffer *old_fb)
+{
+	struct tegra_framebuffer *fb = to_tegra_fb(crtc->fb);
+	struct tegra_dc *dc = to_tegra_dc(crtc);
+	unsigned int h_dda, v_dda, bpp;
+	struct tegra_dc_window win;
+	unsigned long div, value;
+	int err;
+
+	err = tegra_crtc_setup_clk(crtc, mode, &div);
+	if (err) {
+		dev_err(dc->dev, "failed to setup clock for CRTC: %d\n", err);
+		return err;
+	}
+
+	/* program display mode */
+	tegra_dc_set_timings(dc, mode);
+
+	value = DE_SELECT_ACTIVE | DE_CONTROL_NORMAL;
+	tegra_dc_writel(dc, value, DC_DISP_DATA_ENABLE_OPTIONS);
+
+	value = tegra_dc_readl(dc, DC_COM_PIN_OUTPUT_POLARITY(1));
+	value &= ~LVS_OUTPUT_POLARITY_LOW;
+	value &= ~LHS_OUTPUT_POLARITY_LOW;
+	tegra_dc_writel(dc, value, DC_COM_PIN_OUTPUT_POLARITY(1));
+
+	value = DISP_DATA_FORMAT_DF1P1C | DISP_ALIGNMENT_MSB |
+		DISP_ORDER_RED_BLUE;
+	tegra_dc_writel(dc, value, DC_DISP_DISP_INTERFACE_CONTROL);
+
+	tegra_dc_writel(dc, 0x00010001, DC_DISP_SHIFT_CLOCK_OPTIONS);
+
+	value = SHIFT_CLK_DIVIDER(div) | PIXEL_CLK_DIVIDER_PCD1;
+	tegra_dc_writel(dc, value, DC_DISP_DISP_CLOCK_CONTROL);
+
+	/* setup window parameters */
+	memset(&win, 0, sizeof(win));
+	win.x.full = dfixed_const(0);
+	win.y.full = dfixed_const(0);
+	win.w.full = dfixed_const(mode->hdisplay);
+	win.h.full = dfixed_const(mode->vdisplay);
+	win.outx = 0;
+	win.outy = 0;
+	win.outw = mode->hdisplay;
+	win.outh = mode->vdisplay;
+
+	switch (crtc->fb->pixel_format) {
+	case DRM_FORMAT_XRGB8888:
+		win.fmt = WIN_COLOR_DEPTH_B8G8R8A8;
+		break;
+
+	case DRM_FORMAT_RGB565:
+		win.fmt = WIN_COLOR_DEPTH_B5G6R5;
+		break;
+
+	default:
+		win.fmt = WIN_COLOR_DEPTH_B8G8R8A8;
+		WARN_ON(1);
+		break;
+	}
+
+	bpp = crtc->fb->bits_per_pixel / 8;
+	win.stride = crtc->fb->pitches[0];
+
+	/* program window registers */
+	value = WINDOW_A_SELECT;
+	tegra_dc_writel(dc, value, DC_CMD_DISPLAY_WINDOW_HEADER);
+
+	tegra_dc_writel(dc, win.fmt, DC_WIN_COLOR_DEPTH);
+	tegra_dc_writel(dc, 0, DC_WIN_BYTE_SWAP);
+
+	value = V_POSITION(win.outy) | H_POSITION(win.outx);
+	tegra_dc_writel(dc, value, DC_WIN_POSITION);
+
+	value = V_SIZE(win.outh) | H_SIZE(win.outw);
+	tegra_dc_writel(dc, value, DC_WIN_SIZE);
+
+	value = V_PRESCALED_SIZE(dfixed_trunc(win.h)) |
+		H_PRESCALED_SIZE(dfixed_trunc(win.w) * bpp);
+	tegra_dc_writel(dc, value, DC_WIN_PRESCALED_SIZE);
+
+	h_dda = compute_dda_inc(win.w, win.outw, false, bpp);
+	v_dda = compute_dda_inc(win.h, win.outh, true, bpp);
+
+	value = V_DDA_INC(v_dda) | H_DDA_INC(h_dda);
+	tegra_dc_writel(dc, value, DC_WIN_DDA_INC);
+
+	h_dda = compute_initial_dda(win.x);
+	v_dda = compute_initial_dda(win.y);
+
+	tegra_dc_writel(dc, h_dda, DC_WIN_H_INITIAL_DDA);
+	tegra_dc_writel(dc, v_dda, DC_WIN_V_INITIAL_DDA);
+
+	tegra_dc_writel(dc, 0, DC_WIN_UV_BUF_STRIDE);
+	tegra_dc_writel(dc, 0, DC_WIN_BUF_STRIDE);
+
+	tegra_dc_writel(dc, fb->obj->paddr, DC_WINBUF_START_ADDR);
+	tegra_dc_writel(dc, win.stride, DC_WIN_LINE_STRIDE);
+	tegra_dc_writel(dc, dfixed_trunc(win.x) * bpp,
+			DC_WINBUF_ADDR_H_OFFSET);
+	tegra_dc_writel(dc, dfixed_trunc(win.y), DC_WINBUF_ADDR_V_OFFSET);
+
+	value = WIN_ENABLE;
+
+	if (bpp < 24)
+		value |= COLOR_EXPAND;
+
+	tegra_dc_writel(dc, value, DC_WIN_WIN_OPTIONS);
+
+	tegra_dc_writel(dc, 0xff00, DC_WIN_BLEND_NOKEY);
+	tegra_dc_writel(dc, 0xff00, DC_WIN_BLEND_1WIN);
+
+	return 0;
+}
+
+static void tegra_crtc_prepare(struct drm_crtc *crtc)
+{
+	struct tegra_dc *dc = to_tegra_dc(crtc);
+	unsigned int syncpt;
+	unsigned long value;
+
+	/* hardware initialization */
+	tegra_periph_reset_deassert(dc->clk);
+	usleep_range(10000, 20000);
+
+	if (dc->pipe)
+		syncpt = SYNCPT_VBLANK1;
+	else
+		syncpt = SYNCPT_VBLANK0;
+
+	/* initialize display controller */
+	tegra_dc_writel(dc, 0x00000100, DC_CMD_GENERAL_INCR_SYNCPT_CNTRL);
+	tegra_dc_writel(dc, 0x100 | syncpt, DC_CMD_CONT_SYNCPT_VSYNC);
+
+	value = WIN_A_UF_INT | WIN_B_UF_INT | WIN_C_UF_INT | WIN_A_OF_INT;
+	tegra_dc_writel(dc, value, DC_CMD_INT_TYPE);
+
+	value = WIN_A_UF_INT | WIN_B_UF_INT | WIN_C_UF_INT |
+		WIN_A_OF_INT | WIN_B_OF_INT | WIN_C_OF_INT;
+	tegra_dc_writel(dc, value, DC_CMD_INT_POLARITY);
+
+	value = PW0_ENABLE | PW1_ENABLE | PW2_ENABLE | PW3_ENABLE |
+		PW4_ENABLE | PM0_ENABLE | PM1_ENABLE;
+	tegra_dc_writel(dc, value, DC_CMD_DISPLAY_POWER_CONTROL);
+
+	value = tegra_dc_readl(dc, DC_CMD_DISPLAY_COMMAND);
+	value |= DISP_CTRL_MODE_C_DISPLAY;
+	tegra_dc_writel(dc, value, DC_CMD_DISPLAY_COMMAND);
+
+	/* initialize timer */
+	value = CURSOR_THRESHOLD(0) | WINDOW_A_THRESHOLD(0x20) |
+		WINDOW_B_THRESHOLD(0x20) | WINDOW_C_THRESHOLD(0x20);
+	tegra_dc_writel(dc, value, DC_DISP_DISP_MEM_HIGH_PRIORITY);
+
+	value = CURSOR_THRESHOLD(0) | WINDOW_A_THRESHOLD(1) |
+		WINDOW_B_THRESHOLD(1) | WINDOW_C_THRESHOLD(1);
+	tegra_dc_writel(dc, value, DC_DISP_DISP_MEM_HIGH_PRIORITY_TIMER);
+
+	value = VBLANK_INT | WIN_A_UF_INT | WIN_B_UF_INT | WIN_C_UF_INT;
+	tegra_dc_writel(dc, value, DC_CMD_INT_MASK);
+
+	value = VBLANK_INT | WIN_A_UF_INT | WIN_B_UF_INT | WIN_C_UF_INT;
+	tegra_dc_writel(dc, value, DC_CMD_INT_ENABLE);
+}
+
+static void tegra_crtc_commit(struct drm_crtc *crtc)
+{
+	struct tegra_dc *dc = to_tegra_dc(crtc);
+	unsigned long update_mask;
+	unsigned long value;
+
+	update_mask = GENERAL_ACT_REQ | WIN_A_ACT_REQ;
+
+	tegra_dc_writel(dc, update_mask << 8, DC_CMD_STATE_CONTROL);
+
+	value = tegra_dc_readl(dc, DC_CMD_INT_ENABLE);
+	value |= FRAME_END_INT;
+	tegra_dc_writel(dc, value, DC_CMD_INT_ENABLE);
+
+	value = tegra_dc_readl(dc, DC_CMD_INT_MASK);
+	value |= FRAME_END_INT;
+	tegra_dc_writel(dc, value, DC_CMD_INT_MASK);
+
+	tegra_dc_writel(dc, update_mask, DC_CMD_STATE_CONTROL);
+}
+
+static void tegra_crtc_load_lut(struct drm_crtc *crtc)
+{
+}
+
+static const struct drm_crtc_helper_funcs tegra_crtc_helper_funcs = {
+	.dpms = tegra_crtc_dpms,
+	.mode_fixup = tegra_crtc_mode_fixup,
+	.mode_set = tegra_crtc_mode_set,
+	.prepare = tegra_crtc_prepare,
+	.commit = tegra_crtc_commit,
+	.load_lut = tegra_crtc_load_lut,
+};
+
+static irqreturn_t tegra_drm_irq(int irq, void *data)
+{
+	struct tegra_dc *dc = data;
+	unsigned long status;
+
+	status = tegra_dc_readl(dc, DC_CMD_INT_STATUS);
+	tegra_dc_writel(dc, status, DC_CMD_INT_STATUS);
+
+	if (status & FRAME_END_INT) {
+		/*
+		dev_dbg(dc->dev, "%s(): frame end\n", __func__);
+		*/
+	}
+
+	if (status & VBLANK_INT) {
+		/*
+		dev_dbg(dc->dev, "%s(): vertical blank\n", __func__);
+		*/
+		drm_handle_vblank(dc->base.dev, dc->pipe);
+	}
+
+	if (status & (WIN_A_UF_INT | WIN_B_UF_INT | WIN_C_UF_INT)) {
+		/*
+		dev_dbg(dc->dev, "%s(): underflow\n", __func__);
+		*/
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int tegra_dc_show_regs(struct seq_file *s, void *data)
+{
+	struct drm_info_node *node = s->private;
+	struct tegra_dc *dc = node->info_ent->data;
+
+#define DUMP_REG(name)						\
+	seq_printf(s, "%-40s %#05x %08lx\n", #name, name,	\
+		   tegra_dc_readl(dc, name))
+
+	DUMP_REG(DC_CMD_GENERAL_INCR_SYNCPT);
+	DUMP_REG(DC_CMD_GENERAL_INCR_SYNCPT_CNTRL);
+	DUMP_REG(DC_CMD_GENERAL_INCR_SYNCPT_ERROR);
+	DUMP_REG(DC_CMD_WIN_A_INCR_SYNCPT);
+	DUMP_REG(DC_CMD_WIN_A_INCR_SYNCPT_CNTRL);
+	DUMP_REG(DC_CMD_WIN_A_INCR_SYNCPT_ERROR);
+	DUMP_REG(DC_CMD_WIN_B_INCR_SYNCPT);
+	DUMP_REG(DC_CMD_WIN_B_INCR_SYNCPT_CNTRL);
+	DUMP_REG(DC_CMD_WIN_B_INCR_SYNCPT_ERROR);
+	DUMP_REG(DC_CMD_WIN_C_INCR_SYNCPT);
+	DUMP_REG(DC_CMD_WIN_C_INCR_SYNCPT_CNTRL);
+	DUMP_REG(DC_CMD_WIN_C_INCR_SYNCPT_ERROR);
+	DUMP_REG(DC_CMD_CONT_SYNCPT_VSYNC);
+	DUMP_REG(DC_CMD_DISPLAY_COMMAND_OPTION0);
+	DUMP_REG(DC_CMD_DISPLAY_COMMAND);
+	DUMP_REG(DC_CMD_SIGNAL_RAISE);
+	DUMP_REG(DC_CMD_DISPLAY_POWER_CONTROL);
+	DUMP_REG(DC_CMD_INT_STATUS);
+	DUMP_REG(DC_CMD_INT_MASK);
+	DUMP_REG(DC_CMD_INT_ENABLE);
+	DUMP_REG(DC_CMD_INT_TYPE);
+	DUMP_REG(DC_CMD_INT_POLARITY);
+	DUMP_REG(DC_CMD_SIGNAL_RAISE1);
+	DUMP_REG(DC_CMD_SIGNAL_RAISE2);
+	DUMP_REG(DC_CMD_SIGNAL_RAISE3);
+	DUMP_REG(DC_CMD_STATE_ACCESS);
+	DUMP_REG(DC_CMD_STATE_CONTROL);
+	DUMP_REG(DC_CMD_DISPLAY_WINDOW_HEADER);
+	DUMP_REG(DC_CMD_REG_ACT_CONTROL);
+	DUMP_REG(DC_COM_CRC_CONTROL);
+	DUMP_REG(DC_COM_CRC_CHECKSUM);
+	DUMP_REG(DC_COM_PIN_OUTPUT_ENABLE(0));
+	DUMP_REG(DC_COM_PIN_OUTPUT_ENABLE(1));
+	DUMP_REG(DC_COM_PIN_OUTPUT_ENABLE(2));
+	DUMP_REG(DC_COM_PIN_OUTPUT_ENABLE(3));
+	DUMP_REG(DC_COM_PIN_OUTPUT_POLARITY(0));
+	DUMP_REG(DC_COM_PIN_OUTPUT_POLARITY(1));
+	DUMP_REG(DC_COM_PIN_OUTPUT_POLARITY(2));
+	DUMP_REG(DC_COM_PIN_OUTPUT_POLARITY(3));
+	DUMP_REG(DC_COM_PIN_OUTPUT_DATA(0));
+	DUMP_REG(DC_COM_PIN_OUTPUT_DATA(1));
+	DUMP_REG(DC_COM_PIN_OUTPUT_DATA(2));
+	DUMP_REG(DC_COM_PIN_OUTPUT_DATA(3));
+	DUMP_REG(DC_COM_PIN_INPUT_ENABLE(0));
+	DUMP_REG(DC_COM_PIN_INPUT_ENABLE(1));
+	DUMP_REG(DC_COM_PIN_INPUT_ENABLE(2));
+	DUMP_REG(DC_COM_PIN_INPUT_ENABLE(3));
+	DUMP_REG(DC_COM_PIN_INPUT_DATA(0));
+	DUMP_REG(DC_COM_PIN_INPUT_DATA(1));
+	DUMP_REG(DC_COM_PIN_OUTPUT_SELECT(0));
+	DUMP_REG(DC_COM_PIN_OUTPUT_SELECT(1));
+	DUMP_REG(DC_COM_PIN_OUTPUT_SELECT(2));
+	DUMP_REG(DC_COM_PIN_OUTPUT_SELECT(3));
+	DUMP_REG(DC_COM_PIN_OUTPUT_SELECT(4));
+	DUMP_REG(DC_COM_PIN_OUTPUT_SELECT(5));
+	DUMP_REG(DC_COM_PIN_OUTPUT_SELECT(6));
+	DUMP_REG(DC_COM_PIN_MISC_CONTROL);
+	DUMP_REG(DC_COM_PIN_PM0_CONTROL);
+	DUMP_REG(DC_COM_PIN_PM0_DUTY_CYCLE);
+	DUMP_REG(DC_COM_PIN_PM1_CONTROL);
+	DUMP_REG(DC_COM_PIN_PM1_DUTY_CYCLE);
+	DUMP_REG(DC_COM_SPI_CONTROL);
+	DUMP_REG(DC_COM_SPI_START_BYTE);
+	DUMP_REG(DC_COM_HSPI_WRITE_DATA_AB);
+	DUMP_REG(DC_COM_HSPI_WRITE_DATA_CD);
+	DUMP_REG(DC_COM_HSPI_CS_DC);
+	DUMP_REG(DC_COM_SCRATCH_REGISTER_A);
+	DUMP_REG(DC_COM_SCRATCH_REGISTER_B);
+	DUMP_REG(DC_COM_GPIO_CTRL);
+	DUMP_REG(DC_COM_GPIO_DEBOUNCE_COUNTER);
+	DUMP_REG(DC_COM_CRC_CHECKSUM_LATCHED);
+	DUMP_REG(DC_DISP_DISP_SIGNAL_OPTIONS0);
+	DUMP_REG(DC_DISP_DISP_SIGNAL_OPTIONS1);
+	DUMP_REG(DC_DISP_DISP_WIN_OPTIONS);
+	DUMP_REG(DC_DISP_DISP_MEM_HIGH_PRIORITY);
+	DUMP_REG(DC_DISP_DISP_MEM_HIGH_PRIORITY_TIMER);
+	DUMP_REG(DC_DISP_DISP_TIMING_OPTIONS);
+	DUMP_REG(DC_DISP_REF_TO_SYNC);
+	DUMP_REG(DC_DISP_SYNC_WIDTH);
+	DUMP_REG(DC_DISP_BACK_PORCH);
+	DUMP_REG(DC_DISP_ACTIVE);
+	DUMP_REG(DC_DISP_FRONT_PORCH);
+	DUMP_REG(DC_DISP_H_PULSE0_CONTROL);
+	DUMP_REG(DC_DISP_H_PULSE0_POSITION_A);
+	DUMP_REG(DC_DISP_H_PULSE0_POSITION_B);
+	DUMP_REG(DC_DISP_H_PULSE0_POSITION_C);
+	DUMP_REG(DC_DISP_H_PULSE0_POSITION_D);
+	DUMP_REG(DC_DISP_H_PULSE1_CONTROL);
+	DUMP_REG(DC_DISP_H_PULSE1_POSITION_A);
+	DUMP_REG(DC_DISP_H_PULSE1_POSITION_B);
+	DUMP_REG(DC_DISP_H_PULSE1_POSITION_C);
+	DUMP_REG(DC_DISP_H_PULSE1_POSITION_D);
+	DUMP_REG(DC_DISP_H_PULSE2_CONTROL);
+	DUMP_REG(DC_DISP_H_PULSE2_POSITION_A);
+	DUMP_REG(DC_DISP_H_PULSE2_POSITION_B);
+	DUMP_REG(DC_DISP_H_PULSE2_POSITION_C);
+	DUMP_REG(DC_DISP_H_PULSE2_POSITION_D);
+	DUMP_REG(DC_DISP_V_PULSE0_CONTROL);
+	DUMP_REG(DC_DISP_V_PULSE0_POSITION_A);
+	DUMP_REG(DC_DISP_V_PULSE0_POSITION_B);
+	DUMP_REG(DC_DISP_V_PULSE0_POSITION_C);
+	DUMP_REG(DC_DISP_V_PULSE1_CONTROL);
+	DUMP_REG(DC_DISP_V_PULSE1_POSITION_A);
+	DUMP_REG(DC_DISP_V_PULSE1_POSITION_B);
+	DUMP_REG(DC_DISP_V_PULSE1_POSITION_C);
+	DUMP_REG(DC_DISP_V_PULSE2_CONTROL);
+	DUMP_REG(DC_DISP_V_PULSE2_POSITION_A);
+	DUMP_REG(DC_DISP_V_PULSE3_CONTROL);
+	DUMP_REG(DC_DISP_V_PULSE3_POSITION_A);
+	DUMP_REG(DC_DISP_M0_CONTROL);
+	DUMP_REG(DC_DISP_M1_CONTROL);
+	DUMP_REG(DC_DISP_DI_CONTROL);
+	DUMP_REG(DC_DISP_PP_CONTROL);
+	DUMP_REG(DC_DISP_PP_SELECT_A);
+	DUMP_REG(DC_DISP_PP_SELECT_B);
+	DUMP_REG(DC_DISP_PP_SELECT_C);
+	DUMP_REG(DC_DISP_PP_SELECT_D);
+	DUMP_REG(DC_DISP_DISP_CLOCK_CONTROL);
+	DUMP_REG(DC_DISP_DISP_INTERFACE_CONTROL);
+	DUMP_REG(DC_DISP_DISP_COLOR_CONTROL);
+	DUMP_REG(DC_DISP_SHIFT_CLOCK_OPTIONS);
+	DUMP_REG(DC_DISP_DATA_ENABLE_OPTIONS);
+	DUMP_REG(DC_DISP_SERIAL_INTERFACE_OPTIONS);
+	DUMP_REG(DC_DISP_LCD_SPI_OPTIONS);
+	DUMP_REG(DC_DISP_BORDER_COLOR);
+	DUMP_REG(DC_DISP_COLOR_KEY0_LOWER);
+	DUMP_REG(DC_DISP_COLOR_KEY0_UPPER);
+	DUMP_REG(DC_DISP_COLOR_KEY1_LOWER);
+	DUMP_REG(DC_DISP_COLOR_KEY1_UPPER);
+	DUMP_REG(DC_DISP_CURSOR_FOREGROUND);
+	DUMP_REG(DC_DISP_CURSOR_BACKGROUND);
+	DUMP_REG(DC_DISP_CURSOR_START_ADDR);
+	DUMP_REG(DC_DISP_CURSOR_START_ADDR_NS);
+	DUMP_REG(DC_DISP_CURSOR_POSITION);
+	DUMP_REG(DC_DISP_CURSOR_POSITION_NS);
+	DUMP_REG(DC_DISP_INIT_SEQ_CONTROL);
+	DUMP_REG(DC_DISP_SPI_INIT_SEQ_DATA_A);
+	DUMP_REG(DC_DISP_SPI_INIT_SEQ_DATA_B);
+	DUMP_REG(DC_DISP_SPI_INIT_SEQ_DATA_C);
+	DUMP_REG(DC_DISP_SPI_INIT_SEQ_DATA_D);
+	DUMP_REG(DC_DISP_DC_MCCIF_FIFOCTRL);
+	DUMP_REG(DC_DISP_MCCIF_DISPLAY0A_HYST);
+	DUMP_REG(DC_DISP_MCCIF_DISPLAY0B_HYST);
+	DUMP_REG(DC_DISP_MCCIF_DISPLAY1A_HYST);
+	DUMP_REG(DC_DISP_MCCIF_DISPLAY1B_HYST);
+	DUMP_REG(DC_DISP_DAC_CRT_CTRL);
+	DUMP_REG(DC_DISP_DISP_MISC_CONTROL);
+	DUMP_REG(DC_DISP_SD_CONTROL);
+	DUMP_REG(DC_DISP_SD_CSC_COEFF);
+	DUMP_REG(DC_DISP_SD_LUT(0));
+	DUMP_REG(DC_DISP_SD_LUT(1));
+	DUMP_REG(DC_DISP_SD_LUT(2));
+	DUMP_REG(DC_DISP_SD_LUT(3));
+	DUMP_REG(DC_DISP_SD_LUT(4));
+	DUMP_REG(DC_DISP_SD_LUT(5));
+	DUMP_REG(DC_DISP_SD_LUT(6));
+	DUMP_REG(DC_DISP_SD_LUT(7));
+	DUMP_REG(DC_DISP_SD_LUT(8));
+	DUMP_REG(DC_DISP_SD_FLICKER_CONTROL);
+	DUMP_REG(DC_DISP_DC_PIXEL_COUNT);
+	DUMP_REG(DC_DISP_SD_HISTOGRAM(0));
+	DUMP_REG(DC_DISP_SD_HISTOGRAM(1));
+	DUMP_REG(DC_DISP_SD_HISTOGRAM(2));
+	DUMP_REG(DC_DISP_SD_HISTOGRAM(3));
+	DUMP_REG(DC_DISP_SD_HISTOGRAM(4));
+	DUMP_REG(DC_DISP_SD_HISTOGRAM(5));
+	DUMP_REG(DC_DISP_SD_HISTOGRAM(6));
+	DUMP_REG(DC_DISP_SD_HISTOGRAM(7));
+	DUMP_REG(DC_DISP_SD_BL_TF(0));
+	DUMP_REG(DC_DISP_SD_BL_TF(1));
+	DUMP_REG(DC_DISP_SD_BL_TF(2));
+	DUMP_REG(DC_DISP_SD_BL_TF(3));
+	DUMP_REG(DC_DISP_SD_BL_CONTROL);
+	DUMP_REG(DC_DISP_SD_HW_K_VALUES);
+	DUMP_REG(DC_DISP_SD_MAN_K_VALUES);
+	DUMP_REG(DC_WIN_WIN_OPTIONS);
+	DUMP_REG(DC_WIN_BYTE_SWAP);
+	DUMP_REG(DC_WIN_BUFFER_CONTROL);
+	DUMP_REG(DC_WIN_COLOR_DEPTH);
+	DUMP_REG(DC_WIN_POSITION);
+	DUMP_REG(DC_WIN_SIZE);
+	DUMP_REG(DC_WIN_PRESCALED_SIZE);
+	DUMP_REG(DC_WIN_H_INITIAL_DDA);
+	DUMP_REG(DC_WIN_V_INITIAL_DDA);
+	DUMP_REG(DC_WIN_DDA_INC);
+	DUMP_REG(DC_WIN_LINE_STRIDE);
+	DUMP_REG(DC_WIN_BUF_STRIDE);
+	DUMP_REG(DC_WIN_UV_BUF_STRIDE);
+	DUMP_REG(DC_WIN_BUFFER_ADDR_MODE);
+	DUMP_REG(DC_WIN_DV_CONTROL);
+	DUMP_REG(DC_WIN_BLEND_NOKEY);
+	DUMP_REG(DC_WIN_BLEND_1WIN);
+	DUMP_REG(DC_WIN_BLEND_2WIN_X);
+	DUMP_REG(DC_WIN_BLEND_2WIN_Y);
+	DUMP_REG(DC_WIN_BLEND32WIN_XY);
+	DUMP_REG(DC_WIN_HP_FETCH_CONTROL);
+	DUMP_REG(DC_WINBUF_START_ADDR);
+	DUMP_REG(DC_WINBUF_START_ADDR_NS);
+	DUMP_REG(DC_WINBUF_START_ADDR_U);
+	DUMP_REG(DC_WINBUF_START_ADDR_U_NS);
+	DUMP_REG(DC_WINBUF_START_ADDR_V);
+	DUMP_REG(DC_WINBUF_START_ADDR_V_NS);
+	DUMP_REG(DC_WINBUF_ADDR_H_OFFSET);
+	DUMP_REG(DC_WINBUF_ADDR_H_OFFSET_NS);
+	DUMP_REG(DC_WINBUF_ADDR_V_OFFSET);
+	DUMP_REG(DC_WINBUF_ADDR_V_OFFSET_NS);
+	DUMP_REG(DC_WINBUF_UFLOW_STATUS);
+	DUMP_REG(DC_WINBUF_AD_UFLOW_STATUS);
+	DUMP_REG(DC_WINBUF_BD_UFLOW_STATUS);
+	DUMP_REG(DC_WINBUF_CD_UFLOW_STATUS);
+
+#undef DUMP_REG
+
+	return 0;
+}
+
+static struct drm_info_list debugfs_files[] = {
+	{ "regs", tegra_dc_show_regs, 0, NULL },
+};
+
+static int tegra_dc_debugfs_init(struct tegra_dc *dc, struct drm_minor *minor)
+{
+	unsigned int i;
+	char *name;
+	int err;
+
+	name = kasprintf(GFP_KERNEL, "dc.%d", dc->pipe);
+	dc->debugfs = debugfs_create_dir(name, minor->debugfs_root);
+	kfree(name);
+
+	if (!dc->debugfs)
+		return -ENOMEM;
+
+	dc->debugfs_files = kmemdup(debugfs_files, sizeof(debugfs_files),
+				    GFP_KERNEL);
+	if (!dc->debugfs_files) {
+		err = -ENOMEM;
+		goto remove;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(debugfs_files); i++)
+		dc->debugfs_files[i].data = dc;
+
+	err = drm_debugfs_create_files(dc->debugfs_files,
+				       ARRAY_SIZE(debugfs_files),
+				       dc->debugfs, minor);
+	if (err < 0)
+		goto free;
+
+	dc->minor = minor;
+
+	return 0;
+
+free:
+	kfree(dc->debugfs_files);
+	dc->debugfs_files = NULL;
+remove:
+	debugfs_remove(dc->debugfs);
+	dc->debugfs = NULL;
+
+	return err;
+}
+
+static int tegra_dc_debugfs_exit(struct tegra_dc *dc)
+{
+	drm_debugfs_remove_files(dc->debugfs_files, ARRAY_SIZE(debugfs_files),
+				 dc->minor);
+	dc->minor = NULL;
+
+	kfree(dc->debugfs_files);
+	dc->debugfs_files = NULL;
+
+	debugfs_remove(dc->debugfs);
+	dc->debugfs = NULL;
+
+	return 0;
+}
+
+static int tegra_dc_drm_init(struct host1x_client *client,
+			     struct drm_device *drm)
+{
+	struct tegra_dc *dc = host1x_client_to_dc(client);
+	int err;
+
+	dc->pipe = drm->mode_config.num_crtc;
+
+	drm_crtc_init(drm, &dc->base, &tegra_crtc_funcs);
+	drm_mode_crtc_set_gamma_size(&dc->base, 256);
+	drm_crtc_helper_add(&dc->base, &tegra_crtc_helper_funcs);
+
+	err = tegra_dc_rgb_init(drm, dc);
+	if (err < 0 && err != -ENODEV) {
+		dev_err(dc->dev, "failed to initialize RGB output: %d\n", err);
+		return err;
+	}
+
+	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
+		err = tegra_dc_debugfs_init(dc, drm->primary);
+		if (err < 0)
+			dev_err(dc->dev, "debugfs setup failed: %d\n", err);
+	}
+
+	err = devm_request_irq(dc->dev, dc->irq, tegra_drm_irq, 0,
+			       dev_name(dc->dev), dc);
+	if (err < 0) {
+		dev_err(dc->dev, "failed to request IRQ#%u: %d\n", dc->irq,
+			err);
+		return err;
+	}
+
+	return 0;
+}
+
+static int tegra_dc_drm_exit(struct host1x_client *client)
+{
+	struct tegra_dc *dc = host1x_client_to_dc(client);
+	int err;
+
+	devm_free_irq(dc->dev, dc->irq, dc);
+
+	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
+		err = tegra_dc_debugfs_exit(dc);
+		if (err < 0)
+			dev_err(dc->dev, "debugfs cleanup failed: %d\n", err);
+	}
+
+	err = tegra_dc_rgb_exit(dc);
+	if (err) {
+		dev_err(dc->dev, "failed to shutdown RGB output: %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
+static const struct host1x_client_ops dc_client_ops = {
+	.drm_init = tegra_dc_drm_init,
+	.drm_exit = tegra_dc_drm_exit,
+};
+
+static int tegra_dc_probe(struct platform_device *pdev)
+{
+	struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
+	struct resource *regs;
+	struct tegra_dc *dc;
+	int err;
+
+	dc = devm_kzalloc(&pdev->dev, sizeof(*dc), GFP_KERNEL);
+	if (!dc)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&dc->list);
+	dc->dev = &pdev->dev;
+
+	dc->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(dc->clk)) {
+		dev_err(&pdev->dev, "failed to get clock\n");
+		return PTR_ERR(dc->clk);
+	}
+
+	err = clk_prepare_enable(dc->clk);
+	if (err < 0)
+		return err;
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!regs) {
+		dev_err(&pdev->dev, "failed to get registers\n");
+		return -ENXIO;
+	}
+
+	dc->regs = devm_request_and_ioremap(&pdev->dev, regs);
+	if (!dc->regs) {
+		dev_err(&pdev->dev, "failed to remap registers\n");
+		return -ENXIO;
+	}
+
+	dc->irq = platform_get_irq(pdev, 0);
+	if (dc->irq < 0) {
+		dev_err(&pdev->dev, "failed to get IRQ\n");
+		return -ENXIO;
+	}
+
+	INIT_LIST_HEAD(&dc->client.list);
+	dc->client.ops = &dc_client_ops;
+	dc->client.dev = &pdev->dev;
+
+	err = tegra_dc_rgb_probe(dc);
+	if (err < 0 && err != -ENODEV) {
+		dev_err(&pdev->dev, "failed to probe RGB output: %d\n", err);
+		return err;
+	}
+
+	err = host1x_register_client(host1x, &dc->client);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to register host1x client: %d\n",
+			err);
+		return err;
+	}
+
+	platform_set_drvdata(pdev, dc);
+
+	return 0;
+}
+
+static int tegra_dc_remove(struct platform_device *pdev)
+{
+	struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
+	struct tegra_dc *dc = platform_get_drvdata(pdev);
+	int err;
+
+	err = host1x_unregister_client(host1x, &dc->client);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to unregister host1x client: %d\n",
+			err);
+		return err;
+	}
+
+	clk_disable_unprepare(dc->clk);
+
+	return 0;
+}
+
+static struct of_device_id tegra_dc_of_match[] = {
+	{ .compatible = "nvidia,tegra30-dc", },
+	{ .compatible = "nvidia,tegra20-dc", },
+	{ },
+};
+
+struct platform_driver tegra_dc_driver = {
+	.driver = {
+		.name = "tegra-dc",
+		.owner = THIS_MODULE,
+		.of_match_table = tegra_dc_of_match,
+	},
+	.probe = tegra_dc_probe,
+	.remove = tegra_dc_remove,
+};
diff --git a/drivers/gpu/host1x/drm/dc.h b/drivers/gpu/host1x/drm/dc.h
new file mode 100644
index 0000000..99977b5
--- /dev/null
+++ b/drivers/gpu/host1x/drm/dc.h
@@ -0,0 +1,388 @@
+/*
+ * Copyright (C) 2012 Avionic Design GmbH
+ * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef TEGRA_DC_H
+#define TEGRA_DC_H 1
+
+#define DC_CMD_GENERAL_INCR_SYNCPT		0x000
+#define DC_CMD_GENERAL_INCR_SYNCPT_CNTRL	0x001
+#define DC_CMD_GENERAL_INCR_SYNCPT_ERROR	0x002
+#define DC_CMD_WIN_A_INCR_SYNCPT		0x008
+#define DC_CMD_WIN_A_INCR_SYNCPT_CNTRL		0x009
+#define DC_CMD_WIN_A_INCR_SYNCPT_ERROR		0x00a
+#define DC_CMD_WIN_B_INCR_SYNCPT		0x010
+#define DC_CMD_WIN_B_INCR_SYNCPT_CNTRL		0x011
+#define DC_CMD_WIN_B_INCR_SYNCPT_ERROR		0x012
+#define DC_CMD_WIN_C_INCR_SYNCPT		0x018
+#define DC_CMD_WIN_C_INCR_SYNCPT_CNTRL		0x019
+#define DC_CMD_WIN_C_INCR_SYNCPT_ERROR		0x01a
+#define DC_CMD_CONT_SYNCPT_VSYNC		0x028
+#define DC_CMD_DISPLAY_COMMAND_OPTION0		0x031
+#define DC_CMD_DISPLAY_COMMAND			0x032
+#define DISP_CTRL_MODE_STOP (0 << 5)
+#define DISP_CTRL_MODE_C_DISPLAY (1 << 5)
+#define DISP_CTRL_MODE_NC_DISPLAY (2 << 5)
+#define DC_CMD_SIGNAL_RAISE			0x033
+#define DC_CMD_DISPLAY_POWER_CONTROL		0x036
+#define PW0_ENABLE (1 <<  0)
+#define PW1_ENABLE (1 <<  2)
+#define PW2_ENABLE (1 <<  4)
+#define PW3_ENABLE (1 <<  6)
+#define PW4_ENABLE (1 <<  8)
+#define PM0_ENABLE (1 << 16)
+#define PM1_ENABLE (1 << 18)
+
+#define DC_CMD_INT_STATUS			0x037
+#define DC_CMD_INT_MASK				0x038
+#define DC_CMD_INT_ENABLE			0x039
+#define DC_CMD_INT_TYPE				0x03a
+#define DC_CMD_INT_POLARITY			0x03b
+#define CTXSW_INT     (1 << 0)
+#define FRAME_END_INT (1 << 1)
+#define VBLANK_INT    (1 << 2)
+#define WIN_A_UF_INT  (1 << 8)
+#define WIN_B_UF_INT  (1 << 9)
+#define WIN_C_UF_INT  (1 << 10)
+#define WIN_A_OF_INT  (1 << 14)
+#define WIN_B_OF_INT  (1 << 15)
+#define WIN_C_OF_INT  (1 << 16)
+
+#define DC_CMD_SIGNAL_RAISE1			0x03c
+#define DC_CMD_SIGNAL_RAISE2			0x03d
+#define DC_CMD_SIGNAL_RAISE3			0x03e
+
+#define DC_CMD_STATE_ACCESS			0x040
+
+#define DC_CMD_STATE_CONTROL			0x041
+#define GENERAL_ACT_REQ (1 <<  0)
+#define WIN_A_ACT_REQ   (1 <<  1)
+#define WIN_B_ACT_REQ   (1 <<  2)
+#define WIN_C_ACT_REQ   (1 <<  3)
+#define GENERAL_UPDATE  (1 <<  8)
+#define WIN_A_UPDATE    (1 <<  9)
+#define WIN_B_UPDATE    (1 << 10)
+#define WIN_C_UPDATE    (1 << 11)
+#define NC_HOST_TRIG    (1 << 24)
+
+#define DC_CMD_DISPLAY_WINDOW_HEADER		0x042
+#define WINDOW_A_SELECT (1 << 4)
+#define WINDOW_B_SELECT (1 << 5)
+#define WINDOW_C_SELECT (1 << 6)
+
+#define DC_CMD_REG_ACT_CONTROL			0x043
+
+#define DC_COM_CRC_CONTROL			0x300
+#define DC_COM_CRC_CHECKSUM			0x301
+#define DC_COM_PIN_OUTPUT_ENABLE(x) (0x302 + (x))
+#define DC_COM_PIN_OUTPUT_POLARITY(x) (0x306 + (x))
+#define LVS_OUTPUT_POLARITY_LOW (1 << 28)
+#define LHS_OUTPUT_POLARITY_LOW (1 << 30)
+#define DC_COM_PIN_OUTPUT_DATA(x) (0x30a + (x))
+#define DC_COM_PIN_INPUT_ENABLE(x) (0x30e + (x))
+#define DC_COM_PIN_INPUT_DATA(x) (0x312 + (x))
+#define DC_COM_PIN_OUTPUT_SELECT(x) (0x314 + (x))
+
+#define DC_COM_PIN_MISC_CONTROL			0x31b
+#define DC_COM_PIN_PM0_CONTROL			0x31c
+#define DC_COM_PIN_PM0_DUTY_CYCLE		0x31d
+#define DC_COM_PIN_PM1_CONTROL			0x31e
+#define DC_COM_PIN_PM1_DUTY_CYCLE		0x31f
+
+#define DC_COM_SPI_CONTROL			0x320
+#define DC_COM_SPI_START_BYTE			0x321
+#define DC_COM_HSPI_WRITE_DATA_AB		0x322
+#define DC_COM_HSPI_WRITE_DATA_CD		0x323
+#define DC_COM_HSPI_CS_DC			0x324
+#define DC_COM_SCRATCH_REGISTER_A		0x325
+#define DC_COM_SCRATCH_REGISTER_B		0x326
+#define DC_COM_GPIO_CTRL			0x327
+#define DC_COM_GPIO_DEBOUNCE_COUNTER		0x328
+#define DC_COM_CRC_CHECKSUM_LATCHED		0x329
+
+#define DC_DISP_DISP_SIGNAL_OPTIONS0		0x400
+#define H_PULSE_0_ENABLE (1 <<  8)
+#define H_PULSE_1_ENABLE (1 << 10)
+#define H_PULSE_2_ENABLE (1 << 12)
+
+#define DC_DISP_DISP_SIGNAL_OPTIONS1		0x401
+
+#define DC_DISP_DISP_WIN_OPTIONS		0x402
+#define HDMI_ENABLE (1 << 30)
+
+#define DC_DISP_DISP_MEM_HIGH_PRIORITY		0x403
+#define CURSOR_THRESHOLD(x)   (((x) & 0x03) << 24)
+#define WINDOW_A_THRESHOLD(x) (((x) & 0x7f) << 16)
+#define WINDOW_B_THRESHOLD(x) (((x) & 0x7f) <<  8)
+#define WINDOW_C_THRESHOLD(x) (((x) & 0xff) <<  0)
+
+#define DC_DISP_DISP_MEM_HIGH_PRIORITY_TIMER	0x404
+#define CURSOR_DELAY(x)   (((x) & 0x3f) << 24)
+#define WINDOW_A_DELAY(x) (((x) & 0x3f) << 16)
+#define WINDOW_B_DELAY(x) (((x) & 0x3f) <<  8)
+#define WINDOW_C_DELAY(x) (((x) & 0x3f) <<  0)
+
+#define DC_DISP_DISP_TIMING_OPTIONS		0x405
+#define VSYNC_H_POSITION(x) ((x) & 0xfff)
+
+#define DC_DISP_REF_TO_SYNC			0x406
+#define DC_DISP_SYNC_WIDTH			0x407
+#define DC_DISP_BACK_PORCH			0x408
+#define DC_DISP_ACTIVE				0x409
+#define DC_DISP_FRONT_PORCH			0x40a
+#define DC_DISP_H_PULSE0_CONTROL		0x40b
+#define DC_DISP_H_PULSE0_POSITION_A		0x40c
+#define DC_DISP_H_PULSE0_POSITION_B		0x40d
+#define DC_DISP_H_PULSE0_POSITION_C		0x40e
+#define DC_DISP_H_PULSE0_POSITION_D		0x40f
+#define DC_DISP_H_PULSE1_CONTROL		0x410
+#define DC_DISP_H_PULSE1_POSITION_A		0x411
+#define DC_DISP_H_PULSE1_POSITION_B		0x412
+#define DC_DISP_H_PULSE1_POSITION_C		0x413
+#define DC_DISP_H_PULSE1_POSITION_D		0x414
+#define DC_DISP_H_PULSE2_CONTROL		0x415
+#define DC_DISP_H_PULSE2_POSITION_A		0x416
+#define DC_DISP_H_PULSE2_POSITION_B		0x417
+#define DC_DISP_H_PULSE2_POSITION_C		0x418
+#define DC_DISP_H_PULSE2_POSITION_D		0x419
+#define DC_DISP_V_PULSE0_CONTROL		0x41a
+#define DC_DISP_V_PULSE0_POSITION_A		0x41b
+#define DC_DISP_V_PULSE0_POSITION_B		0x41c
+#define DC_DISP_V_PULSE0_POSITION_C		0x41d
+#define DC_DISP_V_PULSE1_CONTROL		0x41e
+#define DC_DISP_V_PULSE1_POSITION_A		0x41f
+#define DC_DISP_V_PULSE1_POSITION_B		0x420
+#define DC_DISP_V_PULSE1_POSITION_C		0x421
+#define DC_DISP_V_PULSE2_CONTROL		0x422
+#define DC_DISP_V_PULSE2_POSITION_A		0x423
+#define DC_DISP_V_PULSE3_CONTROL		0x424
+#define DC_DISP_V_PULSE3_POSITION_A		0x425
+#define DC_DISP_M0_CONTROL			0x426
+#define DC_DISP_M1_CONTROL			0x427
+#define DC_DISP_DI_CONTROL			0x428
+#define DC_DISP_PP_CONTROL			0x429
+#define DC_DISP_PP_SELECT_A			0x42a
+#define DC_DISP_PP_SELECT_B			0x42b
+#define DC_DISP_PP_SELECT_C			0x42c
+#define DC_DISP_PP_SELECT_D			0x42d
+
+#define PULSE_MODE_NORMAL    (0 << 3)
+#define PULSE_MODE_ONE_CLOCK (1 << 3)
+#define PULSE_POLARITY_HIGH  (0 << 4)
+#define PULSE_POLARITY_LOW   (1 << 4)
+#define PULSE_QUAL_ALWAYS    (0 << 6)
+#define PULSE_QUAL_VACTIVE   (2 << 6)
+#define PULSE_QUAL_VACTIVE1  (3 << 6)
+#define PULSE_LAST_START_A   (0 << 8)
+#define PULSE_LAST_END_A     (1 << 8)
+#define PULSE_LAST_START_B   (2 << 8)
+#define PULSE_LAST_END_B     (3 << 8)
+#define PULSE_LAST_START_C   (4 << 8)
+#define PULSE_LAST_END_C     (5 << 8)
+#define PULSE_LAST_START_D   (6 << 8)
+#define PULSE_LAST_END_D     (7 << 8)
+
+#define PULSE_START(x) (((x) & 0xfff) <<  0)
+#define PULSE_END(x)   (((x) & 0xfff) << 16)
+
+#define DC_DISP_DISP_CLOCK_CONTROL		0x42e
+#define PIXEL_CLK_DIVIDER_PCD1  (0 << 8)
+#define PIXEL_CLK_DIVIDER_PCD1H (1 << 8)
+#define PIXEL_CLK_DIVIDER_PCD2  (2 << 8)
+#define PIXEL_CLK_DIVIDER_PCD3  (3 << 8)
+#define PIXEL_CLK_DIVIDER_PCD4  (4 << 8)
+#define PIXEL_CLK_DIVIDER_PCD6  (5 << 8)
+#define PIXEL_CLK_DIVIDER_PCD8  (6 << 8)
+#define PIXEL_CLK_DIVIDER_PCD9  (7 << 8)
+#define PIXEL_CLK_DIVIDER_PCD12 (8 << 8)
+#define PIXEL_CLK_DIVIDER_PCD16 (9 << 8)
+#define PIXEL_CLK_DIVIDER_PCD18 (10 << 8)
+#define PIXEL_CLK_DIVIDER_PCD24 (11 << 8)
+#define PIXEL_CLK_DIVIDER_PCD13 (12 << 8)
+#define SHIFT_CLK_DIVIDER(x)    ((x) & 0xff)
+
+#define DC_DISP_DISP_INTERFACE_CONTROL		0x42f
+#define DISP_DATA_FORMAT_DF1P1C    (0 << 0)
+#define DISP_DATA_FORMAT_DF1P2C24B (1 << 0)
+#define DISP_DATA_FORMAT_DF1P2C18B (2 << 0)
+#define DISP_DATA_FORMAT_DF1P2C16B (3 << 0)
+#define DISP_DATA_FORMAT_DF2S      (4 << 0)
+#define DISP_DATA_FORMAT_DF3S      (5 << 0)
+#define DISP_DATA_FORMAT_DFSPI     (6 << 0)
+#define DISP_DATA_FORMAT_DF1P3C24B (7 << 0)
+#define DISP_DATA_FORMAT_DF1P3C18B (8 << 0)
+#define DISP_ALIGNMENT_MSB         (0 << 8)
+#define DISP_ALIGNMENT_LSB         (1 << 8)
+#define DISP_ORDER_RED_BLUE        (0 << 9)
+#define DISP_ORDER_BLUE_RED        (1 << 9)
+
+#define DC_DISP_DISP_COLOR_CONTROL		0x430
+#define BASE_COLOR_SIZE666     (0 << 0)
+#define BASE_COLOR_SIZE111     (1 << 0)
+#define BASE_COLOR_SIZE222     (2 << 0)
+#define BASE_COLOR_SIZE333     (3 << 0)
+#define BASE_COLOR_SIZE444     (4 << 0)
+#define BASE_COLOR_SIZE555     (5 << 0)
+#define BASE_COLOR_SIZE565     (6 << 0)
+#define BASE_COLOR_SIZE332     (7 << 0)
+#define BASE_COLOR_SIZE888     (8 << 0)
+#define DITHER_CONTROL_DISABLE (0 << 8)
+#define DITHER_CONTROL_ORDERED (2 << 8)
+#define DITHER_CONTROL_ERRDIFF (3 << 8)
+
+#define DC_DISP_SHIFT_CLOCK_OPTIONS		0x431
+
+#define DC_DISP_DATA_ENABLE_OPTIONS		0x432
+#define DE_SELECT_ACTIVE_BLANK  (0 << 0)
+#define DE_SELECT_ACTIVE        (1 << 0)
+#define DE_SELECT_ACTIVE_IS     (2 << 0)
+#define DE_CONTROL_ONECLK       (0 << 2)
+#define DE_CONTROL_NORMAL       (1 << 2)
+#define DE_CONTROL_EARLY_EXT    (2 << 2)
+#define DE_CONTROL_EARLY        (3 << 2)
+#define DE_CONTROL_ACTIVE_BLANK (4 << 2)
+
+#define DC_DISP_SERIAL_INTERFACE_OPTIONS	0x433
+#define DC_DISP_LCD_SPI_OPTIONS			0x434
+#define DC_DISP_BORDER_COLOR			0x435
+#define DC_DISP_COLOR_KEY0_LOWER		0x436
+#define DC_DISP_COLOR_KEY0_UPPER		0x437
+#define DC_DISP_COLOR_KEY1_LOWER		0x438
+#define DC_DISP_COLOR_KEY1_UPPER		0x439
+
+#define DC_DISP_CURSOR_FOREGROUND		0x43c
+#define DC_DISP_CURSOR_BACKGROUND		0x43d
+
+#define DC_DISP_CURSOR_START_ADDR		0x43e
+#define DC_DISP_CURSOR_START_ADDR_NS		0x43f
+
+#define DC_DISP_CURSOR_POSITION			0x440
+#define DC_DISP_CURSOR_POSITION_NS		0x441
+
+#define DC_DISP_INIT_SEQ_CONTROL		0x442
+#define DC_DISP_SPI_INIT_SEQ_DATA_A		0x443
+#define DC_DISP_SPI_INIT_SEQ_DATA_B		0x444
+#define DC_DISP_SPI_INIT_SEQ_DATA_C		0x445
+#define DC_DISP_SPI_INIT_SEQ_DATA_D		0x446
+
+#define DC_DISP_DC_MCCIF_FIFOCTRL		0x480
+#define DC_DISP_MCCIF_DISPLAY0A_HYST		0x481
+#define DC_DISP_MCCIF_DISPLAY0B_HYST		0x482
+#define DC_DISP_MCCIF_DISPLAY1A_HYST		0x483
+#define DC_DISP_MCCIF_DISPLAY1B_HYST		0x484
+
+#define DC_DISP_DAC_CRT_CTRL			0x4c0
+#define DC_DISP_DISP_MISC_CONTROL		0x4c1
+#define DC_DISP_SD_CONTROL			0x4c2
+#define DC_DISP_SD_CSC_COEFF			0x4c3
+#define DC_DISP_SD_LUT(x)			(0x4c4 + (x))
+#define DC_DISP_SD_FLICKER_CONTROL		0x4cd
+#define DC_DISP_DC_PIXEL_COUNT			0x4ce
+#define DC_DISP_SD_HISTOGRAM(x)			(0x4cf + (x))
+#define DC_DISP_SD_BL_PARAMETERS		0x4d7
+#define DC_DISP_SD_BL_TF(x)			(0x4d8 + (x))
+#define DC_DISP_SD_BL_CONTROL			0x4dc
+#define DC_DISP_SD_HW_K_VALUES			0x4dd
+#define DC_DISP_SD_MAN_K_VALUES			0x4de
+
+#define DC_WIN_WIN_OPTIONS			0x700
+#define COLOR_EXPAND (1 <<  6)
+#define WIN_ENABLE   (1 << 30)
+
+#define DC_WIN_BYTE_SWAP			0x701
+#define BYTE_SWAP_NOSWAP  (0 << 0)
+#define BYTE_SWAP_SWAP2   (1 << 0)
+#define BYTE_SWAP_SWAP4   (2 << 0)
+#define BYTE_SWAP_SWAP4HW (3 << 0)
+
+#define DC_WIN_BUFFER_CONTROL			0x702
+#define BUFFER_CONTROL_HOST  (0 << 0)
+#define BUFFER_CONTROL_VI    (1 << 0)
+#define BUFFER_CONTROL_EPP   (2 << 0)
+#define BUFFER_CONTROL_MPEGE (3 << 0)
+#define BUFFER_CONTROL_SB2D  (4 << 0)
+
+#define DC_WIN_COLOR_DEPTH			0x703
+#define WIN_COLOR_DEPTH_P1              0
+#define WIN_COLOR_DEPTH_P2              1
+#define WIN_COLOR_DEPTH_P4              2
+#define WIN_COLOR_DEPTH_P8              3
+#define WIN_COLOR_DEPTH_B4G4R4A4        4
+#define WIN_COLOR_DEPTH_B5G5R5A         5
+#define WIN_COLOR_DEPTH_B5G6R5          6
+#define WIN_COLOR_DEPTH_AB5G5R5         7
+#define WIN_COLOR_DEPTH_B8G8R8A8       12
+#define WIN_COLOR_DEPTH_R8G8B8A8       13
+#define WIN_COLOR_DEPTH_B6x2G6x2R6x2A8 14
+#define WIN_COLOR_DEPTH_R6x2G6x2B6x2A8 15
+#define WIN_COLOR_DEPTH_YCbCr422       16
+#define WIN_COLOR_DEPTH_YUV422         17
+#define WIN_COLOR_DEPTH_YCbCr420P      18
+#define WIN_COLOR_DEPTH_YUV420P        19
+#define WIN_COLOR_DEPTH_YCbCr422P      20
+#define WIN_COLOR_DEPTH_YUV422P        21
+#define WIN_COLOR_DEPTH_YCbCr422R      22
+#define WIN_COLOR_DEPTH_YUV422R        23
+#define WIN_COLOR_DEPTH_YCbCr422RA     24
+#define WIN_COLOR_DEPTH_YUV422RA       25
+
+#define DC_WIN_POSITION				0x704
+#define H_POSITION(x) (((x) & 0x1fff) <<  0)
+#define V_POSITION(x) (((x) & 0x1fff) << 16)
+
+#define DC_WIN_SIZE				0x705
+#define H_SIZE(x) (((x) & 0x1fff) <<  0)
+#define V_SIZE(x) (((x) & 0x1fff) << 16)
+
+#define DC_WIN_PRESCALED_SIZE			0x706
+#define H_PRESCALED_SIZE(x) (((x) & 0x7fff) <<  0)
+#define V_PRESCALED_SIZE(x) (((x) & 0x1fff) << 16)
+
+#define DC_WIN_H_INITIAL_DDA			0x707
+#define DC_WIN_V_INITIAL_DDA			0x708
+#define DC_WIN_DDA_INC				0x709
+#define H_DDA_INC(x) (((x) & 0xffff) <<  0)
+#define V_DDA_INC(x) (((x) & 0xffff) << 16)
+
+#define DC_WIN_LINE_STRIDE			0x70a
+#define DC_WIN_BUF_STRIDE			0x70b
+#define DC_WIN_UV_BUF_STRIDE			0x70c
+#define DC_WIN_BUFFER_ADDR_MODE			0x70d
+#define DC_WIN_DV_CONTROL			0x70e
+
+#define DC_WIN_BLEND_NOKEY			0x70f
+#define DC_WIN_BLEND_1WIN			0x710
+#define DC_WIN_BLEND_2WIN_X			0x711
+#define DC_WIN_BLEND_2WIN_Y			0x712
+#define DC_WIN_BLEND32WIN_XY			0x713
+
+#define DC_WIN_HP_FETCH_CONTROL			0x714
+
+#define DC_WINBUF_START_ADDR			0x800
+#define DC_WINBUF_START_ADDR_NS			0x801
+#define DC_WINBUF_START_ADDR_U			0x802
+#define DC_WINBUF_START_ADDR_U_NS		0x803
+#define DC_WINBUF_START_ADDR_V			0x804
+#define DC_WINBUF_START_ADDR_V_NS		0x805
+
+#define DC_WINBUF_ADDR_H_OFFSET			0x806
+#define DC_WINBUF_ADDR_H_OFFSET_NS		0x807
+#define DC_WINBUF_ADDR_V_OFFSET			0x808
+#define DC_WINBUF_ADDR_V_OFFSET_NS		0x809
+
+#define DC_WINBUF_UFLOW_STATUS			0x80a
+
+#define DC_WINBUF_AD_UFLOW_STATUS		0xbca
+#define DC_WINBUF_BD_UFLOW_STATUS		0xdca
+#define DC_WINBUF_CD_UFLOW_STATUS		0xfca
+
+/* synchronization points */
+#define SYNCPT_VBLANK0 26
+#define SYNCPT_VBLANK1 27
+
+#endif /* TEGRA_DC_H */
diff --git a/drivers/gpu/host1x/drm/drm.c b/drivers/gpu/host1x/drm/drm.c
new file mode 100644
index 0000000..3a503c9
--- /dev/null
+++ b/drivers/gpu/host1x/drm/drm.c
@@ -0,0 +1,115 @@
+/*
+ * Copyright (C) 2012 Avionic Design GmbH
+ * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+
+#include <mach/clk.h>
+#include <linux/dma-mapping.h>
+#include <asm/dma-iommu.h>
+
+#include "drm.h"
+
+#define DRIVER_NAME "tegra"
+#define DRIVER_DESC "NVIDIA Tegra graphics"
+#define DRIVER_DATE "20120330"
+#define DRIVER_MAJOR 0
+#define DRIVER_MINOR 0
+#define DRIVER_PATCHLEVEL 0
+
+static int tegra_drm_load(struct drm_device *drm, unsigned long flags)
+{
+	struct device *dev = drm->dev;
+	struct host1x *host1x;
+	int err;
+
+	host1x = dev_get_drvdata(dev);
+	drm->dev_private = host1x;
+	host1x->drm = drm;
+
+	drm_mode_config_init(drm);
+
+	err = host1x_drm_init(host1x, drm);
+	if (err < 0)
+		return err;
+
+	err = tegra_drm_fb_init(drm);
+	if (err < 0)
+		return err;
+
+	drm_kms_helper_poll_init(drm);
+
+	return 0;
+}
+
+static int tegra_drm_unload(struct drm_device *drm)
+{
+	drm_kms_helper_poll_fini(drm);
+	tegra_drm_fb_exit(drm);
+
+	drm_mode_config_cleanup(drm);
+
+	return 0;
+}
+
+static int tegra_drm_open(struct drm_device *drm, struct drm_file *filp)
+{
+	return 0;
+}
+
+static void tegra_drm_lastclose(struct drm_device *drm)
+{
+	struct host1x *host1x = drm->dev_private;
+
+	drm_fbdev_cma_restore_mode(host1x->fbdev);
+}
+
+static struct drm_ioctl_desc tegra_drm_ioctls[] = {
+};
+
+static const struct file_operations tegra_drm_fops = {
+	.owner = THIS_MODULE,
+	.open = drm_open,
+	.release = drm_release,
+	.unlocked_ioctl = drm_ioctl,
+	.mmap = drm_gem_cma_mmap,
+	.poll = drm_poll,
+	.fasync = drm_fasync,
+	.read = drm_read,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = drm_compat_ioctl,
+#endif
+	.llseek = noop_llseek,
+};
+
+struct drm_driver tegra_drm_driver = {
+	.driver_features = DRIVER_BUS_PLATFORM | DRIVER_MODESET | DRIVER_GEM,
+	.load = tegra_drm_load,
+	.unload = tegra_drm_unload,
+	.open = tegra_drm_open,
+	.lastclose = tegra_drm_lastclose,
+
+	.gem_free_object = drm_gem_cma_free_object,
+	.gem_vm_ops = &drm_gem_cma_vm_ops,
+	.dumb_create = drm_gem_cma_dumb_create,
+	.dumb_map_offset = drm_gem_cma_dumb_map_offset,
+	.dumb_destroy = drm_gem_cma_dumb_destroy,
+
+	.ioctls = tegra_drm_ioctls,
+	.num_ioctls = ARRAY_SIZE(tegra_drm_ioctls),
+	.fops = &tegra_drm_fops,
+
+	.name = DRIVER_NAME,
+	.desc = DRIVER_DESC,
+	.date = DRIVER_DATE,
+	.major = DRIVER_MAJOR,
+	.minor = DRIVER_MINOR,
+	.patchlevel = DRIVER_PATCHLEVEL,
+};
diff --git a/drivers/gpu/host1x/drm/drm.h b/drivers/gpu/host1x/drm/drm.h
new file mode 100644
index 0000000..e68b4ac
--- /dev/null
+++ b/drivers/gpu/host1x/drm/drm.h
@@ -0,0 +1,216 @@
+/*
+ * Copyright (C) 2012 Avionic Design GmbH
+ * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef HOST1X_DRM_H
+#define HOST1X_DRM_H 1
+
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_edid.h>
+#include <drm/drm_fb_helper.h>
+#include <drm/drm_gem_cma_helper.h>
+#include <drm/drm_fb_cma_helper.h>
+#include <drm/drm_fixed.h>
+
+struct tegra_framebuffer {
+	struct drm_framebuffer base;
+	struct drm_gem_cma_object *obj;
+};
+
+static inline struct tegra_framebuffer *to_tegra_fb(struct drm_framebuffer *fb)
+{
+	return container_of(fb, struct tegra_framebuffer, base);
+}
+
+struct host1x {
+	struct drm_device *drm;
+	struct device *dev;
+	void __iomem *regs;
+	struct clk *clk;
+	int syncpt;
+	int irq;
+
+	struct mutex drm_clients_lock;
+	struct list_head drm_clients;
+	struct list_head drm_active;
+
+	struct mutex clients_lock;
+	struct list_head clients;
+
+	struct drm_fbdev_cma *fbdev;
+	struct tegra_framebuffer fb;
+};
+
+struct host1x_client;
+
+struct host1x_client_ops {
+	int (*drm_init)(struct host1x_client *client, struct drm_device *drm);
+	int (*drm_exit)(struct host1x_client *client);
+};
+
+struct host1x_client {
+	struct host1x *host1x;
+	struct device *dev;
+
+	const struct host1x_client_ops *ops;
+
+	struct list_head list;
+};
+
+extern int host1x_drm_init(struct host1x *host1x, struct drm_device *drm);
+extern int host1x_drm_exit(struct host1x *host1x);
+
+extern int host1x_register_client(struct host1x *host1x,
+				  struct host1x_client *client);
+extern int host1x_unregister_client(struct host1x *host1x,
+				    struct host1x_client *client);
+
+struct tegra_output;
+
+struct tegra_dc {
+	struct host1x_client client;
+
+	struct host1x *host1x;
+	struct device *dev;
+
+	struct drm_crtc base;
+	int pipe;
+
+	struct clk *clk;
+
+	void __iomem *regs;
+	int irq;
+
+	struct tegra_output *rgb;
+
+	struct list_head list;
+
+	struct drm_info_list *debugfs_files;
+	struct drm_minor *minor;
+	struct dentry *debugfs;
+};
+
+static inline struct tegra_dc *host1x_client_to_dc(struct host1x_client *client)
+{
+	return container_of(client, struct tegra_dc, client);
+}
+
+static inline struct tegra_dc *to_tegra_dc(struct drm_crtc *crtc)
+{
+	return container_of(crtc, struct tegra_dc, base);
+}
+
+static inline void tegra_dc_writel(struct tegra_dc *dc, unsigned long value,
+				   unsigned long reg)
+{
+	writel(value, dc->regs + (reg << 2));
+}
+
+static inline unsigned long tegra_dc_readl(struct tegra_dc *dc,
+					   unsigned long reg)
+{
+	return readl(dc->regs + (reg << 2));
+}
+
+struct tegra_output_ops {
+	int (*enable)(struct tegra_output *output);
+	int (*disable)(struct tegra_output *output);
+	int (*setup_clock)(struct tegra_output *output, struct clk *clk,
+			   unsigned long pclk);
+	int (*check_mode)(struct tegra_output *output,
+			  struct drm_display_mode *mode,
+			  enum drm_mode_status *status);
+};
+
+enum tegra_output_type {
+	TEGRA_OUTPUT_RGB,
+	TEGRA_OUTPUT_HDMI,
+};
+
+struct tegra_output {
+	struct device_node *of_node;
+	struct device *dev;
+
+	const struct tegra_output_ops *ops;
+	enum tegra_output_type type;
+
+	struct i2c_adapter *ddc;
+	const struct edid *edid;
+	unsigned int hpd_irq;
+	int hpd_gpio;
+
+	struct drm_encoder encoder;
+	struct drm_connector connector;
+};
+
+static inline struct tegra_output *encoder_to_output(struct drm_encoder *e)
+{
+	return container_of(e, struct tegra_output, encoder);
+}
+
+static inline struct tegra_output *connector_to_output(struct drm_connector *c)
+{
+	return container_of(c, struct tegra_output, connector);
+}
+
+static inline int tegra_output_enable(struct tegra_output *output)
+{
+	if (output && output->ops && output->ops->enable)
+		return output->ops->enable(output);
+
+	return output ? -ENOSYS : -EINVAL;
+}
+
+static inline int tegra_output_disable(struct tegra_output *output)
+{
+	if (output && output->ops && output->ops->disable)
+		return output->ops->disable(output);
+
+	return output ? -ENOSYS : -EINVAL;
+}
+
+static inline int tegra_output_setup_clock(struct tegra_output *output,
+					   struct clk *clk, unsigned long pclk)
+{
+	if (output && output->ops && output->ops->setup_clock)
+		return output->ops->setup_clock(output, clk, pclk);
+
+	return output ? -ENOSYS : -EINVAL;
+}
+
+static inline int tegra_output_check_mode(struct tegra_output *output,
+					  struct drm_display_mode *mode,
+					  enum drm_mode_status *status)
+{
+	if (output && output->ops && output->ops->check_mode)
+		return output->ops->check_mode(output, mode, status);
+
+	return output ? -ENOSYS : -EINVAL;
+}
+
+/* from rgb.c */
+extern int tegra_dc_rgb_probe(struct tegra_dc *dc);
+extern int tegra_dc_rgb_init(struct drm_device *drm, struct tegra_dc *dc);
+extern int tegra_dc_rgb_exit(struct tegra_dc *dc);
+
+/* from output.c */
+extern int tegra_output_parse_dt(struct tegra_output *output);
+extern int tegra_output_init(struct drm_device *drm, struct tegra_output *output);
+extern int tegra_output_exit(struct tegra_output *output);
+
+/* from fb.c */
+extern int tegra_drm_fb_init(struct drm_device *drm);
+extern void tegra_drm_fb_exit(struct drm_device *drm);
+
+extern struct platform_driver tegra_host1x_driver;
+extern struct platform_driver tegra_hdmi_driver;
+extern struct platform_driver tegra_dc_driver;
+extern struct drm_driver tegra_drm_driver;
+
+#endif /* HOST1X_DRM_H */
diff --git a/drivers/gpu/host1x/drm/fb.c b/drivers/gpu/host1x/drm/fb.c
new file mode 100644
index 0000000..97993c6
--- /dev/null
+++ b/drivers/gpu/host1x/drm/fb.c
@@ -0,0 +1,56 @@
+/*
+ * Copyright (C) 2012 Avionic Design GmbH
+ * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "drm.h"
+
+static void tegra_drm_fb_output_poll_changed(struct drm_device *drm)
+{
+	struct host1x *host1x = drm->dev_private;
+
+	drm_fbdev_cma_hotplug_event(host1x->fbdev);
+}
+
+static const struct drm_mode_config_funcs tegra_drm_mode_funcs = {
+	.fb_create = drm_fb_cma_create,
+	.output_poll_changed = tegra_drm_fb_output_poll_changed,
+};
+
+int tegra_drm_fb_init(struct drm_device *drm)
+{
+	struct host1x *host1x = drm->dev_private;
+	struct drm_fbdev_cma *fbdev;
+
+	drm->mode_config.min_width = 0;
+	drm->mode_config.min_height = 0;
+
+	drm->mode_config.max_width = 4096;
+	drm->mode_config.max_height = 4096;
+
+	drm->mode_config.funcs = &tegra_drm_mode_funcs;
+
+	fbdev = drm_fbdev_cma_init(drm, 32, drm->mode_config.num_crtc,
+				   drm->mode_config.num_connector);
+	if (IS_ERR(fbdev))
+		return PTR_ERR(fbdev);
+
+#ifndef CONFIG_FRAMEBUFFER_CONSOLE
+	drm_fbdev_cma_restore_mode(fbdev);
+#endif
+
+	host1x->fbdev = fbdev;
+
+	return 0;
+}
+
+void tegra_drm_fb_exit(struct drm_device *drm)
+{
+	struct host1x *host1x = drm->dev_private;
+
+	drm_fbdev_cma_fini(host1x->fbdev);
+}
diff --git a/drivers/gpu/host1x/drm/hdmi.c b/drivers/gpu/host1x/drm/hdmi.c
new file mode 100644
index 0000000..e060c7e
--- /dev/null
+++ b/drivers/gpu/host1x/drm/hdmi.c
@@ -0,0 +1,1321 @@
+/*
+ * Copyright (C) 2012 Avionic Design GmbH
+ * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk.h>
+#include <linux/debugfs.h>
+#include <linux/gpio.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
+
+#include <mach/clk.h>
+
+#include "hdmi.h"
+#include "drm.h"
+#include "dc.h"
+
+struct tegra_hdmi {
+	struct host1x_client client;
+	struct tegra_output output;
+	struct device *dev;
+
+	struct regulator *vdd;
+	struct regulator *pll;
+
+	void __iomem *regs;
+	unsigned int irq;
+
+	struct clk *clk_parent;
+	struct clk *clk;
+
+	unsigned int audio_source;
+	unsigned int audio_freq;
+	bool stereo;
+	bool dvi;
+
+	struct drm_info_list *debugfs_files;
+	struct drm_minor *minor;
+	struct dentry *debugfs;
+};
+
+static inline struct tegra_hdmi *
+host1x_client_to_hdmi(struct host1x_client *client)
+{
+	return container_of(client, struct tegra_hdmi, client);
+}
+
+static inline struct tegra_hdmi *to_hdmi(struct tegra_output *output)
+{
+	return container_of(output, struct tegra_hdmi, output);
+}
+
+#define HDMI_AUDIOCLK_FREQ 216000000
+#define HDMI_REKEY_DEFAULT 56
+
+enum {
+	AUTO = 0,
+	SPDIF,
+	HDA,
+};
+
+static inline unsigned long tegra_hdmi_readl(struct tegra_hdmi *hdmi,
+					     unsigned long reg)
+{
+	return readl(hdmi->regs + (reg << 2));
+}
+
+static inline void tegra_hdmi_writel(struct tegra_hdmi *hdmi, unsigned long val,
+				     unsigned long reg)
+{
+	writel(val, hdmi->regs + (reg << 2));
+}
+
+struct tegra_hdmi_audio_config {
+	unsigned int pclk;
+	unsigned int n;
+	unsigned int cts;
+	unsigned int aval;
+};
+
+static const struct tegra_hdmi_audio_config tegra_hdmi_audio_32k[] = {
+	{  25200000, 4096,  25200, 24000 },
+	{  27000000, 4096,  27000, 24000 },
+	{  74250000, 4096,  74250, 24000 },
+	{ 148500000, 4096, 148500, 24000 },
+	{         0,    0,      0,     0 },
+};
+
+static const struct tegra_hdmi_audio_config tegra_hdmi_audio_44_1k[] = {
+	{  25200000, 5880,  26250, 25000 },
+	{  27000000, 5880,  28125, 25000 },
+	{  74250000, 4704,  61875, 20000 },
+	{ 148500000, 4704, 123750, 20000 },
+	{         0,    0,      0,     0 },
+};
+
+static const struct tegra_hdmi_audio_config tegra_hdmi_audio_48k[] = {
+	{  25200000, 6144,  25200, 24000 },
+	{  27000000, 6144,  27000, 24000 },
+	{  74250000, 6144,  74250, 24000 },
+	{ 148500000, 6144, 148500, 24000 },
+	{         0,    0,      0,     0 },
+};
+
+static const struct tegra_hdmi_audio_config tegra_hdmi_audio_88_2k[] = {
+	{  25200000, 11760,  26250, 25000 },
+	{  27000000, 11760,  28125, 25000 },
+	{  74250000,  9408,  61875, 20000 },
+	{ 148500000,  9408, 123750, 20000 },
+	{         0,     0,      0,     0 },
+};
+
+static const struct tegra_hdmi_audio_config tegra_hdmi_audio_96k[] = {
+	{  25200000, 12288,  25200, 24000 },
+	{  27000000, 12288,  27000, 24000 },
+	{  74250000, 12288,  74250, 24000 },
+	{ 148500000, 12288, 148500, 24000 },
+	{         0,     0,      0,     0 },
+};
+
+static const struct tegra_hdmi_audio_config tegra_hdmi_audio_176_4k[] = {
+	{  25200000, 23520,  26250, 25000 },
+	{  27000000, 23520,  28125, 25000 },
+	{  74250000, 18816,  61875, 20000 },
+	{ 148500000, 18816, 123750, 20000 },
+	{         0,     0,      0,     0 },
+};
+
+static const struct tegra_hdmi_audio_config tegra_hdmi_audio_192k[] = {
+	{  25200000, 24576,  25200, 24000 },
+	{  27000000, 24576,  27000, 24000 },
+	{  74250000, 24576,  74250, 24000 },
+	{ 148500000, 24576, 148500, 24000 },
+	{         0,     0,      0,     0 },
+};
+
+struct tmds_config {
+	unsigned int pclk;
+	u32 pll0;
+	u32 pll1;
+	u32 pe_current;
+	u32 drive_current;
+};
+
+static const struct tmds_config tegra2_tmds_config[] = {
+	{ /* slow pixel clock modes */
+		.pclk = 27000000,
+		.pll0 = SOR_PLL_BG_V17_S(3) | SOR_PLL_ICHPMP(1) |
+			SOR_PLL_RESISTORSEL | SOR_PLL_VCOCAP(0) |
+			SOR_PLL_TX_REG_LOAD(3),
+		.pll1 = SOR_PLL_TMDS_TERM_ENABLE,
+		.pe_current = PE_CURRENT0(PE_CURRENT_0_0_mA) |
+			PE_CURRENT1(PE_CURRENT_0_0_mA) |
+			PE_CURRENT2(PE_CURRENT_0_0_mA) |
+			PE_CURRENT3(PE_CURRENT_0_0_mA),
+		.drive_current = DRIVE_CURRENT_LANE0(DRIVE_CURRENT_7_125_mA) |
+			DRIVE_CURRENT_LANE1(DRIVE_CURRENT_7_125_mA) |
+			DRIVE_CURRENT_LANE2(DRIVE_CURRENT_7_125_mA) |
+			DRIVE_CURRENT_LANE3(DRIVE_CURRENT_7_125_mA),
+	},
+	{ /* high pixel clock modes */
+		.pclk = UINT_MAX,
+		.pll0 = SOR_PLL_BG_V17_S(3) | SOR_PLL_ICHPMP(1) |
+			SOR_PLL_RESISTORSEL | SOR_PLL_VCOCAP(1) |
+			SOR_PLL_TX_REG_LOAD(3),
+		.pll1 = SOR_PLL_TMDS_TERM_ENABLE | SOR_PLL_PE_EN,
+		.pe_current = PE_CURRENT0(PE_CURRENT_6_0_mA) |
+			PE_CURRENT1(PE_CURRENT_6_0_mA) |
+			PE_CURRENT2(PE_CURRENT_6_0_mA) |
+			PE_CURRENT3(PE_CURRENT_6_0_mA),
+		.drive_current = DRIVE_CURRENT_LANE0(DRIVE_CURRENT_7_125_mA) |
+			DRIVE_CURRENT_LANE1(DRIVE_CURRENT_7_125_mA) |
+			DRIVE_CURRENT_LANE2(DRIVE_CURRENT_7_125_mA) |
+			DRIVE_CURRENT_LANE3(DRIVE_CURRENT_7_125_mA),
+	},
+};
+
+static const struct tmds_config tegra3_tmds_config[] = {
+	{ /* 480p modes */
+		.pclk = 27000000,
+		.pll0 = SOR_PLL_BG_V17_S(3) | SOR_PLL_ICHPMP(1) |
+			SOR_PLL_RESISTORSEL | SOR_PLL_VCOCAP(0) |
+			SOR_PLL_TX_REG_LOAD(0),
+		.pll1 = SOR_PLL_TMDS_TERM_ENABLE,
+		.pe_current = PE_CURRENT0(PE_CURRENT_0_0_mA) |
+			PE_CURRENT1(PE_CURRENT_0_0_mA) |
+			PE_CURRENT2(PE_CURRENT_0_0_mA) |
+			PE_CURRENT3(PE_CURRENT_0_0_mA),
+		.drive_current = DRIVE_CURRENT_LANE0(DRIVE_CURRENT_5_250_mA) |
+			DRIVE_CURRENT_LANE1(DRIVE_CURRENT_5_250_mA) |
+			DRIVE_CURRENT_LANE2(DRIVE_CURRENT_5_250_mA) |
+			DRIVE_CURRENT_LANE3(DRIVE_CURRENT_5_250_mA),
+	}, { /* 720p modes */
+		.pclk = 74250000,
+		.pll0 = SOR_PLL_BG_V17_S(3) | SOR_PLL_ICHPMP(1) |
+			SOR_PLL_RESISTORSEL | SOR_PLL_VCOCAP(1) |
+			SOR_PLL_TX_REG_LOAD(0),
+		.pll1 = SOR_PLL_TMDS_TERM_ENABLE | SOR_PLL_PE_EN,
+		.pe_current = PE_CURRENT0(PE_CURRENT_5_0_mA) |
+			PE_CURRENT1(PE_CURRENT_5_0_mA) |
+			PE_CURRENT2(PE_CURRENT_5_0_mA) |
+			PE_CURRENT3(PE_CURRENT_5_0_mA),
+		.drive_current = DRIVE_CURRENT_LANE0(DRIVE_CURRENT_5_250_mA) |
+			DRIVE_CURRENT_LANE1(DRIVE_CURRENT_5_250_mA) |
+			DRIVE_CURRENT_LANE2(DRIVE_CURRENT_5_250_mA) |
+			DRIVE_CURRENT_LANE3(DRIVE_CURRENT_5_250_mA),
+	}, { /* 1080p modes */
+		.pclk = UINT_MAX,
+		.pll0 = SOR_PLL_BG_V17_S(3) | SOR_PLL_ICHPMP(1) |
+			SOR_PLL_RESISTORSEL | SOR_PLL_VCOCAP(3) |
+			SOR_PLL_TX_REG_LOAD(0),
+		.pll1 = SOR_PLL_TMDS_TERM_ENABLE | SOR_PLL_PE_EN,
+		.pe_current = PE_CURRENT0(PE_CURRENT_5_0_mA) |
+			PE_CURRENT1(PE_CURRENT_5_0_mA) |
+			PE_CURRENT2(PE_CURRENT_5_0_mA) |
+			PE_CURRENT3(PE_CURRENT_5_0_mA),
+		.drive_current = DRIVE_CURRENT_LANE0(DRIVE_CURRENT_5_250_mA) |
+			DRIVE_CURRENT_LANE1(DRIVE_CURRENT_5_250_mA) |
+			DRIVE_CURRENT_LANE2(DRIVE_CURRENT_5_250_mA) |
+			DRIVE_CURRENT_LANE3(DRIVE_CURRENT_5_250_mA),
+	},
+};
+
+static const struct tegra_hdmi_audio_config *
+tegra_hdmi_get_audio_config(unsigned int audio_freq, unsigned int pclk)
+{
+	const struct tegra_hdmi_audio_config *table;
+
+	switch (audio_freq) {
+	case 32000:
+		table = tegra_hdmi_audio_32k;
+		break;
+
+	case 44100:
+		table = tegra_hdmi_audio_44_1k;
+		break;
+
+	case 48000:
+		table = tegra_hdmi_audio_48k;
+		break;
+
+	case 88200:
+		table = tegra_hdmi_audio_88_2k;
+		break;
+
+	case 96000:
+		table = tegra_hdmi_audio_96k;
+		break;
+
+	case 176400:
+		table = tegra_hdmi_audio_176_4k;
+		break;
+
+	case 192000:
+		table = tegra_hdmi_audio_192k;
+		break;
+
+	default:
+		return NULL;
+	}
+
+	while (table->pclk) {
+		if (table->pclk == pclk)
+			return table;
+
+		table++;
+	}
+
+	return NULL;
+}
+
+static void tegra_hdmi_setup_audio_fs_tables(struct tegra_hdmi *hdmi)
+{
+	const unsigned int freqs[] = {
+		32000, 44100, 48000, 88200, 96000, 176400, 192000
+	};
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(freqs); i++) {
+		unsigned int f = freqs[i];
+		unsigned int eight_half;
+		unsigned long value;
+		unsigned int delta;
+
+		if (f > 96000)
+			delta = 2;
+		else if (f > 480000)
+			delta = 6;
+		else
+			delta = 9;
+
+		eight_half = (8 * HDMI_AUDIOCLK_FREQ) / (f * 128);
+		value = AUDIO_FS_LOW(eight_half - delta) |
+			AUDIO_FS_HIGH(eight_half + delta);
+		tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_AUDIO_FS(i));
+	}
+}
+
+static int tegra_hdmi_setup_audio(struct tegra_hdmi *hdmi, unsigned int pclk)
+{
+	struct device_node *node = hdmi->dev->of_node;
+	const struct tegra_hdmi_audio_config *config;
+	unsigned int offset = 0;
+	unsigned long value;
+
+	switch (hdmi->audio_source) {
+	case HDA:
+		value = AUDIO_CNTRL0_SOURCE_SELECT_HDAL;
+		break;
+
+	case SPDIF:
+		value = AUDIO_CNTRL0_SOURCE_SELECT_SPDIF;
+		break;
+
+	default:
+		value = AUDIO_CNTRL0_SOURCE_SELECT_AUTO;
+		break;
+	}
+
+	if (of_device_is_compatible(node, "nvidia,tegra30-hdmi")) {
+		value |= AUDIO_CNTRL0_ERROR_TOLERANCE(6) |
+			 AUDIO_CNTRL0_FRAMES_PER_BLOCK(0xc0);
+		tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_AUDIO_CNTRL0);
+	} else {
+		value |= AUDIO_CNTRL0_INJECT_NULLSMPL;
+		tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_SOR_AUDIO_CNTRL0);
+
+		value = AUDIO_CNTRL0_ERROR_TOLERANCE(6) |
+			AUDIO_CNTRL0_FRAMES_PER_BLOCK(0xc0);
+		tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_AUDIO_CNTRL0);
+	}
+
+	config = tegra_hdmi_get_audio_config(hdmi->audio_freq, pclk);
+	if (!config) {
+		dev_err(hdmi->dev, "cannot set audio to %u at %u pclk\n",
+			hdmi->audio_freq, pclk);
+		return -EINVAL;
+	}
+
+	tegra_hdmi_writel(hdmi, 0, HDMI_NV_PDISP_HDMI_ACR_CTRL);
+
+	value = AUDIO_N_RESETF | AUDIO_N_GENERATE_ALTERNATE |
+		AUDIO_N_VALUE(config->n - 1);
+	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_AUDIO_N);
+
+	tegra_hdmi_writel(hdmi, ACR_SUBPACK_N(config->n) | ACR_ENABLE,
+			  HDMI_NV_PDISP_HDMI_ACR_0441_SUBPACK_HIGH);
+
+	value = ACR_SUBPACK_CTS(config->cts);
+	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_HDMI_ACR_0441_SUBPACK_LOW);
+
+	value = SPARE_HW_CTS | SPARE_FORCE_SW_CTS | SPARE_CTS_RESET_VAL(1);
+	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_HDMI_SPARE);
+
+	value = tegra_hdmi_readl(hdmi, HDMI_NV_PDISP_AUDIO_N);
+	value &= ~AUDIO_N_RESETF;
+	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_AUDIO_N);
+
+	if (of_device_is_compatible(node, "nvidia,tegra30-hdmi")) {
+		switch (hdmi->audio_freq) {
+		case 32000:
+			offset = HDMI_NV_PDISP_SOR_AUDIO_AVAL_0320;
+			break;
+
+		case 44100:
+			offset = HDMI_NV_PDISP_SOR_AUDIO_AVAL_0441;
+			break;
+
+		case 48000:
+			offset = HDMI_NV_PDISP_SOR_AUDIO_AVAL_0480;
+			break;
+
+		case 88200:
+			offset = HDMI_NV_PDISP_SOR_AUDIO_AVAL_0882;
+			break;
+
+		case 96000:
+			offset = HDMI_NV_PDISP_SOR_AUDIO_AVAL_0960;
+			break;
+
+		case 176400:
+			offset = HDMI_NV_PDISP_SOR_AUDIO_AVAL_1764;
+			break;
+
+		case 192000:
+			offset = HDMI_NV_PDISP_SOR_AUDIO_AVAL_1920;
+			break;
+		}
+
+		tegra_hdmi_writel(hdmi, config->aval, offset);
+	}
+
+	tegra_hdmi_setup_audio_fs_tables(hdmi);
+
+	return 0;
+}
+
+static void tegra_hdmi_write_infopack(struct tegra_hdmi *hdmi,
+				      unsigned int offset, u8 type,
+				      u8 version, void *data, size_t size)
+{
+	unsigned long value;
+	u8 *ptr = data;
+	u32 subpack[2];
+	size_t i;
+	u8 csum;
+
+	/* first byte of data is the checksum */
+	csum = type + version + size - 1;
+
+	for (i = 1; i < size; i++)
+		csum += ptr[i];
+
+	ptr[0] = 0x100 - csum;
+
+	value = INFOFRAME_HEADER_TYPE(type) |
+		INFOFRAME_HEADER_VERSION(version) |
+		INFOFRAME_HEADER_LEN(size - 1);
+	tegra_hdmi_writel(hdmi, value, offset);
+
+	/* The audio inforame only has one set of subpack registers.  The hdmi
+	 * block pads the rest of the data as per the spec so we have to fixup
+	 * the length before filling in the subpacks.
+	 */
+	if (offset == HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_HEADER)
+		size = 6;
+
+	/* each subpack 7 bytes devided into:
+	 *   subpack_low - bytes 0 - 3
+	 *   subpack_high - bytes 4 - 6 (with byte 7 padded to 0x00)
+	 */
+	for (i = 0; i < size; i++) {
+		size_t index = i % 7;
+
+		if (index == 0)
+			memset(subpack, 0x0, sizeof(subpack));
+
+		((u8 *)subpack)[index] = ptr[i];
+
+		if (index == 6 || (i + 1 == size)) {
+			unsigned int reg = offset + 1 + (i / 7) * 2;
+
+			tegra_hdmi_writel(hdmi, subpack[0], reg);
+			tegra_hdmi_writel(hdmi, subpack[1], reg + 1);
+		}
+	}
+}
+
+static void tegra_hdmi_setup_avi_infoframe(struct tegra_hdmi *hdmi,
+					   struct drm_display_mode *mode)
+{
+	struct hdmi_avi_infoframe frame;
+	unsigned int h_front_porch;
+	unsigned int hsize = 16;
+	unsigned int vsize = 9;
+
+	if (hdmi->dvi) {
+		tegra_hdmi_writel(hdmi, 0,
+				  HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_CTRL);
+		return;
+	}
+
+	h_front_porch = mode->hsync_start - mode->hdisplay;
+	memset(&frame, 0, sizeof(frame));
+	frame.r = HDMI_AVI_R_SAME;
+
+	switch (mode->vdisplay) {
+	case 480:
+		if (mode->hdisplay == 640) {
+			frame.m = HDMI_AVI_M_4_3;
+			frame.vic = 1;
+		} else {
+			frame.m = HDMI_AVI_M_16_9;
+			frame.vic = 3;
+		}
+		break;
+
+	case 576:
+		if (((hsize * 10) / vsize) > 14) {
+			frame.m = HDMI_AVI_M_16_9;
+			frame.vic = 18;
+		} else {
+			frame.m = HDMI_AVI_M_4_3;
+			frame.vic = 17;
+		}
+		break;
+
+	case 720:
+	case 1470: /* stereo mode */
+		frame.m = HDMI_AVI_M_16_9;
+
+		if (h_front_porch == 110)
+			frame.vic = 4;
+		else
+			frame.vic = 19;
+		break;
+
+	case 1080:
+	case 2205: /* stereo mode */
+		frame.m = HDMI_AVI_M_16_9;
+
+		switch (h_front_porch) {
+		case 88:
+			frame.vic = 16;
+			break;
+
+		case 528:
+			frame.vic = 31;
+			break;
+
+		default:
+			frame.vic = 32;
+			break;
+		}
+		break;
+
+	default:
+		frame.m = HDMI_AVI_M_16_9;
+		frame.vic = 0;
+		break;
+	}
+
+	tegra_hdmi_write_infopack(hdmi, HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_HEADER,
+				  HDMI_INFOFRAME_TYPE_AVI, HDMI_AVI_VERSION,
+				  &frame, sizeof(frame));
+
+	tegra_hdmi_writel(hdmi, INFOFRAME_CTRL_ENABLE,
+			  HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_CTRL);
+}
+
+static void tegra_hdmi_setup_audio_infoframe(struct tegra_hdmi *hdmi)
+{
+	struct hdmi_audio_infoframe frame;
+
+	if (hdmi->dvi) {
+		tegra_hdmi_writel(hdmi, 0,
+				  HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_CTRL);
+		return;
+	}
+
+	memset(&frame, 0, sizeof(frame));
+	frame.cc = HDMI_AUDIO_CC_2;
+
+	tegra_hdmi_write_infopack(hdmi,
+				  HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_HEADER,
+				  HDMI_INFOFRAME_TYPE_AUDIO,
+				  HDMI_AUDIO_VERSION,
+				  &frame, sizeof(frame));
+
+	tegra_hdmi_writel(hdmi, INFOFRAME_CTRL_ENABLE,
+			  HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_CTRL);
+}
+
+static void tegra_hdmi_setup_stereo_infoframe(struct tegra_hdmi *hdmi)
+{
+	struct hdmi_stereo_infoframe frame;
+	unsigned long value;
+
+	if (!hdmi->stereo) {
+		value = tegra_hdmi_readl(hdmi, HDMI_NV_PDISP_HDMI_GENERIC_CTRL);
+		value &= ~GENERIC_CTRL_ENABLE;
+		tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_HDMI_GENERIC_CTRL);
+		return;
+	}
+
+	memset(&frame, 0, sizeof(frame));
+	frame.regid0 = 0x03;
+	frame.regid1 = 0x0c;
+	frame.regid2 = 0x00;
+	frame.hdmi_video_format = 2;
+
+	/* TODO: 74 MHz limit? */
+	if (1) {
+		frame._3d_structure = 0;
+	} else {
+		frame._3d_structure = 8;
+		frame._3d_ext_data = 0;
+	}
+
+	tegra_hdmi_write_infopack(hdmi, HDMI_NV_PDISP_HDMI_GENERIC_HEADER,
+				  HDMI_INFOFRAME_TYPE_VENDOR,
+				  HDMI_VENDOR_VERSION, &frame, 6);
+
+	value = tegra_hdmi_readl(hdmi, HDMI_NV_PDISP_HDMI_GENERIC_CTRL);
+	value |= GENERIC_CTRL_ENABLE;
+	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_HDMI_GENERIC_CTRL);
+}
+
+static void tegra_hdmi_setup_tmds(struct tegra_hdmi *hdmi,
+				  const struct tmds_config *tmds)
+{
+	unsigned long value;
+
+	tegra_hdmi_writel(hdmi, tmds->pll0, HDMI_NV_PDISP_SOR_PLL0);
+	tegra_hdmi_writel(hdmi, tmds->pll1, HDMI_NV_PDISP_SOR_PLL1);
+	tegra_hdmi_writel(hdmi, tmds->pe_current, HDMI_NV_PDISP_PE_CURRENT);
+
+	value = tmds->drive_current | DRIVE_CURRENT_FUSE_OVERRIDE;
+	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_SOR_LANE_DRIVE_CURRENT);
+}
+
+static int tegra_output_hdmi_enable(struct tegra_output *output)
+{
+	unsigned int h_sync_width, h_front_porch, h_back_porch, i, rekey;
+	struct tegra_dc *dc = to_tegra_dc(output->encoder.crtc);
+	struct drm_display_mode *mode = &dc->base.mode;
+	struct tegra_hdmi *hdmi = to_hdmi(output);
+	struct device_node *node = hdmi->dev->of_node;
+	unsigned int pulse_start, div82, pclk;
+	const struct tmds_config *tmds;
+	unsigned int num_tmds;
+	unsigned long value;
+	int retries = 1000;
+	int err;
+
+	pclk = mode->clock * 1000;
+	h_sync_width = mode->hsync_end - mode->hsync_start;
+	h_back_porch = mode->htotal - mode->hsync_end;
+	h_front_porch = mode->hsync_start - mode->hdisplay;
+
+	err = regulator_enable(hdmi->vdd);
+	if (err < 0) {
+		dev_err(hdmi->dev, "failed to enable VDD regulator: %d\n", err);
+		return err;
+	}
+
+	err = regulator_enable(hdmi->pll);
+	if (err < 0) {
+		dev_err(hdmi->dev, "failed to enable PLL regulator: %d\n", err);
+		return err;
+	}
+
+	/*
+	 * This assumes that the display controller will divide its parent
+	 * clock by 2 to generate the pixel clock.
+	 */
+	err = tegra_output_setup_clock(output, hdmi->clk, pclk * 2);
+	if (err < 0) {
+		dev_err(hdmi->dev, "failed to setup clock: %d\n", err);
+		return err;
+	}
+
+	err = clk_set_rate(hdmi->clk, pclk);
+	if (err < 0)
+		return err;
+
+	err = clk_enable(hdmi->clk);
+	if (err < 0) {
+		dev_err(hdmi->dev, "failed to enable clock: %d\n", err);
+		return err;
+	}
+
+	tegra_periph_reset_assert(hdmi->clk);
+	usleep_range(1000, 2000);
+	tegra_periph_reset_deassert(hdmi->clk);
+
+	tegra_dc_writel(dc, VSYNC_H_POSITION(1),
+			DC_DISP_DISP_TIMING_OPTIONS);
+	tegra_dc_writel(dc, DITHER_CONTROL_DISABLE | BASE_COLOR_SIZE888,
+			DC_DISP_DISP_COLOR_CONTROL);
+
+	/* video_preamble uses h_pulse2 */
+	pulse_start = 1 + h_sync_width + h_back_porch - 10;
+
+	tegra_dc_writel(dc, H_PULSE_2_ENABLE, DC_DISP_DISP_SIGNAL_OPTIONS0);
+
+	value = PULSE_MODE_NORMAL | PULSE_POLARITY_HIGH | PULSE_QUAL_VACTIVE |
+		PULSE_LAST_END_A;
+	tegra_dc_writel(dc, value, DC_DISP_H_PULSE2_CONTROL);
+
+	value = PULSE_START(pulse_start) | PULSE_END(pulse_start + 8);
+	tegra_dc_writel(dc, value, DC_DISP_H_PULSE2_POSITION_A);
+
+	value = VSYNC_WINDOW_END(0x210) | VSYNC_WINDOW_START(0x200) |
+		VSYNC_WINDOW_ENABLE;
+	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_HDMI_VSYNC_WINDOW);
+
+	if (dc->pipe)
+		value = HDMI_SRC_DISPLAYB;
+	else
+		value = HDMI_SRC_DISPLAYA;
+
+	if ((mode->hdisplay == 720) && ((mode->vdisplay == 480) ||
+					(mode->vdisplay == 576)))
+		tegra_hdmi_writel(hdmi,
+				  value | ARM_VIDEO_RANGE_FULL,
+				  HDMI_NV_PDISP_INPUT_CONTROL);
+	else
+		tegra_hdmi_writel(hdmi,
+				  value | ARM_VIDEO_RANGE_LIMITED,
+				  HDMI_NV_PDISP_INPUT_CONTROL);
+
+	div82 = clk_get_rate(hdmi->clk) / 1000000 * 4;
+	value = SOR_REFCLK_DIV_INT(div82 >> 2) | SOR_REFCLK_DIV_FRAC(div82);
+	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_SOR_REFCLK);
+
+	if (!hdmi->dvi) {
+		err = tegra_hdmi_setup_audio(hdmi, pclk);
+		if (err < 0)
+			hdmi->dvi = true;
+	}
+
+	if (of_device_is_compatible(node, "nvidia,tegra20-hdmi")) {
+		/*
+		 * TODO: add ELD support
+		 */
+	}
+
+	rekey = HDMI_REKEY_DEFAULT;
+	value = HDMI_CTRL_REKEY(rekey);
+	value |= HDMI_CTRL_MAX_AC_PACKET((h_sync_width + h_back_porch +
+					  h_front_porch - rekey - 18) / 32);
+
+	if (!hdmi->dvi)
+		value |= HDMI_CTRL_ENABLE;
+
+	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_HDMI_CTRL);
+
+	if (hdmi->dvi)
+		tegra_hdmi_writel(hdmi, 0x0,
+				  HDMI_NV_PDISP_HDMI_GENERIC_CTRL);
+	else
+		tegra_hdmi_writel(hdmi, GENERIC_CTRL_AUDIO,
+				  HDMI_NV_PDISP_HDMI_GENERIC_CTRL);
+
+	tegra_hdmi_setup_avi_infoframe(hdmi, mode);
+	tegra_hdmi_setup_audio_infoframe(hdmi);
+	tegra_hdmi_setup_stereo_infoframe(hdmi);
+
+	/* TMDS CONFIG */
+	if (of_device_is_compatible(node, "nvidia,tegra30-hdmi")) {
+		num_tmds = ARRAY_SIZE(tegra3_tmds_config);
+		tmds = tegra3_tmds_config;
+	} else {
+		num_tmds = ARRAY_SIZE(tegra2_tmds_config);
+		tmds = tegra2_tmds_config;
+	}
+
+	for (i = 0; i < num_tmds; i++) {
+		if (pclk <= tmds[i].pclk) {
+			tegra_hdmi_setup_tmds(hdmi, &tmds[i]);
+			break;
+		}
+	}
+
+	tegra_hdmi_writel(hdmi,
+			  SOR_SEQ_CTL_PU_PC(0) |
+			  SOR_SEQ_PU_PC_ALT(0) |
+			  SOR_SEQ_PD_PC(8) |
+			  SOR_SEQ_PD_PC_ALT(8),
+			  HDMI_NV_PDISP_SOR_SEQ_CTL);
+
+	value = SOR_SEQ_INST_WAIT_TIME(1) |
+		SOR_SEQ_INST_WAIT_UNITS_VSYNC |
+		SOR_SEQ_INST_HALT |
+		SOR_SEQ_INST_PIN_A_LOW |
+		SOR_SEQ_INST_PIN_B_LOW |
+		SOR_SEQ_INST_DRIVE_PWM_OUT_LO;
+
+	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_SOR_SEQ_INST(0));
+	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_SOR_SEQ_INST(8));
+
+	value = 0x1c800;
+	value &= ~SOR_CSTM_ROTCLK(~0);
+	value |= SOR_CSTM_ROTCLK(2);
+	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_SOR_CSTM);
+
+	tegra_dc_writel(dc, DISP_CTRL_MODE_STOP, DC_CMD_DISPLAY_COMMAND);
+	tegra_dc_writel(dc, GENERAL_ACT_REQ << 8, DC_CMD_STATE_CONTROL);
+	tegra_dc_writel(dc, GENERAL_ACT_REQ, DC_CMD_STATE_CONTROL);
+
+	/* start SOR */
+	tegra_hdmi_writel(hdmi,
+			  SOR_PWR_NORMAL_STATE_PU |
+			  SOR_PWR_NORMAL_START_NORMAL |
+			  SOR_PWR_SAFE_STATE_PD |
+			  SOR_PWR_SETTING_NEW_TRIGGER,
+			  HDMI_NV_PDISP_SOR_PWR);
+	tegra_hdmi_writel(hdmi,
+			  SOR_PWR_NORMAL_STATE_PU |
+			  SOR_PWR_NORMAL_START_NORMAL |
+			  SOR_PWR_SAFE_STATE_PD |
+			  SOR_PWR_SETTING_NEW_DONE,
+			  HDMI_NV_PDISP_SOR_PWR);
+
+	do {
+		BUG_ON(--retries < 0);
+		value = tegra_hdmi_readl(hdmi, HDMI_NV_PDISP_SOR_PWR);
+	} while (value & SOR_PWR_SETTING_NEW_PENDING);
+
+	value = SOR_STATE_ASY_CRCMODE_COMPLETE |
+		SOR_STATE_ASY_OWNER_HEAD0 |
+		SOR_STATE_ASY_SUBOWNER_BOTH |
+		SOR_STATE_ASY_PROTOCOL_SINGLE_TMDS_A |
+		SOR_STATE_ASY_DEPOL_POS;
+
+	/* setup sync polarities */
+	if (mode->flags & DRM_MODE_FLAG_PHSYNC)
+		value |= SOR_STATE_ASY_HSYNCPOL_POS;
+
+	if (mode->flags & DRM_MODE_FLAG_NHSYNC)
+		value |= SOR_STATE_ASY_HSYNCPOL_NEG;
+
+	if (mode->flags & DRM_MODE_FLAG_PVSYNC)
+		value |= SOR_STATE_ASY_VSYNCPOL_POS;
+
+	if (mode->flags & DRM_MODE_FLAG_NVSYNC)
+		value |= SOR_STATE_ASY_VSYNCPOL_NEG;
+
+	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_SOR_STATE2);
+
+	value = SOR_STATE_ASY_HEAD_OPMODE_AWAKE | SOR_STATE_ASY_ORMODE_NORMAL;
+	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_SOR_STATE1);
+
+	tegra_hdmi_writel(hdmi, 0, HDMI_NV_PDISP_SOR_STATE0);
+	tegra_hdmi_writel(hdmi, SOR_STATE_UPDATE, HDMI_NV_PDISP_SOR_STATE0);
+	tegra_hdmi_writel(hdmi, value | SOR_STATE_ATTACHED,
+			  HDMI_NV_PDISP_SOR_STATE1);
+	tegra_hdmi_writel(hdmi, 0, HDMI_NV_PDISP_SOR_STATE0);
+
+	tegra_dc_writel(dc, HDMI_ENABLE, DC_DISP_DISP_WIN_OPTIONS);
+
+	value = PW0_ENABLE | PW1_ENABLE | PW2_ENABLE | PW3_ENABLE |
+		PW4_ENABLE | PM0_ENABLE | PM1_ENABLE;
+	tegra_dc_writel(dc, value, DC_CMD_DISPLAY_POWER_CONTROL);
+
+	value = DISP_CTRL_MODE_C_DISPLAY;
+	tegra_dc_writel(dc, value, DC_CMD_DISPLAY_COMMAND);
+
+	tegra_dc_writel(dc, GENERAL_ACT_REQ << 8, DC_CMD_STATE_CONTROL);
+	tegra_dc_writel(dc, GENERAL_ACT_REQ, DC_CMD_STATE_CONTROL);
+
+	/* TODO: add HDCP support */
+
+	return 0;
+}
+
+static int tegra_output_hdmi_disable(struct tegra_output *output)
+{
+	struct tegra_hdmi *hdmi = to_hdmi(output);
+
+	tegra_periph_reset_assert(hdmi->clk);
+	clk_disable(hdmi->clk);
+	regulator_disable(hdmi->pll);
+	regulator_disable(hdmi->vdd);
+
+	return 0;
+}
+
+static int tegra_output_hdmi_setup_clock(struct tegra_output *output,
+					 struct clk *clk, unsigned long pclk)
+{
+	struct tegra_hdmi *hdmi = to_hdmi(output);
+	struct clk *base;
+	int err;
+
+	err = clk_set_parent(clk, hdmi->clk_parent);
+	if (err < 0) {
+		dev_err(output->dev, "failed to set parent: %d\n", err);
+		return err;
+	}
+
+	base = clk_get_parent(hdmi->clk_parent);
+
+	/*
+	 * This assumes that the parent clock is pll_d_out0 or pll_d2_out
+	 * respectively, each of which divides the base pll_d by 2.
+	 */
+	err = clk_set_rate(base, pclk * 2);
+	if (err < 0)
+		dev_err(output->dev,
+			"failed to set base clock rate to %lu Hz\n",
+			pclk * 2);
+
+	return 0;
+}
+
+static int tegra_output_hdmi_check_mode(struct tegra_output *output,
+					struct drm_display_mode *mode,
+					enum drm_mode_status *status)
+{
+	struct tegra_hdmi *hdmi = to_hdmi(output);
+	unsigned long pclk = mode->clock * 1000;
+	struct clk *parent;
+	long err;
+
+	parent = clk_get_parent(hdmi->clk_parent);
+
+	err = clk_round_rate(parent, pclk * 4);
+	if (err < 0)
+		*status = MODE_NOCLOCK;
+	else
+		*status = MODE_OK;
+
+	return 0;
+}
+
+static const struct tegra_output_ops hdmi_ops = {
+	.enable = tegra_output_hdmi_enable,
+	.disable = tegra_output_hdmi_disable,
+	.setup_clock = tegra_output_hdmi_setup_clock,
+	.check_mode = tegra_output_hdmi_check_mode,
+};
+
+static int tegra_hdmi_show_regs(struct seq_file *s, void *data)
+{
+	struct drm_info_node *node = s->private;
+	struct tegra_hdmi *hdmi = node->info_ent->data;
+
+#define DUMP_REG(name)						\
+	seq_printf(s, "%-56s %#05x %08lx\n", #name, name,	\
+		tegra_hdmi_readl(hdmi, name))
+
+	DUMP_REG(HDMI_CTXSW);
+	DUMP_REG(HDMI_NV_PDISP_SOR_STATE0);
+	DUMP_REG(HDMI_NV_PDISP_SOR_STATE1);
+	DUMP_REG(HDMI_NV_PDISP_SOR_STATE2);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_AN_MSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_AN_LSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_CN_MSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_CN_LSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_AKSV_MSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_AKSV_LSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_BKSV_MSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_BKSV_LSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_CKSV_MSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_CKSV_LSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_DKSV_MSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_DKSV_LSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_CTRL);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_CMODE);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_MPRIME_MSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_MPRIME_LSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_SPRIME_MSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_SPRIME_LSB2);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_SPRIME_LSB1);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_RI);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_CS_MSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_CS_LSB);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AUDIO_EMU0);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AUDIO_EMU_RDATA0);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AUDIO_EMU1);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AUDIO_EMU2);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_CTRL);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_STATUS);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_HEADER);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_SUBPACK0_LOW);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_SUBPACK0_HIGH);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_CTRL);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_STATUS);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_HEADER);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_SUBPACK0_LOW);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_SUBPACK0_HIGH);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_SUBPACK1_LOW);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_SUBPACK1_HIGH);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_CTRL);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_STATUS);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_HEADER);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK0_LOW);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK0_HIGH);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK1_LOW);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK1_HIGH);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK2_LOW);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK2_HIGH);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK3_LOW);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK3_HIGH);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_CTRL);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_0320_SUBPACK_LOW);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_0320_SUBPACK_HIGH);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_0441_SUBPACK_LOW);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_0441_SUBPACK_HIGH);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_0882_SUBPACK_LOW);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_0882_SUBPACK_HIGH);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_1764_SUBPACK_LOW);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_1764_SUBPACK_HIGH);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_0480_SUBPACK_LOW);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_0480_SUBPACK_HIGH);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_0960_SUBPACK_LOW);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_0960_SUBPACK_HIGH);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_1920_SUBPACK_LOW);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_1920_SUBPACK_HIGH);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_CTRL);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_VSYNC_KEEPOUT);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_VSYNC_WINDOW);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_GCP_CTRL);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_GCP_STATUS);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_GCP_SUBPACK);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_CHANNEL_STATUS1);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_CHANNEL_STATUS2);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_EMU0);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_EMU1);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_EMU1_RDATA);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_SPARE);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_SPDIF_CHN_STATUS1);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_SPDIF_CHN_STATUS2);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_HDCPRIF_ROM_CTRL);
+	DUMP_REG(HDMI_NV_PDISP_SOR_CAP);
+	DUMP_REG(HDMI_NV_PDISP_SOR_PWR);
+	DUMP_REG(HDMI_NV_PDISP_SOR_TEST);
+	DUMP_REG(HDMI_NV_PDISP_SOR_PLL0);
+	DUMP_REG(HDMI_NV_PDISP_SOR_PLL1);
+	DUMP_REG(HDMI_NV_PDISP_SOR_PLL2);
+	DUMP_REG(HDMI_NV_PDISP_SOR_CSTM);
+	DUMP_REG(HDMI_NV_PDISP_SOR_LVDS);
+	DUMP_REG(HDMI_NV_PDISP_SOR_CRCA);
+	DUMP_REG(HDMI_NV_PDISP_SOR_CRCB);
+	DUMP_REG(HDMI_NV_PDISP_SOR_BLANK);
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_CTL);
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(0));
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(1));
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(2));
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(3));
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(4));
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(5));
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(6));
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(7));
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(8));
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(9));
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(10));
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(11));
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(12));
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(13));
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(14));
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(15));
+	DUMP_REG(HDMI_NV_PDISP_SOR_VCRCA0);
+	DUMP_REG(HDMI_NV_PDISP_SOR_VCRCA1);
+	DUMP_REG(HDMI_NV_PDISP_SOR_CCRCA0);
+	DUMP_REG(HDMI_NV_PDISP_SOR_CCRCA1);
+	DUMP_REG(HDMI_NV_PDISP_SOR_EDATAA0);
+	DUMP_REG(HDMI_NV_PDISP_SOR_EDATAA1);
+	DUMP_REG(HDMI_NV_PDISP_SOR_COUNTA0);
+	DUMP_REG(HDMI_NV_PDISP_SOR_COUNTA1);
+	DUMP_REG(HDMI_NV_PDISP_SOR_DEBUGA0);
+	DUMP_REG(HDMI_NV_PDISP_SOR_DEBUGA1);
+	DUMP_REG(HDMI_NV_PDISP_SOR_TRIG);
+	DUMP_REG(HDMI_NV_PDISP_SOR_MSCHECK);
+	DUMP_REG(HDMI_NV_PDISP_SOR_LANE_DRIVE_CURRENT);
+	DUMP_REG(HDMI_NV_PDISP_AUDIO_DEBUG0);
+	DUMP_REG(HDMI_NV_PDISP_AUDIO_DEBUG1);
+	DUMP_REG(HDMI_NV_PDISP_AUDIO_DEBUG2);
+	DUMP_REG(HDMI_NV_PDISP_AUDIO_FS(0));
+	DUMP_REG(HDMI_NV_PDISP_AUDIO_FS(1));
+	DUMP_REG(HDMI_NV_PDISP_AUDIO_FS(2));
+	DUMP_REG(HDMI_NV_PDISP_AUDIO_FS(3));
+	DUMP_REG(HDMI_NV_PDISP_AUDIO_FS(4));
+	DUMP_REG(HDMI_NV_PDISP_AUDIO_FS(5));
+	DUMP_REG(HDMI_NV_PDISP_AUDIO_FS(6));
+	DUMP_REG(HDMI_NV_PDISP_AUDIO_PULSE_WIDTH);
+	DUMP_REG(HDMI_NV_PDISP_AUDIO_THRESHOLD);
+	DUMP_REG(HDMI_NV_PDISP_AUDIO_CNTRL0);
+	DUMP_REG(HDMI_NV_PDISP_AUDIO_N);
+	DUMP_REG(HDMI_NV_PDISP_HDCPRIF_ROM_TIMING);
+	DUMP_REG(HDMI_NV_PDISP_SOR_REFCLK);
+	DUMP_REG(HDMI_NV_PDISP_CRC_CONTROL);
+	DUMP_REG(HDMI_NV_PDISP_INPUT_CONTROL);
+	DUMP_REG(HDMI_NV_PDISP_SCRATCH);
+	DUMP_REG(HDMI_NV_PDISP_PE_CURRENT);
+	DUMP_REG(HDMI_NV_PDISP_KEY_CTRL);
+	DUMP_REG(HDMI_NV_PDISP_KEY_DEBUG0);
+	DUMP_REG(HDMI_NV_PDISP_KEY_DEBUG1);
+	DUMP_REG(HDMI_NV_PDISP_KEY_DEBUG2);
+	DUMP_REG(HDMI_NV_PDISP_KEY_HDCP_KEY_0);
+	DUMP_REG(HDMI_NV_PDISP_KEY_HDCP_KEY_1);
+	DUMP_REG(HDMI_NV_PDISP_KEY_HDCP_KEY_2);
+	DUMP_REG(HDMI_NV_PDISP_KEY_HDCP_KEY_3);
+	DUMP_REG(HDMI_NV_PDISP_KEY_HDCP_KEY_TRIG);
+	DUMP_REG(HDMI_NV_PDISP_KEY_SKEY_INDEX);
+	DUMP_REG(HDMI_NV_PDISP_SOR_AUDIO_CNTRL0);
+	DUMP_REG(HDMI_NV_PDISP_SOR_AUDIO_HDA_ELD_BUFWR);
+	DUMP_REG(HDMI_NV_PDISP_SOR_AUDIO_HDA_PRESENSE);
+
+#undef DUMP_REG
+
+	return 0;
+}
+
+static struct drm_info_list debugfs_files[] = {
+	{ "regs", tegra_hdmi_show_regs, 0, NULL },
+};
+
+static int tegra_hdmi_debugfs_init(struct tegra_hdmi *hdmi,
+				   struct drm_minor *minor)
+{
+	unsigned int i;
+	int err;
+
+	hdmi->debugfs = debugfs_create_dir("hdmi", minor->debugfs_root);
+	if (!hdmi->debugfs)
+		return -ENOMEM;
+
+	hdmi->debugfs_files = kmemdup(debugfs_files, sizeof(debugfs_files),
+				      GFP_KERNEL);
+	if (!hdmi->debugfs_files) {
+		err = -ENOMEM;
+		goto remove;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(debugfs_files); i++)
+		hdmi->debugfs_files[i].data = hdmi;
+
+	err = drm_debugfs_create_files(hdmi->debugfs_files,
+				       ARRAY_SIZE(debugfs_files),
+				       hdmi->debugfs, minor);
+	if (err < 0)
+		goto free;
+
+	hdmi->minor = minor;
+
+	return 0;
+
+free:
+	kfree(hdmi->debugfs_files);
+	hdmi->debugfs_files = NULL;
+remove:
+	debugfs_remove(hdmi->debugfs);
+	hdmi->debugfs = NULL;
+
+	return err;
+}
+
+static int tegra_hdmi_debugfs_exit(struct tegra_hdmi *hdmi)
+{
+	drm_debugfs_remove_files(hdmi->debugfs_files, ARRAY_SIZE(debugfs_files),
+				 hdmi->minor);
+	hdmi->minor = NULL;
+
+	kfree(hdmi->debugfs_files);
+	hdmi->debugfs_files = NULL;
+
+	debugfs_remove(hdmi->debugfs);
+	hdmi->debugfs = NULL;
+
+	return 0;
+}
+
+static int tegra_hdmi_drm_init(struct host1x_client *client,
+			       struct drm_device *drm)
+{
+	struct tegra_hdmi *hdmi = host1x_client_to_hdmi(client);
+	int err;
+
+	hdmi->output.type = TEGRA_OUTPUT_HDMI;
+	hdmi->output.dev = client->dev;
+	hdmi->output.ops = &hdmi_ops;
+
+	err = tegra_output_init(drm, &hdmi->output);
+	if (err < 0) {
+		dev_err(client->dev, "output setup failed: %d\n", err);
+		return err;
+	}
+
+	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
+		err = tegra_hdmi_debugfs_init(hdmi, drm->primary);
+		if (err < 0)
+			dev_err(client->dev, "debugfs setup failed: %d\n", err);
+	}
+
+	return 0;
+}
+
+static int tegra_hdmi_drm_exit(struct host1x_client *client)
+{
+	struct tegra_hdmi *hdmi = host1x_client_to_hdmi(client);
+	int err;
+
+	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
+		err = tegra_hdmi_debugfs_exit(hdmi);
+		if (err < 0)
+			dev_err(client->dev, "debugfs cleanup failed: %d\n",
+				err);
+	}
+
+	err = tegra_output_disable(&hdmi->output);
+	if (err < 0) {
+		dev_err(client->dev, "output failed to disable: %d\n", err);
+		return err;
+	}
+
+	err = tegra_output_exit(&hdmi->output);
+	if (err < 0) {
+		dev_err(client->dev, "output cleanup failed: %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
+static const struct host1x_client_ops hdmi_client_ops = {
+	.drm_init = tegra_hdmi_drm_init,
+	.drm_exit = tegra_hdmi_drm_exit,
+};
+
+static int tegra_hdmi_probe(struct platform_device *pdev)
+{
+	struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
+	struct tegra_hdmi *hdmi;
+	struct resource *regs;
+	int err;
+
+	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
+	if (!hdmi)
+		return -ENOMEM;
+
+	hdmi->dev = &pdev->dev;
+	hdmi->audio_source = AUTO;
+	hdmi->audio_freq = 44100;
+	hdmi->stereo = false;
+	hdmi->dvi = false;
+
+	hdmi->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(hdmi->clk)) {
+		dev_err(&pdev->dev, "failed to get clock\n");
+		return PTR_ERR(hdmi->clk);
+	}
+
+	err = clk_prepare(hdmi->clk);
+	if (err < 0)
+		return err;
+
+	hdmi->clk_parent = devm_clk_get(&pdev->dev, "parent");
+	if (IS_ERR(hdmi->clk_parent))
+		return PTR_ERR(hdmi->clk_parent);
+
+	err = clk_prepare(hdmi->clk_parent);
+	if (err < 0)
+		return err;
+
+	err = clk_set_parent(hdmi->clk, hdmi->clk_parent);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to setup clocks: %d\n", err);
+		return err;
+	}
+
+	hdmi->vdd = devm_regulator_get(&pdev->dev, "vdd");
+	if (IS_ERR(hdmi->vdd)) {
+		dev_err(&pdev->dev, "failed to get VDD regulator\n");
+		return PTR_ERR(hdmi->vdd);
+	}
+
+	hdmi->pll = devm_regulator_get(&pdev->dev, "pll");
+	if (IS_ERR(hdmi->pll)) {
+		dev_err(&pdev->dev, "failed to get PLL regulator\n");
+		return PTR_ERR(hdmi->pll);
+	}
+
+	hdmi->output.dev = &pdev->dev;
+
+	err = tegra_output_parse_dt(&hdmi->output);
+	if (err < 0)
+		return err;
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!regs)
+		return -ENXIO;
+
+	hdmi->regs = devm_request_and_ioremap(&pdev->dev, regs);
+	if (!hdmi->regs)
+		return -EADDRNOTAVAIL;
+
+	err = platform_get_irq(pdev, 0);
+	if (err < 0)
+		return err;
+
+	hdmi->irq = err;
+
+	hdmi->client.ops = &hdmi_client_ops;
+	INIT_LIST_HEAD(&hdmi->client.list);
+	hdmi->client.dev = &pdev->dev;
+
+	err = host1x_register_client(host1x, &hdmi->client);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to register host1x client: %d\n",
+			err);
+		return err;
+	}
+
+	platform_set_drvdata(pdev, hdmi);
+
+	return 0;
+}
+
+static int tegra_hdmi_remove(struct platform_device *pdev)
+{
+	struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
+	struct tegra_hdmi *hdmi = platform_get_drvdata(pdev);
+	int err;
+
+	err = host1x_unregister_client(host1x, &hdmi->client);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to unregister host1x client: %d\n",
+			err);
+		return err;
+	}
+
+	clk_unprepare(hdmi->clk_parent);
+	clk_unprepare(hdmi->clk);
+
+	return 0;
+}
+
+static struct of_device_id tegra_hdmi_of_match[] = {
+	{ .compatible = "nvidia,tegra30-hdmi", },
+	{ .compatible = "nvidia,tegra20-hdmi", },
+	{ },
+};
+
+struct platform_driver tegra_hdmi_driver = {
+	.driver = {
+		.name = "tegra-hdmi",
+		.owner = THIS_MODULE,
+		.of_match_table = tegra_hdmi_of_match,
+	},
+	.probe = tegra_hdmi_probe,
+	.remove = tegra_hdmi_remove,
+};
diff --git a/drivers/gpu/host1x/drm/hdmi.h b/drivers/gpu/host1x/drm/hdmi.h
new file mode 100644
index 0000000..1477f36
--- /dev/null
+++ b/drivers/gpu/host1x/drm/hdmi.h
@@ -0,0 +1,575 @@
+/*
+ * Copyright (C) 2012 Avionic Design GmbH
+ * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef TEGRA_HDMI_H
+#define TEGRA_HDMI_H 1
+
+#define HDMI_INFOFRAME_TYPE_VENDOR   0x81
+#define HDMI_INFOFRAME_TYPE_AVI      0x82
+#define HDMI_INFOFRAME_TYPE_SPD      0x83
+#define HDMI_INFOFRAME_TYPE_AUDIO    0x84
+#define HDMI_INFOFRAME_TYPE_MPEG_SRC 0x85
+#define HDMI_INFOFRAME_TYPE_NTSC_VBI 0x86
+
+/* all fields little endian */
+struct hdmi_avi_infoframe {
+	/* PB0 */
+	u8 csum;
+
+	/* PB1 */
+	unsigned s:2; /* scan information */
+	unsigned b:2; /* bar info data valid */
+	unsigned a:1; /* active info present */
+	unsigned y:2; /* RGB or YCbCr */
+	unsigned res1:1;
+
+	/* PB2 */
+	unsigned r:4; /* active format aspect ratio */
+	unsigned m:2; /* picture aspect ratio */
+	unsigned c:2; /* colorimetry */
+
+	/* PB3 */
+	unsigned sc:2;  /* scan information */
+	unsigned q:2;   /* quantization range */
+	unsigned ec:3;  /* extended colorimetry */
+	unsigned itc:1; /* it content */
+
+	/* PB4 */
+	unsigned vic:7; /* video format id code */
+	unsigned res4:1;
+
+	/* PB5 */
+	unsigned pr:4; /* pixel repetition factor */
+	unsigned cn:2; /* it content type*/
+	unsigned yq:2; /* ycc quantization range */
+
+	/* PB6-7 */
+	u16 top_bar_end_line;
+
+	/* PB8-9 */
+	u16 bot_bar_start_line;
+
+	/* PB10-11 */
+	u16 left_bar_end_pixel;
+
+	/* PB12-13 */
+	u16 right_bar_start_pixel;
+} __packed;
+
+#define HDMI_AVI_VERSION 0x02
+
+#define HDMI_AVI_Y_RGB       0x0
+#define HDMI_AVI_Y_YCBCR_422 0x1
+#define HDMI_AVI_Y_YCBCR_444 0x2
+
+#define HDMI_AVI_B_VERT  0x1
+#define HDMI_AVI_B_HORIZ 0x2
+
+#define HDMI_AVI_S_NONE      0x0
+#define HDMI_AVI_S_OVERSCAN  0x1
+#define HDMI_AVI_S_UNDERSCAN 0x2
+
+#define HDMI_AVI_C_NONE     0x0
+#define HDMI_AVI_C_SMPTE    0x1
+#define HDMI_AVI_C_ITU_R    0x2
+#define HDMI_AVI_C_EXTENDED 0x4
+
+#define HDMI_AVI_M_4_3  0x1
+#define HDMI_AVI_M_16_9 0x2
+
+#define HDMI_AVI_R_SAME        0x8
+#define HDMI_AVI_R_4_3_CENTER  0x9
+#define HDMI_AVI_R_16_9_CENTER 0xa
+#define HDMI_AVI_R_14_9_CENTER 0xb
+
+/* all fields little endian */
+struct hdmi_audio_infoframe {
+	/* PB0 */
+	u8 csum;
+
+	/* PB1 */
+	unsigned cc:3; /* channel count */
+	unsigned res1:1;
+	unsigned ct:4; /* coding type */
+
+	/* PB2 */
+	unsigned ss:2; /* sample size */
+	unsigned sf:3; /* sample frequency */
+	unsigned res2:3;
+
+	/* PB3 */
+	unsigned cxt:5; /* coding extention type */
+	unsigned res3:3;
+
+	/* PB4 */
+	u8 ca; /* channel/speaker allocation */
+
+	/* PB5 */
+	unsigned res5:3;
+	unsigned lsv:4; /* level shift value */
+	unsigned dm_inh:1; /* downmix inhibit */
+
+	/* PB6-10 reserved */
+	u8 res6;
+	u8 res7;
+	u8 res8;
+	u8 res9;
+	u8 res10;
+} __packed;
+
+#define HDMI_AUDIO_VERSION 0x01
+
+#define HDMI_AUDIO_CC_STREAM 0x0 /* specified by audio stream */
+#define HDMI_AUDIO_CC_2      0x1
+#define HDMI_AUDIO_CC_3      0x2
+#define HDMI_AUDIO_CC_4      0x3
+#define HDMI_AUDIO_CC_5      0x4
+#define HDMI_AUDIO_CC_6      0x5
+#define HDMI_AUDIO_CC_7      0x6
+#define HDMI_AUDIO_CC_8      0x7
+
+#define HDMI_AUDIO_CT_STREAM  0x0 /* specified by audio stream */
+#define HDMI_AUDIO_CT_PCM     0x1
+#define HDMI_AUDIO_CT_AC3     0x2
+#define HDMI_AUDIO_CT_MPEG1   0x3
+#define HDMI_AUDIO_CT_MP3     0x4
+#define HDMI_AUDIO_CT_MPEG2   0x5
+#define HDMI_AUDIO_CT_AAC_LC  0x6
+#define HDMI_AUDIO_CT_DTS     0x7
+#define HDMI_AUDIO_CT_ATRAC   0x8
+#define HDMI_AUDIO_CT_DSD     0x9
+#define HDMI_AUDIO_CT_E_AC3   0xa
+#define HDMI_AUDIO_CT_DTS_HD  0xb
+#define HDMI_AUDIO_CT_MLP     0xc
+#define HDMI_AUDIO_CT_DST     0xd
+#define HDMI_AUDIO_CT_WMA_PRO 0xe
+#define HDMI_AUDIO_CT_CXT     0xf
+
+#define HDMI_AUDIO_SF_STREAM 0x0 /* specified by audio stream */
+#define HDMI_AUIDO_SF_32K    0x1
+#define HDMI_AUDIO_SF_44_1K  0x2
+#define HDMI_AUDIO_SF_48K    0x3
+#define HDMI_AUDIO_SF_88_2K  0x4
+#define HDMI_AUDIO_SF_96K    0x5
+#define HDMI_AUDIO_SF_176_4K 0x6
+#define HDMI_AUDIO_SF_192K   0x7
+
+#define HDMI_AUDIO_SS_STREAM 0x0 /* specified by audio stream */
+#define HDMI_AUDIO_SS_16BIT  0x1
+#define HDMI_AUDIO_SS_20BIT  0x2
+#define HDMI_AUDIO_SS_24BIT  0x3
+
+#define HDMI_AUDIO_CXT_CT            0x0 /* refer to coding in CT */
+#define HDMI_AUDIO_CXT_HE_AAC        0x1
+#define HDMI_AUDIO_CXT_HE_AAC_V2     0x2
+#define HDMI_AUDIO_CXT_MPEG_SURROUND 0x3
+
+/* all fields little endian */
+struct hdmi_stereo_infoframe {
+	/* PB0 */
+	u8 csum;
+
+	/* PB1 */
+	u8 regid0;
+
+	/* PB2 */
+	u8 regid1;
+
+	/* PB3 */
+	u8 regid2;
+
+	/* PB4 */
+	unsigned res1:5;
+	unsigned hdmi_video_format:3;
+
+	/* PB5 */
+	unsigned res2:4;
+	unsigned _3d_structure:4;
+
+	/* PB6*/
+	unsigned res3:4;
+	unsigned _3d_ext_data:4;
+} __packed;
+
+#define HDMI_VENDOR_VERSION 0x01
+
+/* register definitions */
+#define HDMI_CTXSW						0x00
+
+#define HDMI_NV_PDISP_SOR_STATE0				0x01
+#define SOR_STATE_UPDATE (1 << 0)
+
+#define HDMI_NV_PDISP_SOR_STATE1				0x02
+#define SOR_STATE_ASY_HEAD_OPMODE_AWAKE (2 << 0)
+#define SOR_STATE_ASY_ORMODE_NORMAL     (1 << 2)
+#define SOR_STATE_ATTACHED              (1 << 3)
+
+#define HDMI_NV_PDISP_SOR_STATE2				0x03
+#define SOR_STATE_ASY_OWNER_NONE         (0 <<  0)
+#define SOR_STATE_ASY_OWNER_HEAD0        (1 <<  0)
+#define SOR_STATE_ASY_SUBOWNER_NONE      (0 <<  4)
+#define SOR_STATE_ASY_SUBOWNER_SUBHEAD0  (1 <<  4)
+#define SOR_STATE_ASY_SUBOWNER_SUBHEAD1  (2 <<  4)
+#define SOR_STATE_ASY_SUBOWNER_BOTH      (3 <<  4)
+#define SOR_STATE_ASY_CRCMODE_ACTIVE     (0 <<  6)
+#define SOR_STATE_ASY_CRCMODE_COMPLETE   (1 <<  6)
+#define SOR_STATE_ASY_CRCMODE_NON_ACTIVE (2 <<  6)
+#define SOR_STATE_ASY_PROTOCOL_SINGLE_TMDS_A (1 << 8)
+#define SOR_STATE_ASY_PROTOCOL_CUSTOM        (15 << 8)
+#define SOR_STATE_ASY_HSYNCPOL_POS       (0 << 12)
+#define SOR_STATE_ASY_HSYNCPOL_NEG       (1 << 12)
+#define SOR_STATE_ASY_VSYNCPOL_POS       (0 << 13)
+#define SOR_STATE_ASY_VSYNCPOL_NEG       (1 << 13)
+#define SOR_STATE_ASY_DEPOL_POS          (0 << 14)
+#define SOR_STATE_ASY_DEPOL_NEG          (1 << 14)
+
+#define HDMI_NV_PDISP_RG_HDCP_AN_MSB				0x04
+#define HDMI_NV_PDISP_RG_HDCP_AN_LSB				0x05
+#define HDMI_NV_PDISP_RG_HDCP_CN_MSB				0x06
+#define HDMI_NV_PDISP_RG_HDCP_CN_LSB				0x07
+#define HDMI_NV_PDISP_RG_HDCP_AKSV_MSB				0x08
+#define HDMI_NV_PDISP_RG_HDCP_AKSV_LSB				0x09
+#define HDMI_NV_PDISP_RG_HDCP_BKSV_MSB				0x0a
+#define HDMI_NV_PDISP_RG_HDCP_BKSV_LSB				0x0b
+#define HDMI_NV_PDISP_RG_HDCP_CKSV_MSB				0x0c
+#define HDMI_NV_PDISP_RG_HDCP_CKSV_LSB				0x0d
+#define HDMI_NV_PDISP_RG_HDCP_DKSV_MSB				0x0e
+#define HDMI_NV_PDISP_RG_HDCP_DKSV_LSB				0x0f
+#define HDMI_NV_PDISP_RG_HDCP_CTRL				0x10
+#define HDMI_NV_PDISP_RG_HDCP_CMODE				0x11
+#define HDMI_NV_PDISP_RG_HDCP_MPRIME_MSB			0x12
+#define HDMI_NV_PDISP_RG_HDCP_MPRIME_LSB			0x13
+#define HDMI_NV_PDISP_RG_HDCP_SPRIME_MSB			0x14
+#define HDMI_NV_PDISP_RG_HDCP_SPRIME_LSB2			0x15
+#define HDMI_NV_PDISP_RG_HDCP_SPRIME_LSB1			0x16
+#define HDMI_NV_PDISP_RG_HDCP_RI				0x17
+#define HDMI_NV_PDISP_RG_HDCP_CS_MSB				0x18
+#define HDMI_NV_PDISP_RG_HDCP_CS_LSB				0x19
+#define HDMI_NV_PDISP_HDMI_AUDIO_EMU0				0x1a
+#define HDMI_NV_PDISP_HDMI_AUDIO_EMU_RDATA0			0x1b
+#define HDMI_NV_PDISP_HDMI_AUDIO_EMU1				0x1c
+#define HDMI_NV_PDISP_HDMI_AUDIO_EMU2				0x1d
+
+#define HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_CTRL			0x1e
+#define HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_STATUS		0x1f
+#define HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_HEADER		0x20
+#define HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_SUBPACK0_LOW		0x21
+#define HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_SUBPACK0_HIGH	0x22
+#define HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_CTRL			0x23
+#define HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_STATUS			0x24
+#define HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_HEADER			0x25
+#define HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_SUBPACK0_LOW		0x26
+#define HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_SUBPACK0_HIGH		0x27
+#define HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_SUBPACK1_LOW		0x28
+#define HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_SUBPACK1_HIGH		0x29
+
+#define INFOFRAME_CTRL_ENABLE (1 << 0)
+
+#define INFOFRAME_HEADER_TYPE(x)    (((x) & 0xff) <<  0)
+#define INFOFRAME_HEADER_VERSION(x) (((x) & 0xff) <<  8)
+#define INFOFRAME_HEADER_LEN(x)     (((x) & 0x0f) << 16)
+
+#define HDMI_NV_PDISP_HDMI_GENERIC_CTRL				0x2a
+#define GENERIC_CTRL_ENABLE (1 <<  0)
+#define GENERIC_CTRL_OTHER  (1 <<  4)
+#define GENERIC_CTRL_SINGLE (1 <<  8)
+#define GENERIC_CTRL_HBLANK (1 << 12)
+#define GENERIC_CTRL_AUDIO  (1 << 16)
+
+#define HDMI_NV_PDISP_HDMI_GENERIC_STATUS			0x2b
+#define HDMI_NV_PDISP_HDMI_GENERIC_HEADER			0x2c
+#define HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK0_LOW			0x2d
+#define HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK0_HIGH		0x2e
+#define HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK1_LOW			0x2f
+#define HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK1_HIGH		0x30
+#define HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK2_LOW			0x31
+#define HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK2_HIGH		0x32
+#define HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK3_LOW			0x33
+#define HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK3_HIGH		0x34
+
+#define HDMI_NV_PDISP_HDMI_ACR_CTRL				0x35
+#define HDMI_NV_PDISP_HDMI_ACR_0320_SUBPACK_LOW			0x36
+#define HDMI_NV_PDISP_HDMI_ACR_0320_SUBPACK_HIGH		0x37
+#define HDMI_NV_PDISP_HDMI_ACR_0441_SUBPACK_LOW			0x38
+#define HDMI_NV_PDISP_HDMI_ACR_0441_SUBPACK_HIGH		0x39
+#define HDMI_NV_PDISP_HDMI_ACR_0882_SUBPACK_LOW			0x3a
+#define HDMI_NV_PDISP_HDMI_ACR_0882_SUBPACK_HIGH		0x3b
+#define HDMI_NV_PDISP_HDMI_ACR_1764_SUBPACK_LOW			0x3c
+#define HDMI_NV_PDISP_HDMI_ACR_1764_SUBPACK_HIGH		0x3d
+#define HDMI_NV_PDISP_HDMI_ACR_0480_SUBPACK_LOW			0x3e
+#define HDMI_NV_PDISP_HDMI_ACR_0480_SUBPACK_HIGH		0x3f
+#define HDMI_NV_PDISP_HDMI_ACR_0960_SUBPACK_LOW			0x40
+#define HDMI_NV_PDISP_HDMI_ACR_0960_SUBPACK_HIGH		0x41
+#define HDMI_NV_PDISP_HDMI_ACR_1920_SUBPACK_LOW			0x42
+#define HDMI_NV_PDISP_HDMI_ACR_1920_SUBPACK_HIGH		0x43
+
+#define ACR_SUBPACK_CTS(x) (((x) & 0xffffff) << 8)
+#define ACR_SUBPACK_N(x)   (((x) & 0xffffff) << 0)
+#define ACR_ENABLE         (1 << 31)
+
+#define HDMI_NV_PDISP_HDMI_CTRL					0x44
+#define HDMI_CTRL_REKEY(x)         (((x) & 0x7f) <<  0)
+#define HDMI_CTRL_MAX_AC_PACKET(x) (((x) & 0x1f) << 16)
+#define HDMI_CTRL_ENABLE           (1 << 30)
+
+#define HDMI_NV_PDISP_HDMI_VSYNC_KEEPOUT			0x45
+#define HDMI_NV_PDISP_HDMI_VSYNC_WINDOW				0x46
+#define VSYNC_WINDOW_END(x)   (((x) & 0x3ff) <<  0)
+#define VSYNC_WINDOW_START(x) (((x) & 0x3ff) << 16)
+#define VSYNC_WINDOW_ENABLE   (1 << 31)
+
+#define HDMI_NV_PDISP_HDMI_GCP_CTRL				0x47
+#define HDMI_NV_PDISP_HDMI_GCP_STATUS				0x48
+#define HDMI_NV_PDISP_HDMI_GCP_SUBPACK				0x49
+#define HDMI_NV_PDISP_HDMI_CHANNEL_STATUS1			0x4a
+#define HDMI_NV_PDISP_HDMI_CHANNEL_STATUS2			0x4b
+#define HDMI_NV_PDISP_HDMI_EMU0					0x4c
+#define HDMI_NV_PDISP_HDMI_EMU1					0x4d
+#define HDMI_NV_PDISP_HDMI_EMU1_RDATA				0x4e
+
+#define HDMI_NV_PDISP_HDMI_SPARE				0x4f
+#define SPARE_HW_CTS           (1 << 0)
+#define SPARE_FORCE_SW_CTS     (1 << 1)
+#define SPARE_CTS_RESET_VAL(x) (((x) & 0x7) << 16)
+
+#define HDMI_NV_PDISP_HDMI_SPDIF_CHN_STATUS1			0x50
+#define HDMI_NV_PDISP_HDMI_SPDIF_CHN_STATUS2			0x51
+#define HDMI_NV_PDISP_HDMI_HDCPRIF_ROM_CTRL			0x53
+#define HDMI_NV_PDISP_SOR_CAP					0x54
+#define HDMI_NV_PDISP_SOR_PWR					0x55
+#define SOR_PWR_NORMAL_STATE_PD     (0 <<  0)
+#define SOR_PWR_NORMAL_STATE_PU     (1 <<  0)
+#define SOR_PWR_NORMAL_START_NORMAL (0 <<  1)
+#define SOR_PWR_NORMAL_START_ALT    (1 <<  1)
+#define SOR_PWR_SAFE_STATE_PD       (0 << 16)
+#define SOR_PWR_SAFE_STATE_PU       (1 << 16)
+#define SOR_PWR_SETTING_NEW_DONE    (0 << 31)
+#define SOR_PWR_SETTING_NEW_PENDING (1 << 31)
+#define SOR_PWR_SETTING_NEW_TRIGGER (1 << 31)
+
+#define HDMI_NV_PDISP_SOR_TEST					0x56
+#define HDMI_NV_PDISP_SOR_PLL0					0x57
+#define SOR_PLL_PWR            (1 << 0)
+#define SOR_PLL_PDBG           (1 << 1)
+#define SOR_PLL_VCAPD          (1 << 2)
+#define SOR_PLL_PDPORT         (1 << 3)
+#define SOR_PLL_RESISTORSEL    (1 << 4)
+#define SOR_PLL_PULLDOWN       (1 << 5)
+#define SOR_PLL_VCOCAP(x)      (((x) & 0xf) <<  8)
+#define SOR_PLL_BG_V17_S(x)    (((x) & 0xf) << 12)
+#define SOR_PLL_FILTER(x)      (((x) & 0xf) << 16)
+#define SOR_PLL_ICHPMP(x)      (((x) & 0xf) << 24)
+#define SOR_PLL_TX_REG_LOAD(x) (((x) & 0xf) << 28)
+
+#define HDMI_NV_PDISP_SOR_PLL1					0x58
+#define SOR_PLL_TMDS_TERM_ENABLE (1 << 8)
+#define SOR_PLL_TMDS_TERMADJ(x)  (((x) & 0xf) <<  9)
+#define SOR_PLL_LOADADJ(x)       (((x) & 0xf) << 20)
+#define SOR_PLL_PE_EN            (1 << 28)
+#define SOR_PLL_HALF_FULL_PE     (1 << 29)
+#define SOR_PLL_S_D_PIN_PE       (1 << 30)
+
+#define HDMI_NV_PDISP_SOR_PLL2					0x59
+
+#define HDMI_NV_PDISP_SOR_CSTM					0x5a
+#define SOR_CSTM_ROTCLK(x) (((x) & 0xf) << 24)
+
+#define HDMI_NV_PDISP_SOR_LVDS					0x5b
+#define HDMI_NV_PDISP_SOR_CRCA					0x5c
+#define HDMI_NV_PDISP_SOR_CRCB					0x5d
+#define HDMI_NV_PDISP_SOR_BLANK					0x5e
+#define HDMI_NV_PDISP_SOR_SEQ_CTL				0x5f
+#define SOR_SEQ_CTL_PU_PC(x) (((x) & 0xf) <<  0)
+#define SOR_SEQ_PU_PC_ALT(x) (((x) & 0xf) <<  4)
+#define SOR_SEQ_PD_PC(x)     (((x) & 0xf) <<  8)
+#define SOR_SEQ_PD_PC_ALT(x) (((x) & 0xf) << 12)
+#define SOR_SEQ_PC(x)        (((x) & 0xf) << 16)
+#define SOR_SEQ_STATUS       (1 << 28)
+#define SOR_SEQ_SWITCH       (1 << 30)
+
+#define HDMI_NV_PDISP_SOR_SEQ_INST(x)				(0x60 + (x))
+
+#define SOR_SEQ_INST_WAIT_TIME(x)     (((x) & 0x3ff) << 0)
+#define SOR_SEQ_INST_WAIT_UNITS_VSYNC (2 << 12)
+#define SOR_SEQ_INST_HALT             (1 << 15)
+#define SOR_SEQ_INST_PIN_A_LOW        (0 << 21)
+#define SOR_SEQ_INST_PIN_A_HIGH       (1 << 21)
+#define SOR_SEQ_INST_PIN_B_LOW        (0 << 22)
+#define SOR_SEQ_INST_PIN_B_HIGH       (1 << 22)
+#define SOR_SEQ_INST_DRIVE_PWM_OUT_LO (1 << 23)
+
+#define HDMI_NV_PDISP_SOR_VCRCA0				0x72
+#define HDMI_NV_PDISP_SOR_VCRCA1				0x73
+#define HDMI_NV_PDISP_SOR_CCRCA0				0x74
+#define HDMI_NV_PDISP_SOR_CCRCA1				0x75
+#define HDMI_NV_PDISP_SOR_EDATAA0				0x76
+#define HDMI_NV_PDISP_SOR_EDATAA1				0x77
+#define HDMI_NV_PDISP_SOR_COUNTA0				0x78
+#define HDMI_NV_PDISP_SOR_COUNTA1				0x79
+#define HDMI_NV_PDISP_SOR_DEBUGA0				0x7a
+#define HDMI_NV_PDISP_SOR_DEBUGA1				0x7b
+#define HDMI_NV_PDISP_SOR_TRIG					0x7c
+#define HDMI_NV_PDISP_SOR_MSCHECK				0x7d
+
+#define HDMI_NV_PDISP_SOR_LANE_DRIVE_CURRENT			0x7e
+#define DRIVE_CURRENT_LANE0(x)      (((x) & 0x3f) <<  0)
+#define DRIVE_CURRENT_LANE1(x)      (((x) & 0x3f) <<  8)
+#define DRIVE_CURRENT_LANE2(x)      (((x) & 0x3f) << 16)
+#define DRIVE_CURRENT_LANE3(x)      (((x) & 0x3f) << 24)
+#define DRIVE_CURRENT_FUSE_OVERRIDE (1 << 31)
+
+#define DRIVE_CURRENT_1_500_mA  0x00
+#define DRIVE_CURRENT_1_875_mA  0x01
+#define DRIVE_CURRENT_2_250_mA  0x02
+#define DRIVE_CURRENT_2_625_mA  0x03
+#define DRIVE_CURRENT_3_000_mA  0x04
+#define DRIVE_CURRENT_3_375_mA  0x05
+#define DRIVE_CURRENT_3_750_mA  0x06
+#define DRIVE_CURRENT_4_125_mA  0x07
+#define DRIVE_CURRENT_4_500_mA  0x08
+#define DRIVE_CURRENT_4_875_mA  0x09
+#define DRIVE_CURRENT_5_250_mA  0x0a
+#define DRIVE_CURRENT_5_625_mA  0x0b
+#define DRIVE_CURRENT_6_000_mA  0x0c
+#define DRIVE_CURRENT_6_375_mA  0x0d
+#define DRIVE_CURRENT_6_750_mA  0x0e
+#define DRIVE_CURRENT_7_125_mA  0x0f
+#define DRIVE_CURRENT_7_500_mA  0x10
+#define DRIVE_CURRENT_7_875_mA  0x11
+#define DRIVE_CURRENT_8_250_mA  0x12
+#define DRIVE_CURRENT_8_625_mA  0x13
+#define DRIVE_CURRENT_9_000_mA  0x14
+#define DRIVE_CURRENT_9_375_mA  0x15
+#define DRIVE_CURRENT_9_750_mA  0x16
+#define DRIVE_CURRENT_10_125_mA 0x17
+#define DRIVE_CURRENT_10_500_mA 0x18
+#define DRIVE_CURRENT_10_875_mA 0x19
+#define DRIVE_CURRENT_11_250_mA 0x1a
+#define DRIVE_CURRENT_11_625_mA 0x1b
+#define DRIVE_CURRENT_12_000_mA 0x1c
+#define DRIVE_CURRENT_12_375_mA 0x1d
+#define DRIVE_CURRENT_12_750_mA 0x1e
+#define DRIVE_CURRENT_13_125_mA 0x1f
+#define DRIVE_CURRENT_13_500_mA 0x20
+#define DRIVE_CURRENT_13_875_mA 0x21
+#define DRIVE_CURRENT_14_250_mA 0x22
+#define DRIVE_CURRENT_14_625_mA 0x23
+#define DRIVE_CURRENT_15_000_mA 0x24
+#define DRIVE_CURRENT_15_375_mA 0x25
+#define DRIVE_CURRENT_15_750_mA 0x26
+#define DRIVE_CURRENT_16_125_mA 0x27
+#define DRIVE_CURRENT_16_500_mA 0x28
+#define DRIVE_CURRENT_16_875_mA 0x29
+#define DRIVE_CURRENT_17_250_mA 0x2a
+#define DRIVE_CURRENT_17_625_mA 0x2b
+#define DRIVE_CURRENT_18_000_mA 0x2c
+#define DRIVE_CURRENT_18_375_mA 0x2d
+#define DRIVE_CURRENT_18_750_mA 0x2e
+#define DRIVE_CURRENT_19_125_mA 0x2f
+#define DRIVE_CURRENT_19_500_mA 0x30
+#define DRIVE_CURRENT_19_875_mA 0x31
+#define DRIVE_CURRENT_20_250_mA 0x32
+#define DRIVE_CURRENT_20_625_mA 0x33
+#define DRIVE_CURRENT_21_000_mA 0x34
+#define DRIVE_CURRENT_21_375_mA 0x35
+#define DRIVE_CURRENT_21_750_mA 0x36
+#define DRIVE_CURRENT_22_125_mA 0x37
+#define DRIVE_CURRENT_22_500_mA 0x38
+#define DRIVE_CURRENT_22_875_mA 0x39
+#define DRIVE_CURRENT_23_250_mA 0x3a
+#define DRIVE_CURRENT_23_625_mA 0x3b
+#define DRIVE_CURRENT_24_000_mA 0x3c
+#define DRIVE_CURRENT_24_375_mA 0x3d
+#define DRIVE_CURRENT_24_750_mA 0x3e
+
+#define HDMI_NV_PDISP_AUDIO_DEBUG0				0x7f
+#define HDMI_NV_PDISP_AUDIO_DEBUG1				0x80
+#define HDMI_NV_PDISP_AUDIO_DEBUG2				0x81
+
+#define HDMI_NV_PDISP_AUDIO_FS(x)				(0x82 + (x))
+#define AUDIO_FS_LOW(x)  (((x) & 0xfff) <<  0)
+#define AUDIO_FS_HIGH(x) (((x) & 0xfff) << 16)
+
+#define HDMI_NV_PDISP_AUDIO_PULSE_WIDTH				0x89
+#define HDMI_NV_PDISP_AUDIO_THRESHOLD				0x8a
+#define HDMI_NV_PDISP_AUDIO_CNTRL0				0x8b
+#define AUDIO_CNTRL0_ERROR_TOLERANCE(x)  (((x) & 0xff) << 0)
+#define AUDIO_CNTRL0_SOURCE_SELECT_AUTO  (0 << 20)
+#define AUDIO_CNTRL0_SOURCE_SELECT_SPDIF (1 << 20)
+#define AUDIO_CNTRL0_SOURCE_SELECT_HDAL  (2 << 20)
+#define AUDIO_CNTRL0_FRAMES_PER_BLOCK(x) (((x) & 0xff) << 24)
+
+#define HDMI_NV_PDISP_AUDIO_N					0x8c
+#define AUDIO_N_VALUE(x)           (((x) & 0xfffff) << 0)
+#define AUDIO_N_RESETF             (1 << 20)
+#define AUDIO_N_GENERATE_NORMAL    (0 << 24)
+#define AUDIO_N_GENERATE_ALTERNATE (1 << 24)
+
+#define HDMI_NV_PDISP_HDCPRIF_ROM_TIMING			0x94
+#define HDMI_NV_PDISP_SOR_REFCLK				0x95
+#define SOR_REFCLK_DIV_INT(x)  (((x) & 0xff) << 8)
+#define SOR_REFCLK_DIV_FRAC(x) (((x) & 0x03) << 6)
+
+#define HDMI_NV_PDISP_CRC_CONTROL				0x96
+#define HDMI_NV_PDISP_INPUT_CONTROL				0x97
+#define HDMI_SRC_DISPLAYA       (0 << 0)
+#define HDMI_SRC_DISPLAYB       (1 << 0)
+#define ARM_VIDEO_RANGE_FULL    (0 << 1)
+#define ARM_VIDEO_RANGE_LIMITED (1 << 1)
+
+#define HDMI_NV_PDISP_SCRATCH					0x98
+#define HDMI_NV_PDISP_PE_CURRENT				0x99
+#define PE_CURRENT0(x) (((x) & 0xf) << 0)
+#define PE_CURRENT1(x) (((x) & 0xf) << 8)
+#define PE_CURRENT2(x) (((x) & 0xf) << 16)
+#define PE_CURRENT3(x) (((x) & 0xf) << 24)
+
+#define PE_CURRENT_0_0_mA 0x0
+#define PE_CURRENT_0_5_mA 0x1
+#define PE_CURRENT_1_0_mA 0x2
+#define PE_CURRENT_1_5_mA 0x3
+#define PE_CURRENT_2_0_mA 0x4
+#define PE_CURRENT_2_5_mA 0x5
+#define PE_CURRENT_3_0_mA 0x6
+#define PE_CURRENT_3_5_mA 0x7
+#define PE_CURRENT_4_0_mA 0x8
+#define PE_CURRENT_4_5_mA 0x9
+#define PE_CURRENT_5_0_mA 0xa
+#define PE_CURRENT_5_5_mA 0xb
+#define PE_CURRENT_6_0_mA 0xc
+#define PE_CURRENT_6_5_mA 0xd
+#define PE_CURRENT_7_0_mA 0xe
+#define PE_CURRENT_7_5_mA 0xf
+
+#define HDMI_NV_PDISP_KEY_CTRL					0x9a
+#define HDMI_NV_PDISP_KEY_DEBUG0				0x9b
+#define HDMI_NV_PDISP_KEY_DEBUG1				0x9c
+#define HDMI_NV_PDISP_KEY_DEBUG2				0x9d
+#define HDMI_NV_PDISP_KEY_HDCP_KEY_0				0x9e
+#define HDMI_NV_PDISP_KEY_HDCP_KEY_1				0x9f
+#define HDMI_NV_PDISP_KEY_HDCP_KEY_2				0xa0
+#define HDMI_NV_PDISP_KEY_HDCP_KEY_3				0xa1
+#define HDMI_NV_PDISP_KEY_HDCP_KEY_TRIG				0xa2
+#define HDMI_NV_PDISP_KEY_SKEY_INDEX				0xa3
+
+#define HDMI_NV_PDISP_SOR_AUDIO_CNTRL0				0xac
+#define AUDIO_CNTRL0_INJECT_NULLSMPL (1 << 29)
+#define HDMI_NV_PDISP_SOR_AUDIO_HDA_ELD_BUFWR			0xbc
+#define HDMI_NV_PDISP_SOR_AUDIO_HDA_PRESENSE			0xbd
+
+#define HDMI_NV_PDISP_SOR_AUDIO_AVAL_0320    0xbf
+#define HDMI_NV_PDISP_SOR_AUDIO_AVAL_0441    0xc0
+#define HDMI_NV_PDISP_SOR_AUDIO_AVAL_0882    0xc1
+#define HDMI_NV_PDISP_SOR_AUDIO_AVAL_1764    0xc2
+#define HDMI_NV_PDISP_SOR_AUDIO_AVAL_0480    0xc3
+#define HDMI_NV_PDISP_SOR_AUDIO_AVAL_0960    0xc4
+#define HDMI_NV_PDISP_SOR_AUDIO_AVAL_1920    0xc5
+#define HDMI_NV_PDISP_SOR_AUDIO_AVAL_DEFAULT 0xc5
+
+#endif /* TEGRA_HDMI_H */
diff --git a/drivers/gpu/host1x/drm/host1x.c b/drivers/gpu/host1x/drm/host1x.c
new file mode 100644
index 0000000..5d17b11
--- /dev/null
+++ b/drivers/gpu/host1x/drm/host1x.c
@@ -0,0 +1,327 @@
+/*
+ * Copyright (C) 2012 Avionic Design GmbH
+ * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+
+#include "drm.h"
+
+struct host1x_drm_client {
+	struct host1x_client *client;
+	struct device_node *np;
+	struct list_head list;
+};
+
+static int host1x_add_drm_client(struct host1x *host1x, struct device_node *np)
+{
+	struct host1x_drm_client *client;
+
+	client = kzalloc(sizeof(*client), GFP_KERNEL);
+	if (!client)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&client->list);
+	client->np = of_node_get(np);
+
+	list_add_tail(&client->list, &host1x->drm_clients);
+
+	return 0;
+}
+
+static int host1x_activate_drm_client(struct host1x *host1x,
+				      struct host1x_drm_client *drm,
+				      struct host1x_client *client)
+{
+	mutex_lock(&host1x->drm_clients_lock);
+	list_del_init(&drm->list);
+	list_add_tail(&drm->list, &host1x->drm_active);
+	drm->client = client;
+	mutex_unlock(&host1x->drm_clients_lock);
+
+	return 0;
+}
+
+static int host1x_remove_drm_client(struct host1x *host1x,
+				    struct host1x_drm_client *client)
+{
+	mutex_lock(&host1x->drm_clients_lock);
+	list_del_init(&client->list);
+	mutex_unlock(&host1x->drm_clients_lock);
+
+	of_node_put(client->np);
+	kfree(client);
+
+	return 0;
+}
+
+static int host1x_parse_dt(struct host1x *host1x)
+{
+	static const char * const compat[] = {
+		"nvidia,tegra20-dc",
+		"nvidia,tegra20-hdmi",
+		"nvidia,tegra30-dc",
+		"nvidia,tegra30-hdmi",
+	};
+	unsigned int i;
+	int err;
+
+	for (i = 0; i < ARRAY_SIZE(compat); i++) {
+		struct device_node *np;
+
+		for_each_child_of_node(host1x->dev->of_node, np) {
+			if (of_device_is_compatible(np, compat[i]) &&
+			    of_device_is_available(np)) {
+				err = host1x_add_drm_client(host1x, np);
+				if (err < 0)
+					return err;
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int tegra_host1x_probe(struct platform_device *pdev)
+{
+	struct host1x *host1x;
+	struct resource *regs;
+	int err;
+
+	host1x = devm_kzalloc(&pdev->dev, sizeof(*host1x), GFP_KERNEL);
+	if (!host1x)
+		return -ENOMEM;
+
+	mutex_init(&host1x->drm_clients_lock);
+	INIT_LIST_HEAD(&host1x->drm_clients);
+	INIT_LIST_HEAD(&host1x->drm_active);
+	mutex_init(&host1x->clients_lock);
+	INIT_LIST_HEAD(&host1x->clients);
+	host1x->dev = &pdev->dev;
+
+	err = host1x_parse_dt(host1x);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to parse DT: %d\n", err);
+		return err;
+	}
+
+	host1x->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(host1x->clk))
+		return PTR_ERR(host1x->clk);
+
+	err = clk_prepare_enable(host1x->clk);
+	if (err < 0)
+		return err;
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!regs) {
+		err = -ENXIO;
+		goto err;
+	}
+
+	err = platform_get_irq(pdev, 0);
+	if (err < 0)
+		goto err;
+
+	host1x->syncpt = err;
+
+	err = platform_get_irq(pdev, 1);
+	if (err < 0)
+		goto err;
+
+	host1x->irq = err;
+
+	host1x->regs = devm_request_and_ioremap(&pdev->dev, regs);
+	if (!host1x->regs) {
+		err = -EADDRNOTAVAIL;
+		goto err;
+	}
+
+	platform_set_drvdata(pdev, host1x);
+
+	return 0;
+
+err:
+	clk_disable_unprepare(host1x->clk);
+	return err;
+}
+
+static int tegra_host1x_remove(struct platform_device *pdev)
+{
+	struct host1x *host1x = platform_get_drvdata(pdev);
+
+	clk_disable_unprepare(host1x->clk);
+
+	return 0;
+}
+
+int host1x_drm_init(struct host1x *host1x, struct drm_device *drm)
+{
+	struct host1x_client *client;
+
+	mutex_lock(&host1x->clients_lock);
+
+	list_for_each_entry(client, &host1x->clients, list) {
+		if (client->ops && client->ops->drm_init) {
+			int err = client->ops->drm_init(client, drm);
+			if (err < 0) {
+				dev_err(host1x->dev,
+					"DRM setup failed for %s: %d\n",
+					dev_name(client->dev), err);
+				return err;
+			}
+		}
+	}
+
+	mutex_unlock(&host1x->clients_lock);
+
+	return 0;
+}
+
+int host1x_drm_exit(struct host1x *host1x)
+{
+	struct platform_device *pdev = to_platform_device(host1x->dev);
+	struct host1x_client *client;
+
+	if (!host1x->drm)
+		return 0;
+
+	mutex_lock(&host1x->clients_lock);
+
+	list_for_each_entry_reverse(client, &host1x->clients, list) {
+		if (client->ops && client->ops->drm_exit) {
+			int err = client->ops->drm_exit(client);
+			if (err < 0) {
+				dev_err(host1x->dev,
+					"DRM cleanup failed for %s: %d\n",
+					dev_name(client->dev), err);
+				return err;
+			}
+		}
+	}
+
+	mutex_unlock(&host1x->clients_lock);
+
+	drm_platform_exit(&tegra_drm_driver, pdev);
+	host1x->drm = NULL;
+
+	return 0;
+}
+
+int host1x_register_client(struct host1x *host1x, struct host1x_client *client)
+{
+	struct host1x_drm_client *drm, *tmp;
+	int err;
+
+	mutex_lock(&host1x->clients_lock);
+	list_add_tail(&client->list, &host1x->clients);
+	mutex_unlock(&host1x->clients_lock);
+
+	list_for_each_entry_safe(drm, tmp, &host1x->drm_clients, list)
+		if (drm->np == client->dev->of_node)
+			host1x_activate_drm_client(host1x, drm, client);
+
+	if (list_empty(&host1x->drm_clients)) {
+		struct platform_device *pdev = to_platform_device(host1x->dev);
+
+		err = drm_platform_init(&tegra_drm_driver, pdev);
+		if (err < 0) {
+			dev_err(host1x->dev, "drm_platform_init(): %d\n", err);
+			return err;
+		}
+	}
+
+	client->host1x = host1x;
+
+	return 0;
+}
+
+int host1x_unregister_client(struct host1x *host1x,
+			     struct host1x_client *client)
+{
+	struct host1x_drm_client *drm, *tmp;
+	int err;
+
+	list_for_each_entry_safe(drm, tmp, &host1x->drm_active, list) {
+		if (drm->client == client) {
+			err = host1x_drm_exit(host1x);
+			if (err < 0) {
+				dev_err(host1x->dev, "host1x_drm_exit(): %d\n",
+					err);
+				return err;
+			}
+
+			host1x_remove_drm_client(host1x, drm);
+			break;
+		}
+	}
+
+	mutex_lock(&host1x->clients_lock);
+	list_del_init(&client->list);
+	mutex_unlock(&host1x->clients_lock);
+
+	return 0;
+}
+
+static struct of_device_id tegra_host1x_of_match[] = {
+	{ .compatible = "nvidia,tegra30-host1x", },
+	{ .compatible = "nvidia,tegra20-host1x", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, tegra_host1x_of_match);
+
+struct platform_driver tegra_host1x_driver = {
+	.driver = {
+		.name = "tegra-host1x",
+		.owner = THIS_MODULE,
+		.of_match_table = tegra_host1x_of_match,
+	},
+	.probe = tegra_host1x_probe,
+	.remove = tegra_host1x_remove,
+};
+
+static int __init tegra_host1x_init(void)
+{
+	int err;
+
+	err = platform_driver_register(&tegra_host1x_driver);
+	if (err < 0)
+		return err;
+
+	err = platform_driver_register(&tegra_dc_driver);
+	if (err < 0)
+		goto unregister_host1x;
+
+	err = platform_driver_register(&tegra_hdmi_driver);
+	if (err < 0)
+		goto unregister_dc;
+
+	return 0;
+
+unregister_dc:
+	platform_driver_unregister(&tegra_dc_driver);
+unregister_host1x:
+	platform_driver_unregister(&tegra_host1x_driver);
+	return err;
+}
+module_init(tegra_host1x_init);
+
+static void __exit tegra_host1x_exit(void)
+{
+	platform_driver_unregister(&tegra_hdmi_driver);
+	platform_driver_unregister(&tegra_dc_driver);
+	platform_driver_unregister(&tegra_host1x_driver);
+}
+module_exit(tegra_host1x_exit);
+
+MODULE_AUTHOR("Thierry Reding <thierry.reding@avionic-design.de>");
+MODULE_DESCRIPTION("NVIDIA Tegra DRM driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/host1x/drm/output.c b/drivers/gpu/host1x/drm/output.c
new file mode 100644
index 0000000..8140fc6
--- /dev/null
+++ b/drivers/gpu/host1x/drm/output.c
@@ -0,0 +1,272 @@
+/*
+ * Copyright (C) 2012 Avionic Design GmbH
+ * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/of_gpio.h>
+#include <linux/of_i2c.h>
+
+#include "drm.h"
+
+static int tegra_connector_get_modes(struct drm_connector *connector)
+{
+	struct tegra_output *output = connector_to_output(connector);
+	struct edid *edid = NULL;
+	int err = 0;
+
+	if (output->edid)
+		edid = kmemdup(output->edid, sizeof(*edid), GFP_KERNEL);
+	else if (output->ddc)
+		edid = drm_get_edid(connector, output->ddc);
+
+	drm_mode_connector_update_edid_property(connector, edid);
+
+	if (edid) {
+		err = drm_add_edid_modes(connector, edid);
+		kfree(edid);
+	}
+
+	return err;
+}
+
+static int tegra_connector_mode_valid(struct drm_connector *connector,
+				      struct drm_display_mode *mode)
+{
+	struct tegra_output *output = connector_to_output(connector);
+	enum drm_mode_status status = MODE_OK;
+	int err;
+
+	err = tegra_output_check_mode(output, mode, &status);
+	if (err < 0)
+		return MODE_ERROR;
+
+	return status;
+}
+
+static struct drm_encoder *
+tegra_connector_best_encoder(struct drm_connector *connector)
+{
+	struct tegra_output *output = connector_to_output(connector);
+
+	return &output->encoder;
+}
+
+static const struct drm_connector_helper_funcs connector_helper_funcs = {
+	.get_modes = tegra_connector_get_modes,
+	.mode_valid = tegra_connector_mode_valid,
+	.best_encoder = tegra_connector_best_encoder,
+};
+
+static enum drm_connector_status
+tegra_connector_detect(struct drm_connector *connector, bool force)
+{
+	struct tegra_output *output = connector_to_output(connector);
+	enum drm_connector_status status = connector_status_unknown;
+
+	if (gpio_is_valid(output->hpd_gpio)) {
+		if (gpio_get_value(output->hpd_gpio) == 0)
+			status = connector_status_disconnected;
+		else
+			status = connector_status_connected;
+	} else {
+		if (connector->connector_type == DRM_MODE_CONNECTOR_LVDS)
+			status = connector_status_connected;
+	}
+
+	return status;
+}
+
+static void tegra_connector_destroy(struct drm_connector *connector)
+{
+	drm_sysfs_connector_remove(connector);
+	drm_connector_cleanup(connector);
+}
+
+static const struct drm_connector_funcs connector_funcs = {
+	.dpms = drm_helper_connector_dpms,
+	.detect = tegra_connector_detect,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.destroy = tegra_connector_destroy,
+};
+
+static void tegra_encoder_destroy(struct drm_encoder *encoder)
+{
+	drm_encoder_cleanup(encoder);
+}
+
+static const struct drm_encoder_funcs encoder_funcs = {
+	.destroy = tegra_encoder_destroy,
+};
+
+static void tegra_encoder_dpms(struct drm_encoder *encoder, int mode)
+{
+}
+
+static bool tegra_encoder_mode_fixup(struct drm_encoder *encoder,
+				     const struct drm_display_mode *mode,
+				     struct drm_display_mode *adjusted)
+{
+	return true;
+}
+
+static void tegra_encoder_prepare(struct drm_encoder *encoder)
+{
+}
+
+static void tegra_encoder_commit(struct drm_encoder *encoder)
+{
+}
+
+static void tegra_encoder_mode_set(struct drm_encoder *encoder,
+				   struct drm_display_mode *mode,
+				   struct drm_display_mode *adjusted)
+{
+	struct tegra_output *output = encoder_to_output(encoder);
+	int err;
+
+	err = tegra_output_enable(output);
+	if (err < 0)
+		dev_err(encoder->dev->dev, "tegra_output_enable(): %d\n", err);
+}
+
+static const struct drm_encoder_helper_funcs encoder_helper_funcs = {
+	.dpms = tegra_encoder_dpms,
+	.mode_fixup = tegra_encoder_mode_fixup,
+	.prepare = tegra_encoder_prepare,
+	.commit = tegra_encoder_commit,
+	.mode_set = tegra_encoder_mode_set,
+};
+
+static irqreturn_t hpd_irq(int irq, void *data)
+{
+	struct tegra_output *output = data;
+
+	drm_helper_hpd_irq_event(output->connector.dev);
+
+	return IRQ_HANDLED;
+}
+
+int tegra_output_parse_dt(struct tegra_output *output)
+{
+	enum of_gpio_flags flags;
+	struct device_node *ddc;
+	size_t size;
+	int err;
+
+	if (!output->of_node)
+		output->of_node = output->dev->of_node;
+
+	output->edid = of_get_property(output->of_node, "nvidia,edid", &size);
+
+	ddc = of_parse_phandle(output->of_node, "nvidia,ddc-i2c-bus", 0);
+	if (ddc) {
+		output->ddc = of_find_i2c_adapter_by_node(ddc);
+		if (!output->ddc) {
+			err = -EPROBE_DEFER;
+			of_node_put(ddc);
+			return err;
+		}
+
+		of_node_put(ddc);
+	}
+
+	if (!output->edid && !output->ddc)
+		return -ENODEV;
+
+	output->hpd_gpio = of_get_named_gpio_flags(output->of_node,
+						   "nvidia,hpd-gpio", 0,
+						   &flags);
+
+	return 0;
+}
+
+int tegra_output_init(struct drm_device *drm, struct tegra_output *output)
+{
+	int connector, encoder, err;
+
+	if (gpio_is_valid(output->hpd_gpio)) {
+		unsigned long flags;
+
+		err = gpio_request_one(output->hpd_gpio, GPIOF_DIR_IN,
+				       "HDMI hotplug detect");
+		if (err < 0) {
+			dev_err(output->dev, "gpio_request_one(): %d\n", err);
+			return err;
+		}
+
+		err = gpio_to_irq(output->hpd_gpio);
+		if (err < 0) {
+			dev_err(output->dev, "gpio_to_irq(): %d\n", err);
+			goto free_hpd;
+		}
+
+		output->hpd_irq = err;
+
+		flags = IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING |
+			IRQF_ONESHOT;
+
+		err = request_threaded_irq(output->hpd_irq, NULL, hpd_irq,
+					   flags, "hpd", output);
+		if (err < 0) {
+			dev_err(output->dev, "failed to request IRQ#%u: %d\n",
+				output->hpd_irq, err);
+			goto free_hpd;
+		}
+
+		output->connector.polled = DRM_CONNECTOR_POLL_HPD;
+	}
+
+	switch (output->type) {
+	case TEGRA_OUTPUT_RGB:
+		connector = DRM_MODE_CONNECTOR_LVDS;
+		encoder = DRM_MODE_ENCODER_LVDS;
+		break;
+
+	case TEGRA_OUTPUT_HDMI:
+		connector = DRM_MODE_CONNECTOR_HDMIA;
+		encoder = DRM_MODE_ENCODER_TMDS;
+		break;
+
+	default:
+		connector = DRM_MODE_CONNECTOR_Unknown;
+		encoder = DRM_MODE_ENCODER_NONE;
+		break;
+	}
+
+	drm_connector_init(drm, &output->connector, &connector_funcs,
+			   connector);
+	drm_connector_helper_add(&output->connector, &connector_helper_funcs);
+
+	drm_encoder_init(drm, &output->encoder, &encoder_funcs, encoder);
+	drm_encoder_helper_add(&output->encoder, &encoder_helper_funcs);
+
+	drm_mode_connector_attach_encoder(&output->connector, &output->encoder);
+	drm_sysfs_connector_add(&output->connector);
+
+	output->encoder.possible_crtcs = 0x3;
+
+	return 0;
+
+free_hpd:
+	gpio_free(output->hpd_gpio);
+
+	return err;
+}
+
+int tegra_output_exit(struct tegra_output *output)
+{
+	if (gpio_is_valid(output->hpd_gpio)) {
+		free_irq(output->hpd_irq, output);
+		gpio_free(output->hpd_gpio);
+	}
+
+	if (output->ddc)
+		put_device(&output->ddc->dev);
+
+	return 0;
+}
diff --git a/drivers/gpu/host1x/drm/rgb.c b/drivers/gpu/host1x/drm/rgb.c
new file mode 100644
index 0000000..ed4416f
--- /dev/null
+++ b/drivers/gpu/host1x/drm/rgb.c
@@ -0,0 +1,228 @@
+/*
+ * Copyright (C) 2012 Avionic Design GmbH
+ * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+
+#include "drm.h"
+#include "dc.h"
+
+struct tegra_rgb {
+	struct tegra_output output;
+	struct clk *clk_parent;
+	struct clk *clk;
+};
+
+static inline struct tegra_rgb *to_rgb(struct tegra_output *output)
+{
+	return container_of(output, struct tegra_rgb, output);
+}
+
+struct reg_entry {
+	unsigned long offset;
+	unsigned long value;
+};
+
+static const struct reg_entry rgb_enable[] = {
+	{ DC_COM_PIN_OUTPUT_ENABLE(0),   0x00000000 },
+	{ DC_COM_PIN_OUTPUT_ENABLE(1),   0x00000000 },
+	{ DC_COM_PIN_OUTPUT_ENABLE(2),   0x00000000 },
+	{ DC_COM_PIN_OUTPUT_ENABLE(3),   0x00000000 },
+	{ DC_COM_PIN_OUTPUT_POLARITY(0), 0x00000000 },
+	{ DC_COM_PIN_OUTPUT_POLARITY(1), 0x01000000 },
+	{ DC_COM_PIN_OUTPUT_POLARITY(2), 0x00000000 },
+	{ DC_COM_PIN_OUTPUT_POLARITY(3), 0x00000000 },
+	{ DC_COM_PIN_OUTPUT_DATA(0),     0x00000000 },
+	{ DC_COM_PIN_OUTPUT_DATA(1),     0x00000000 },
+	{ DC_COM_PIN_OUTPUT_DATA(2),     0x00000000 },
+	{ DC_COM_PIN_OUTPUT_DATA(3),     0x00000000 },
+	{ DC_COM_PIN_OUTPUT_SELECT(0),   0x00000000 },
+	{ DC_COM_PIN_OUTPUT_SELECT(1),   0x00000000 },
+	{ DC_COM_PIN_OUTPUT_SELECT(2),   0x00000000 },
+	{ DC_COM_PIN_OUTPUT_SELECT(3),   0x00000000 },
+	{ DC_COM_PIN_OUTPUT_SELECT(4),   0x00210222 },
+	{ DC_COM_PIN_OUTPUT_SELECT(5),   0x00002200 },
+	{ DC_COM_PIN_OUTPUT_SELECT(6),   0x00020000 },
+};
+
+static const struct reg_entry rgb_disable[] = {
+	{ DC_COM_PIN_OUTPUT_SELECT(6),   0x00000000 },
+	{ DC_COM_PIN_OUTPUT_SELECT(5),   0x00000000 },
+	{ DC_COM_PIN_OUTPUT_SELECT(4),   0x00000000 },
+	{ DC_COM_PIN_OUTPUT_SELECT(3),   0x00000000 },
+	{ DC_COM_PIN_OUTPUT_SELECT(2),   0x00000000 },
+	{ DC_COM_PIN_OUTPUT_SELECT(1),   0x00000000 },
+	{ DC_COM_PIN_OUTPUT_SELECT(0),   0x00000000 },
+	{ DC_COM_PIN_OUTPUT_DATA(3),     0xaaaaaaaa },
+	{ DC_COM_PIN_OUTPUT_DATA(2),     0xaaaaaaaa },
+	{ DC_COM_PIN_OUTPUT_DATA(1),     0xaaaaaaaa },
+	{ DC_COM_PIN_OUTPUT_DATA(0),     0xaaaaaaaa },
+	{ DC_COM_PIN_OUTPUT_POLARITY(3), 0x00000000 },
+	{ DC_COM_PIN_OUTPUT_POLARITY(2), 0x00000000 },
+	{ DC_COM_PIN_OUTPUT_POLARITY(1), 0x00000000 },
+	{ DC_COM_PIN_OUTPUT_POLARITY(0), 0x00000000 },
+	{ DC_COM_PIN_OUTPUT_ENABLE(3),   0x55555555 },
+	{ DC_COM_PIN_OUTPUT_ENABLE(2),   0x55555555 },
+	{ DC_COM_PIN_OUTPUT_ENABLE(1),   0x55150005 },
+	{ DC_COM_PIN_OUTPUT_ENABLE(0),   0x55555555 },
+};
+
+static void tegra_dc_write_regs(struct tegra_dc *dc,
+				const struct reg_entry *table,
+				unsigned int num)
+{
+	unsigned int i;
+
+	for (i = 0; i < num; i++)
+		tegra_dc_writel(dc, table[i].value, table[i].offset);
+}
+
+static int tegra_output_rgb_enable(struct tegra_output *output)
+{
+	struct tegra_dc *dc = to_tegra_dc(output->encoder.crtc);
+
+	tegra_dc_write_regs(dc, rgb_enable, ARRAY_SIZE(rgb_enable));
+
+	return 0;
+}
+
+static int tegra_output_rgb_disable(struct tegra_output *output)
+{
+	struct tegra_dc *dc = to_tegra_dc(output->encoder.crtc);
+
+	tegra_dc_write_regs(dc, rgb_disable, ARRAY_SIZE(rgb_disable));
+
+	return 0;
+}
+
+static int tegra_output_rgb_setup_clock(struct tegra_output *output,
+					struct clk *clk, unsigned long pclk)
+{
+	struct tegra_rgb *rgb = to_rgb(output);
+
+	return clk_set_parent(clk, rgb->clk_parent);
+}
+
+static int tegra_output_rgb_check_mode(struct tegra_output *output,
+				       struct drm_display_mode *mode,
+				       enum drm_mode_status *status)
+{
+	/*
+	 * FIXME: For now, always assume that the mode is okay. There are
+	 * unresolved issues with clk_round_rate(), which doesn't always
+	 * reliably report whether a frequency can be set or not.
+	 */
+
+	*status = MODE_OK;
+
+	return 0;
+}
+
+static const struct tegra_output_ops rgb_ops = {
+	.enable = tegra_output_rgb_enable,
+	.disable = tegra_output_rgb_disable,
+	.setup_clock = tegra_output_rgb_setup_clock,
+	.check_mode = tegra_output_rgb_check_mode,
+};
+
+int tegra_dc_rgb_probe(struct tegra_dc *dc)
+{
+	struct device_node *np;
+	struct tegra_rgb *rgb;
+	int err;
+
+	np = of_get_child_by_name(dc->dev->of_node, "rgb");
+	if (!np || !of_device_is_available(np))
+		return -ENODEV;
+
+	rgb = devm_kzalloc(dc->dev, sizeof(*rgb), GFP_KERNEL);
+	if (!rgb)
+		return -ENOMEM;
+
+	rgb->clk = devm_clk_get(dc->dev, NULL);
+	if (IS_ERR(rgb->clk)) {
+		dev_err(dc->dev, "failed to get clock\n");
+		return PTR_ERR(rgb->clk);
+	}
+
+	rgb->clk_parent = devm_clk_get(dc->dev, "parent");
+	if (IS_ERR(rgb->clk_parent)) {
+		dev_err(dc->dev, "failed to get parent clock\n");
+		return PTR_ERR(rgb->clk_parent);
+	}
+
+	err = clk_set_parent(rgb->clk, rgb->clk_parent);
+	if (err < 0) {
+		dev_err(dc->dev, "failed to set parent clock: %d\n", err);
+		return err;
+	}
+
+	rgb->output.dev = dc->dev;
+	rgb->output.of_node = np;
+
+	err = tegra_output_parse_dt(&rgb->output);
+	if (err < 0)
+		return err;
+
+	dc->rgb = &rgb->output;
+
+	return 0;
+}
+
+int tegra_dc_rgb_init(struct drm_device *drm, struct tegra_dc *dc)
+{
+	struct tegra_rgb *rgb = to_rgb(dc->rgb);
+	int err;
+
+	if (!dc->rgb)
+		return -ENODEV;
+
+	rgb->output.type = TEGRA_OUTPUT_RGB;
+	rgb->output.ops = &rgb_ops;
+
+	err = tegra_output_init(dc->base.dev, &rgb->output);
+	if (err < 0) {
+		dev_err(dc->dev, "output setup failed: %d\n", err);
+		return err;
+	}
+
+	/*
+	 * By default, outputs can be associated with each display controller.
+	 * RGB outputs are an exception, so we make sure they can be attached
+	 * to only their parent display controller.
+	 */
+	rgb->output.encoder.possible_crtcs = 1 << dc->pipe;
+
+	return 0;
+}
+
+int tegra_dc_rgb_exit(struct tegra_dc *dc)
+{
+	if (dc->rgb) {
+		int err;
+
+		err = tegra_output_disable(dc->rgb);
+		if (err < 0) {
+			dev_err(dc->dev, "output failed to disable: %d\n", err);
+			return err;
+		}
+
+		err = tegra_output_exit(dc->rgb);
+		if (err < 0) {
+			dev_err(dc->dev, "output cleanup failed: %d\n", err);
+			return err;
+		}
+
+		dc->rgb = NULL;
+	}
+
+	return 0;
+}
diff --git a/drivers/gpu/host1x/host1x_client.h b/drivers/gpu/host1x/host1x_client.h
new file mode 100644
index 0000000..fdd2920
--- /dev/null
+++ b/drivers/gpu/host1x/host1x_client.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (c) 2013, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef HOST1X_CLIENT_H
+#define HOST1X_CLIENT_H
+
+struct platform_device;
+
+void host1x_set_drm_data(struct platform_device *pdev, void *data);
+void *host1x_get_drm_data(struct platform_device *pdev);
+
+#endif
-- 
1.7.9.5

