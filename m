Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbaAILNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:13:38 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:43701 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbaAILNV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:13:21 -0500
Date: Thu, 9 Jan 2014 12:07:35 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 27/28] drm/i2c: tda998x: adjust the audio clock divider
 for S/PDIF
Message-ID: <20140109120735.7ee3d672@armhf>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The S/PDIF input asks for a greater audio clock divider.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index d3b3f3a..67d7450 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -757,6 +757,10 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 					AIP_CNTRL_0_ACR_MAN);
 	reg_write(priv, REG_CTS_N, cts_n);
 
+	/* S/PDIF asks for a large divider */
+	if (priv->audio_type == (AFMT_SPDIF | AUDIO_ACTIVE))
+		adiv = AUDIO_DIV_SERCLK_32;
+
 	/*
 	 * Audio input somehow depends on HDMI line rate which is
 	 * related to pixclk. Testing showed that modes with pixclk
@@ -764,7 +768,7 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 	 * There is no detailed info in the datasheet, so we just
 	 * assume 100MHz requires larger divider.
 	 */
-	if (mode->clock > 100000)
+	else if (mode->clock > 100000)
 		adiv = AUDIO_DIV_SERCLK_16;
 	else
 		adiv = AUDIO_DIV_SERCLK_8;
-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
