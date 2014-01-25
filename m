Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbaAYRPJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 12:15:09 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:42959 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbaAYRPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 12:15:07 -0500
Date: Sat, 25 Jan 2014 18:14:36 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v4 24/24] drm/i2c: tda998x: adjust the audio clock divider
 for S/PDIF
Message-ID: <20140125181436.5c443251@armhf>
In-Reply-To: <cover.1390646891.git.moinejf@free.fr>
References: <cover.1390646891.git.moinejf@free.fr>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to some tests on the Cubox (Marvell Armada 510 + TDA19988),
the S/PDIF input asks for a greater audio clock divider.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index b4827c0..e4dfcb4 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -679,10 +679,14 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 	 * There is no detailed info in the datasheet, so we just
 	 * assume 100MHz requires larger divider.
 	 */
+	adiv = AUDIO_DIV_SERCLK_8;
 	if (mode->clock > 100000)
-		adiv = AUDIO_DIV_SERCLK_16;
-	else
-		adiv = AUDIO_DIV_SERCLK_8;
+		adiv++;			/* AUDIO_DIV_SERCLK_8 */
+
+	/* S/PDIF asks for a larger divider */
+	if (p->audio_format == AFMT_SPDIF)
+		adiv++;			/* AUDIO_DIV_SERCLK_16 or _32 */
+
 	reg_write(priv, REG_AUDIO_DIV, adiv);
 
 	/*
-- 
1.8.5.3
