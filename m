Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbaGIOxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:53:36 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51511 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbaGIOxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:53:33 -0400
X-AuditID: cbfee61a-f79e46d00000134f-a0-53bd576b4278
From: Kamil Debski <k.debski@samsung.com>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Cc: t.figa@samsung.com, m.szyprowski@samsung.com,
        Kamil Debski <k.debski@samsung.com>
Subject: [PATCH] hwmon: pwm-fan: Add pwm-fan driver
Date: Wed, 09 Jul 2014 16:53:20 +0200
Message-id: <1404917600-4430-1-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFJMWRmVeSWpSXmKPExsVy+t9jAd3s8L3BBmdnclrMP3KO1eLH6wts
	Fpd3zWGzuDNtL5vF2iN32S3Wz3jN4sDm8WDibjaPvi2rGD0+b5ILYI7isklJzcksSy3St0vg
	yli7ZyJbwXubit2np7M0MF417GLk5JAQMJHYcnwWG4QtJnHh3nogm4tDSGARo8TNH7+hnA4m
	iVmTprF3MXJwsAloSqy65wHSICIQKfG1bwcLiM0sEC7Rv/M/M4gtLGAssffvShaQchYBVYkZ
	1/lBwrwCzhINn+8zgoQlBBQk5kyymcDIvYCRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZG
	cAg8k9rBuLLB4hCjAAejEg+vAs+eYCHWxLLiytxDjBIczEoivMJhe4OFeFMSK6tSi/Lji0pz
	UosPMUpzsCiJ8x5otQ4UEkhPLEnNTk0tSC2CyTJxcEo1MCZYXlrd/9tyJuvxhrL3Ux/fZfcL
	mvMsIPb4/vbNFz6scovTqRexLgz2+8CxOK50mcOuisSbMtfkWyIL30VaLv50T2rDJu4LLa+4
	f/I+yfZ9LWp6N2RRdfb1Jp2ZjSvmTD3Smd7Zvlpde2k87473s1axV1kV/ZyncLqLo6O0Im5P
	9fLO5uOOe5RYijMSDbWYi4oTAdgL0tr9AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pwm-fan driver enables control of fans connected to PWM lines.
This driver uses the PWM framework, so it is compatible with all
PWM devices that provide drivers through the PWM framework.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 .../devicetree/bindings/hwmon/pwm-fan.txt          |   12 ++
 drivers/hwmon/Kconfig                              |    9 +
 drivers/hwmon/Makefile                             |    1 +
 drivers/hwmon/pwm-fan.c                            |  199 ++++++++++++++++++++
 4 files changed, 221 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/hwmon/pwm-fan.txt
 create mode 100644 drivers/hwmon/pwm-fan.c

diff --git a/Documentation/devicetree/bindings/hwmon/pwm-fan.txt b/Documentation/devicetree/bindings/hwmon/pwm-fan.txt
new file mode 100644
index 0000000..f534607
--- /dev/null
+++ b/Documentation/devicetree/bindings/hwmon/pwm-fan.txt
@@ -0,0 +1,12 @@
+Bindings for a fan connected to the PWM lines
+
+Required properties:
+- compatible: "pwm-fan"
+- pwms: the PWM that is used to control the PWM fan
+
+Example:
+	pwm-fan {
+		compatible = "pwm-fan";
+		status = "okay";
+		pwms = <&pwm 0 10000 0>;
+	};
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 08531a1..838ffb8 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1104,6 +1104,15 @@ config SENSORS_PCF8591
 
 source drivers/hwmon/pmbus/Kconfig
 
+config SENSORS_PWM_FAN
+	tristate "PWM fan"
+	depends on PWM
+	help
+	  If you say yes here you get support for fans connected to PWM lines.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called pwm-fan.
+
 config SENSORS_SHT15
 	tristate "Sensiron humidity and temperature sensors. SHT15 and compat."
 	depends on GPIOLIB
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 3dc0f02..3967ecf 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -120,6 +120,7 @@ obj-$(CONFIG_SENSORS_NTC_THERMISTOR)	+= ntc_thermistor.o
 obj-$(CONFIG_SENSORS_PC87360)	+= pc87360.o
 obj-$(CONFIG_SENSORS_PC87427)	+= pc87427.o
 obj-$(CONFIG_SENSORS_PCF8591)	+= pcf8591.o
+obj-$(CONFIG_SENSORS_PWM_FAN)	+= pwm-fan.o
 obj-$(CONFIG_SENSORS_S3C)	+= s3c-hwmon.o
 obj-$(CONFIG_SENSORS_SCH56XX_COMMON)+= sch56xx-common.o
 obj-$(CONFIG_SENSORS_SCH5627)	+= sch5627.o
diff --git a/drivers/hwmon/pwm-fan.c b/drivers/hwmon/pwm-fan.c
new file mode 100644
index 0000000..78fa627
--- /dev/null
+++ b/drivers/hwmon/pwm-fan.c
@@ -0,0 +1,199 @@
+/*
+ * pwm-fan.c - Hwmon driver for fans connected to PWM lines.
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *
+ * Author: Kamil Debski <k.debski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/hwmon-sysfs.h>
+#include <linux/hwmon.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/pwm.h>
+
+#define MAX_PWM 255
+
+struct pwm_fan_ctx {
+	struct device *hwmon;
+	struct mutex lock;
+	struct platform_device *pdev;
+	struct pwm_device *pwm;
+	unsigned int duty_cycle;
+	unsigned char pwm_value;
+};
+
+static ssize_t show_pwm_enable(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	/* For the sake of simplicity only mode 1 (PWM) is supported */
+	return sprintf(buf, "1\n");
+}
+
+static ssize_t set_pwm(struct device *dev, struct device_attribute *attr,
+		       const char *buf, size_t count)
+{
+	struct pwm_fan_ctx *ctx = dev_get_drvdata(dev);
+	unsigned long pwm, duty;
+
+	if (kstrtoul(buf, 10, &pwm) || pwm > MAX_PWM)
+		return -EINVAL;
+
+	mutex_lock(&ctx->lock);
+
+	if (ctx->pwm_value == pwm)
+		goto exit_set_pwm;
+
+	duty =  DIV_ROUND_UP(pwm * (ctx->pwm->period - 1), MAX_PWM);
+	if (pwm_config(ctx->pwm, duty, ctx->pwm->period))
+		goto exit_set_pwm;
+
+	ctx->duty_cycle = duty;
+	ctx->pwm_value = pwm;
+
+
+exit_set_pwm:
+	mutex_unlock(&ctx->lock);
+
+	return count;
+}
+
+static ssize_t show_pwm(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct pwm_fan_ctx *ctx = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", ctx->pwm_value);
+}
+
+
+static SENSOR_DEVICE_ATTR(pwm1_enable, S_IRUGO | S_IWUSR,
+		   show_pwm_enable, NULL, 0);
+static SENSOR_DEVICE_ATTR(pwm1, S_IRUGO | S_IWUSR,
+		   show_pwm, set_pwm, 0);
+
+static struct attribute *pwm_fan_attributes[] = {
+	&sensor_dev_attr_pwm1_enable.dev_attr.attr,
+	&sensor_dev_attr_pwm1.dev_attr.attr,
+	NULL,
+};
+
+static const struct attribute_group pwm_fan_group = {
+	.attrs = pwm_fan_attributes,
+};
+
+static const struct attribute_group *pwm_fan_groups[] = {
+	&pwm_fan_group,
+	NULL
+};
+
+static int pwm_fan_probe(struct platform_device *pdev)
+{
+	struct pwm_fan_ctx *ctx;
+
+	ctx = devm_kzalloc(&pdev->dev, sizeof(*ctx), GFP_KERNEL);
+	if (!ctx) {
+		dev_err(&pdev->dev, "Not enough memory for PWM fan device\n");
+		return -ENOMEM;
+	}
+
+	ctx->pdev = pdev;
+	mutex_init(&ctx->lock);
+
+	ctx->pwm = devm_of_pwm_get(&pdev->dev, pdev->dev.of_node, 0);
+	if (IS_ERR(ctx->pwm)) {
+		dev_err(&pdev->dev, "Could not get PWM");
+		return -EINVAL;
+	}
+
+	dev_set_drvdata(&pdev->dev, ctx);
+	platform_set_drvdata(pdev, ctx);
+
+	/* Set duty cycle to maximum allowed */
+	ctx->duty_cycle = ctx->pwm->period - 1;
+	ctx->pwm_value = MAX_PWM;
+	pwm_config(ctx->pwm, ctx->duty_cycle, ctx->pwm->period);
+
+	ctx->hwmon = hwmon_device_register_with_groups(&pdev->dev, "pwmfan",
+		ctx, pwm_fan_groups);
+
+	if (IS_ERR(ctx->hwmon)) {
+		dev_err(&pdev->dev, "Failed to register hwmon device");
+		return PTR_ERR(ctx->hwmon);
+	}
+
+	/* Enbale PWM output */
+	pwm_enable(ctx->pwm);
+
+	return 0;
+}
+
+static int pwm_fan_remove(struct platform_device *pdev)
+{
+	struct pwm_fan_ctx *ctx = platform_get_drvdata(pdev);
+
+	pwm_disable(ctx->pwm);
+	hwmon_device_unregister(ctx->hwmon);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int pwm_fan_suspend(struct device *dev)
+{
+	struct pwm_fan_ctx *ctx = dev_get_drvdata(dev);
+
+	return pwm_config(ctx->pwm, 0, ctx->pwm->period);
+}
+
+static int pwm_fan_resume(struct device *dev)
+{
+	struct pwm_fan_ctx *ctx = dev_get_drvdata(dev);
+
+	return pwm_config(ctx->pwm, ctx->duty_cycle, ctx->pwm->period);
+}
+
+static SIMPLE_DEV_PM_OPS(pwm_fan_pm, pwm_fan_suspend, pwm_fan_resume);
+#endif
+
+
+
+static struct of_device_id of_pwm_fan_match[] = {
+	{ .compatible = "pwm-fan", },
+	{},
+};
+
+static struct platform_driver pwm_fan_driver = {
+	.probe		= pwm_fan_probe,
+	.remove		= pwm_fan_remove,
+	.driver	= {
+		.name		= "pwm-fan",
+#ifdef CONFIG_PM_SLEEP
+		.pm		= &pwm_fan_pm,
+#endif
+		.of_match_table	= of_match_ptr(of_pwm_fan_match),
+	},
+};
+
+module_platform_driver(pwm_fan_driver);
+
+MODULE_AUTHOR("Kamil Debski <k.debski@samsung.com>");
+MODULE_ALIAS("platform:pwm-fan");
+MODULE_DESCRIPTION("PWM FAN driver");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

