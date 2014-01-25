Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbaA2JXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:23:14 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:56680 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbaA2JXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:23:12 -0500
X-Mailbox-Line: From a099c45e70ce9ffc09be2cff86f82f46948f0baa Mon Sep 17 00:00:00 2001
Message-Id: <a099c45e70ce9ffc09be2cff86f82f46948f0baa.1390986082.git.moinejf@free.fr>
In-Reply-To: <cover.1390986082.git.moinejf@free.fr>
References: <cover.1390986082.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sat, 25 Jan 2014 18:14:46 +0100
Subject: [PATCH v5 03/23] drm/i2c: tda998x: code cleanup
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch:
- replaces ARRAY_SIZE() by sizeof() when a number of bytes is needed,
- adds a linefeed in an error message and
- removes an useless variable setting.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 11f0607..320b37f 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -335,7 +335,7 @@ cec_write(struct tda998x_priv *priv, uint16_t addr, uint8_t val)
 	uint8_t buf[] = {addr, val};
 	int ret;
 
-	ret = i2c_master_send(client, buf, ARRAY_SIZE(buf));
+	ret = i2c_master_send(client, buf, sizeof(buf));
 	if (ret < 0)
 		dev_err(&client->dev, "Error %d writing to cec:0x%x\n", ret, addr);
 }
@@ -372,7 +372,8 @@ set_page(struct tda998x_priv *priv, uint16_t reg)
 		};
 		int ret = i2c_master_send(client, buf, sizeof(buf));
 		if (ret < 0) {
-			dev_err(&client->dev, "Error %d writing to REG_CURPAGE\n", ret);
+			dev_err(&client->dev, "setpage %04x err %d\n",
+					reg, ret);
 			return ret;
 		}
 
@@ -449,7 +450,7 @@ reg_write(struct tda998x_priv *priv, uint16_t reg, uint8_t val)
 	if (ret < 0)
 		return;
 
-	ret = i2c_master_send(client, buf, ARRAY_SIZE(buf));
+	ret = i2c_master_send(client, buf, sizeof(buf));
 	if (ret < 0)
 		dev_err(&client->dev, "Error %d writing to 0x%x\n", ret, reg);
 }
@@ -465,7 +466,7 @@ reg_write16(struct tda998x_priv *priv, uint16_t reg, uint16_t val)
 	if (ret < 0)
 		return;
 
-	ret = i2c_master_send(client, buf, ARRAY_SIZE(buf));
+	ret = i2c_master_send(client, buf, sizeof(buf));
 	if (ret < 0)
 		dev_err(&client->dev, "Error %d writing to 0x%x\n", ret, reg);
 }
@@ -1006,7 +1007,7 @@ read_edid_block(struct drm_encoder *encoder, uint8_t *buf, int blk)
 
 	ret = reg_read_range(priv, REG_EDID_DATA_0, buf, EDID_LENGTH);
 	if (ret != EDID_LENGTH) {
-		dev_err(encoder->dev->dev, "failed to read edid block %d: %d",
+		dev_err(encoder->dev->dev, "failed to read edid block %d: %d\n",
 				blk, ret);
 		return ret;
 	}
@@ -1020,7 +1021,7 @@ static uint8_t *
 do_get_edid(struct drm_encoder *encoder)
 {
 	struct tda998x_priv *priv = to_tda998x_priv(encoder);
-	int j = 0, valid_extensions = 0;
+	int j, valid_extensions = 0;
 	uint8_t *block, *new;
 	bool print_bad_edid = drm_debug & DRM_UT_KMS;
 
-- 
1.9.rc1

