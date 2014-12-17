Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbaLQDfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 22:35:20 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:37317 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaLQDfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 22:35:15 -0500
X-AuditID: cbfee68f-f791c6d000004834-cd-5490f9f19b5b
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-input@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>,
        Hyunhee Kim <hyunhee.kim@samsung.com>
Subject: [PATCH v7 1/3] Input: add regulator haptic driver
Date: Wed, 17 Dec 2014 12:35:06 +0900
Message-id: <1418787308-29019-2-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1418787308-29019-1-git-send-email-jaewon02.kim@samsung.com>
References: <1418787308-29019-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsWyRsSkUPfjzwkhBtfucFhc//Kc1eLwoheM
	Fp8/tLBb7Gg4wmrRu+Aqm8XNT99YLS7vmsNmMeP8PiYHDo+ds+6ye/RtWcXo8XmTXABzFJdN
	SmpOZllqkb5dAlfGxltnWQoWRlbsnj6fpYHxqlcXIweHhICJxO4upS5GTiBTTOLCvfVsXYxc
	HEICSxklLn54ywaRMJG4vKyLCSKxiFGi9eBedpCEkEAbk8SMd9EgNpuAtsT39YtZQWwRgVCJ
	zxdmMYM0MAvcYJS4sGkKC0hCWMBK4vurrWwgm1kEVCWaVoSAhHkFPCTuf5zPDHGQgsScSTYg
	YU4BT4kHvx6zQqzykFjz7ycLyEgJgensErN+NjCBJFgEBCS+TT7EAtErK7HpADPEzZISB1fc
	YJnAKLyAkWEVo2hqQXJBcVJ6kbFecWJucWleul5yfu4mRmBgn/73rH8H490D1ocYBTgYlXh4
	X1yfECLEmlhWXJl7iNEUaMNEZinR5Hxg/OSVxBsamxlZmJqYGhuZW5opifMulPoZLCSQnliS
	mp2aWpBaFF9UmpNafIiRiYNTqoEx6NZVkbhVwjyNje4zf2prTb7ywUKE7d/hRToHV/4v9jMS
	b//Qep5tebuXI7+hjcX922WuaxjSXR7yLe992Ji/IPHBgUkLpC+dul5/525r6OGnfWe0ecwX
	zfiQ5bJGVO11Sn9YZu4j1RJPn2y519veM/p7nir6++ua/Lurp+NL/c7cF9V/nhutxFKckWio
	xVxUnAgA40RVQ2cCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t9jAd0PPyeEGHy8am1x/ctzVovDi14w
	Wnz+0MJusaPhCKtF74KrbBY3P31jtbi8aw6bxYzz+5gcODx2zrrL7tG3ZRWjx+dNcgHMUQ2M
	NhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAJygplCXm
	lAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYMzbeOstSsDCyYvf0+SwNjFe9uhg5
	OSQETCQuL+tigrDFJC7cW8/WxcjFISSwiFGi9eBedpCEkEAbk8SMd9EgNpuAtsT39YtZQWwR
	gVCJzxdmMYM0MAvcYJS4sGkKC0hCWMBK4vurrUCTODhYBFQlmlaEgIR5BTwk7n+czwwSlhBQ
	kJgzyQYkzCngKfHg12NWiFUeEmv+/WSZwMi7gJFhFaNoakFyQXFSeq6RXnFibnFpXrpecn7u
	JkZw5DyT3sG4qsHiEKMAB6MSD+/L6xNChFgTy4orcw8xSnAwK4nwWiwCCvGmJFZWpRblxxeV
	5qQWH2I0BbppIrOUaHI+MKrzSuINjU3MjCyNzA0tjIzNlcR5lezbQoQE0hNLUrNTUwtSi2D6
	mDg4pRoY1wWemSTfJnXxuf0shpll6QZyZY532Cdu934c9qizdePseVyGTFmtyy4++ZTTxbBU
	u2jRuiDu005eQbfW5R8wXsckvH3G9YBmPfEjPbf8o9l5btyxyWY1skv+nXRWh+dv4ZHcI8v+
	bGNxP1j6zCjE7cSZ6/ac2zJ8ipveyu6UZkqL3+I6xeOlEktxRqKhFnNRcSIATvUqXbICAAA=
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
Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 .../devicetree/bindings/input/regulator-haptic.txt |   21 ++
 drivers/input/misc/Kconfig                         |   11 +
 drivers/input/misc/Makefile                        |    1 +
 drivers/input/misc/regulator-haptic.c              |  247 ++++++++++++++++++++
 include/linux/platform_data/regulator-haptic.h     |   29 +++
 5 files changed, 309 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/regulator-haptic.txt
 create mode 100644 drivers/input/misc/regulator-haptic.c
 create mode 100644 include/linux/platform_data/regulator-haptic.h

diff --git a/Documentation/devicetree/bindings/input/regulator-haptic.txt b/Documentation/devicetree/bindings/input/regulator-haptic.txt
new file mode 100644
index 0000000..3ed1c7e
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/regulator-haptic.txt
@@ -0,0 +1,21 @@
+* Regulator Haptic Device Tree Bindings
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
index 0000000..16f5ec8
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
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_data/regulator-haptic.h>
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
+
+	struct work_struct work;
+	struct mutex mutex;
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
+	error = state ? regulator_enable(haptic->regulator) :
+		regulator_disable(haptic->regulator);
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
+	mutex_lock(&haptic->mutex);
+
+	if (haptic->suspend_state)
+		goto err;
+
+	error = regulator_set_voltage(haptic->regulator,
+			haptic->intensity + haptic->min_volt, haptic->max_volt);
+	if (error) {
+		dev_err(haptic->dev, "cannot set regulator voltage\n");
+		goto err;
+	}
+
+	if (haptic->magnitude)
+		regulator_haptic_enable(haptic, true);
+	else
+		regulator_haptic_enable(haptic, false);
+
+err:
+	mutex_unlock(&haptic->mutex);
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
+static int regulator_haptic_get_data(struct platform_device *pdev)
+{
+	struct device_node *node = pdev->dev.of_node;
+	struct regulator_haptic_data *data = dev_get_platdata(&pdev->dev);
+	struct regulator_haptic *haptic = platform_get_drvdata(pdev);
+	int error;
+
+	if (data) {
+		haptic->max_volt = data->max_volt;
+		haptic->min_volt = data->min_volt;
+	} else if (pdev->dev.of_node) {
+		error = of_property_read_u32(node, "max-microvolt",
+				&haptic->max_volt);
+		if (error) {
+			dev_err(&pdev->dev, "cannot parse max-microvolt\n");
+			return error;
+		}
+
+		error = of_property_read_u32(node, "min-microvolt",
+				&haptic->min_volt);
+		if (error) {
+			dev_err(&pdev->dev, "cannot parse min-microvolt\n");
+			return error;
+		}
+	} else {
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int regulator_haptic_probe(struct platform_device *pdev)
+{
+	struct regulator_haptic *haptic;
+	struct input_dev *input_dev;
+	int error;
+
+	haptic = devm_kzalloc(&pdev->dev, sizeof(*haptic), GFP_KERNEL);
+	if (!haptic)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, haptic);
+	haptic->dev = &pdev->dev;
+	haptic->enabled = false;
+	haptic->suspend_state = false;
+	mutex_init(&haptic->mutex);
+	INIT_WORK(&haptic->work, regulator_haptic_work);
+
+	error = regulator_haptic_get_data(pdev);
+	if (error) {
+		dev_err(&pdev->dev, "failed to get voltage value\n");
+		return error;
+	}
+
+	haptic->regulator = devm_regulator_get_exclusive(&pdev->dev, "haptic");
+	if (IS_ERR(haptic->regulator)) {
+		dev_err(&pdev->dev, "failed to get regulator\n");
+		return PTR_ERR(haptic->regulator);
+	}
+
+	input_dev = devm_input_allocate_device(&pdev->dev);
+	if (!input_dev)
+		return	-ENOMEM;
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
+	return 0;
+}
+
+static int __maybe_unused regulator_haptic_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct regulator_haptic *haptic = platform_get_drvdata(pdev);
+
+	mutex_lock(&haptic->mutex);
+
+	haptic->suspend_state = true;
+
+	if (haptic->enabled)
+		regulator_haptic_enable(haptic, false);
+
+	mutex_unlock(&haptic->mutex);
+
+	return 0;
+}
+
+static int __maybe_unused regulator_haptic_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct regulator_haptic *haptic = platform_get_drvdata(pdev);
+
+	haptic->suspend_state = false;
+
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(regulator_haptic_pm_ops,
+		regulator_haptic_suspend, regulator_haptic_resume);
+
+static struct of_device_id regulator_haptic_dt_match[] = {
+	{ .compatible = "regulator-haptic" },
+	{ /* sentinel */ },
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
diff --git a/include/linux/platform_data/regulator-haptic.h b/include/linux/platform_data/regulator-haptic.h
new file mode 100644
index 0000000..5658e58
--- /dev/null
+++ b/include/linux/platform_data/regulator-haptic.h
@@ -0,0 +1,29 @@
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
+#define _REGULATOR_HAPTIC_H
+
+/*
+ * struct regulator_haptic_data - Platform device data
+ *
+ * @max_volt: maximum voltage value supplied to the haptic motor.
+ *		<The unit of the voltage is a micro>
+ * @min_volt: minimum voltage value supplied to the haptic motor.
+ *		<The unit of the voltage is a micro>
+ */
+struct regulator_haptic_data {
+	unsigned int max_volt;
+	unsigned int min_volt;
+};
+
+#endif /* _REGULATOR_HAPTIC_H */
-- 
1.7.9.5

