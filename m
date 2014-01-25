Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaA2JX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:23:56 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:60055 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbaA2JXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:23:52 -0500
X-Mailbox-Line: From 355bdd8697d6f427a45915c71e1649ad35a00538 Mon Sep 17 00:00:00 2001
Message-Id: <355bdd8697d6f427a45915c71e1649ad35a00538.1390986083.git.moinejf@free.fr>
In-Reply-To: <cover.1390986082.git.moinejf@free.fr>
References: <cover.1390986082.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sat, 25 Jan 2014 18:14:44 +0100
Subject: [PATCH v5 07/23] drm/i2c: tda998x: fix bad value in the AIF
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AIF has an uninitialized byte. This patch clears the whole buffer
before filling it.

Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index b688801..16f2473 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -551,10 +551,10 @@ tda998x_write_aif(struct tda998x_priv *priv, struct tda998x_encoder_params *p)
 {
 	uint8_t buf[PB(5) + 1];
 
+	memset(buf, 0, sizeof(buf));
 	buf[HB(0)] = 0x84;
 	buf[HB(1)] = 0x01;
 	buf[HB(2)] = 10;
-	buf[PB(0)] = 0;
 	buf[PB(1)] = p->audio_frame[1] & 0x07; /* CC */
 	buf[PB(2)] = p->audio_frame[2] & 0x1c; /* SF */
 	buf[PB(4)] = p->audio_frame[4];
-- 
1.9.rc1

