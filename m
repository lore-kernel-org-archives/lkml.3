Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbaAILM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:12:27 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:38428 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755885AbaAILLz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:11:55 -0500
Date: Thu, 9 Jan 2014 12:05:26 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 18/28] drm/i2c: tda998x: fix the ENABLE_SPACE register
Message-ID: <20140109120526.6035167d@armhf>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the ENABLE_SPACE register, the value of which was
inverted.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
  drivers/gpu/drm/i2c/tda998x_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 8a7d8a2..192ddd2 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -1069,7 +1069,7 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 
 		if (priv->rev == TDA19988) {
 			/* let incoming pixels fill the active space (if any) */
-			reg_write(priv, REG_ENABLE_SPACE, 0x01);
+			reg_write(priv, REG_ENABLE_SPACE, 0x00);
 		}
 	}
 
-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
