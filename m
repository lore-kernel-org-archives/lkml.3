Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbaA2J0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:26:38 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:44383 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbaA2J0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:26:35 -0500
X-Mailbox-Line: From 46333b5b18b676ca298a817e70d982a7b13e2965 Mon Sep 17 00:00:00 2001
Message-Id: <46333b5b18b676ca298a817e70d982a7b13e2965.1390986083.git.moinejf@free.fr>
In-Reply-To: <cover.1390986082.git.moinejf@free.fr>
References: <cover.1390986082.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sat, 25 Jan 2014 18:14:36 +0100
Subject: [PATCH v5 23/23] drm/i2c: tda998x: adjust the audio clock divider for
 S/PDIF
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
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
index 4f1a047..2f97290 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -680,10 +680,14 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 	 * There is no detailed info in the datasheet, so we just
 	 * assume 100MHz requires larger divider.
 	 */
+	adiv = AUDIO_DIV_SERCLK_8;
 	if (mode->clock > 100000)
-		adiv = AUDIO_DIV_SERCLK_16;
-	else
-		adiv = AUDIO_DIV_SERCLK_8;
+		adiv++;			/* AUDIO_DIV_SERCLK_16 */
+
+	/* S/PDIF asks for a larger divider */
+	if (p->audio_format == AFMT_SPDIF)
+		adiv++;			/* AUDIO_DIV_SERCLK_16 or _32 */
+
 	reg_write(priv, REG_AUDIO_DIV, adiv);
 
 	/*
-- 
1.9.rc1

