Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaA2J0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:26:00 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:41450 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbaA2JZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:25:55 -0500
X-Mailbox-Line: From e8aa5b9ca825332cba8abead7bbc65ab8683f991 Mon Sep 17 00:00:00 2001
Message-Id: <e8aa5b9ca825332cba8abead7bbc65ab8683f991.1390986083.git.moinejf@free.fr>
In-Reply-To: <cover.1390986082.git.moinejf@free.fr>
References: <cover.1390986082.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sat, 25 Jan 2014 18:14:40 +0100
Subject: [PATCH v5 19/23] drm/i2c: tda998x: remove the unused variable ca_i2s
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ca_i2s is only ever written to, but never read, so let's get rid of it.

Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 3e56302..1242da1 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -638,7 +638,7 @@ static void
 tda998x_configure_audio(struct tda998x_priv *priv,
 		struct drm_display_mode *mode, struct tda998x_encoder_params *p)
 {
-	uint8_t buf[6], clksel_aip, clksel_fs, ca_i2s, cts_n, adiv;
+	uint8_t buf[6], clksel_aip, clksel_fs, cts_n, adiv;
 	uint32_t n;
 
 	/* Enable audio ports */
@@ -652,7 +652,6 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 		clksel_aip = AIP_CLKSEL_AIP_SPDIF;
 		clksel_fs = AIP_CLKSEL_FS_FS64SPDIF;
 		cts_n = CTS_N_M(3) | CTS_N_K(3);
-		ca_i2s = 0;
 		break;
 
 	case AFMT_I2S:
@@ -660,7 +659,6 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 		clksel_aip = AIP_CLKSEL_AIP_I2S;
 		clksel_fs = AIP_CLKSEL_FS_ACLK;
 		cts_n = CTS_N_M(3) | CTS_N_K(3);
-		ca_i2s = CA_I2S_CA_I2S(0);
 		break;
 
 	default:
-- 
1.9.rc1

