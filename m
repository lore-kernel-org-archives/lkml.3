Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbaCYLHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 07:07:37 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:44937 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbaCYLHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 07:07:36 -0400
X-Mailbox-Line: From b3089323c2b69e7860fc4997f3b59e0b2db67314 Mon Sep 17 00:00:00 2001
From: Jean-Francois Moine <moinejf@free.fr>
Date: Tue, 25 Mar 2014 12:04:15 +0100
Subject: [PATCH v4] drm/i2c: tda998x: Deprecate "nxp,tda998x" in favour of
 "nxp,tda9989"
To: dri-devel@lists.freedesktop.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-Id: <20140325110725.6C4C682289@smtp6-g21.free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tda998x driver accepts only 3 chips from the TDA998x family.

To avoid confusion with the other TDA998x chips, this patch changes
the driver compatible string to "nxp,tda9989".

As the previous compatible string is not used in any DT,
no compatibility is offered.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
v4:
  - the armada and tilcdc DRM drivers are impacted
v3:
  - fix the I2C ID (the OF compatible is not used for such drivers)
  - define only one compatible (Sebastian Hesselbarth)
  - change the subject (Sebastian Hesselbarth)
v2:
  - change the subject to drm/i2c
This patch applies after
	drm/i2c: tda998x: Fix lack of required reg in DT documentation
---
 Documentation/devicetree/bindings/drm/i2c/tda998x.txt | 4 ++--
 drivers/gpu/drm/armada/armada_drv.c                   | 2 +-
 drivers/gpu/drm/i2c/tda998x_drv.c                     | 4 ++--
 drivers/gpu/drm/tilcdc/tilcdc_slave.c                 | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
index e9e4bce..9b41c7e 100644
--- a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
+++ b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
@@ -1,7 +1,7 @@
 Device-Tree bindings for the NXP TDA998x HDMI transmitter
 
 Required properties;
-  - compatible: must be "nxp,tda998x"
+  - compatible: must be "nxp,tda9989"
 
   - reg: I2C address
 
@@ -20,7 +20,7 @@ Optional properties:
 Example:
 
 	tda998x: hdmi-encoder {
-		compatible = "nxp,tda998x";
+		compatible = "nxp,tda9989";
 		reg = <0x70>;
 		interrupt-parent = <&gpio0>;
 		interrupts = <27 2>;		/* falling edge */
diff --git a/drivers/gpu/drm/armada/armada_drv.c b/drivers/gpu/drm/armada/armada_drv.c
index acf3a36..d949279 100644
--- a/drivers/gpu/drm/armada/armada_drv.c
+++ b/drivers/gpu/drm/armada/armada_drv.c
@@ -45,7 +45,7 @@ static const struct armada_drm_slave_config tda19988_config = {
 	.polled = DRM_CONNECTOR_POLL_CONNECT | DRM_CONNECTOR_POLL_DISCONNECT,
 	.interlace_allowed = true,
 	.info = {
-		.type = "tda998x",
+		.type = "tda9989",
 		.addr = 0x70,
 		.platform_data = &params,
 	},
diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 48af5ca..249ef84 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -1367,14 +1367,14 @@ fail:
 
 #ifdef CONFIG_OF
 static const struct of_device_id tda998x_dt_ids[] = {
-	{ .compatible = "nxp,tda998x", },
+	{ .compatible = "nxp,tda9989", },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, tda998x_dt_ids);
 #endif
 
 static struct i2c_device_id tda998x_ids[] = {
-	{ "tda998x", 0 },
+	{ "tda9989", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, tda998x_ids);
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_slave.c b/drivers/gpu/drm/tilcdc/tilcdc_slave.c
index 595068b..eadfed7 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_slave.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_slave.c
@@ -112,7 +112,7 @@ static const struct drm_encoder_helper_funcs slave_encoder_helper_funcs = {
 };
 
 static const struct i2c_board_info info = {
-		I2C_BOARD_INFO("tda998x", 0x70)
+		I2C_BOARD_INFO("tda9989", 0x70)
 };
 
 static struct drm_encoder *slave_encoder_create(struct drm_device *dev,
-- 
1.9.1

