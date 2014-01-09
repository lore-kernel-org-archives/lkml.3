Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbaAILOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:14:41 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:39648 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755822AbaAILMO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:12:14 -0500
Date: Thu, 9 Jan 2014 12:06:07 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 20/28] drm/i2c: tda998x: move the TBG_CNTRL_0 register
 setting
Message-ID: <20140109120607.6a33bee5@armhf>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the comment, the TBG_CNTRL_0 register must be set at the
end of the mode change sequence.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 7dbbc6b..864b9f5 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -1073,9 +1073,6 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 		}
 	}
 
-	/* must be last register set: */
-	reg_clear(priv, REG_TBG_CNTRL_0, TBG_CNTRL_0_SYNC_ONCE);
-
 	/*
 	 * Always generate sync polarity relative to input sync and
 	 * revert input stage toggled sync at output stage
@@ -1100,6 +1097,9 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 		if (priv->audio_type)
 			tda998x_configure_audio(priv, mode);
 	}
+
+	/* must be last register set: */
+	reg_write(priv, REG_TBG_CNTRL_0, 0);
 }
 
 static enum drm_connector_status
-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
