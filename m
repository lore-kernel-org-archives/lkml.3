Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbaIDPDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:03:00 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:55302 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaIDPBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:01:52 -0400
X-AuditID: cbfee690-f79ce6d00000115a-60-54087edd4703
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v2 2/4] Input: misc: Add haptic driver on max77693
Date: Fri, 05 Sep 2014 00:01:29 +0900
Message-id: <1409842891-26549-3-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1409842891-26549-1-git-send-email-jaewon02.kim@samsung.com>
References: <1409842891-26549-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsWyRsSkQPduHUeIwbF3PBbXvzxntTi86AWj
	xY6GI6wW978eZbS4+ekbq8XlXXPYLE53szqwe+ycdZfd4861PWwe804GevRtWcXo8XmTXABr
	FJdNSmpOZllqkb5dAlfGhXk/WQpWxVYc/beTuYFxjl8XIyeHhICJxMx/x9ggbDGJC/fWA9lc
	HEICSxkltvReZ4Mp+v3qGCtEYjqjxLWnU6CcNiaJaws62EGq2AS0Jb6vX8wKYosIVEr0d78A
	K2IW6GGU+N6+mhkkISzgJPFr1j2wBhYBVYmnc94xgdi8Ah4Su+4eBbI5gNYpSMyZZAMS5hTw
	lOh6sIIFxBYCKlkw5RsLyEwJgensEovbZrNAzBGQ+Db5EAtEr6zEpgPMEFdLShxccYNlAqPw
	AkaGVYyiqQXJBcVJ6UUmesWJucWleel6yfm5mxiBQX7637MJOxjvHbA+xCjAwajEw1vwgj1E
	iDWxrLgy9xCjKdCGicxSosn5wFjKK4k3NDYzsjA1MTU2Mrc0UxLnfS31M1hIID2xJDU7NbUg
	tSi+qDQntfgQIxMHp1QDYzl/WdaUlzsNX1RtjOs5rSh0aH08o3fG7lipiy8qRSeJ/v/bZ5y3
	NfmlOIdstfQZhjVBBzYoLdr4UzLK13PVC691O3ae2LX/hOsNkysJmhqO2g33C9+Fc1/P/7DK
	d4O6npxFPY+J4vYHQa0T/1jxf5r5w2f1/DeHvxtP1AyN35Zs8nBncuq++UosxRmJhlrMRcWJ
	ANXfuuVtAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsVy+t9jQd27dRwhBtfvMFlc//Kc1eLwoheM
	FjsajrBa3P96lNHi5qdvrBaXd81hszjdzerA7rFz1l12jzvX9rB5zDsZ6NG3ZRWjx+dNcgGs
	UQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAVygp
	lCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYMy7M+8lSsCq24ui/ncwNjHP8
	uhg5OSQETCR+vzrGCmGLSVy4t56ti5GLQ0hgOqPEtadTWCGcNiaJaws62EGq2AS0Jb6vXwzW
	ISJQKdHf/QKsiFmgh1Hie/tqZpCEsICTxK9Z98AaWARUJZ7OeccEYvMKeEjsunsUyOYAWqcg
	MWeSDUiYU8BTouvBChYQWwioZMGUbywTGHkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/d
	xAiOoWdSOxhXNlgcYhTgYFTi4S14wR4ixJpYVlyZe4hRgoNZSYTXPY8jRIg3JbGyKrUoP76o
	NCe1+BCjKdBRE5mlRJPzgfGdVxJvaGxiZmRpZG5oYWRsriTOe6DVOlBIID2xJDU7NbUgtQim
	j4mDU6qB0drwrbFdc5vZsaPHjL1Sg6v8Dptd37ExVif4v4ElT82HKwvrF/hIeb2IaQqd07TC
	LKGpbt6ixfWnOmf2rXaaKsFps3brg4yV69rCv08SsN/z+aHcnKWXUw9mLhBOS874n+21e/2F
	rG42k1vJb6+wVaUc5vXft+jDzJYr713PZn79krBfQvDNXSWW4oxEQy3mouJEAGGHIkS3AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add max77693-haptic device driver to support the haptic controller
on MAX77693. The MAX77693 is a Multifunction device with PMIC, CHARGER, LED,
MUIC, HAPTIC and the patch is haptic device driver in the MAX77693. This driver
support external pwm and LRA(Linear Resonant Actuator) motor. User can control
the haptic driver by using force feedback framework.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/input/misc/Kconfig           |   12 ++
 drivers/input/misc/Makefile          |    1 +
 drivers/input/misc/max77693-haptic.c |  333 ++++++++++++++++++++++++++++++++++
 include/linux/mfd/max77693-private.h |    9 +
 4 files changed, 355 insertions(+)
 create mode 100644 drivers/input/misc/max77693-haptic.c

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 2ff4425..c597c52 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -144,6 +144,18 @@ config INPUT_M68K_BEEP
 	tristate "M68k Beeper support"
 	depends on M68K
 
+config INPUT_MAX77693_HAPTIC
+	tristate "MAXIM MAX77693 haptic controller support"
+	depends on MFD_MAX77693 && PWM
+	select INPUT_FF_MEMLESS
+	help
+	  This option enables device driver support for the haptic controller
+	  on MAXIM MAX77693 chip. This driver supports ff-memless interface
+	  from input framework.
+
+	  To compile this driver as module, choose M here: the
+	  module will be called max77693-haptic.
+
 config INPUT_MAX8925_ONKEY
 	tristate "MAX8925 ONKEY support"
 	depends on MFD_MAX8925
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index 4955ad3..b28570c 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -35,6 +35,7 @@ obj-$(CONFIG_INPUT_IXP4XX_BEEPER)	+= ixp4xx-beeper.o
 obj-$(CONFIG_INPUT_KEYSPAN_REMOTE)	+= keyspan_remote.o
 obj-$(CONFIG_INPUT_KXTJ9)		+= kxtj9.o
 obj-$(CONFIG_INPUT_M68K_BEEP)		+= m68kspkr.o
+obj-$(CONFIG_INPUT_MAX77693_HAPTIC)	+= max77693-haptic.o
 obj-$(CONFIG_INPUT_MAX8925_ONKEY)	+= max8925_onkey.o
 obj-$(CONFIG_INPUT_MAX8997_HAPTIC)	+= max8997_haptic.o
 obj-$(CONFIG_INPUT_MC13783_PWRBUTTON)	+= mc13783-pwrbutton.o
diff --git a/drivers/input/misc/max77693-haptic.c b/drivers/input/misc/max77693-haptic.c
new file mode 100644
index 0000000..2a69496
--- /dev/null
+++ b/drivers/input/misc/max77693-haptic.c
@@ -0,0 +1,333 @@
+/*
+ * max77693-haptic.c - MAXIM MAX77693 Haptic device driver
+ *
+ * Copyright (C) 2014 Samsung Electronics
+ * Jaewon Kim <jaewon02.kim@samsung.com>
+ *
+ * This program is not provided / owned by Maxim Integrated Products.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/regmap.h>
+#include <linux/input.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/pwm.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+#include <linux/regulator/consumer.h>
+#include <linux/mfd/max77693.h>
+#include <linux/mfd/max77693-private.h>
+
+#define MAX_MAGNITUDE_SHIFT	16
+
+enum max77693_haptic_motor_type {
+	MAX77693_HAPTIC_ERM = 0,
+	MAX77693_HAPTIC_LRA,
+};
+
+enum max77693_haptic_pulse_mode {
+	MAX77693_HAPTIC_EXTERNAL_MODE = 0,
+	MAX77693_HAPTIC_INTERNAL_MODE,
+};
+
+enum max77693_haptic_pwm_divisor {
+	MAX77693_HAPTIC_PWM_DIVISOR_32 = 0,
+	MAX77693_HAPTIC_PWM_DIVISOR_64,
+	MAX77693_HAPTIC_PWM_DIVISOR_128,
+	MAX77693_HAPTIC_PWM_DIVISOR_256,
+};
+
+struct max77693_haptic {
+	struct regmap *regmap_pmic;
+	struct regmap *regmap_haptic;
+	struct device *dev;
+	struct input_dev *input_dev;
+	struct pwm_device *pwm_dev;
+	struct regulator *motor_reg;
+
+	bool enabled;
+	unsigned int magnitude;
+	enum max77693_haptic_motor_type type;
+	enum max77693_haptic_pulse_mode mode;
+	enum max77693_haptic_pwm_divisor pwm_divisor;
+
+	struct mutex mutex;
+	struct work_struct work;
+};
+
+static int max77693_haptic_set_duty_cycle(struct max77693_haptic *haptic,
+						unsigned int pwm_duty)
+{
+	int ret;
+	int delta = (haptic->pwm_dev->period + pwm_duty)/2;
+
+	ret = pwm_config(haptic->pwm_dev, delta, haptic->pwm_dev->period);
+	if (ret) {
+		dev_err(haptic->dev, "cannot configuration pwm\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int max77693_haptic_configure(struct max77693_haptic *haptic,
+						unsigned int enable)
+{
+	int ret;
+	unsigned int value = 0;
+
+	value = ((haptic->type << MAX77693_CONFIG2_MODE) |
+		(enable << MAX77693_CONFIG2_MEN) |
+		(haptic->mode << MAX77693_CONFIG2_HTYP) |
+		(haptic->pwm_divisor));
+
+	ret = regmap_write(haptic->regmap_haptic,
+				MAX77693_HAPTIC_REG_CONFIG2, value);
+	if (ret) {
+		dev_err(haptic->dev, "cannot write haptic regmap\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int max77693_haptic_lowsys(struct max77693_haptic *haptic,
+						unsigned int enable)
+{
+	int ret;
+
+	ret = regmap_update_bits(haptic->regmap_pmic,
+			MAX77693_PMIC_REG_LSCNFG,
+			MAX77693_PMIC_LOW_SYS_MASK,
+			enable << MAX77693_PMIC_LOW_SYS_SHIFT);
+	if (ret) {
+		dev_err(haptic->dev, "cannot update pmic regmap\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static void max77693_haptic_enable(struct max77693_haptic *haptic)
+{
+	int ret;
+
+	if (haptic->enabled)
+		return;
+
+	ret = pwm_enable(haptic->pwm_dev);
+	if (ret < 0) {
+		dev_err(haptic->dev, "cannot enable haptic pwm device");
+		return;
+	}
+
+	ret = regulator_enable(haptic->motor_reg);
+	if (ret) {
+		dev_err(haptic->dev, "cannot enable haptic regulator\n");
+		goto err_pwm_enable;
+	}
+
+	ret = max77693_haptic_lowsys(haptic, 1);
+	if (ret)
+		goto err_enable_lowsys;
+
+	ret = max77693_haptic_configure(haptic, 1);
+	if (ret < 0)
+		goto err_enable_config;
+
+	haptic->enabled = true;
+
+	return;
+
+err_enable_config:
+	max77693_haptic_lowsys(haptic, 0);
+err_enable_lowsys:
+	regulator_disable(haptic->motor_reg);
+err_pwm_enable:
+	pwm_disable(haptic->pwm_dev);
+}
+
+static void max77693_haptic_disable(struct max77693_haptic *haptic)
+{
+	int ret;
+
+	if (!haptic->enabled)
+		return;
+
+	ret = max77693_haptic_configure(haptic, 0);
+	if (ret < 0)
+		return;
+
+	ret = max77693_haptic_lowsys(haptic, 0);
+	if (ret)
+		goto err_disable_lowsys;
+
+	ret = regulator_disable(haptic->motor_reg);
+	if (ret) {
+		dev_err(haptic->dev, "cannot disable haptic regulator\n");
+		goto err_reg_disable;
+	}
+
+	pwm_disable(haptic->pwm_dev);
+	haptic->enabled = false;
+
+	return;
+
+err_reg_disable:
+	max77693_haptic_lowsys(haptic, 1);
+err_disable_lowsys:
+	max77693_haptic_configure(haptic, 1);
+}
+
+static void max77693_haptic_play_work(struct work_struct *work)
+{
+	struct max77693_haptic *haptic =
+			container_of(work, struct max77693_haptic, work);
+
+	mutex_lock(&haptic->mutex);
+	if (haptic->magnitude)
+		max77693_haptic_enable(haptic);
+	else
+		max77693_haptic_disable(haptic);
+	mutex_unlock(&haptic->mutex);
+}
+
+static int max77693_haptic_play_effect(struct input_dev *dev, void *data,
+				struct ff_effect *effect)
+{
+	struct max77693_haptic *haptic = input_get_drvdata(dev);
+	uint64_t period_mag_multi;
+	unsigned int pwm_duty;
+	int ret;
+
+	haptic->magnitude = effect->u.rumble.strong_magnitude;
+	if (!haptic->magnitude)
+		haptic->magnitude = effect->u.rumble.weak_magnitude;
+
+	/*
+	 * The magnitude comes from force-feedback interface.
+	 * The formula convert magnitude to pwm_duty as following:
+	 * - pwm_duty = (magnitude * pwm_period) / MAX_MAGNITUDE(0xFFFF)
+	 */
+	period_mag_multi = (int64_t)(haptic->pwm_dev->period *
+						haptic->magnitude);
+	pwm_duty = (unsigned int)(period_mag_multi >> MAX_MAGNITUDE_SHIFT);
+	ret = max77693_haptic_set_duty_cycle(haptic, pwm_duty);
+	if (ret)
+		return ret;
+
+	schedule_work(&haptic->work);
+
+	return 0;
+}
+
+static void max77693_haptic_close(struct input_dev *dev)
+{
+	struct max77693_haptic *haptic = input_get_drvdata(dev);
+
+	cancel_work_sync(&haptic->work);
+	max77693_haptic_disable(haptic);
+}
+
+static int max77693_haptic_probe(struct platform_device *pdev)
+{
+	struct max77693_dev *max77693 = dev_get_drvdata(pdev->dev.parent);
+	struct max77693_haptic *haptic;
+	int ret = 0;
+
+	haptic = devm_kzalloc(&pdev->dev, sizeof(*haptic), GFP_KERNEL);
+	if (!haptic)
+		return -ENOMEM;
+
+	haptic->regmap_pmic = max77693->regmap;
+	haptic->regmap_haptic = max77693->regmap_haptic;
+	haptic->dev = &pdev->dev;
+	haptic->type = MAX77693_HAPTIC_LRA;
+	haptic->mode = MAX77693_HAPTIC_EXTERNAL_MODE;
+	haptic->pwm_divisor = MAX77693_HAPTIC_PWM_DIVISOR_128;
+	mutex_init(&haptic->mutex);
+
+	/* Get pwm and regulatot for haptic device */
+	haptic->pwm_dev = devm_pwm_get(&pdev->dev, NULL);
+	if (IS_ERR(haptic->pwm_dev)) {
+		dev_err(&pdev->dev, "failed to get pwm device\n");
+		return PTR_ERR(haptic->pwm_dev);
+	}
+
+	haptic->motor_reg = devm_regulator_get(&pdev->dev, "haptic");
+	if (IS_ERR(haptic->motor_reg)) {
+		dev_err(&pdev->dev, "failed to get regulator\n");
+		return PTR_ERR(haptic->motor_reg);
+	}
+
+	/* Initialize input device for haptic device */
+	haptic->input_dev = devm_input_allocate_device(&pdev->dev);
+	if (!haptic->input_dev) {
+		dev_err(&pdev->dev, "failed to allocate input device\n");
+		return -ENOMEM;
+	}
+
+	haptic->input_dev->name = "max77693-haptic";
+	haptic->input_dev->id.version = 1;
+	haptic->input_dev->dev.parent = &pdev->dev;
+	haptic->input_dev->close = max77693_haptic_close;
+	input_set_drvdata(haptic->input_dev, haptic);
+	input_set_capability(haptic->input_dev, EV_FF, FF_RUMBLE);
+
+	ret = input_ff_create_memless(haptic->input_dev, NULL,
+				max77693_haptic_play_effect);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to create force-feedback\n");
+		return ret;
+	}
+
+	ret = input_register_device(haptic->input_dev);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register input device\n");
+		goto err_input_device;
+	}
+
+	INIT_WORK(&haptic->work, max77693_haptic_play_work);
+
+	platform_set_drvdata(pdev, haptic);
+
+	return 0;
+
+err_input_device:
+	input_ff_destroy(haptic->input_dev);
+
+	return ret;
+}
+
+static int max77693_haptic_remove(struct platform_device *pdev)
+{
+	struct max77693_haptic *haptic = platform_get_drvdata(pdev);
+
+	max77693_haptic_disable(haptic);
+	input_unregister_device(haptic->input_dev);
+
+	return 0;
+}
+
+static struct platform_driver max77693_haptic_driver = {
+	.driver		= {
+		.name	= "max77693-haptic",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= max77693_haptic_probe,
+	.remove		= max77693_haptic_remove,
+};
+module_platform_driver(max77693_haptic_driver);
+
+MODULE_AUTHOR("Jaewon Kim <jaewon02.kim@samsung.com>");
+MODULE_DESCRIPTION("MAXIM MAX77693 Haptic driver");
+MODULE_ALIAS("platform:max77693-haptic");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
index c466ff3..d0e578f 100644
--- a/include/linux/mfd/max77693-private.h
+++ b/include/linux/mfd/max77693-private.h
@@ -251,6 +251,15 @@ enum max77693_haptic_reg {
 	MAX77693_HAPTIC_REG_END,
 };
 
+/* max77693-pmic LSCNFG configuraton register */
+#define MAX77693_PMIC_LOW_SYS_MASK      0x80
+#define MAX77693_PMIC_LOW_SYS_SHIFT     7
+
+/* max77693-haptic configuration register */
+#define MAX77693_CONFIG2_MODE           7
+#define MAX77693_CONFIG2_MEN            6
+#define MAX77693_CONFIG2_HTYP           5
+
 enum max77693_irq_source {
 	LED_INT = 0,
 	TOPSYS_INT,
-- 
1.7.9.5

