Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbaASTEL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 14:04:11 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:57576 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbaASTEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 14:04:07 -0500
Date: Sun, 19 Jan 2014 19:58:48 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v3 24/24] drm/i2c: tda998x: adjust the audio clock divider
 for S/PDIF
Message-ID: <20140119195848.0bede2c3@armhf>
In-Reply-To: <cover.1390153344.git.moinejf@free.fr>
References: <cover.1390153344.git.moinejf@free.fr>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The S/PDIF input asks for a greater audio clock divider.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 0716a75..06c484d 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -707,6 +707,10 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 	reg_write(priv, REG_CTS_N, cts_n);
 	reg_write(priv, REG_ENA_ACLK, aclk);
 
+	/* S/PDIF asks for a large divider */
+	if (priv->audio_format == AFMT_SPDIF)
+		adiv = AUDIO_DIV_SERCLK_32;
+
 	/*
 	 * Audio input somehow depends on HDMI line rate which is
 	 * related to pixclk. Testing showed that modes with pixclk
@@ -714,7 +718,7 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 	 * There is no detailed info in the datasheet, so we just
 	 * assume 100MHz requires larger divider.
 	 */
-	if (mode->clock > 100000)
+	else if (mode->clock > 100000)
 		adiv = AUDIO_DIV_SERCLK_16;
 	else
 		adiv = AUDIO_DIV_SERCLK_8;
-- 
1.8.5.3
