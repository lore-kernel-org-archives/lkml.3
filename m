Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbaA2J0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:26:18 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:42885 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbaA2J0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:26:15 -0500
X-Mailbox-Line: From 7b0cc5b60f2ba36361e062d205785e80518447b7 Mon Sep 17 00:00:00 2001
Message-Id: <7b0cc5b60f2ba36361e062d205785e80518447b7.1390986083.git.moinejf@free.fr>
In-Reply-To: <cover.1390986082.git.moinejf@free.fr>
References: <cover.1390986082.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sat, 25 Jan 2014 18:14:39 +0100
Subject: [PATCH v5 21/23] drm/i2c: tda998x: change the frequence in the audio
 channel
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch sets the frequence as 'not indicated' instead of '48kHz'
and uses the asound values in the channel status definition.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index dba5b96..dedeb22 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -20,6 +20,7 @@
 #include <linux/hdmi.h>
 #include <linux/module.h>
 #include <linux/irq.h>
+#include <sound/asoundef.h>
 
 #include <drm/drmP.h>
 #include <drm/drm_crtc_helper.h>
@@ -710,10 +711,11 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 	reg_clear(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_RST_CTS);
 
 	/* Write the channel status */
-	buf[0] = 0x04;
+	buf[0] = IEC958_AES0_CON_NOT_COPYRIGHT;
 	buf[1] = 0x00;
-	buf[2] = 0x00;
-	buf[3] = 0xf1;
+	buf[2] = IEC958_AES3_CON_FS_NOTID;
+	buf[3] = IEC958_AES4_CON_ORIGFS_NOTID |
+			IEC958_AES4_CON_MAX_WORDLEN_24;
 	reg_write_range(priv, REG_CH_STAT_B(0), buf, 4);
 
 	tda998x_audio_mute(priv, true);
-- 
1.9.rc1

