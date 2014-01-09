Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbaAILPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:15:48 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:39009 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269AbaAILME convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:12:04 -0500
Date: Thu, 9 Jan 2014 12:05:43 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 19/28] drm/i2c: tda998x: fix the value of the TBG_CNTRL_1
 register
Message-ID: <20140109120543.1e3c9581@armhf>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the 'toggle flag enable' bit of the TBG_CNTRL_1
register which was set when no toggle was needed.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 192ddd2..7dbbc6b 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -1080,11 +1080,11 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 	 * Always generate sync polarity relative to input sync and
 	 * revert input stage toggled sync at output stage
 	 */
-	reg = TBG_CNTRL_1_DWIN_DIS | TBG_CNTRL_1_TGL_EN;
+	reg = TBG_CNTRL_1_DWIN_DIS;
 	if (mode->flags & DRM_MODE_FLAG_NHSYNC)
-		reg |= TBG_CNTRL_1_H_TGL;
+		reg |= TBG_CNTRL_1_H_TGL | TBG_CNTRL_1_TGL_EN;
 	if (mode->flags & DRM_MODE_FLAG_NVSYNC)
-		reg |= TBG_CNTRL_1_V_TGL;
+		reg |= TBG_CNTRL_1_V_TGL | TBG_CNTRL_1_TGL_EN;
 	reg_write(priv, REG_TBG_CNTRL_1, reg);
 
 	/* Only setup the info frames if the sink is HDMI */
-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
