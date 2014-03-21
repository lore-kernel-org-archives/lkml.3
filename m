Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760796AbaCUKz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 06:55:28 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:39466 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760234AbaCUKzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 06:55:23 -0400
Date: Fri, 21 Mar 2014 11:55:41 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] drm/i2c: tda998x: Change the compatible strings
Message-ID: <20140321115541.01cbbb06@armhf>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tda998x driver accepts only 3 chips from the TDA998x family.
This patch changes the driver compatible strings to these chips.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
v2: change the subject to drm/i2c
This patch applies after
	drm/i2c: tda998x: Fix lack of required reg in DT documentation
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
