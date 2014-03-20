Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759608AbaCTRcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:32:55 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:45746 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759286AbaCTRcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:32:53 -0400
X-Mailbox-Line: From b9c741180289468654316b4552fb0f6d42836005 Mon Sep 17 00:00:00 2001
From: Jean-Francois Moine <moinejf@free.fr>
Date: Thu, 20 Mar 2014 18:15:13 +0100
Subject: [PATCH] ASoC: tda998x: Change the compatible strings
To: Russell King - ARM <linux@arm.linux.org.uk>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org
Cc: Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Message-Id: <20140320173240.A1152A61AD@smtp3-g21.free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tda998x driver accepts 3 chips only from the TDA998x family.
This patch changes the driver to accept only these chips.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 Documentation/devicetree/bindings/drm/i2c/tda998x.txt | 4 ++--
 drivers/gpu/drm/i2c/tda998x_drv.c                     | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
index fc7effa..e3f3d65 100644
--- a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
+++ b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
@@ -1,7 +1,7 @@
 Device-Tree bindings for the NXP TDA998x HDMI transmitter
 
 Required properties;
-  - compatible: must be "nxp,tda998x"
+  - compatible: may be "nxp,tda9989", "nxp,tda19988" or "nxp,tda19989"
 
   - reg: I2C address
 
@@ -20,7 +20,7 @@ Optional properties:
 Example:
 
 	tda998x: hdmi-encoder {
-		compatible = "nxp,tda998x";
+		compatible = "nxp,tda19988";
 		reg = <0x70>;
 		interrupt-parent = <&gpio0>;
 		interrupts = <27 2>;		/* falling edge */
diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 48af5ca..fd6751c 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -1367,7 +1367,9 @@ fail:
 
 #ifdef CONFIG_OF
 static const struct of_device_id tda998x_dt_ids[] = {
-	{ .compatible = "nxp,tda998x", },
+	{ .compatible = "nxp,tda9989", },
+	{ .compatible = "nxp,tda19988", },
+	{ .compatible = "nxp,tda19989", },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, tda998x_dt_ids);
-- 
1.9.1

