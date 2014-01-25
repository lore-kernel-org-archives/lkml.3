Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaA2JYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:24:25 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:34215 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbaA2JYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:24:23 -0500
X-Mailbox-Line: From 90b017f1731d86562af90fd3416197261d193cd1 Mon Sep 17 00:00:00 2001
Message-Id: <90b017f1731d86562af90fd3416197261d193cd1.1390986083.git.moinejf@free.fr>
In-Reply-To: <cover.1390986082.git.moinejf@free.fr>
References: <cover.1390986082.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sat, 25 Jan 2014 18:14:42 +0100
Subject: [PATCH v5 10/23] drm/i2c: tda998x: free the CEC device on
 encoder_destroy
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cec i2c device is created in tda998x_encoder_init() when the DRM
driver starts.
This patch frees it when the DRM driver is unloaded.

Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index d6d0e80..7d8bc22 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -1124,6 +1124,8 @@ tda998x_encoder_destroy(struct drm_encoder *encoder)
 {
 	struct tda998x_priv *priv = to_tda998x_priv(encoder);
 	drm_i2c_encoder_destroy(encoder);
+	if (priv->cec)
+		i2c_unregister_device(priv->cec);
 	kfree(priv);
 }
 
-- 
1.9.rc1

