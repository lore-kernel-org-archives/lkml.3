Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbbAWFDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 00:03:12 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:51754 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbbAWFDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 00:03:05 -0500
X-AuditID: cbfee68d-f79296d000004278-58-54c1d606b7ff
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Inki Dae <inki.dae@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Lee Jones <lee.jones@linaro.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sebastian Reichel <sre@kernel.org>, Mark Brown <broonie@kernel.org>,
        Beomho Seo <beomho.seo@samsung.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH 1/6] mfd: max77843: Add max77843 MFD driver core driver
Date: Fri, 23 Jan 2015 14:02:42 +0900
Message-id: <1421989367-32721-2-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1421989367-32721-1-git-send-email-jaewon02.kim@samsung.com>
References: <1421989367-32721-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42JZI2JSoMt27WCIwdE9vBanP21jt5j68Amb
	xfUvz1kt5h85x2rR/2Yhq8W5VysZLSbdn8BisaPhCKvF/a9HGS0u75rDZvG59wijxdLrF5ks
	Jkxfy2LRuvcIu8Xp3SUO/B5r5q1h9Ljc18vksXL5FzaPTas62TzuXNvD5tG3ZRWjx+dNcgHs
	UVw2Kak5mWWpRfp2CVwZC+b2MhX82clYcfzyZuYGxvnzGLsYOTkkBEwk/m6byAJhi0lcuLee
	rYuRi0NIYCmjRNe/y6wwRavuTWKBSExnlNg6cRUrhNPGJNHxYSE7SBWbgLbE9/WLwTpEBCIk
	nn9cyQxSxCxwkFmi4+JpsCJhAXeJNRdfMIHYLAKqEudXHgKzeQU8JB7NXAjUzAG0TkFiziQb
	kDCngKfEuz0v2EBsIaCS1RNOgl0hIfCSXeLx1i9sEHMEJL5NPsQC0SsrsekAM8TVkhIHV9xg
	mcAovICRYRWjaGpBckFxUnqRoV5xYm5xaV66XnJ+7iZGYDyd/vesdwfj7QPWhxgFOBiVeHgb
	thwMEWJNLCuuzD3EaAq0YSKzlGhyPjBq80riDY3NjCxMTUyNjcwtzZTEeRWlfgYLCaQnlqRm
	p6YWpBbFF5XmpBYfYmTi4JRqYDSfuXHG/q2T2MV2F16+lrN1oXj0kt2nwzM2hF5yjAnStP5z
	dEGZwf0du/sb0xglRJRuv7Fe12q1Z/+GnZekCydUvjy5o316m3xZZM3NnA0xwVPzs/aZGevp
	l4etSwjh1+Uv/M/TzcJbZ1DWHNIV5LQ9tr3sltqa4DkuW8PWGMd8lMp5lr5BQImlOCPRUIu5
	qDgRADRo+0GiAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t9jQV22awdDDE69ZbQ4/Wkbu8XUh0/Y
	LK5/ec5qMf/IOVaL/jcLWS3OvVrJaDHp/gQWix0NR1gt7n89ymhxedccNovPvUcYLZZev8hk
	MWH6WhaL1r1H2C1O7y5x4PdYM28No8flvl4mj5XLv7B5bFrVyeZx59oeNo++LasYPT5vkgtg
	j2pgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOlxJ
	oSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmLFgbi9TwZ+djBXHL29mbmCc
	P4+xi5GTQ0LARGLVvUksELaYxIV769m6GLk4hASmM0psnbiKFcJpY5Lo+LCQHaSKTUBb4vv6
	xawgtohAhMTzjyuZQYqYBQ4yS3RcPA1WJCzgLrHm4gsmEJtFQFXi/MpDYDavgIfEo5kLgZo5
	gNYpSMyZZAMS5hTwlHi35wUbiC0EVLJ6wkmWCYy8CxgZVjGKphYkFxQnpeca6RUn5haX5qXr
	JefnbmIER+sz6R2MqxosDjEKcDAq8fA2bDkYIsSaWFZcmXuIUYKDWUmE98kBoBBvSmJlVWpR
	fnxRaU5q8SFGU6CjJjJLiSbnAxNJXkm8obGJmZGlkbmhhZGxuZI4r5J9W4iQQHpiSWp2ampB
	ahFMHxMHp1QD46QDdrtsbP4nG2kZ55olPSpZftr3ZHnBQasdNq+O3q9acEPP1nTO1IJVR+Zo
	H7jE8dffYLnLGes+kZ+icr8CDZqWrWsWPpm6zfjVf7F72rHc8s2e2t9DN4kJ9p5senhw2R/5
	4vv5jxWkzpZosVe9EDrnq+Hw9UZV/eFctaKDKiy7fgl099+xUWIpzkg01GIuKk4EAHx1fEfs	AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds MAX77843 core/irq driver to support PMIC,
MUIC(Micro USB Interface Controller), Charger, Fuel Gauge,
LED and Haptic device.

Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Beomho Seo <beomho.seo@samsung.com>
Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
---
 drivers/mfd/Kconfig                  |   14 ++
 drivers/mfd/Makefile                 |    1 +
 drivers/mfd/max77843.c               |  241 ++++++++++++++++++++
 include/linux/mfd/max77843-private.h |  410 ++++++++++++++++++++++++++++++++++
 4 files changed, 666 insertions(+)
 create mode 100644 drivers/mfd/max77843.c
 create mode 100644 include/linux/mfd/max77843-private.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 2e6b731..0c67c79 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -442,6 +442,20 @@ config MFD_MAX77693
 	  additional drivers must be enabled in order to use the functionality
 	  of the device.
 
+config MFD_MAX77843
+	bool "Maxim Semiconductor MAX77843 PMIC Support"
+	depends on I2C=y
+	select MFD_CORE
+	select REGMAP_I2C
+	select REGMAP_IRQ
+	help
+	  Say yes here to add support for Maxim Semiconductor MAX77843.
+	  This is companion Power Management IC with LEDs, Haptic, Charger,
+	  Fuel Gauge, MUIC(Micro USB Interface Controller) controls on chip.
+	  This driver provides common support for accessing the device;
+	  additional drivers must be enabled in order to use the functionality
+	  of the device.
+
 config MFD_MAX8907
 	tristate "Maxim Semiconductor MAX8907 PMIC Support"
 	select MFD_CORE
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 53467e2..fe4f75c 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -117,6 +117,7 @@ obj-$(CONFIG_MFD_DA9063)	+= da9063.o
 obj-$(CONFIG_MFD_MAX14577)	+= max14577.o
 obj-$(CONFIG_MFD_MAX77686)	+= max77686.o
 obj-$(CONFIG_MFD_MAX77693)	+= max77693.o
+obj-$(CONFIG_MFD_MAX77843)	+= max77843.o
 obj-$(CONFIG_MFD_MAX8907)	+= max8907.o
 max8925-objs			:= max8925-core.o max8925-i2c.o
 obj-$(CONFIG_MFD_MAX8925)	+= max8925.o
diff --git a/drivers/mfd/max77843.c b/drivers/mfd/max77843.c
new file mode 100644
index 0000000..d7f8b76
--- /dev/null
+++ b/drivers/mfd/max77843.c
@@ -0,0 +1,241 @@
+/*
+ * max77843.c - MFD core driver for the Maxim MAX77843
+ *
+ * Copyright (C) 2014 Samsung Electrnoics
+ * Author: Jaewon Kim <jaewon02.kim@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/max77843-private.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+
+static const struct mfd_cell max77843_devs[] = {
+	{
+		.name = "max77843-muic",
+		.of_compatible = "maxim,max77843-muic",
+	}, {
+		.name = "max77843-regulator",
+		.of_compatible = "maxim,max77843-regulator",
+	}, {
+		.name = "max77843-charger",
+		.of_compatible = "maxim,max77843-charger"
+	}, {
+		.name = "max77843-fuelgauge",
+		.of_compatible = "maxim,max77843-fuelgauge",
+	},
+};
+
+static const struct regmap_config max77843_charger_regmap_config = {
+	.reg_bits	= 8,
+	.val_bits	= 8,
+	.max_register	= MAX77843_CHG_REG_END,
+};
+
+static const struct regmap_config max77843_regmap_config = {
+	.reg_bits	= 8,
+	.val_bits	= 8,
+	.max_register	= MAX77843_SYS_REG_END,
+};
+
+static const struct regmap_irq max77843_irqs[] = {
+	/* TOPSYS interrupts */
+	{ .reg_offset = 0, .mask = MAX77843_SYS_IRQ_SYSUVLO_INT, },
+	{ .reg_offset = 0, .mask = MAX77843_SYS_IRQ_SYSOVLO_INT, },
+	{ .reg_offset = 0, .mask = MAX77843_SYS_IRQ_TSHDN_INT, },
+	{ .reg_offset = 0, .mask = MAX77843_SYS_IRQ_TM_INT, },
+};
+
+static const struct regmap_irq_chip max77843_irq_chip = {
+	.name		= "max77843",
+	.status_base	= MAX77843_SYS_REG_SYSINTSRC,
+	.mask_base	= MAX77843_SYS_REG_SYSINTMASK,
+	.mask_invert	= false,
+	.num_regs	= 1,
+	.irqs		= max77843_irqs,
+	.num_irqs	= ARRAY_SIZE(max77843_irqs),
+};
+
+static int max77843_chg_init(struct max77843 *max77843)
+{
+	int ret;
+
+	max77843->i2c_chg = i2c_new_dummy(max77843->i2c->adapter, I2C_ADDR_CHG);
+	if (!max77843->i2c_chg) {
+		dev_err(&max77843->i2c->dev,
+				"Cannot allocate I2C device for Charger\n");
+		return PTR_ERR(max77843->i2c_chg);
+	}
+	i2c_set_clientdata(max77843->i2c_chg, max77843);
+
+	max77843->regmap_chg = devm_regmap_init_i2c(max77843->i2c_chg,
+			&max77843_charger_regmap_config);
+	if (IS_ERR(max77843->regmap_chg)) {
+		ret = PTR_ERR(max77843->regmap_chg);
+		goto err_chg_i2c;
+	}
+
+	return 0;
+
+err_chg_i2c:
+	i2c_unregister_device(max77843->i2c_chg);
+
+	return ret;
+}
+
+static int max77843_probe(struct i2c_client *i2c,
+					const struct i2c_device_id *id)
+{
+	struct max77843 *max77843;
+	int ret;
+	unsigned int reg_data;
+
+	max77843 = devm_kzalloc(&i2c->dev, sizeof(*max77843), GFP_KERNEL);
+	if (!max77843)
+		return -ENOMEM;
+
+	i2c_set_clientdata(i2c, max77843);
+	max77843->dev = &i2c->dev;
+	max77843->i2c = i2c;
+	max77843->irq = i2c->irq;
+
+	max77843->regmap = devm_regmap_init_i2c(i2c,
+			&max77843_regmap_config);
+	if (IS_ERR(max77843->regmap)) {
+		dev_err(&i2c->dev, "Failed to allocate topsys register map\n");
+		return PTR_ERR(max77843->regmap);
+	}
+
+	ret = regmap_add_irq_chip(max77843->regmap, max77843->irq,
+			IRQF_TRIGGER_LOW | IRQF_ONESHOT | IRQF_SHARED,
+			0, &max77843_irq_chip, &max77843->irq_data);
+	if (ret) {
+		dev_err(&i2c->dev, "Failed to add TOPSYS IRQ chip\n");
+		return ret;
+	}
+
+	ret = regmap_read(max77843->regmap,
+			MAX77843_SYS_REG_PMICID, &reg_data);
+	if (ret < 0) {
+		dev_err(&i2c->dev, "Failed to read PMIC ID\n");
+		goto err_pmic_id;
+	}
+	dev_info(&i2c->dev, "device ID: 0x%x\n", reg_data);
+
+	ret = max77843_chg_init(max77843);
+	if (ret) {
+		dev_err(&i2c->dev, "Failed to init Charger\n");
+		goto err_pmic_id;
+	}
+
+	ret = regmap_update_bits(max77843->regmap,
+			MAX77843_SYS_REG_INTSRCMASK,
+			MAX77843_INTSRC_MASK_MASK,
+			(unsigned int)~MAX77843_INTSRC_MASK_MASK);
+	if (ret < 0) {
+		dev_err(&i2c->dev, "Failed to unmask interrupt sourece\n");
+		goto err_pmic_id;
+	}
+
+	ret = mfd_add_devices(max77843->dev, -1, max77843_devs,
+			ARRAY_SIZE(max77843_devs), NULL, 0, NULL);
+	if (ret < 0) {
+		dev_err(&i2c->dev, "Failed to add mfd device\n");
+		goto err_pmic_id;
+	}
+
+	device_init_wakeup(max77843->dev, 1);
+
+	return 0;
+
+err_pmic_id:
+	regmap_del_irq_chip(max77843->irq, max77843->irq_data);
+
+	return ret;
+}
+
+static int max77843_remove(struct i2c_client *i2c)
+{
+	struct max77843 *max77843 = i2c_get_clientdata(i2c);
+
+	mfd_remove_devices(max77843->dev);
+
+	regmap_del_irq_chip(max77843->irq, max77843->irq_data);
+
+	i2c_unregister_device(max77843->i2c);
+
+	return 0;
+}
+
+static const struct of_device_id max77843_dt_match[] = {
+	{ .compatible = "maxim,max77843", },
+	{ /* sentinel */ },
+};
+
+static const struct i2c_device_id max77843_id[] = {
+	{ "max77843", },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(i2c, max77843_id);
+
+static int __maybe_unused max77843_suspend(struct device *dev)
+{
+	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
+	struct max77843 *max77843 = i2c_get_clientdata(i2c);
+
+	if (device_may_wakeup(dev))
+		enable_irq_wake(max77843->irq);
+	disable_irq(max77843->irq);
+
+	return 0;
+}
+
+static int __maybe_unused max77843_resume(struct device *dev)
+{
+	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
+	struct max77843 *max77843 = i2c_get_clientdata(i2c);
+
+	if (device_may_wakeup(dev))
+		disable_irq_wake(max77843->irq);
+	enable_irq(max77843->irq);
+
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(max77843_pm, max77843_suspend, max77843_resume);
+
+static struct i2c_driver max77843_i2c_driver = {
+	.driver		= {
+		.name		= "max77843",
+		.pm		= &max77843_pm,
+		.of_match_table = max77843_dt_match,
+	},
+	.probe		= max77843_probe,
+	.remove		= max77843_remove,
+	.id_table	= max77843_id,
+};
+static int __init max77843_i2c_init(void)
+{
+	return i2c_add_driver(&max77843_i2c_driver);
+}
+subsys_initcall(max77843_i2c_init);
+
+static void __exit max77843_i2c_exit(void)
+{
+	i2c_del_driver(&max77843_i2c_driver);
+}
+module_exit(max77843_i2c_exit);
+
+MODULE_AUTHOR("Jaewon Kim <jaewon02.kim@samsung.com>");
+MODULE_DESCRIPTION("Maxim MAX77843 multi-function core driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/max77843-private.h b/include/linux/mfd/max77843-private.h
new file mode 100644
index 0000000..560ed73
--- /dev/null
+++ b/include/linux/mfd/max77843-private.h
@@ -0,0 +1,410 @@
+/*
+ * max77843-private.h - Common API for the Maxim MAX77843 internal sub chip
+ *
+ * Copyright (C) 2014 Samsung Electrnoics
+ * Author: Jaewon Kim <jaewon02.kim@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __MAX77843_PRIVATE_H_
+#define __MAX77843_PRIVATE_H_
+
+#include <linux/i2c.h>
+#include <linux/regmap.h>
+
+#define I2C_ADDR_TOPSYS	(0xCC >> 1)
+#define I2C_ADDR_CHG	(0xD2 >> 1)
+#define I2C_ADDR_FG	(0x6C >> 1)
+#define I2C_ADDR_MUIC	(0x4A >> 1)
+
+/* Topsys, Haptic and LED registers */
+enum max77843_sys_reg {
+	MAX77843_SYS_REG_PMICID		= 0x00,
+	MAX77843_SYS_REG_PMICREV	= 0x01,
+	MAX77843_SYS_REG_MAINCTRL1	= 0x02,
+	MAX77843_SYS_REG_INTSRC		= 0x22,
+	MAX77843_SYS_REG_INTSRCMASK	= 0x23,
+	MAX77843_SYS_REG_SYSINTSRC	= 0x24,
+	MAX77843_SYS_REG_SYSINTMASK	= 0x26,
+	MAX77843_SYS_REG_TOPSYS_STAT	= 0x28,
+	MAX77843_SYS_REG_SAFEOUTCTRL	= 0xC6,
+
+	MAX77843_SYS_REG_END,
+};
+
+enum max77843_led_reg {
+	MAX77843_LED_REG_LEDEN		= 0x30,
+	MAX77843_LED_REG_LED0BRT	= 0x31,
+	MAX77843_LED_REG_LED1BRT	= 0x32,
+	MAX77843_LED_REG_LED2BRT	= 0x33,
+	MAX77843_LED_REG_LED3BRT	= 0x34,
+	MAX77843_LED_REG_LEDBLNK	= 0x38,
+	MAX77843_LED_REG_LEDRAMP	= 0x36,
+
+	MAX77843_LED_REG_END,
+};
+
+/* Charger registers */
+enum max77843_charger_reg {
+	MAX77843_CHG_REG_CHG_INT	= 0xB0,
+	MAX77843_CHG_REG_CHG_INT_MASK	= 0xB1,
+	MAX77843_CHG_REG_CHG_INT_OK	= 0xB2,
+	MAX77843_CHG_REG_CHG_DTLS_00	= 0xB3,
+	MAX77843_CHG_REG_CHG_DTLS_01	= 0xB4,
+	MAX77843_CHG_REG_CHG_DTLS_02	= 0xB5,
+	MAX77843_CHG_REG_CHG_CNFG_00	= 0xB7,
+	MAX77843_CHG_REG_CHG_CNFG_01	= 0xB8,
+	MAX77843_CHG_REG_CHG_CNFG_02	= 0xB9,
+	MAX77843_CHG_REG_CHG_CNFG_03	= 0xBA,
+	MAX77843_CHG_REG_CHG_CNFG_04	= 0xBB,
+	MAX77843_CHG_REG_CHG_CNFG_06	= 0xBD,
+	MAX77843_CHG_REG_CHG_CNFG_07	= 0xBE,
+	MAX77843_CHG_REG_CHG_CNFG_09	= 0xC0,
+	MAX77843_CHG_REG_CHG_CNFG_10	= 0xC1,
+	MAX77843_CHG_REG_CHG_CNFG_11	= 0xC2,
+	MAX77843_CHG_REG_CHG_CNFG_12	= 0xC3,
+
+	MAX77843_CHG_REG_END,
+};
+
+/* Fuel gauge registers */
+enum max77843_fuelgauge {
+	MAX77843_FG_REG_STATUS		= 0x00,
+	MAX77843_FG_REG_VALRT_TH	= 0x01,
+	MAX77843_FG_REG_TALRT_TH	= 0x02,
+	MAX77843_FG_REG_SALRT_TH	= 0x03,
+	MAX77843_FG_RATE_AT_RATE	= 0x04,
+	MAX77843_FG_REG_REMCAP_REP	= 0x05,
+	MAX77843_FG_REG_SOCREP		= 0x06,
+	MAX77843_FG_REG_AGE		= 0x07,
+	MAX77843_FG_REG_TEMP		= 0x08,
+	MAX77843_FG_REG_VCELL		= 0x09,
+	MAX77843_FG_REG_CURRENT		= 0x0A,
+	MAX77843_FG_REG_AVG_CURRENT	= 0x0B,
+	MAX77843_FG_REG_SOCMIX		= 0x0D,
+	MAX77843_FG_REG_SOCAV		= 0x0E,
+	MAX77843_FG_REG_REMCAP_MIX	= 0x0F,
+	MAX77843_FG_REG_FULLCAP		= 0x10,
+	MAX77843_FG_REG_AVG_TEMP	= 0x16,
+	MAX77843_FG_REG_CYCLES		= 0x17,
+	MAX77843_FG_REG_AVG_VCELL	= 0x19,
+	MAX77843_FG_REG_CONFIG		= 0x1D,
+	MAX77843_FG_REG_REMCAP_AV	= 0x1F,
+	MAX77843_FG_REG_FULLCAP_NOM	= 0x23,
+	MAX77843_FG_REG_MISCCFG		= 0x2B,
+	MAX77843_FG_REG_RCOMP		= 0x38,
+	MAX77843_FG_REG_FSTAT		= 0x3D,
+	MAX77843_FG_REG_DQACC		= 0x45,
+	MAX77843_FG_REG_DPACC		= 0x46,
+	MAX77843_FG_REG_OCV		= 0xEE,
+	MAX77843_FG_REG_VFOCV		= 0xFB,
+	MAX77843_FG_SOCVF		= 0xFF,
+
+	MAX77843_FG_END,
+};
+
+/* Muic registers */
+enum max77843_muic_reg {
+	MAX77843_MUIC_REG_ID		= 0x00,
+	MAX77843_MUIC_REG_INT1		= 0x01,
+	MAX77843_MUIC_REG_INT2		= 0x02,
+	MAX77843_MUIC_REG_INT3		= 0x03,
+	MAX77843_MUIC_REG_STATUS1	= 0x04,
+	MAX77843_MUIC_REG_STATUS2	= 0x05,
+	MAX77843_MUIC_REG_STATUS3	= 0x06,
+	MAX77843_MUIC_REG_INTMASK1	= 0x07,
+	MAX77843_MUIC_REG_INTMASK2	= 0x08,
+	MAX77843_MUIC_REG_INTMASK3	= 0x09,
+	MAX77843_MUIC_REG_CDETCTRL1	= 0x0A,
+	MAX77843_MUIC_REG_CDETCTRL2	= 0x0B,
+	MAX77843_MUIC_REG_CONTROL1	= 0x0C,
+	MAX77843_MUIC_REG_CONTROL2	= 0x0D,
+	MAX77843_MUIC_REG_CONTROL3	= 0x0E,
+	MAX77843_MUIC_REG_CONTROL4	= 0x16,
+	MAX77843_MUIC_REG_HVCONTROL1	= 0x17,
+	MAX77843_MUIC_REG_HVCONTROL2	= 0x18,
+
+	MAX77843_MUIC_REG_END,
+};
+
+enum max77843_irq {
+	/* Topsys: SYSTEM */
+	MAX77843_SYS_IRQ_SYSINTSRC_SYSUVLO_INT,
+	MAX77843_SYS_IRQ_SYSINTSRC_SYSOVLO_INT,
+	MAX77843_SYS_IRQ_SYSINTSRC_TSHDN_INT,
+	MAX77843_SYS_IRQ_SYSINTSRC_TM_INT,
+
+	/* Charger: CHG_INT */
+	MAX77843_CHG_IRQ_CHG_INT_BYP_I,
+	MAX77843_CHG_IRQ_CHG_INT_BATP_I,
+	MAX77843_CHG_IRQ_CHG_INT_BAT_I,
+	MAX77843_CHG_IRQ_CHG_INT_CHG_I,
+	MAX77843_CHG_IRQ_CHG_INT_WCIN_I,
+	MAX77843_CHG_IRQ_CHG_INT_CHGIN_I,
+	MAX77843_CHG_IRQ_CHG_INT_AICL_I,
+
+	MAX77843_IRQ_NUM,
+};
+
+enum max77843_irq_muic {
+	/* MUIC: INT1 */
+	MAX77843_MUIC_IRQ_INT1_ADC,
+	MAX77843_MUIC_IRQ_INT1_ADCERROR,
+	MAX77843_MUIC_IRQ_INT1_ADC1K,
+
+	/* MUIC: INT2 */
+	MAX77843_MUIC_IRQ_INT2_CHGTYP,
+	MAX77843_MUIC_IRQ_INT2_CHGDETRUN,
+	MAX77843_MUIC_IRQ_INT2_DCDTMR,
+	MAX77843_MUIC_IRQ_INT2_DXOVP,
+	MAX77843_MUIC_IRQ_INT2_VBVOLT,
+
+	/* MUIC: INT3 */
+	MAX77843_MUIC_IRQ_INT3_VBADC,
+	MAX77843_MUIC_IRQ_INT3_VDNMON,
+	MAX77843_MUIC_IRQ_INT3_DNRES,
+	MAX77843_MUIC_IRQ_INT3_MPNACK,
+	MAX77843_MUIC_IRQ_INT3_MRXBUFOW,
+	MAX77843_MUIC_IRQ_INT3_MRXTRF,
+	MAX77843_MUIC_IRQ_INT3_MRXPERR,
+	MAX77843_MUIC_IRQ_INT3_MRXRDY,
+
+	MAX77843_MUIC_IRQ_NUM,
+};
+
+/* MAX77843 interrupts */
+#define MAX77843_SYS_IRQ_SYSUVLO_INT		BIT(0)
+#define MAX77843_SYS_IRQ_SYSOVLO_INT		BIT(1)
+#define MAX77843_SYS_IRQ_TSHDN_INT		BIT(2)
+#define MAX77843_SYS_IRQ_TM_INT			BIT(3)
+
+/* Max77843 charger insterrupts */
+#define MAX77843_CHG_BYP_I			BIT(0)
+#define MAX77843_CHG_BATP_I			BIT(2)
+#define MAX77843_CHG_BAT_I			BIT(3)
+#define MAX77843_CHG_CHG_I			BIT(4)
+#define MAX77843_CHG_WCIN_I			BIT(5)
+#define MAX77843_CHG_CHGIN_I			BIT(6)
+#define MAX77843_CHG_AICL_I			BIT(7)
+
+/* MAX77843 CHG_INT_OK register */
+#define MAX77843_CHG_BYP_OK			BIT(0)
+#define MAX77843_CHG_BATP_OK			BIT(2)
+#define MAX77843_CHG_BAT_OK			BIT(3)
+#define MAX77843_CHG_CHG_OK			BIT(4)
+#define MAX77843_CHG_WCIN_OK			BIT(5)
+#define MAX77843_CHG_CHGIN_OK			BIT(6)
+#define MAX77843_CHG_AICL_OK			BIT(7)
+
+/* MAX77843 CHG_DETAILS_00 register */
+#define MAX77843_CHG_BAT_DTLS			BIT(0)
+
+/* MAX77843 CHG_DETAILS_01 register */
+#define MAX77843_CHG_DTLS_MASK			0x0f
+#define MAX77843_CHG_PQ_MODE			0x00
+#define MAX77843_CHG_CC_MODE			0x01
+#define MAX77843_CHG_CV_MODE			0x02
+#define MAX77843_CHG_TO_MODE			0x03
+#define MAX77843_CHG_DO_MODE			0x04
+#define MAX77843_CHG_HT_MODE			0x05
+#define MAX77843_CHG_TF_MODE			0x06
+#define MAX77843_CHG_TS_MODE			0x07
+#define MAX77843_CHG_OFF_MODE			0x08
+
+#define MAX77843_CHG_BAT_DTLS_MASK		0xf0
+#define MAX77843_CHG_NO_BAT			(0x00 << 4)
+#define MAX77843_CHG_LOW_VOLT_BAT		(0x01 << 4)
+#define MAX77843_CHG_LONG_BAT_TIME		(0x02 << 4)
+#define MAX77843_CHG_OK_BAT			(0x03 << 4)
+#define MAX77843_CHG_OK_LOW_VOLT_BAT		(0x04 << 4)
+#define MAX77843_CHG_OVER_VOLT_BAT		(0x05 << 4)
+#define MAX77843_CHG_OVER_CURRENT_BAT		(0x06 << 4)
+
+/* MAX77843 CHG_CNFG_00 register */
+#define MAX77843_CHG_DISABLE			0x00
+#define MAX77843_CHG_ENABLE			0x05
+#define MAX77843_CHG_MASK			0x01
+#define MAX77843_CHG_BUCK_MASK			0x04
+
+/* MAX77843 CHG_CNFG_01 register */
+#define MAX77843_CHG_RESTART_THRESHOLD_100	0x00
+#define MAX77843_CHG_RESTART_THRESHOLD_150	0x10
+#define MAX77843_CHG_RESTART_THRESHOLD_200	0x20
+#define MAX77843_CHG_RESTART_THRESHOLD_DISABLE	0x30
+
+/* MAX77843 CHG_CNFG_02 register */
+#define MAX77843_CHG_FAST_CHG_CURRENT_MIN	100000
+#define MAX77843_CHG_FAST_CHG_CURRENT_MAX	3150000
+#define MAX77843_CHG_FAST_CHG_CURRENT_STEP	50000
+#define MAX77843_CHG_FAST_CHG_CURRENT_MASK	0x3f
+#define MAX77843_CHG_OTG_ILIMIT_500		(0x00 << 6)
+#define MAX77843_CHG_OTG_ILIMIT_900		(0x01 << 6)
+#define MAX77843_CHG_OTG_ILIMIT_1200		(0x02 << 6)
+#define MAX77843_CHG_OTG_ILIMIT_1500		(0x03 << 6)
+#define MAX77843_CHG_OTG_ILIMIT_MASK		0xc0
+
+/* MAX77843 CHG_CNFG_03 register */
+#define MAX77843_CHG_TOP_OFF_CURRENT_MIN	125000
+#define MAX77843_CHG_TOP_OFF_CURRENT_MAX	650000
+#define MAX77843_CHG_TOP_OFF_CURRENT_STEP	75000
+#define MAX77843_CHG_TOP_OFF_CURRENT_MASK	0x07
+
+/* MAX77843 CHG_CNFG_06 register */
+#define MAX77843_CHG_WRITE_CAP_BLOCK		0x10
+#define MAX77843_CHG_WRITE_CAP_UNBLOCK		0x0C
+
+/* MAX77843_CHG_CNFG_09_register */
+#define MAX77843_CHG_INPUT_CURRENT_LIMIT_MIN	100000
+#define MAX77843_CHG_INPUT_CURRENT_LIMIT_MAX	4000000
+#define MAX77843_CHG_INPUT_CURRENT_LIMIT_REF	3367000
+#define MAX77843_CHG_INPUT_CURRENT_LIMIT_STEP	33000
+
+#define MAX77843_MUIC_ADC			BIT(0)
+#define MAX77843_MUIC_ADCERROR			BIT(2)
+#define MAX77843_MUIC_ADC1K			BIT(3)
+
+#define MAX77843_MUIC_CHGTYP			BIT(0)
+#define MAX77843_MUIC_CHGDETRUN			BIT(1)
+#define MAX77843_MUIC_DCDTMR			BIT(2)
+#define MAX77843_MUIC_DXOVP			BIT(3)
+#define MAX77843_MUIC_VBVOLT			BIT(4)
+
+#define MAX77843_MUIC_VBADC			BIT(0)
+#define MAX77843_MUIC_VDNMON			BIT(1)
+#define MAX77843_MUIC_DNRES			BIT(2)
+#define MAX77843_MUIC_MPNACK			BIT(3)
+#define MAX77843_MUIC_MRXBUFOW			BIT(4)
+#define MAX77843_MUIC_MRXTRF			BIT(5)
+#define MAX77843_MUIC_MRXPERR			BIT(6)
+#define MAX77843_MUIC_MRXRDY			BIT(7)
+
+/* MAX77843 INTSRCMASK register */
+#define MAX77843_INTSRCMASK_CHGR		0
+#define MAX77843_INTSRCMASK_SYS			1
+#define MAX77843_INTSRCMASK_FG			2
+#define MAX77843_INTSRCMASK_MUIC		3
+
+#define MAX77843_INTSRCMASK_CHGR_MASK          BIT(MAX77843_INTSRCMASK_CHGR)
+#define MAX77843_INTSRCMASK_SYS_MASK           BIT(MAX77843_INTSRCMASK_SYS)
+#define MAX77843_INTSRCMASK_FG_MASK            BIT(MAX77843_INTSRCMASK_FG)
+#define MAX77843_INTSRCMASK_MUIC_MASK          BIT(MAX77843_INTSRCMASK_MUIC)
+
+#define MAX77843_INTSRC_MASK_MASK \
+		(MAX77843_INTSRCMASK_MUIC_MASK | MAX77843_INTSRCMASK_FG_MASK | \
+		MAX77843_INTSRCMASK_SYS_MASK | MAX77843_INTSRCMASK_CHGR_MASK)
+
+/* MAX77843 STATUS register*/
+#define STATUS1_ADC_SHIFT			0
+#define STATUS1_ADCERROR_SHIFT			6
+#define STATUS1_ADC1K_SHIFT			7
+#define STATUS2_CHGTYP_SHIFT			0
+#define STATUS2_CHGDETRUN_SHIFT			3
+#define STATUS2_DCDTMR_SHIFT			4
+#define STATUS2_DXOVP_SHIFT			5
+#define STATUS2_VBVOLT_SHIFT			6
+#define STATUS3_VBADC_SHIFT			0
+#define STATUS3_VDNMON_SHIFT			4
+#define STATUS3_DNRES_SHIFT			5
+#define STATUS3_MPNACK_SHIFT			6
+
+#define MAX77843_MUIC_STATUS1_ADC_MASK		(0x1f << STATUS1_ADC_SHIFT)
+#define MAX77843_MUIC_STATUS1_ADCERROR_MASK	BIT(STATUS1_ADCERROR_SHIFT)
+#define MAX77843_MUIC_STATUS1_ADC1K_MASK	BIT(STATUS1_ADC1K_SHIFT)
+#define MAX77843_MUIC_STATUS2_CHGTYP_MASK	(0x7 << STATUS2_CHGTYP_SHIFT)
+#define MAX77843_MUIC_STATUS2_CHGDETRUN_MASK	BIT(STATUS2_CHGDETRUN_SHIFT)
+#define MAX77843_MUIC_STATUS2_DCDTMR_MASK	BIT(STATUS2_DCDTMR_SHIFT)
+#define MAX77843_MUIC_STATUS2_DXOVP_MASK	BIT(STATUS2_DXOVP_SHIFT)
+#define MAX77843_MUIC_STATUS2_VBVOLT_MASK	BIT(STATUS2_VBVOLT_SHIFT)
+#define MAX77843_MUIC_STATUS3_VBADC_MASK	(0xf << STATUS3_VBADC_SHIFT)
+#define MAX77843_MUIC_STATUS3_VDNMON_MASK	BIT(STATUS3_VDNMON_SHIFT)
+#define MAX77843_MUIC_STATUS3_DNRES_MASK	BIT(STATUS3_DNRES_SHIFT)
+#define MAX77843_MUIC_STATUS3_MPNACK_MASK	BIT(STATUS3_MPNACK_SHIFT)
+
+/* MAX77843 CONTROL register */
+#define CONTROL1_COMP1SW_SHIFT			0
+#define CONTROL1_COMP2SW_SHIFT			3
+#define CONTROL1_IDBEN_SHIFT			7
+#define CONTROL2_LOWPWR_SHIFT			0
+#define CONTROL2_ADCEN_SHIFT			1
+#define CONTROL2_CPEN_SHIFT			2
+#define CONTROL2_ACC_DET_SHIFT			5
+#define CONTROL2_USBCPINT_SHIFT			6
+#define CONTROL2_RCPS_SHIFT			7
+#define CONTROL3_JIGSET_SHIFT			0
+#define CONTROL4_ADCDBSET_SHIFT			0
+#define CONTROL4_USBAUTO_SHIFT			4
+#define CONTROL4_FCTAUTO_SHIFT			5
+#define CONTROL4_ADCMODE_SHIFT			6
+
+#define MAX77843_MUIC_CONTROL1_COMP1SW_MASK	(0x7 << CONTROL1_COMP1SW_SHIFT)
+#define MAX77843_MUIC_CONTROL1_COMP2SW_MASK	(0x7 << CONTROL1_COMP2SW_SHIFT)
+#define MAX77843_MUIC_CONTROL1_IDBEN_MASK	BIT(CONTROL1_IDBEN_SHIFT)
+#define MAX77843_MUIC_CONTROL2_LOWPWR_MASK	BIT(CONTROL2_LOWPWR_SHIFT)
+#define MAX77843_MUIC_CONTROL2_ADCEN_MASK	BIT(CONTROL2_ADCEN_SHIFT)
+#define MAX77843_MUIC_CONTROL2_CPEN_MASK	BIT(CONTROL2_CPEN_SHIFT)
+#define MAX77843_MUIC_CONTROL2_ACC_DET_MASK	BIT(CONTROL2_ACC_DET_SHIFT)
+#define MAX77843_MUIC_CONTROL2_USBCPINT_MASK	BIT(CONTROL2_USBCPINT_SHIFT)
+#define MAX77843_MUIC_CONTROL2_RCPS_MASK	BIT(CONTROL2_RCPS_SHIFT)
+#define MAX77843_MUIC_CONTROL3_JIGSET_MASK	(0x3 << CONTROL3_JIGSET_SHIFT)
+#define MAX77843_MUIC_CONTROL4_ADCDBSET_MASK	(0x3 << CONTROL4_ADCDBSET_SHIFT)
+#define MAX77843_MUIC_CONTROL4_USBAUTO_MASK	BIT(CONTROL4_USBAUTO_SHIFT)
+#define MAX77843_MUIC_CONTROL4_FCTAUTO_MASK	BIT(CONTROL4_FCTAUTO_SHIFT)
+#define MAX77843_MUIC_CONTROL4_ADCMODE_MASK	(0x3 << CONTROL4_ADCMODE_SHIFT)
+
+/* MAX77843 switch port */
+#define MAX77843_SIWTH_PORT \
+(MAX77843_MUIC_CONTROL1_COMP1SW_MASK | MAX77843_MUIC_CONTROL1_COMP2SW_MASK)
+
+#define MAX77843_SWITCH_OPEN \
+		(0 << CONTROL1_COMP1SW_SHIFT | 0 << CONTROL1_COMP2SW_SHIFT)
+#define MAX77843_SWITCH_USB \
+		(1 << CONTROL1_COMP1SW_SHIFT | 1 << CONTROL1_COMP2SW_SHIFT)
+#define MAX77843_SWITCH_AUDIO \
+		(2 << CONTROL1_COMP1SW_SHIFT | 2 << CONTROL1_COMP2SW_SHIFT)
+#define MAX77843_SWITCH_UART \
+		(3 << CONTROL1_COMP1SW_SHIFT | 3 << CONTROL1_COMP2SW_SHIFT)
+#define MAX77843_SWITCH_AUX_USB \
+		(4 << CONTROL1_COMP1SW_SHIFT | 4 << CONTROL1_COMP2SW_SHIFT)
+#define MAX77843_SWITCH_AUX_UART \
+		(5 << CONTROL1_COMP1SW_SHIFT | 5 << CONTROL1_COMP2SW_SHIFT)
+
+/* MAX77843 SAFEOUT LDO Control register */
+#define SAFEOUTCTRL_SAFEOUT1_SHIFT		0
+#define SAFEOUTCTRL_SAFEOUT2_SHIFT		2
+#define SAFEOUTCTRL_ENSAFEOUT1_SHIFT		6
+#define SAFEOUTCTRL_ENSAFEOUT2_SHIFT		7
+
+#define MAX77843_REG_SAFEOUTCTRL_ENSAFEOUT1 \
+		BIT(SAFEOUTCTRL_ENSAFEOUT1_SHIFT)
+#define MAX77843_REG_SAFEOUTCTRL_ENSAFEOUT2 \
+		BIT(SAFEOUTCTRL_ENSAFEOUT2_SHIFT)
+#define MAX77843_REG_SAFEOUTCTRL_SAFEOUT1_MASK \
+		(0x3 << SAFEOUTCTRL_SAFEOUT1_SHIFT)
+#define MAX77843_REG_SAFEOUTCTRL_SAFEOUT2_MASK \
+		(0x3 << SAFEOUTCTRL_SAFEOUT2_SHIFT)
+
+struct max77843 {
+	struct device *dev;
+
+	struct i2c_client *i2c;
+	struct i2c_client *i2c_chg;
+	struct i2c_client *i2c_fuel;
+	struct i2c_client *i2c_muic;
+
+	struct regmap *regmap;
+	struct regmap *regmap_chg;
+	struct regmap *regmap_fuel;
+	struct regmap *regmap_muic;
+
+	struct regmap_irq_chip_data *irq_data;
+	struct regmap_irq_chip_data *irq_data_chg;
+	struct regmap_irq_chip_data *irq_data_fuel;
+	struct regmap_irq_chip_data *irq_data_muic;
+
+	int irq;
+};
+#endif /* __MAX77843_H__ */
-- 
1.7.9.5

