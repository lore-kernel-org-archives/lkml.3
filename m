Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaA2JYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:24:08 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:60804 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbaA2JYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:24:02 -0500
X-Mailbox-Line: From 7968ed34e74f395ce559d47ea00736d102e6a5f9 Mon Sep 17 00:00:00 2001
Message-Id: <7968ed34e74f395ce559d47ea00736d102e6a5f9.1390986083.git.moinejf@free.fr>
In-Reply-To: <cover.1390986082.git.moinejf@free.fr>
References: <cover.1390986082.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sat, 25 Jan 2014 18:14:41 +0100
Subject: [PATCH v5 08/23] drm/i2c: tda998x: use HDMI constants
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces hard coded values by hdmi constants.

Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 16f2473..bb0c6ac 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -549,12 +549,12 @@ tda998x_write_if(struct tda998x_priv *priv, uint8_t bit, uint16_t addr,
 static void
 tda998x_write_aif(struct tda998x_priv *priv, struct tda998x_encoder_params *p)
 {
-	uint8_t buf[PB(5) + 1];
+	u8 buf[PB(HDMI_AUDIO_INFOFRAME_SIZE) + 1];
 
 	memset(buf, 0, sizeof(buf));
-	buf[HB(0)] = 0x84;
+	buf[HB(0)] = HDMI_INFOFRAME_TYPE_AUDIO;
 	buf[HB(1)] = 0x01;
-	buf[HB(2)] = 10;
+	buf[HB(2)] = HDMI_AUDIO_INFOFRAME_SIZE;
 	buf[PB(1)] = p->audio_frame[1] & 0x07; /* CC */
 	buf[PB(2)] = p->audio_frame[2] & 0x1c; /* SF */
 	buf[PB(4)] = p->audio_frame[4];
@@ -567,12 +567,12 @@ tda998x_write_aif(struct tda998x_priv *priv, struct tda998x_encoder_params *p)
 static void
 tda998x_write_avi(struct tda998x_priv *priv, struct drm_display_mode *mode)
 {
-	uint8_t buf[PB(13) + 1];
+	u8 buf[PB(HDMI_AVI_INFOFRAME_SIZE) + 1];
 
 	memset(buf, 0, sizeof(buf));
-	buf[HB(0)] = 0x82;
+	buf[HB(0)] = HDMI_INFOFRAME_TYPE_AVI;
 	buf[HB(1)] = 0x02;
-	buf[HB(2)] = 13;
+	buf[HB(2)] = HDMI_AVI_INFOFRAME_SIZE;
 	buf[PB(1)] = HDMI_SCAN_MODE_UNDERSCAN;
 	buf[PB(3)] = HDMI_QUANTIZATION_RANGE_FULL << 2;
 	buf[PB(4)] = drm_match_cea_mode(mode);
-- 
1.9.rc1

