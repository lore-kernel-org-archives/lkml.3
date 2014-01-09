Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbaAILMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:12:52 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:41441 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754423AbaAILMn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:12:43 -0500
Date: Thu, 9 Jan 2014 12:06:39 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 23/28] drm/i2c: tda998x: add the active aspect in HDMI
 AVI frame
Message-ID: <20140109120639.5f76c620@armhf>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the active aspect as 'picture' in the HDMI AVI frame
and also some comments about this frame.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 55cecb8..68630b8 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -696,7 +696,11 @@ tda998x_write_avi(struct tda998x_priv *priv, struct drm_display_mode *mode)
 	buf[HB(1)] = 0x02;
 	buf[HB(2)] = HDMI_AVI_INFOFRAME_SIZE;
 	buf[PB(1)] = HDMI_SCAN_MODE_UNDERSCAN;
+			/* (color_ind << 5) | (info_pres << 4) | (bar << 2) | scan */
+	buf[PB(2)] = HDMI_ACTIVE_ASPECT_PICTURE;
+			/* (colorimetry << 6) | (pic_ratio << 4) | active_ratio */
 	buf[PB(3)] = HDMI_QUANTIZATION_RANGE_FULL << 2;
+				/* (quant_range << 2) | non_uniform_scaling */
 	buf[PB(4)] = drm_match_cea_mode(mode);
 
 	tda998x_write_if(priv, DIP_IF_FLAGS_IF2, REG_IF2_HB0, buf,
-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
