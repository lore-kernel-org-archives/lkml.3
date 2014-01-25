Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaA2JXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:23:35 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:58354 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbaA2JXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:23:32 -0500
X-Mailbox-Line: From d99de82d4aa42708d97a168c244558577719db96 Mon Sep 17 00:00:00 2001
Message-Id: <d99de82d4aa42708d97a168c244558577719db96.1390986083.git.moinejf@free.fr>
In-Reply-To: <cover.1390986082.git.moinejf@free.fr>
References: <cover.1390986082.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sat, 25 Jan 2014 18:14:44 +0100
Subject: [PATCH v5 05/23] drm/i2c: tda998x: don't freeze the system at audio
 startup time
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prevents the system to be freezed at audio startup time,
replacing mdelay by msleep.

Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index fbd7937..96b5966 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -678,7 +678,7 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 	reg_write_range(priv, REG_CH_STAT_B(0), buf, 4);
 
 	tda998x_audio_mute(priv, true);
-	mdelay(20);
+	msleep(20);
 	tda998x_audio_mute(priv, false);
 
 	/* Write the audio information packet */
-- 
1.9.rc1

