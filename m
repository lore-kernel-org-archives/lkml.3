Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbaAILJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:09:45 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:57487 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191AbaAILJ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:09:28 -0500
Date: Thu, 9 Jan 2014 11:58:11 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/28] drm/i2c: tda998x: code cleanup
Message-ID: <20140109115811.779554cb@armhf>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c  | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 603f716..cd7ac58 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -335,7 +335,7 @@ cec_write(struct tda998x_priv *priv, uint16_t addr, uint8_t val)
 	uint8_t buf[] = {addr, val};
 	int ret;
 
-	ret = i2c_master_send(client, buf, ARRAY_SIZE(buf));
+	ret = i2c_master_send(client, buf, sizeof buf);
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
+	ret = i2c_master_send(client, buf, sizeof buf);
 	if (ret < 0)
 		dev_err(&client->dev, "Error %d writing to 0x%x\n", ret, reg);
 }
@@ -465,7 +466,7 @@ reg_write16(struct tda998x_priv *priv, uint16_t reg, uint16_t val)
 	if (ret < 0)
 		return;
 
-	ret = i2c_master_send(client, buf, ARRAY_SIZE(buf));
+	ret = i2c_master_send(client, buf, sizeof buf);
 	if (ret < 0)
 		dev_err(&client->dev, "Error %d writing to 0x%x\n", ret, reg);
 }
@@ -998,7 +999,7 @@ read_edid_block(struct drm_encoder *encoder, uint8_t *buf, int blk)
 
 	ret = reg_read_range(priv, REG_EDID_DATA_0, buf, EDID_LENGTH);
 	if (ret != EDID_LENGTH) {
-		dev_err(encoder->dev->dev, "failed to read edid block %d: %d",
+		dev_err(encoder->dev->dev, "failed to read edid block %d: %d\n",
 				blk, ret);
 		return ret;
 	}
@@ -1012,7 +1013,7 @@ static uint8_t *
 do_get_edid(struct drm_encoder *encoder)
 {
 	struct tda998x_priv *priv = to_tda998x_priv(encoder);
-	int j = 0, valid_extensions = 0;
+	int j, valid_extensions = 0;
 	uint8_t *block, *new;
 	bool print_bad_edid = drm_debug & DRM_UT_KMS;
 

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
