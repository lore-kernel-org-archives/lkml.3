Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbaAILN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:13:29 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:43106 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821AbaAILNL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:13:11 -0500
Date: Thu, 9 Jan 2014 12:07:25 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 26/28] drm/i2c: tda998x: code optimization
Message-ID: <20140109120725.0b0f3e55@armhf>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reduces the number of I2C exchanges by setting many bits in
one write and removing a useless write.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c   | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 6b4f6d2..d3b3f3a 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -751,10 +751,10 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 	}
 
 	reg_write(priv, REG_AIP_CLKSEL, clksel_aip);
-	reg_clear(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_LAYOUT);
+	reg_clear(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_LAYOUT |
 
 	/* Enable automatic CTS generation */
-	reg_clear(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_ACR_MAN);
+					AIP_CNTRL_0_ACR_MAN);
 	reg_write(priv, REG_CTS_N, cts_n);
 
 	/*
@@ -1001,10 +1001,10 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 	reg_write(priv, REG_VIP_CNTRL_5, VIP_CNTRL_5_SP_CNT(0));
 	reg_write(priv, REG_VIP_CNTRL_4, VIP_CNTRL_4_BLANKIT(0) |
 			VIP_CNTRL_4_BLC(0));
-	reg_clear(priv, REG_PLL_SERIAL_3, PLL_SERIAL_3_SRL_CCIR);
 
 	reg_clear(priv, REG_PLL_SERIAL_1, PLL_SERIAL_1_SRL_MAN_IZ);
-	reg_clear(priv, REG_PLL_SERIAL_3, PLL_SERIAL_3_SRL_DE);
+	reg_clear(priv, REG_PLL_SERIAL_3, PLL_SERIAL_3_SRL_CCIR |
+					  PLL_SERIAL_3_SRL_DE);
 	reg_write(priv, REG_SERIALIZER, 0);
 
 	/* video quantization range = 0: full, 1: RGB/YUV, 2: YUV */
@@ -1026,8 +1026,6 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 	/* set BIAS tmds value: */
 	reg_write(priv, REG_ANA_GENERAL, 0x09);
 
-	reg_write(priv, REG_TBG_CNTRL_0, 0);
-
 	/*
 	 * Sync on rising HSYNC/VSYNC
 	 */
-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
