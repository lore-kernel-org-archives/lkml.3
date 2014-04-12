Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727AbaDLKGI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 06:06:08 -0400
Received: from fallback2.mail.ru ([94.100.176.87]:39509 "EHLO
	fallback6.mail.ru" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752511AbaDLKGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 06:06:05 -0400
From: Brilliantov Kirill Vladimirovich <brilliantov@inbox.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sascha Hauer <kernel@pengutronix.de>, linux-kernel@vger.kernel.org,
        Brilliantov Kirill Vladimirovich <brilliantov@inbox.ru>
Subject: [PATCH] staging/imx-drm: fix code line width
Date: Sat, 12 Apr 2014 14:04:21 +0400
Message-Id: <1397297061-3778-1-git-send-email-brilliantov@inbox.ru>
X-Mailer: git-send-email 1.9.1
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Brilliantov Kirill Vladimirovich <brilliantov@inbox.ru>
---
 drivers/staging/imx-drm/imx-tve.c           |  3 ++-
 drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h |  3 ++-
 drivers/staging/imx-drm/ipu-v3/ipu-common.c | 23 +++++++++++++++--------
 drivers/staging/imx-drm/ipu-v3/ipu-dc.c     | 27 ++++++++++++++++++---------
 drivers/staging/imx-drm/ipu-v3/ipu-di.c     | 12 ++++++++----
 drivers/staging/imx-drm/ipuv3-crtc.c        |  6 ++++--
 6 files changed, 49 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/imx-drm/imx-tve.c b/drivers/staging/imx-drm/imx-tve.c
index 575533f..7023035 100644
--- a/drivers/staging/imx-drm/imx-tve.c
+++ b/drivers/staging/imx-drm/imx-tve.c
@@ -669,7 +669,8 @@ static int imx_tve_bind(struct device *dev, struct device *master, void *data)
 
 	ret = regmap_read(tve->regmap, TVE_COM_CONF_REG, &val);
 	if (ret < 0) {
-		dev_err(dev, "failed to read configuration register: %d\n", ret);
+		dev_err(dev,
+			"failed to read configuration register: %d\n", ret);
 		return ret;
 	}
 	if (val != 0x00100000) {
diff --git a/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h b/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h
index c4d14ea..4fd7be7 100644
--- a/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h
+++ b/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h
@@ -230,7 +230,8 @@ struct ipu_ch_param {
 	struct ipu_cpmem_word word[2];
 };
 
-void ipu_ch_param_write_field(struct ipu_ch_param __iomem *base, u32 wbs, u32 v);
+void ipu_ch_param_write_field(struct ipu_ch_param __iomem *base, u32 wbs,
+				u32 v);
 u32 ipu_ch_param_read_field(struct ipu_ch_param __iomem *base, u32 wbs);
 struct ipu_ch_param __iomem *ipu_get_cpmem(struct ipuv3_channel *channel);
 void ipu_ch_param_dump(struct ipu_ch_param __iomem *p);
diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-common.c b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
index ca85d3d..b2c672f 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-common.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
@@ -233,14 +233,20 @@ void ipu_cpmem_set_yuv_interleaved(struct ipu_ch_param __iomem *p,
 {
 	switch (pixel_format) {
 	case V4L2_PIX_FMT_UYVY:
-		ipu_ch_param_write_field(p, IPU_FIELD_BPP, 3);    /* bits/pixel */
-		ipu_ch_param_write_field(p, IPU_FIELD_PFS, 0xA);  /* pix format */
-		ipu_ch_param_write_field(p, IPU_FIELD_NPB, 31);   /* burst size */
+		/* bits/pixel */
+		ipu_ch_param_write_field(p, IPU_FIELD_BPP, 3);
+		/* pix format */
+		ipu_ch_param_write_field(p, IPU_FIELD_PFS, 0xA);
+		/* burst size */
+		ipu_ch_param_write_field(p, IPU_FIELD_NPB, 31);
 		break;
 	case V4L2_PIX_FMT_YUYV:
-		ipu_ch_param_write_field(p, IPU_FIELD_BPP, 3);    /* bits/pixel */
-		ipu_ch_param_write_field(p, IPU_FIELD_PFS, 0x8);  /* pix format */
-		ipu_ch_param_write_field(p, IPU_FIELD_NPB, 31);   /* burst size */
+		/* bits/pixel */
+		ipu_ch_param_write_field(p, IPU_FIELD_BPP, 3);
+		/* pix format */
+		ipu_ch_param_write_field(p, IPU_FIELD_PFS, 0x8);
+		/* burst size */
+		ipu_ch_param_write_field(p, IPU_FIELD_NPB, 31);
 		break;
 	}
 }
@@ -900,7 +906,8 @@ static void ipu_irq_handle(struct ipu_soc *ipu, const int *regs, int num_regs)
 		status &= ipu_cm_read(ipu, IPU_INT_CTRL(regs[i]));
 
 		for_each_set_bit(bit, &status, 32) {
-			irq = irq_linear_revmap(ipu->domain, regs[i] * 32 + bit);
+			irq =
+			    irq_linear_revmap(ipu->domain, regs[i] * 32 + bit);
 			if (irq)
 				generic_handle_irq(irq);
 		}
@@ -1053,7 +1060,7 @@ static int ipu_irq_init(struct ipu_soc *ipu)
 	}
 
 	ret = irq_alloc_domain_generic_chips(ipu->domain, 32, 1, "IPU",
-					     handle_level_irq, 0, IRQF_VALID, 0);
+				     handle_level_irq, 0, IRQF_VALID, 0);
 	if (ret < 0) {
 		dev_err(ipu->dev, "failed to alloc generic irq chips\n");
 		irq_domain_remove(ipu->domain);
diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-dc.c b/drivers/staging/imx-drm/ipu-v3/ipu-dc.c
index d5de8bb..b05111a 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-dc.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-dc.c
@@ -132,10 +132,12 @@ static void dc_write_tmpl(struct ipu_dc *dc, int word, u32 opcode, u32 operand,
 		reg1 = (operand << 20) & 0xfff00000;
 		reg2 = operand >> 12 | opcode << 1 | stop << 9;
 	} else if (opcode == WRG) {
-		reg1 = sync | glue << 4 | ++wave << 11 | ((operand << 15) & 0xffff8000);
+		reg1 = sync | glue << 4 | ++wave << 11 |
+			((operand << 15) & 0xffff8000);
 		reg2 = operand >> 17 | opcode << 7 | stop << 9;
 	} else {
-		reg1 = sync | glue << 4 | ++wave << 11 | ++map << 15 | ((operand << 20) & 0xfff00000);
+		reg1 = sync | glue << 4 | ++wave << 11 | ++map << 15 |
+			((operand << 20) & 0xfff00000);
 		reg2 = operand >> 12 | opcode << 4 | stop << 9;
 	}
 	writel(reg1, priv->dc_tmpl_reg + word * 8);
@@ -188,19 +190,25 @@ int ipu_dc_init_sync(struct ipu_dc *dc, struct ipu_di *di, bool interlaced,
 			dc_link_event(dc, DC_EVT_EOL, 3, 2);
 			dc_link_event(dc, DC_EVT_NEW_DATA, 1, 1);
 			/* Init template microcode */
-			dc_write_tmpl(dc, 2, WROD(0), 0, map, SYNC_WAVE, 8, 5, 1);
-			dc_write_tmpl(dc, 3, WROD(0), 0, map, SYNC_WAVE, 4, 5, 0);
+			dc_write_tmpl(dc, 2, WROD(0), 0, map, SYNC_WAVE, 8,
+					5, 1);
+			dc_write_tmpl(dc, 3, WROD(0), 0, map, SYNC_WAVE, 4,
+					5, 0);
 			dc_write_tmpl(dc, 4, WRG, 0, map, NULL_WAVE, 0, 0, 1);
-			dc_write_tmpl(dc, 1, WROD(0), 0, map, SYNC_WAVE, 0, 5, 1);
+			dc_write_tmpl(dc, 1, WROD(0), 0, map, SYNC_WAVE, 0,
+					5, 1);
 		} else {
 			dc_link_event(dc, DC_EVT_NL, 5, 3);
 			dc_link_event(dc, DC_EVT_EOL, 6, 2);
 			dc_link_event(dc, DC_EVT_NEW_DATA, 8, 1);
 			/* Init template microcode */
-			dc_write_tmpl(dc, 5, WROD(0), 0, map, SYNC_WAVE, 8, 5, 1);
-			dc_write_tmpl(dc, 6, WROD(0), 0, map, SYNC_WAVE, 4, 5, 0);
+			dc_write_tmpl(dc, 5, WROD(0), 0, map, SYNC_WAVE, 8,
+					5, 1);
+			dc_write_tmpl(dc, 6, WROD(0), 0, map, SYNC_WAVE, 4,
+					5, 0);
 			dc_write_tmpl(dc, 7, WRG, 0, map, NULL_WAVE, 0, 0, 1);
-			dc_write_tmpl(dc, 8, WROD(0), 0, map, SYNC_WAVE, 0, 5, 1);
+			dc_write_tmpl(dc, 8, WROD(0), 0, map, SYNC_WAVE, 0,
+					5, 1);
 		}
 	}
 	dc_link_event(dc, DC_EVT_NF, 0, 0);
@@ -367,7 +375,8 @@ int ipu_dc_init(struct ipu_soc *ipu, struct device *dev,
 	writel(DC_WR_CH_CONF_WORD_SIZE_24 | DC_WR_CH_CONF_DISP_ID_PARALLEL(0),
 			priv->channels[5].base + DC_WR_CH_CONF);
 
-	writel(DC_GEN_SYNC_1_6_SYNC | DC_GEN_SYNC_PRIORITY_1, priv->dc_reg + DC_GEN);
+	writel(DC_GEN_SYNC_1_6_SYNC | DC_GEN_SYNC_PRIORITY_1,
+		priv->dc_reg + DC_GEN);
 
 	ipu->dc_priv = priv;
 
diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-di.c b/drivers/staging/imx-drm/ipu-v3/ipu-di.c
index 82a9eba..97d20c0 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-di.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-di.c
@@ -347,7 +347,8 @@ static void ipu_di_sync_config_noninterlaced(struct ipu_di *di,
 			/* PIN4: HSYNC for VGA via TVEv2 on TQ MBa53 */
 			.run_count = h_total - 1,
 			.run_src = DI_SYNC_CLK,
-			.offset_count = div * sig->v_to_h_sync + 18, /* magic value from Freescale TVE driver */
+			/* magic value from Freescale TVE driver */
+			.offset_count = div * sig->v_to_h_sync + 18,
 			.offset_src = DI_SYNC_CLK,
 			.cnt_polarity_gen_en = 1,
 			.cnt_polarity_trigger_src = DI_SYNC_CLK,
@@ -363,7 +364,8 @@ static void ipu_di_sync_config_noninterlaced(struct ipu_di *di,
 			/* PIN6: VSYNC for VGA via TVEv2 on TQ MBa53 */
 			.run_count = v_total - 1,
 			.run_src = DI_SYNC_INT_HSYNC,
-			.offset_count = 1, /* magic value from Freescale TVE driver */
+			/* magic value from Freescale TVE driver */
+			.offset_count = 1,
 			.offset_src = DI_SYNC_INT_HSYNC,
 			.cnt_polarity_gen_en = 1,
 			.cnt_polarity_trigger_src = DI_SYNC_INT_HSYNC,
@@ -372,7 +374,8 @@ static void ipu_di_sync_config_noninterlaced(struct ipu_di *di,
 			/* PIN4: HSYNC for VGA via TVEv2 on i.MX53-QSB */
 			.run_count = h_total - 1,
 			.run_src = DI_SYNC_CLK,
-			.offset_count = div * sig->v_to_h_sync + 18, /* magic value from Freescale TVE driver */
+			/* magic value from Freescale TVE driver */
+			.offset_count = div * sig->v_to_h_sync + 18,
 			.offset_src = DI_SYNC_CLK,
 			.cnt_polarity_gen_en = 1,
 			.cnt_polarity_trigger_src = DI_SYNC_CLK,
@@ -381,7 +384,8 @@ static void ipu_di_sync_config_noninterlaced(struct ipu_di *di,
 			/* PIN6: VSYNC for VGA via TVEv2 on i.MX53-QSB */
 			.run_count = v_total - 1,
 			.run_src = DI_SYNC_INT_HSYNC,
-			.offset_count = 1, /* magic value from Freescale TVE driver */
+			/* magic value from Freescale TVE driver */
+			.offset_count = 1,
 			.offset_src = DI_SYNC_INT_HSYNC,
 			.cnt_polarity_gen_en = 1,
 			.cnt_polarity_trigger_src = DI_SYNC_INT_HSYNC,
diff --git a/drivers/staging/imx-drm/ipuv3-crtc.c b/drivers/staging/imx-drm/ipuv3-crtc.c
index c48f640..39752c5 100644
--- a/drivers/staging/imx-drm/ipuv3-crtc.c
+++ b/drivers/staging/imx-drm/ipuv3-crtc.c
@@ -193,7 +193,8 @@ static int ipu_crtc_mode_set(struct drm_crtc *crtc,
 		return ret;
 	}
 
-	return ipu_plane_mode_set(ipu_crtc->plane[0], crtc, mode, crtc->primary->fb,
+	return ipu_plane_mode_set(ipu_crtc->plane[0], crtc, mode,
+				crtc->primary->fb,
 				  0, 0, mode->hdisplay, mode->vdisplay,
 				  x, y, mode->hdisplay, mode->vdisplay);
 }
@@ -219,7 +220,8 @@ static irqreturn_t ipu_irq_handler(int irq, void *dev_id)
 
 	if (ipu_crtc->newfb) {
 		ipu_crtc->newfb = NULL;
-		ipu_plane_set_base(ipu_crtc->plane[0], ipu_crtc->base.primary->fb,
+		ipu_plane_set_base(ipu_crtc->plane[0],
+				ipu_crtc->base.primary->fb,
 				ipu_crtc->plane[0]->x, ipu_crtc->plane[0]->y);
 		ipu_crtc_handle_pageflip(ipu_crtc);
 	}
-- 
1.9.1

