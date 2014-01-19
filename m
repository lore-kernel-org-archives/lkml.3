Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaASTBk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 14:01:40 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:33979 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbaASTBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 14:01:34 -0500
Date: Sun, 19 Jan 2014 19:58:42 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v3 09/24] drm/i2c: tda998x: use HDMI constants
Message-ID: <20140119195842.5790f26d@armhf>
In-Reply-To: <cover.1390153344.git.moinejf@free.fr>
References: <cover.1390153344.git.moinejf@free.fr>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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
index 78d324b..978edaf 100644
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
1.8.5.3

