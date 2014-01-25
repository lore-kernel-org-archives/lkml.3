Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaA2JXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:23:45 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:59204 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbaA2JXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:23:42 -0500
X-Mailbox-Line: From b680d727b2347c9724b599b6e809b412f3725aaf Mon Sep 17 00:00:00 2001
Message-Id: <b680d727b2347c9724b599b6e809b412f3725aaf.1390986083.git.moinejf@free.fr>
In-Reply-To: <cover.1390986082.git.moinejf@free.fr>
References: <cover.1390986082.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sat, 25 Jan 2014 18:14:45 +0100
Subject: [PATCH v5 06/23] drm/i2c: tda998x: force the page register at startup
 time
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch forces the page register to be set on the first I/O operation.

Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 96b5966..b688801 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -1170,7 +1170,7 @@ tda998x_encoder_init(struct i2c_client *client,
 	priv->vip_cntrl_1 = VIP_CNTRL_1_SWAP_C(0) | VIP_CNTRL_1_SWAP_D(1);
 	priv->vip_cntrl_2 = VIP_CNTRL_2_SWAP_E(4) | VIP_CNTRL_2_SWAP_F(5);
 
-	priv->current_page = 0;
+	priv->current_page = 0xff;
 	priv->hdmi = client;
 	priv->cec = i2c_new_dummy(client->adapter, 0x34);
 	priv->dpms = DRM_MODE_DPMS_OFF;
-- 
1.9.rc1

