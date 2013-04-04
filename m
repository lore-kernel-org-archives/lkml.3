Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762959Ab3DDQRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:17:40 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:54250 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762940Ab3DDQRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:17:37 -0400
X-AuditID: cbfee61b-b7f076d0000034b6-83-515da7a0c0f7
From: Tomasz Figa <t.figa@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        kyungmin.park@samsung.com, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, myungjoo.ham@samsung.com,
        kgene.kim@samsung.com, Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH 2/2] regulator: max8952: Add Device Tree support
Date: Thu, 04 Apr 2013 18:17:20 +0200
Message-id: <1365092240-8956-3-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1365092240-8956-1-git-send-email-t.figa@samsung.com>
References: <1365092240-8956-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHLMWRmVeSWpSXmKPExsVy+t9jAd0Fy2MDDY61qVn8m32KzeLA7Ies
	Fr0LrrJZnG16w25xedccNosZ5/cxWTRtn8BucbtxBZvF+hmvWRw4Pc7PWMjo8XLibzaPvi2r
	GD2O39jO5PF5k1wAaxSXTUpqTmZZapG+XQJXxpS/m5gKzhhUdJ29xNzA+Fq9i5GTQ0LAROL5
	of/MELaYxIV769m6GLk4hAQWMUpsuDUNyuliknj8YhEjSBWbgJrE54ZHbCC2iICCxObeZ6wg
	RcwC7xklbt3qAysSFnCQ2HB3BSuIzSKgKvFp2y8WEJtXwFHi1ZYmRoh18hJP7/eBDeIUcJK4
	uuUIUD0H0DZHia/Pqycw8i5gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERxqz6R3MK5q
	sDjEKMDBqMTDm9EXGyjEmlhWXJl7iFGCg1lJhPdoC1CINyWxsiq1KD++qDQntfgQozQHi5I4
	78FW60AhgfTEktTs1NSC1CKYLBMHp1QD49x/Vwoy00NrhdxnPJYN9/t3R9Yp8HHOr5sibBKB
	6iW6jTZXVGMEOFauiOe1ljgz6drbOU68iqUasmKFdhN26ipnP2ZIPTxNWvkP1z22P1n7Yp6G
	8a05qlUkxWgR0eSyJ3jZlpoJefdU3/GFt12f82Z9R9OVksO9/1dlJW1/arD0fmDi2R8/lFiK
	MxINtZiLihMBDHS/lTECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Device Tree support to max8952 regulator driver.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/regulator/max8952.txt      | 52 ++++++++++++++++
 drivers/regulator/max8952.c                        | 70 ++++++++++++++++++++++
 include/linux/regulator/max8952.h                  |  8 +--
 3 files changed, 126 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/max8952.txt

diff --git a/Documentation/devicetree/bindings/regulator/max8952.txt b/Documentation/devicetree/bindings/regulator/max8952.txt
new file mode 100644
index 0000000..866fcdd
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/max8952.txt
@@ -0,0 +1,52 @@
+Maxim MAX8952 voltage regulator
+
+Required properties:
+- compatible: must be equal to "maxim,max8952"
+- reg: I2C slave address, usually 0x60
+- max8952,dvs-mode-microvolt: array of 4 integer values defining DVS voltages
+  in microvolts. All values must be from range <770000, 1400000>
+- any required generic properties defined in regulator.txt
+
+Optional properties:
+- max8952,vid-gpios: array of two GPIO pins used for DVS voltage selection
+- max8952,en-gpio: GPIO used to control enable status of regulator
+- max8952,default-mode: index of default DVS voltage, from <0, 3> range
+- max8952,sync-freq: sync frequency, must be one of following values:
+    - 0: 26 MHz
+    - 1: 13 MHz
+    - 2: 19.2 MHz
+  Defaults to 26 MHz if not specified.
+- max8952,ramp-speed: voltage ramp speed, must be one of following values:
+    - 0: 32mV/us
+    - 1: 16mV/us
+    - 2: 8mV/us
+    - 3: 4mV/us
+    - 4: 2mV/us
+    - 5: 1mV/us
+    - 6: 0.5mV/us
+    - 7: 0.25mV/us
+  Defaults to 32mV/us if not specified.
+- any available generic properties defined in regulator.txt
+
+Example:
+
+	vdd_arm_reg: pmic@60 {
+		compatible = "maxim,max8952";
+		reg = <0x60>;
+
+		/* max8952-specific properties */
+		max8952,vid-gpios = <&gpx0 3 0>, <&gpx0 4 0>;
+		max8952,en-gpio = <&gpx0 1 0>;
+		max8952,default-mode = <0>;
+		max8952,dvs-mode-microvolt = <1250000>, <1200000>,
+						<1050000>, <950000>;
+		max8952,sync-freq = <0>;
+		max8952,ramp-speed = <0>;
+
+		/* generic regulator properties */
+		regulator-name = "vdd_arm";
+		regulator-min-microvolt = <770000>;
+		regulator-max-microvolt = <1400000>;
+		regulator-always-on;
+		regulator-boot-on;
+	};
diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index 100b917..4259c78 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -28,6 +28,9 @@
 #include <linux/regulator/max8952.h>
 #include <linux/gpio.h>
 #include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
+#include <linux/regulator/of_regulator.h>
 #include <linux/slab.h>
 
 /* Registers */
@@ -126,6 +129,69 @@ static const struct regulator_desc regulator = {
 	.owner		= THIS_MODULE,
 };
 
+#ifdef CONFIG_OF
+static struct of_device_id max8952_dt_match[] = {
+	{ .compatible = "maxim,max8952" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, max8952_dt_match);
+
+static struct max8952_platform_data *max8952_parse_dt(struct device *dev)
+{
+	struct max8952_platform_data *pd;
+	struct device_node *np = dev->of_node;
+	int ret;
+	int i;
+
+	pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
+	if (!pd) {
+		dev_err(dev, "Failed to allocate platform data\n");
+		return NULL;
+	}
+
+	pd->gpio_vid0 = of_get_named_gpio(np, "max8952,vid-gpios", 0);
+	pd->gpio_vid1 = of_get_named_gpio(np, "max8952,vid-gpios", 1);
+	pd->gpio_en = of_get_named_gpio(np, "max8952,en-gpio", 0);
+
+	if (of_property_read_u32(np, "max8952,default-mode", &pd->default_mode))
+		dev_warn(dev, "Default mode not specified, assuming 0\n");
+
+	ret = of_property_read_u32_array(np, "max8952,dvs-mode-microvolt",
+					pd->dvs_mode, ARRAY_SIZE(pd->dvs_mode));
+	if (ret) {
+		dev_err(dev, "max8952,dvs-mode-microvolt property not specified");
+		return NULL;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(pd->dvs_mode); ++i) {
+		if (pd->dvs_mode[i] < 770000 || pd->dvs_mode[i] > 1400000) {
+			dev_err(dev, "DVS voltage %d out of range\n", i);
+			return NULL;
+		}
+		pd->dvs_mode[i] = (pd->dvs_mode[i] - 770000) / 10000;
+	}
+
+	if (of_property_read_u32(np, "max8952,sync-freq", &pd->sync_freq))
+		dev_warn(dev, "max8952,sync-freq property not specified, defaulting to 26MHz\n");
+
+	if (of_property_read_u32(np, "max8952,ramp-speed", &pd->ramp_speed))
+		dev_warn(dev, "max8952,ramp-speed property not specified, defaulting to 32mV/us\n");
+
+	pd->reg_data = of_get_regulator_init_data(dev, np);
+	if (!pd->reg_data) {
+		dev_err(dev, "Failed to parse regulator init data\n");
+		return NULL;
+	}
+
+	return pd;
+}
+#else
+static struct max8952_platform_data *max8952_parse_dt(struct device *dev)
+{
+	return NULL;
+}
+#endif
+
 static int max8952_pmic_probe(struct i2c_client *client,
 		const struct i2c_device_id *i2c_id)
 {
@@ -136,6 +202,9 @@ static int max8952_pmic_probe(struct i2c_client *client,
 
 	int ret = 0, err = 0;
 
+	if (client->dev.of_node)
+		pdata = max8952_parse_dt(&client->dev);
+
 	if (!pdata) {
 		dev_err(&client->dev, "Require the platform data\n");
 		return -EINVAL;
@@ -271,6 +340,7 @@ static struct i2c_driver max8952_pmic_driver = {
 	.remove		= max8952_pmic_remove,
 	.driver		= {
 		.name	= "max8952",
+		.of_match_table = of_match_ptr(max8952_dt_match),
 	},
 	.id_table	= max8952_ids,
 };
diff --git a/include/linux/regulator/max8952.h b/include/linux/regulator/max8952.h
index c13aa34..4dbb63a 100644
--- a/include/linux/regulator/max8952.h
+++ b/include/linux/regulator/max8952.h
@@ -122,11 +122,11 @@ struct max8952_platform_data {
 	int gpio_vid1;
 	int gpio_en;
 
-	u8 default_mode;
-	u8 dvs_mode[MAX8952_NUM_DVS_MODE]; /* MAX8952_DVS_MODEx_XXXXmV */
+	u32 default_mode;
+	u32 dvs_mode[MAX8952_NUM_DVS_MODE]; /* MAX8952_DVS_MODEx_XXXXmV */
 
-	u8 sync_freq;
-	u8 ramp_speed;
+	u32 sync_freq;
+	u32 ramp_speed;
 
 	struct regulator_init_data *reg_data;
 };
-- 
1.8.1.5

