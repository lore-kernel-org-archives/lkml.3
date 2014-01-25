Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbaAYRPb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 12:15:31 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:44212 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794AbaAYRPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 12:15:25 -0500
Date: Sat, 25 Jan 2014 18:14:37 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v4 17/24] drm/i2c: tda998x: fix the ENABLE_SPACE register
Message-ID: <20140125181437.07f7860f@armhf>
In-Reply-To: <cover.1390646891.git.moinejf@free.fr>
References: <cover.1390646891.git.moinejf@free.fr>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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
index 5a67b6f..e172f11 100644
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
1.8.5.3

