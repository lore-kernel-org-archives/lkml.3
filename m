Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbaAILRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:17:32 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:35869 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828AbaAILLQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:11:16 -0500
Date: Thu, 9 Jan 2014 12:04:28 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 14/28] drm/i2c: tda998x: get a better status of the
 connexion
Message-ID: <20140109120428.1ea7ec3a@armhf>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch refines the connexion status testing both bits RXSENS and
HPD of the CEC register giving the connexion level.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 2187d63..0cae820 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -1009,7 +1009,9 @@ tda998x_encoder_detect(struct drm_encoder *encoder,
 	struct tda998x_priv *priv = to_tda998x_priv(encoder);
 	uint8_t val = cec_read(priv, REG_CEC_RXSHPDLEV);
 
-	return (val & CEC_RXSHPDLEV_HPD) ? connector_status_connected :
+	return (val & (CEC_RXSHPDLEV_RXSENS | CEC_RXSHPDLEV_HPD)) ==
+				(CEC_RXSHPDLEV_RXSENS | CEC_RXSHPDLEV_HPD) ?
+			connector_status_connected :
 			connector_status_disconnected;
 }
 
-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
