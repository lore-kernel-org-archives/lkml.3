Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbaKXOwD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:52:03 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:20767 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbaKXOvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:51:53 -0500
X-AuditID: cbfee68d-f79296d000004278-01-54734606f1d2
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>, Dan Murphy <dmurphy@ti.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Hyunhee Kim <hyunhee.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v2 1/2] Input: add regulator haptic driver
Date: Mon, 24 Nov 2014 23:50:50 +0900
Message-id: <1416840651-17141-2-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416840651-17141-1-git-send-email-jaewon02.kim@samsung.com>
References: <1416840651-17141-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWyRsSkRJfdrTjE4OoiJovrX56zWhxe9ILR
	ovv0FlaLzx9a2C12NBxhtehdcJXN4uanb6wWl3fNYbOYcX4fk8WirV/YHbg8ds66y+7Rt2UV
	o8fxG9uZPD5vkgtgieKySUnNySxLLdK3S+DKWP3iBXvBwsiK72f+MjYwbvHqYuTkkBAwkfhw
	9BIrhC0mceHeerYuRi4OIYGljBKTjj1lgSlqfdfOCpFYxChx59JSRginjUni0OzNzCBVbALa
	Et/XLwYbJSLwhlHi6+ZwkCJmgfmMEt1T54MlhAWsJDZPewdmswioSlx5Mw+smVfAQ2La7w6g
	OAfQOgWJOZNsQMKcAp4SHRuOgZUIAZW8eTuDCWSmhMAqdoldXRdYIOYISHybfIgFoldWYtMB
	ZoirJSUOrrjBMoFReAEjwypG0dSC5ILipPQiQ73ixNzi0rx0veT83E2MwOA//e9Z7w7G2wes
	DzEKcDAq8fB+2FgUIsSaWFZcmXuI0RRow0RmKdHkfGCM5ZXEGxqbGVmYmpgaG5lbmimJ8ypK
	/QwWEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwFh0ktlWZul9h6jTIt9szV/OvN+g7H939tX4
	mj835mzQ3HFL90Jvx6sHb5Ttj8aHzH1x4GTFQ6X8X08j+HJqHx9TeS27cNoSvo03LF1Lgz52
	Xzz71GaT44u40vwlssbH8tyNuwxrnp//7TpffdLfno9Z1+wKlF5VT3NP2B+x35JprWW4oXnd
	lK9KLMUZiYZazEXFiQAAKbereQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t9jAV02t+IQg7szjS2uf3nOanF40QtG
	i+7TW1gtPn9oYbfY0XCE1aJ3wVU2i5ufvrFaXN41h81ixvl9TBaLtn5hd+Dy2DnrLrtH35ZV
	jB7Hb2xn8vi8SS6AJaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfV
	VsnFJ0DXLTMH6CIlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8bqFy/Y
	CxZGVnw/85exgXGLVxcjJ4eEgIlE67t2VghbTOLCvfVsXYxcHEICixgl7lxaygjhtDFJHJq9
	mRmkik1AW+L7+sVgHSICbxglvm4OByliFpjPKNE9dT5YQljASmLztHdgNouAqsSVN/PAmnkF
	PCSm/e4AinMArVOQmDPJBiTMKeAp0bHhGFiJEFDJm7czmCYw8i5gZFjFKJpakFxQnJSea6RX
	nJhbXJqXrpecn7uJERxbz6R3MK5qsDjEKMDBqMTDO2N9UYgQa2JZcWXuIUYJDmYlEV4xseIQ
	Id6UxMqq1KL8+KLSnNTiQ4ymQEdNZJYSTc4Hxn1eSbyhsYmZkaWRuaGFkbG5kjjvjZu5IUIC
	6YklqdmpqQWpRTB9TBycUg2MuoKFvgsa1j+8xaWcoubT84In02KSsyxLVMsC3VKl7TLXWLyr
	Tv6aVFnBtJ0vseoxY2jbDL4Le3N23f+yIG+ZlfHckybbrjwoZ5jGmuO2plhySfWSXt0V0b8u
	+pgY6OTGCj9Vr9LMbN/jWxa9due+p37RM63S/T7YLJVfvkerpOzK/rvzllYpsRRnJBpqMRcV
	JwIAd7kUrcMCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for haptic driver controlled by
voltage of regulator. And this driver support for
Force Feedback interface from input framework

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
Signed-off-by: Hyunhee Kim <hyunhee.kim@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/input/regulator-haptic.txt |   24 ++
 drivers/input/misc/Kconfig                         |   11 +
 drivers/input/misc/Makefile                        |    1 +
 drivers/input/misc/regulator-haptic.c              |  247 ++++++++++++++++++++
 include/linux/input/regulator-haptic.h             |   30 +++
 5 files changed, 313 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/regulator-haptic.txt
 create mode 100644 drivers/input/misc/regulator-haptic.c
 create mode 100644 include/linux/input/regulator-haptic.h

diff --git a/Documentation/devicetree/bindings/input/regulator-haptic.txt b/Documentation/devicetree/bindings/input/regulator-haptic.txt
new file mode 100644
index 0000000..5a44e8f
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/regulator-haptic.txt
@@ -0,0 +1,24 @@
+* Requlator Haptic Device Tree Bindings
+
+The regulator haptic driver controlled by voltage of regulator.
+This driver implemented via Force Feedback interface.
+
+Required Properties:
+ - compatible : Should be "regulator-haptic"
+ - haptic-supply : Power supply to the haptic motor.
+	[*] refer Documentation/devicetree/bindings/regulator/regulator.txt
+
+ - max-microvolt : The maximum voltage value supplied to the haptic motor.
+		[The unit of the voltage is a micro]
+
+ - min-microvolt : The minimum voltage value supplied to the haptic motor.
+		[The unit of the voltage is a micro]
+
+Example:
+
+	haptics {
+		compatible = "regulator-haptic";
+		haptic-supply = <&motor_regulator>;
+		max-microvolt = <2700000>;
+		min-microvolt = <1100000>;
+	};
diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 23297ab..e5e556d 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -394,6 +394,17 @@ config INPUT_CM109
 	  To compile this driver as a module, choose M here: the module will be
 	  called cm109.
 
+config INPUT_REGULATOR_HAPTIC
+	tristate "regulator haptics support"
+	select INPUT_FF_MEMLESS
+	help
+	  This option enables device driver support for the haptic controlled
+	  by regulator. This driver supports ff-memless interface
+	  from input framework.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called regulator-haptic.
+
 config INPUT_RETU_PWRBUTTON
 	tristate "Retu Power button Driver"
 	depends on MFD_RETU
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index 19c7603..1f135af 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_INPUT_PMIC8XXX_PWRKEY)	+= pmic8xxx-pwrkey.o
 obj-$(CONFIG_INPUT_POWERMATE)		+= powermate.o
 obj-$(CONFIG_INPUT_PWM_BEEPER)		+= pwm-beeper.o
 obj-$(CONFIG_INPUT_RB532_BUTTON)	+= rb532_button.o
+obj-$(CONFIG_INPUT_REGULATOR_HAPTIC)	+= regulator-haptic.o
 obj-$(CONFIG_INPUT_RETU_PWRBUTTON)	+= retu-pwrbutton.o
 obj-$(CONFIG_INPUT_GPIO_ROTARY_ENCODER)	+= rotary_encoder.o
 obj-$(CONFIG_INPUT_SGI_BTNS)		+= sgi_btns.o
diff --git a/drivers/input/misc/regulator-haptic.c b/drivers/input/misc/regulator-haptic.c
new file mode 100644
index 0000000..c61dd99
--- /dev/null
+++ b/drivers/input/misc/regulator-haptic.c
@@ -0,0 +1,247 @@
+/*
+ * Regulator haptic driver
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ * Author: Jaewon Kim <jaewon02.kim@samsung.com>
+ * Author: Hyunhee Kim <hyunhee.kim@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/input.h>
+#include <linux/input/regulator-haptic.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
+#include <linux/slab.h>
+
+#define MAX_MAGNITUDE_SHIFT	16
+
+struct regulator_haptic {
+	struct device *dev;
+	struct input_dev *input_dev;
+	struct regulator *regulator;
+	struct work_struct work;
+
+	bool enabled;
+	bool suspend_state;
+	unsigned int max_volt;
+	unsigned int min_volt;
+	unsigned int intensity;
+	unsigned int magnitude;
+};
+
+static void regulator_haptic_enable(struct regulator_haptic *haptic, bool state)
+{
+	int error;
+
+	if (haptic->enabled == state)
+		return;
+
+	if (state)
+		error = regulator_enable(haptic->regulator);
+	else
+		error = regulator_disable(haptic->regulator);
+	if (error) {
+		dev_err(haptic->dev, "cannot enable regulator\n");
+		return;
+	}
+
+	haptic->enabled = state;
+}
+
+static void regulator_haptic_work(struct work_struct *work)
+{
+	struct regulator_haptic *haptic = container_of(work,
+					struct regulator_haptic, work);
+	int error;
+
+	error = regulator_set_voltage(haptic->regulator,
+			haptic->intensity + haptic->min_volt, haptic->max_volt);
+	if (error) {
+		dev_err(haptic->dev, "cannot set regulator voltage\n");
+		return;
+	}
+
+	if (haptic->magnitude)
+		regulator_haptic_enable(haptic, true);
+	else
+		regulator_haptic_enable(haptic, false);
+}
+
+static int regulator_haptic_play_effect(struct input_dev *input, void *data,
+					struct ff_effect *effect)
+{
+	struct regulator_haptic *haptic = input_get_drvdata(input);
+	u64 volt_mag_multi;
+
+	haptic->magnitude = effect->u.rumble.strong_magnitude;
+	if (!haptic->magnitude)
+		haptic->magnitude = effect->u.rumble.weak_magnitude;
+
+
+	volt_mag_multi = (u64)(haptic->max_volt - haptic->min_volt) *
+					haptic->magnitude;
+	haptic->intensity = (unsigned int)(volt_mag_multi >>
+					MAX_MAGNITUDE_SHIFT);
+
+	schedule_work(&haptic->work);
+
+	return 0;
+}
+
+static void regulator_haptic_close(struct input_dev *input)
+{
+	struct regulator_haptic *haptic = input_get_drvdata(input);
+
+	cancel_work_sync(&haptic->work);
+	regulator_haptic_enable(haptic, false);
+}
+
+#ifdef CONFIG_OF
+static int regulator_haptic_parse_dt(struct regulator_haptic *haptic)
+{
+	struct device_node *node = haptic->dev->of_node;
+	int error;
+
+	error = of_property_read_u32(node, "max-microvolt", &haptic->max_volt);
+	if (error) {
+		dev_err(haptic->dev, "cannot parse max-microvolt\n");
+		return error;
+	}
+
+	error = of_property_read_u32(node, "min-microvolt", &haptic->min_volt);
+	if (error) {
+		dev_err(haptic->dev, "cannot parse min-microvolt\n");
+		return error;
+	}
+
+	return 0;
+}
+#else
+static int regulator_haptic_parse_dt(struct regulator_haptic *haptic)
+{
+	return 0;
+}
+#endif /* CONFIG_OF */
+
+static int regulator_haptic_probe(struct platform_device *pdev)
+{
+	struct regulator_haptic *haptic;
+	struct regulator_haptic_data *data;
+	struct input_dev *input_dev;
+	int error;
+
+	haptic = devm_kzalloc(&pdev->dev, sizeof(*haptic), GFP_KERNEL);
+	if (!haptic)
+		return -ENOMEM;
+
+	haptic->dev = &pdev->dev;
+	haptic->enabled = false;
+	haptic->suspend_state = false;
+	INIT_WORK(&haptic->work, regulator_haptic_work);
+
+	if (pdev->dev.of_node) {
+		error = regulator_haptic_parse_dt(haptic);
+		if (error) {
+			dev_err(&pdev->dev, "failed to parse device tree\n");
+			return error;
+		}
+	} else {
+		data = dev_get_platdata(&pdev->dev);
+		if (data) {
+			dev_err(&pdev->dev, "failed to get platdata\n");
+			return -EINVAL;
+		}
+
+		haptic->regulator = data->regulator;
+		haptic->max_volt = data->max_volt;
+		haptic->min_volt = data->min_volt;
+	}
+
+	haptic->regulator = devm_regulator_get(&pdev->dev, "haptic");
+	if (IS_ERR(haptic->regulator)) {
+		dev_err(&pdev->dev, "failed to get regulator\n");
+		return PTR_ERR(haptic->regulator);
+	}
+
+	input_dev = devm_input_allocate_device(&pdev->dev);
+	if (!input_dev)
+		return  -ENOMEM;
+
+	haptic->input_dev = input_dev;
+	haptic->input_dev->name = "regulator-haptic";
+	haptic->input_dev->dev.parent = &pdev->dev;
+	haptic->input_dev->close = regulator_haptic_close;
+	input_set_drvdata(haptic->input_dev, haptic);
+	input_set_capability(haptic->input_dev, EV_FF, FF_RUMBLE);
+
+	error = input_ff_create_memless(input_dev, NULL,
+			      regulator_haptic_play_effect);
+	if (error) {
+		dev_err(&pdev->dev, "failed to create force-feedback\n");
+		return error;
+	}
+
+	error = input_register_device(haptic->input_dev);
+	if (error) {
+		dev_err(&pdev->dev, "failed to register input device\n");
+		return error;
+	}
+
+	platform_set_drvdata(pdev, haptic);
+
+	return 0;
+}
+
+static int __maybe_unused regulator_haptic_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct regulator_haptic *haptic = platform_get_drvdata(pdev);
+
+	if (haptic->enabled) {
+		regulator_haptic_enable(haptic, false);
+		haptic->suspend_state = true;
+	}
+
+	return 0;
+}
+
+static int __maybe_unused regulator_haptic_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct regulator_haptic *haptic = platform_get_drvdata(pdev);
+
+	if (haptic->suspend_state) {
+		regulator_haptic_enable(haptic, true);
+		haptic->suspend_state = false;
+	}
+
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(regulator_haptic_pm_ops,
+		regulator_haptic_suspend, regulator_haptic_resume);
+
+static struct of_device_id regulator_haptic_dt_match[] = {
+	{ .compatible = "regulator-haptic" },
+	{},
+};
+
+static struct platform_driver regulator_haptic_driver = {
+	.probe		= regulator_haptic_probe,
+	.driver		= {
+		.name		= "regulator-haptic",
+		.of_match_table = regulator_haptic_dt_match,
+		.pm		= &regulator_haptic_pm_ops,
+	},
+};
+module_platform_driver(regulator_haptic_driver);
+
+MODULE_AUTHOR("Jaewon Kim <jaewon02.kim@samsung.com>");
+MODULE_AUTHOR("Hyunhee Kim <hyunhee.kim@samsung.com>");
+MODULE_DESCRIPTION("Regulator haptic driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/input/regulator-haptic.h b/include/linux/input/regulator-haptic.h
new file mode 100644
index 0000000..15a629c
--- /dev/null
+++ b/include/linux/input/regulator-haptic.h
@@ -0,0 +1,30 @@
+/*
+ * Regulator Haptic Platform Data
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ * Author: Jaewon Kim <jaewon02.kim@samsung.com>
+ * Author: Hyunhee Kim <hyunhee.kim@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _REGULATOR_HAPTIC_H
+
+/*
+ * struct regulator_haptic_data - Platform device data
+ *
+ * @regulator: Power supply to the haptic motor
+ * @max_volt: maximum voltage value supplied to the haptic motor.
+ * 		<The unit of the voltage is a micro>
+ * @min_volt: minimum voltage value supplied to the haptic motor.
+ * 		<The unit of the voltage is a micro>
+ */
+struct regulator_haptic_data {
+	struct regulator *regulator;
+	unsigned int max_volt;
+	unsigned int min_volt;
+};
+
+#endif /* _REGULATOR_HAPTIC_H */
-- 
1.7.9.5

