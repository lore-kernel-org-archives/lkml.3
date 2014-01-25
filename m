Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbaA2JZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:25:28 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:39348 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbaA2JZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:25:24 -0500
X-Mailbox-Line: From 5bfabf21196699bf011d7f0cf706315c9da7394b Mon Sep 17 00:00:00 2001
Message-Id: <5bfabf21196699bf011d7f0cf706315c9da7394b.1390986083.git.moinejf@free.fr>
In-Reply-To: <cover.1390986082.git.moinejf@free.fr>
References: <cover.1390986082.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sat, 25 Jan 2014 18:14:37 +0100
Subject: [PATCH v5 16/23] drm/i2c: tda998x: fix the ENABLE_SPACE register
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
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
index 7fab61a..36e95b2 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -965,7 +965,7 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 
 	if (priv->rev == TDA19988) {
 		/* let incoming pixels fill the active space (if any) */
-		reg_write(priv, REG_ENABLE_SPACE, 0x01);
+		reg_write(priv, REG_ENABLE_SPACE, 0x00);
 	}
 
 	/*
-- 
1.9.rc1

