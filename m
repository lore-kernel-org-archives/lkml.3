Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933373Ab3ECGw0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:52:26 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:51303 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab3ECGwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:52:24 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Arnd Bergmann <arnd@arndb.de>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org
Subject: [PATCH RFC v3] media: i2c: mt9p031: add OF support
Date: Fri,  3 May 2013 12:21:59 +0530
Message-Id: <1367563919-2880-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

add OF support for the mt9p031 sensor driver.
Alongside this patch sorts the header inclusion alphabetically.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: davinci-linux-open-source@linux.davincidsp.com
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 Changes for v2:
 1: Used '-' instead of '_' for device properties.
 2: Specified gpio reset pin as phandle in device node.
 3: Handle platform data properly even if kernel is compiled with
    devicetree support.
 4: Used dev_* for messages in drivers instead of pr_*.
 5: Changed compatible property to "aptina,mt9p031" and "aptina,mt9p031m".
 6: Sorted the header inclusion alphabetically and fixed some minor code nits.

Changes for v3:
 1: Dropped check if gpio-reset is valid.
 2: Fixed some code nits.
 3: Included a reference to the V4L2 DT bindings documentation.

 .../devicetree/bindings/media/i2c/mt9p031.txt      |   40 +++++++++++++
 drivers/media/i2c/mt9p031.c                        |   60 +++++++++++++++++++-
 2 files changed, 97 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/mt9p031.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/mt9p031.txt b/Documentation/devicetree/bindings/media/i2c/mt9p031.txt
new file mode 100644
index 0000000..e740541
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/mt9p031.txt
@@ -0,0 +1,40 @@
+* Aptina 1/2.5-Inch 5Mp CMOS Digital Image Sensor
+
+The Aptina MT9P031 is a 1/2.5-inch CMOS active pixel digital image sensor with
+an active array size of 2592H x 1944V. It is programmable through a simple
+two-wire serial interface.
+
+Required Properties :
+- compatible : value should be either one among the following
+	(a) "aptina,mt9p031" for mt9p031 sensor
+	(b) "aptina,mt9p031m" for mt9p031m sensor
+
+- input-clock-frequency : Input clock frequency.
+
+- pixel-clock-frequency : Pixel clock frequency.
+
+Optional Properties :
+-gpio-reset: Chip reset GPIO
+
+For further reading of port node refer Documentation/devicetree/bindings/media/
+video-interfaces.txt.
+
+Example:
+
+	i2c0@1c22000 {
+		...
+		...
+		mt9p031@5d {
+			compatible = "aptina,mt9p031";
+			reg = <0x5d>;
+			gpio-reset = <&gpio3 30 0>;
+
+			port {
+				mt9p031_1: endpoint {
+					input-clock-frequency = <6000000>;
+					pixel-clock-frequency = <96000000>;
+				};
+			};
+		};
+		...
+	};
diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index 28cf95b..4514f8f 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -16,9 +16,11 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/gpio.h>
-#include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/log2.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/of_gpio.h>
 #include <linux/pm.h>
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
@@ -28,6 +30,7 @@
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-of.h>
 #include <media/v4l2-subdev.h>
 
 #include "aptina-pll.h"
@@ -928,10 +931,50 @@ static const struct v4l2_subdev_internal_ops mt9p031_subdev_internal_ops = {
  * Driver initialization and probing
  */
 
+static struct mt9p031_platform_data *
+mt9p031_get_pdata(struct i2c_client *client)
+{
+	struct device_node *np;
+	struct mt9p031_platform_data *pdata;
+
+	if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
+		return client->dev.platform_data;
+
+	np = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
+	if (!np)
+		return NULL;
+
+	pdata = devm_kzalloc(&client->dev, sizeof(struct mt9p031_platform_data),
+			     GFP_KERNEL);
+	if (!pdata)
+		return NULL;
+
+	pdata->reset = of_get_named_gpio(client->dev.of_node, "gpio-reset", 0);
+	of_property_read_u32(np, "input-clock-frequency", &pdata->ext_freq);
+	of_property_read_u32(np, "pixel-clock-frequency", &pdata->target_freq);
+
+	return pdata;
+}
+
+#if IS_ENABLED(CONFIG_OF)
+static const struct of_device_id mt9p031_of_match[] = {
+	{
+		.compatible = "aptina,mt9p031",
+		.data = (void *)MT9P031_MODEL_COLOR,
+	}, {
+		.compatible = "aptina,mt9p031m",
+		.data = (void *)MT9P031_MODEL_MONOCHROME,
+	}, {
+		/* sentinel */
+	},
+};
+MODULE_DEVICE_TABLE(of, mt9p031_of_match);
+#endif
+
 static int mt9p031_probe(struct i2c_client *client,
 			 const struct i2c_device_id *did)
 {
-	struct mt9p031_platform_data *pdata = client->dev.platform_data;
+	struct mt9p031_platform_data *pdata = mt9p031_get_pdata(client);
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
 	struct mt9p031 *mt9p031;
 	unsigned int i;
@@ -955,7 +998,17 @@ static int mt9p031_probe(struct i2c_client *client,
 	mt9p031->pdata = pdata;
 	mt9p031->output_control	= MT9P031_OUTPUT_CONTROL_DEF;
 	mt9p031->mode2 = MT9P031_READ_MODE_2_ROW_BLC;
-	mt9p031->model = did->driver_data;
+
+	if (!client->dev.of_node) {
+		mt9p031->model = (enum mt9p031_model)did->driver_data;
+	} else {
+		const struct of_device_id *of_id;
+
+		of_id = of_match_device(of_match_ptr(mt9p031_of_match),
+					&client->dev);
+		if (of_id)
+			mt9p031->model = (enum mt9p031_model)of_id->data;
+	}
 	mt9p031->reset = -1;
 
 	mt9p031->vaa = devm_regulator_get(&client->dev, "vaa");
@@ -1072,6 +1125,7 @@ MODULE_DEVICE_TABLE(i2c, mt9p031_id);
 
 static struct i2c_driver mt9p031_i2c_driver = {
 	.driver = {
+		.of_match_table = of_match_ptr(mt9p031_of_match),
 		.name = "mt9p031",
 	},
 	.probe          = mt9p031_probe,
-- 
1.7.4.1

