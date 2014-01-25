Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaA2JZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:25:41 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:40109 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbaA2JZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:25:35 -0500
X-Mailbox-Line: From d4ba259762605793aee726b5e33dcad6a8bd4777 Mon Sep 17 00:00:00 2001
Message-Id: <d4ba259762605793aee726b5e33dcad6a8bd4777.1390986083.git.moinejf@free.fr>
In-Reply-To: <cover.1390986082.git.moinejf@free.fr>
References: <cover.1390986082.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sat, 25 Jan 2014 18:14:36 +0100
Subject: [PATCH v5 17/23] drm/i2c: tda998x: set the PLL division factor in
 range 0..3
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The predivider division factor of the register PLL_SERIAL_2 is in the
range 0..3, the value 0 being used for a division by 1.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 36e95b2..873e1e9 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -214,7 +214,7 @@ struct tda998x_priv {
 # define PLL_SERIAL_1_SRL_IZ(x)   (((x) & 3) << 1)
 # define PLL_SERIAL_1_SRL_MAN_IZ  (1 << 6)
 #define REG_PLL_SERIAL_2          REG(0x02, 0x01)     /* read/write */
-# define PLL_SERIAL_2_SRL_NOSC(x) (((x) & 3) << 0)
+# define PLL_SERIAL_2_SRL_NOSC(x) ((x) << 0)
 # define PLL_SERIAL_2_SRL_PR(x)   (((x) & 0xf) << 4)
 #define REG_PLL_SERIAL_3          REG(0x02, 0x02)     /* read/write */
 # define PLL_SERIAL_3_SRL_CCIR    (1 << 0)
@@ -886,6 +886,11 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 	}
 
 	div = 148500 / mode->clock;
+	if (div != 0) {
+		div--;
+		if (div > 3)
+			div = 3;
+	}
 
 	/* mute the audio FIFO: */
 	reg_set(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_RST_FIFO);
-- 
1.9.rc1

