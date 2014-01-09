Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaAILL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:11:56 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:37755 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755808AbaAILLp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:11:45 -0500
Date: Thu, 9 Jan 2014 12:05:13 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 17/28] drm/i2c: tda998x: set the repeat PLL value in
 range 0..3
Message-ID: <20140109120513.0965ddad@armhf>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index f60aef9..8a7d8a2 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -220,7 +220,7 @@ struct tda998x_priv {
 # define PLL_SERIAL_1_SRL_IZ(x)   (((x) & 3) << 1)
 # define PLL_SERIAL_1_SRL_MAN_IZ  (1 << 6)
 #define REG_PLL_SERIAL_2          REG(0x02, 0x01)     /* read/write */
-# define PLL_SERIAL_2_SRL_NOSC(x) (((x) & 3) << 0)
+# define PLL_SERIAL_2_SRL_NOSC(x) ((x) << 0)
 # define PLL_SERIAL_2_SRL_PR(x)   (((x) & 0xf) << 4)
 #define REG_PLL_SERIAL_3          REG(0x02, 0x02)     /* read/write */
 # define PLL_SERIAL_3_SRL_CCIR    (1 << 0)
@@ -972,6 +972,11 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
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
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
