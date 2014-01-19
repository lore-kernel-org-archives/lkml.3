Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbaASTAP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 14:00:15 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:57016 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbaASTAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 14:00:12 -0500
Date: Sun, 19 Jan 2014 19:58:38 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v3 04/24] drm/i2c: tda998x: change probe message origin
Message-ID: <20140119195838.0910ade2@armhf>
In-Reply-To: <cover.1390153344.git.moinejf@free.fr>
References: <cover.1390153344.git.moinejf@free.fr>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On probe, a message giving the TDA chip version seems to come from the
DRM driver:

	armada-drm armada-510-drm: found TDA19988

This patch changes the originator of the message to the TDA driver:

	tda998x 0-0070: found TDA19988

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 320b37f..fbd7937 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -1195,12 +1195,21 @@ tda998x_encoder_init(struct i2c_client *client,
 	priv->rev &= ~0x30; /* not-hdcp and not-scalar bit */
 
 	switch (priv->rev) {
-	case TDA9989N2:  dev_info(dev->dev, "found TDA9989 n2");  break;
-	case TDA19989:   dev_info(dev->dev, "found TDA19989");    break;
-	case TDA19989N2: dev_info(dev->dev, "found TDA19989 n2"); break;
-	case TDA19988:   dev_info(dev->dev, "found TDA19988");    break;
+	case TDA9989N2:
+		dev_info(&client->dev, "found TDA9989 n2");
+		break;
+	case TDA19989:
+		dev_info(&client->dev, "found TDA19989");
+		break;
+	case TDA19989N2:
+		dev_info(&client->dev, "found TDA19989 n2");
+		break;
+	case TDA19988:
+		dev_info(&client->dev, "found TDA19988");
+		break;
 	default:
-		DBG("found unsupported device: %04x", priv->rev);
+		dev_err(&client->dev, "found unsupported device: %04x\n",
+			priv->rev);
 		goto fail;
 	}
 
-- 
1.8.5.3

