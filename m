Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab3KTOMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 09:12:42 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:63135 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab3KTOMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 09:12:33 -0500
X-AuditID: cbfec7f4-b7fee6d000004b2d-4f-528cc34f79fe
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 1/5] mfd: max14577: Add max14577 MFD driver core
Date: Wed, 20 Nov 2013 15:12:08 +0100
Message-id: <1384956732-19526-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1384956732-19526-1-git-send-email-k.kozlowski@samsung.com>
References: <1384956732-19526-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xK7r+h3uCDM4eFrQ4uFXTYuOM9awW
	Ux8+YbO4/uU5q8X8I+dYLSaunMxsceDPDkaLc69WMlq8fmFocbbpDbvF/a9HGS2+Xelgstj0
	+BqrxcK2JSwWl3fNYbNYe+Quu8XtxhVsFhOmr2WxOLziAJPFupfTWSxOd7NavDrYxuIg5rFm
	3hpGjwWfr7B7TOj/xOixc9Zddo+Vy7+weWxeoeWxaVUnm8er1TNZPe5c28PmMe9koMfmJfUe
	fVtWMXp83iTnsXFuaABfFJdNSmpOZllqkb5dAlfGvUdnGQsePGGsuDppHWMD44x9jF2MHBwS
	AiYSl79GdTFyApliEhfurWfrYuTiEBJYyihxpvE+C4TTxyRx+O5vFpAqNgFjic3Ll4BViQjM
	YZXYfeYZWBWzwFFGibedu5hAqoQFnCU+LLjDBmKzCKhKNHw6xgSyjlfAXWLaNBuIzQoScybZ
	gFRwCnhIrFk8mxnEFgKqePtoH8sERt4FjAyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3MUJi
	58sOxsXHrA4xCnAwKvHwSizoDhJiTSwrrsw9xCjBwawkwtu1tydIiDclsbIqtSg/vqg0J7X4
	ECMTB6dUA+P6mHy5ir3ln2SFj75tOCXD353UH7jziMehpZb5wZPfv7+aw1Vf1MM/N+nNgvyU
	RsYtaR+YT8v+EDun33lH/VC00eIVfNdvyk1as9laX/TF0fKFDybu/vH5mlee4TndU1Nj0su6
	TZfLrM7Q7M48fWrrJ76HKSzyIhHPH3d/e1LI+tsnzPlQzzslluKMREMt5qLiRADhOEXQewIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chanwoo Choi <cw00.choi@samsung.com>

This patch adds max14577 core/irq driver to support MUIC(Micro USB IC)
device and charger device and support irq domain method to control
internal interrupt of max14577 device. Also, this patch supports DT
binding with max14577_i2c_parse_dt().

The MAXIM 14577 chip contains Micro-USB Interface Circuit and Li+ Battery
Charger. It contains accessory and USB charger detection logic. It supports
USB 2.0 Hi-Speed, UART and stereo audio signals over Micro-USB connector.

The battery charger is compliant with the USB Battery Charging Specification
Revision 1.1. It has also SFOUT LDO output for powering USB devices.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mfd/Kconfig                  |   13 ++
 drivers/mfd/Makefile                 |    1 +
 drivers/mfd/max14577-irq.c           |  245 ++++++++++++++++++++++++++
 drivers/mfd/max14577.c               |  216 +++++++++++++++++++++++
 include/linux/mfd/max14577-private.h |  317 ++++++++++++++++++++++++++++++++++
 include/linux/mfd/max14577.h         |   72 ++++++++
 6 files changed, 864 insertions(+)
 create mode 100644 drivers/mfd/max14577-irq.c
 create mode 100644 drivers/mfd/max14577.c
 create mode 100644 include/linux/mfd/max14577-private.h
 create mode 100644 include/linux/mfd/max14577.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 62a60ca..3da452a4 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -321,6 +321,19 @@ config MFD_88PM860X
 	  select individual components like voltage regulators, RTC and
 	  battery-charger under the corresponding menus.
 
+config MFD_MAX14577
+	bool "Maxim Semiconductor MAX14577 MUIC + Charger Support"
+	depends on I2C=y
+	select MFD_CORE
+	select REGMAP_I2C
+	select IRQ_DOMAIN
+	help
+	  Say yes here to support for Maxim Semiconductor MAX14577.
+	  This is a Micro-USB IC with Charger controls on chip.
+	  This driver provides common support for accessing the device;
+	  additional drivers must be enabled in order to use the functionality
+	  of the device.
+
 config MFD_MAX77686
 	bool "Maxim Semiconductor MAX77686 PMIC Support"
 	depends on I2C=y
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 8a28dc9..3feaffc 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -110,6 +110,7 @@ obj-$(CONFIG_MFD_DA9055)	+= da9055.o
 da9063-objs			:= da9063-core.o da9063-irq.o da9063-i2c.o
 obj-$(CONFIG_MFD_DA9063)	+= da9063.o
 
+obj-$(CONFIG_MFD_MAX14577)	+= max14577.o max14577-irq.o
 obj-$(CONFIG_MFD_MAX77686)	+= max77686.o max77686-irq.o
 obj-$(CONFIG_MFD_MAX77693)	+= max77693.o max77693-irq.o
 obj-$(CONFIG_MFD_MAX8907)	+= max8907.o
diff --git a/drivers/mfd/max14577-irq.c b/drivers/mfd/max14577-irq.c
new file mode 100644
index 0000000..bbb6356
--- /dev/null
+++ b/drivers/mfd/max14577-irq.c
@@ -0,0 +1,245 @@
+/*
+ * max14577-irq.c - MFD Interrupt controller support for MAX14577
+ *
+ * Copyright (C) 2013 Samsung Electronics Co.Ltd
+ * Chanwoo Choi <cw00.choi@samsung.com>
+ * Krzysztof Kozlowski <k.kozlowski@samsung.com>
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
+ * This driver is based on max8997-irq.c
+ */
+
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/irqdomain.h>
+#include <linux/mfd/max14577.h>
+#include <linux/mfd/max14577-private.h>
+
+/**
+ * After resuming from suspend it may happen that IRQ is signalled but
+ * IRQ GPIO is not high. Also the interrupt registers won't have any data
+ * (all of them equal to 0x00).
+ *
+ * In such case retry few times reading the interrupt registers.
+ */
+#define IRQ_READ_REG_RETRY_CNT		5
+
+static const u8 max14577_mask_reg[] = {
+	[MAX14577_IRQ_INT1] = MAX14577_REG_INTMASK1,
+	[MAX14577_IRQ_INT2] = MAX14577_REG_INTMASK2,
+	[MAX14577_IRQ_INT3] = MAX14577_REG_INTMASK3,
+};
+
+struct max14577_irq_data {
+	int mask;
+	enum max14577_irq_source group;
+};
+
+#define DECLARE_IRQ(idx, _group, _mask)		\
+	[(idx)] = { .group = (_group), .mask = (_mask) }
+static const struct max14577_irq_data max14577_irqs[] = {
+	DECLARE_IRQ(MAX14577_IRQ_INT1_ADC,		MAX14577_IRQ_INT1, 1 << 0),
+	DECLARE_IRQ(MAX14577_IRQ_INT1_ADCLOW,		MAX14577_IRQ_INT1, 1 << 1),
+	DECLARE_IRQ(MAX14577_IRQ_INT1_ADCERR,		MAX14577_IRQ_INT1, 1 << 2),
+
+	DECLARE_IRQ(MAX14577_IRQ_INT2_CHGTYP,		MAX14577_IRQ_INT2, 1 << 0),
+	DECLARE_IRQ(MAX14577_IRQ_INT2_CHGDETRUN,	MAX14577_IRQ_INT2, 1 << 1),
+	DECLARE_IRQ(MAX14577_IRQ_INT2_DCDTMR,		MAX14577_IRQ_INT2, 1 << 2),
+	DECLARE_IRQ(MAX14577_IRQ_INT2_DBCHG,		MAX14577_IRQ_INT2, 1 << 3),
+	DECLARE_IRQ(MAX14577_IRQ_INT2_VBVOLT,		MAX14577_IRQ_INT2, 1 << 4),
+
+	DECLARE_IRQ(MAX14577_IRQ_INT3_EOC,		MAX14577_IRQ_INT3, 1 << 0),
+	DECLARE_IRQ(MAX14577_IRQ_INT3_CGMBC,		MAX14577_IRQ_INT3, 1 << 1),
+	DECLARE_IRQ(MAX14577_IRQ_INT3_OVP,		MAX14577_IRQ_INT3, 1 << 2),
+	DECLARE_IRQ(MAX14577_IRQ_INT3_MBCCHGERR,	MAX14577_IRQ_INT3, 1 << 3),
+};
+
+static void max14577_irq_lock(struct irq_data *data)
+{
+	struct max14577 *max14577 = irq_get_chip_data(data->irq);
+
+	mutex_lock(&max14577->irq_lock);
+}
+
+static void max14577_irq_sync_unlock(struct irq_data *data)
+{
+	struct max14577 *max14577 = irq_get_chip_data(data->irq);
+	int i;
+
+	for (i = 0; i < MAX14577_IRQ_REGS_NUM; i++) {
+		u8 mask_reg = max14577_mask_reg[i];
+
+		if (mask_reg == MAX14577_REG_INVALID)
+			continue;
+
+		max14577->irq_masks_cache[i] = max14577->irq_masks_cur[i];
+
+		max14577_write_reg(max14577->regmap, max14577_mask_reg[i],
+				max14577->irq_masks_cur[i]);
+	}
+
+	mutex_unlock(&max14577->irq_lock);
+}
+
+static const inline struct max14577_irq_data *
+irq_to_max14577_irq(struct max14577 *max14577, int irq)
+{
+	struct irq_data *data = irq_get_irq_data(irq);
+	return &max14577_irqs[data->hwirq];
+}
+
+static void max14577_irq_mask(struct irq_data *data)
+{
+	struct max14577 *max14577 = irq_get_chip_data(data->irq);
+	const struct max14577_irq_data *irq_data =
+	    irq_to_max14577_irq(max14577, data->irq);
+
+	if (!irq_data)
+		return;
+
+	if (irq_data->group >= MAX14577_IRQ_REGS_NUM)
+		return;
+
+	max14577->irq_masks_cur[irq_data->group] &= ~irq_data->mask;
+}
+
+static void max14577_irq_unmask(struct irq_data *data)
+{
+	struct max14577 *max14577 = irq_get_chip_data(data->irq);
+	const struct max14577_irq_data *irq_data =
+	    irq_to_max14577_irq(max14577, data->irq);
+
+	if (!irq_data)
+		return;
+
+	if (irq_data->group >= MAX14577_IRQ_REGS_NUM)
+		return;
+
+	max14577->irq_masks_cur[irq_data->group] |= irq_data->mask;
+}
+
+static struct irq_chip max14577_irq_chip = {
+	.name			= MAX14577_MFD_DEV_NAME,
+	.irq_bus_lock		= max14577_irq_lock,
+	.irq_bus_sync_unlock	= max14577_irq_sync_unlock,
+	.irq_mask		= max14577_irq_mask,
+	.irq_unmask		= max14577_irq_unmask,
+};
+
+static irqreturn_t max14577_irq_thread(int irq, void *data)
+{
+	struct max14577 *max14577 = data;
+	u8 irq_reg[MAX14577_IRQ_REGS_NUM] = {0};
+	u8 tmp_irq_reg[MAX14577_IRQ_REGS_NUM] = {};
+	int i, cur_irq;
+
+	max14577_bulk_read(max14577->regmap, MAX14577_REG_INT1,
+			&tmp_irq_reg[MAX14577_IRQ_INT1],
+			MAX14577_IRQ_REGS_NUM);
+
+	for (i = MAX14577_IRQ_INT1; i < MAX14577_IRQ_REGS_NUM; i++)
+		irq_reg[i] |= tmp_irq_reg[i];
+
+	for (i = 0; i < MAX14577_IRQ_REGS_NUM; i++)
+		irq_reg[i] &= max14577->irq_masks_cur[i];
+
+	for (i = 0; i < MAX14577_IRQ_NUM; i++) {
+		if (irq_reg[max14577_irqs[i].group] & max14577_irqs[i].mask) {
+			cur_irq = irq_find_mapping(max14577->irq_domain, i);
+			if (cur_irq)
+				handle_nested_irq(cur_irq);
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int max14577_irq_domain_map(struct irq_domain *d, unsigned int irq,
+				irq_hw_number_t hw)
+{
+	struct max14577 *max14577 = d->host_data;
+
+	irq_set_chip_data(irq, max14577);
+	irq_set_chip_and_handler(irq, &max14577_irq_chip, handle_edge_irq);
+	irq_set_nested_thread(irq, 1);
+#ifdef CONFIG_ARM
+	set_irq_flags(irq, IRQF_VALID);
+#else
+	irq_set_noprobe(irq);
+#endif
+	return 0;
+}
+
+static struct irq_domain_ops max14577_irq_domain_ops = {
+	.map = max14577_irq_domain_map,
+};
+
+int max14577_irq_init(struct max14577 *max14577)
+{
+	struct irq_domain *domain;
+	int i, ret;
+
+	mutex_init(&max14577->irq_lock);
+
+	/* Mask individual interrupt sources */
+	for (i = 0; i < MAX14577_IRQ_REGS_NUM; i++) {
+		/* IRQ  0:MASK 1:NOT MASK */
+		max14577->irq_masks_cur[i] = 0x00;
+		max14577->irq_masks_cache[i] = 0x00;
+
+		if (max14577_mask_reg[i] == MAX14577_REG_INVALID)
+			continue;
+
+		max14577_write_reg(max14577->regmap, max14577_mask_reg[i],
+				max14577->irq_masks_cur[i]);
+	}
+
+	domain = irq_domain_add_linear(NULL, MAX14577_IRQ_NUM,
+					&max14577_irq_domain_ops, max14577);
+	if (!domain) {
+		dev_err(max14577->dev, "Could not create IRQ domain\n");
+		ret = -ENODEV;
+		goto err;
+	}
+	max14577->irq_domain = domain;
+
+	ret = request_threaded_irq(max14577->irq, NULL, max14577_irq_thread,
+				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+				   "max14577-irq", max14577);
+	if (ret) {
+		dev_err(max14577->dev, "Failed to request IRQ %d: %d\n",
+				max14577->irq, ret);
+		goto err;
+	}
+
+	return 0;
+err:
+	mutex_destroy(&max14577->irq_lock);
+	return ret;
+}
+
+int max14577_irq_resume(struct max14577 *max14577)
+{
+	int ret = 0;
+
+	if (max14577->irq && max14577->irq_domain)
+		ret = max14577_irq_thread(0, max14577);
+
+	return ret >= 0 ? 0 : ret;
+}
+
+void max14577_irq_exit(struct max14577 *max14577)
+{
+	if (max14577->irq)
+		free_irq(max14577->irq, max14577);
+	mutex_destroy(&max14577->irq_lock);
+}
diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
new file mode 100644
index 0000000..bfc4eb5
--- /dev/null
+++ b/drivers/mfd/max14577.c
@@ -0,0 +1,216 @@
+/*
+ * max14577.c - mfd core driver for the Maxim 14577
+ *
+ * Copyright (C) 2013 Samsung Electrnoics
+ * Chanwoo Choi <cw00.choi@samsung.com>
+ * Krzysztof Kozlowski <k.kozlowski@samsung.com>
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
+ * This driver is based on max8997.c
+ */
+
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/max14577.h>
+#include <linux/mfd/max14577-private.h>
+
+static struct mfd_cell max14577_devs[] = {
+	{ .name = "max14577-muic", },
+	{ .name = "max14577-regulator", },
+	{ .name = "max14577-charger", },
+};
+
+static bool max14577_volatile_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case MAX14577_REG_INT1 ... MAX14577_REG_STATUS3:
+		return true;
+	default:
+		break;
+	}
+	return false;
+}
+
+static const struct regmap_config max14577_regmap_config = {
+	.reg_bits	= 8,
+	.val_bits	= 8,
+	.volatile_reg	= max14577_volatile_reg,
+	.max_register	= MAX14577_REG_END,
+};
+
+static int max14577_i2c_probe(struct i2c_client *i2c,
+			      const struct i2c_device_id *id)
+{
+	struct max14577 *max14577;
+	struct max14577_platform_data *pdata = dev_get_platdata(&i2c->dev);
+	u8 reg_data;
+	int ret = 0;
+
+	if (i2c->dev.of_node) {
+		pdata = devm_kzalloc(&i2c->dev,
+				sizeof(struct max14577_platform_data),
+				GFP_KERNEL);
+		if (!pdata)
+			return -ENOMEM;
+		i2c->dev.platform_data = pdata;
+	}
+
+	if (IS_ERR_OR_NULL(pdata)) {
+		dev_err(&i2c->dev, "No platform data found: %ld\n",
+				PTR_ERR(pdata));
+		return -EINVAL;
+	}
+
+	max14577 = devm_kzalloc(&i2c->dev, sizeof(struct max14577), GFP_KERNEL);
+	if (!max14577)
+		return -ENOMEM;
+
+	i2c_set_clientdata(i2c, max14577);
+	max14577->pdata = pdata;
+	max14577->dev = &i2c->dev;
+	max14577->i2c = i2c;
+	max14577->irq = i2c->irq;
+
+	max14577->regmap = devm_regmap_init_i2c(i2c, &max14577_regmap_config);
+	if (IS_ERR(max14577->regmap)) {
+		ret = PTR_ERR(max14577->regmap);
+		dev_err(max14577->dev, "Failed to allocate register map: %d\n",
+				ret);
+		return ret;
+	}
+
+	ret = max14577_read_reg(max14577->regmap, MAX14577_REG_DEVICEID,
+			&reg_data);
+	if (ret) {
+		dev_err(max14577->dev, "Device not found on this channel: %d\n",
+				ret);
+		return ret;
+	}
+	max14577->vendor_id = (reg_data & 0x7);
+	max14577->device_id = ((reg_data & 0xF8) >> 0x3);
+	dev_info(max14577->dev, "Device ID: 0x%x, vendor: 0x%x\n",
+			max14577->device_id, max14577->vendor_id);
+
+	ret = max14577_irq_init(max14577);
+	if (ret < 0)
+		return ret;
+
+	ret = mfd_add_devices(max14577->dev, -1, max14577_devs,
+			ARRAY_SIZE(max14577_devs), NULL, 0, NULL);
+	if (ret < 0)
+		goto err_mfd;
+
+	device_init_wakeup(max14577->dev, 1);
+
+	return 0;
+
+err_mfd:
+	max14577_irq_exit(max14577);
+	return ret;
+}
+
+static int max14577_i2c_remove(struct i2c_client *i2c)
+{
+	struct max14577 *max14577 = i2c_get_clientdata(i2c);
+
+	mfd_remove_devices(max14577->dev);
+	max14577_irq_exit(max14577);
+
+	return 0;
+}
+
+static const struct i2c_device_id max14577_i2c_id[] = {
+	{ MAX14577_MFD_DEV_NAME, 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, max14577_i2c_id);
+
+#ifdef CONFIG_PM
+static int max14577_suspend(struct device *dev)
+{
+	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
+	struct max14577 *max14577 = i2c_get_clientdata(i2c);
+
+	if (device_may_wakeup(dev)) {
+		enable_irq_wake(max14577->irq);
+		/*
+		 * MUIC IRQ must be disabled during suspend if this is
+		 * a wake up source because it will be handled before
+		 * resuming I2C.
+		 *
+		 * When device is woken up from suspend (e.g. by ADC change),
+		 * an interrupt occurs before resuming I2C bus controller.
+		 * Interrupt handler tries to read registers but this read
+		 * will fail because I2C is still suspended.
+		 */
+		disable_irq(max14577->irq);
+	}
+
+	return 0;
+}
+
+static int max14577_resume(struct device *dev)
+{
+	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
+	struct max14577 *max14577 = i2c_get_clientdata(i2c);
+
+	if (device_may_wakeup(dev)) {
+		disable_irq_wake(max14577->irq);
+		enable_irq(max14577->irq);
+	}
+
+	return max14577_irq_resume(max14577);
+}
+#else
+#define max14577_suspend	NULL
+#define max14577_resume		NULL
+#endif /* CONFIG_PM */
+
+#ifdef CONFIG_OF
+static struct of_device_id max14577_dt_match[] = {
+	{ .compatible = "maxim,max14577", },
+	{},
+};
+#else
+#define max14577_dt_match	NULL
+#endif
+
+static SIMPLE_DEV_PM_OPS(max14577_pm, max14577_suspend, max14577_resume);
+
+static struct i2c_driver max14577_i2c_driver = {
+	.driver = {
+		.name = MAX14577_MFD_DEV_NAME,
+		.owner = THIS_MODULE,
+		.pm = &max14577_pm,
+		.of_match_table = of_match_ptr(max14577_dt_match),
+	},
+	.probe = max14577_i2c_probe,
+	.remove = max14577_i2c_remove,
+	.id_table = max14577_i2c_id,
+};
+
+static int __init max14577_i2c_init(void)
+{
+	return i2c_add_driver(&max14577_i2c_driver);
+}
+subsys_initcall(max14577_i2c_init);
+
+static void __exit max14577_i2c_exit(void)
+{
+	i2c_del_driver(&max14577_i2c_driver);
+}
+module_exit(max14577_i2c_exit);
+
+MODULE_AUTHOR("Chanwoo Choi <cw00.choi@samsung.com>, Krzysztof Kozlowski <k.kozlowski@samsung.com>");
+MODULE_DESCRIPTION("MAXIM 14577 multi-function core driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/max14577-private.h b/include/linux/mfd/max14577-private.h
new file mode 100644
index 0000000..a6e72b5
--- /dev/null
+++ b/include/linux/mfd/max14577-private.h
@@ -0,0 +1,317 @@
+/*
+ * max14577-private.h - Common API for the Maxim 14577 internal sub chip
+ *
+ * Copyright (C) 2013 Samsung Electrnoics
+ * Chanwoo Choi <cw00.choi@samsung.com>
+ * Krzysztof Kozlowski <k.kozlowski@samsung.com>
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
+ */
+
+#ifndef __MAX14577_PRIVATE_H__
+#define __MAX14577_PRIVATE_H__
+
+#include <linux/i2c.h>
+#include <linux/regmap.h>
+
+#define MAX14577_REG_INVALID		(0xff)
+
+/* Slave addr = 0x4A: Interrupt */
+enum max14577_reg {
+	MAX14577_REG_DEVICEID		= 0x00,
+	MAX14577_REG_INT1		= 0x01,
+	MAX14577_REG_INT2		= 0x02,
+	MAX14577_REG_INT3		= 0x03,
+	MAX14577_REG_STATUS1		= 0x04,
+	MAX14577_REG_STATUS2		= 0x05,
+	MAX14577_REG_STATUS3		= 0x06,
+	MAX14577_REG_INTMASK1		= 0x07,
+	MAX14577_REG_INTMASK2		= 0x08,
+	MAX14577_REG_INTMASK3		= 0x09,
+	MAX14577_REG_CDETCTRL1		= 0x0A,
+	MAX14577_REG_RFU		= 0x0B,
+	MAX14577_REG_CONTROL1		= 0x0C,
+	MAX14577_REG_CONTROL2		= 0x0D,
+	MAX14577_REG_CONTROL3		= 0x0E,
+	MAX14577_REG_CHGCTRL1		= 0x0F,
+	MAX14577_REG_CHGCTRL2		= 0x10,
+	MAX14577_REG_CHGCTRL3		= 0x11,
+	MAX14577_REG_CHGCTRL4		= 0x12,
+	MAX14577_REG_CHGCTRL5		= 0x13,
+	MAX14577_REG_CHGCTRL6		= 0x14,
+	MAX14577_REG_CHGCTRL7		= 0x15,
+
+	MAX14577_REG_END,
+};
+
+/* Slave addr = 0x4A: MUIC */
+enum max14577_muic_reg {
+	MAX14577_MUIC_REG_STATUS1	= 0x04,
+	MAX14577_MUIC_REG_STATUS2	= 0x05,
+	MAX14577_MUIC_REG_CONTROL1	= 0x0C,
+	MAX14577_MUIC_REG_CONTROL3	= 0x0E,
+
+	MAX14577_MUIC_REG_END,
+};
+
+enum max14577_muic_charger_type {
+	MAX14577_CHARGER_TYPE_NONE = 0,
+	MAX14577_CHARGER_TYPE_USB,
+	MAX14577_CHARGER_TYPE_DOWNSTREAM_PORT,
+	MAX14577_CHARGER_TYPE_DEDICATED_CHG,
+	MAX14577_CHARGER_TYPE_SPECIAL_500MA,
+	MAX14577_CHARGER_TYPE_SPECIAL_1A,
+	MAX14577_CHARGER_TYPE_RESERVED,
+	MAX14577_CHARGER_TYPE_DEAD_BATTERY = 7,
+};
+
+/* MAX14577 STATUS1 register */
+#define STATUS1_ADC_SHIFT		0
+#define STATUS1_ADCLOW_SHIFT		5
+#define STATUS1_ADCERR_SHIFT		6
+#define STATUS1_ADC_MASK		(0x1f << STATUS1_ADC_SHIFT)
+#define STATUS1_ADCLOW_MASK		(0x1 << STATUS1_ADCLOW_SHIFT)
+#define STATUS1_ADCERR_MASK		(0x1 << STATUS1_ADCERR_SHIFT)
+
+/* MAX14577 STATUS2 register */
+#define STATUS2_CHGTYP_SHIFT		0
+#define STATUS2_CHGDETRUN_SHIFT		3
+#define STATUS2_DCDTMR_SHIFT		4
+#define STATUS2_DBCHG_SHIFT		5
+#define STATUS2_VBVOLT_SHIFT		6
+#define STATUS2_CHGTYP_MASK		(0x7 << STATUS2_CHGTYP_SHIFT)
+#define STATUS2_CHGDETRUN_MASK		(0x1 << STATUS2_CHGDETRUN_SHIFT)
+#define STATUS2_DCDTMR_MASK		(0x1 << STATUS2_DCDTMR_SHIFT)
+#define STATUS2_DBCHG_MASK		(0x1 << STATUS2_DBCHG_SHIFT)
+#define STATUS2_VBVOLT_MASK		(0x1 << STATUS2_VBVOLT_SHIFT)
+
+/* MAX14577 CONTROL1 register */
+#define COMN1SW_SHIFT			0
+#define COMP2SW_SHIFT			3
+#define MICEN_SHIFT			6
+#define IDBEN_SHIFT			7
+#define COMN1SW_MASK			(0x7 << COMN1SW_SHIFT)
+#define COMP2SW_MASK			(0x7 << COMP2SW_SHIFT)
+#define MICEN_MASK			(0x1 << MICEN_SHIFT)
+#define IDBEN_MASK			(0x1 << IDBEN_SHIFT)
+#define CLEAR_IDBEN_MICEN_MASK		(COMN1SW_MASK | COMP2SW_MASK)
+#define CTRL1_SW_USB			((1 << COMP2SW_SHIFT) \
+						| (1 << COMN1SW_SHIFT))
+#define CTRL1_SW_AUDIO			((2 << COMP2SW_SHIFT) \
+						| (2 << COMN1SW_SHIFT))
+#define CTRL1_SW_UART			((3 << COMP2SW_SHIFT) \
+						| (3 << COMN1SW_SHIFT))
+#define CTRL1_SW_OPEN			((0 << COMP2SW_SHIFT) \
+						| (0 << COMN1SW_SHIFT))
+
+/* MAX14577 CONTROL2 register */
+#define CTRL2_LOWPWR_SHIFT		(0)
+#define CTRL2_ADCEN_SHIFT		(1)
+#define CTRL2_CPEN_SHIFT		(2)
+#define CTRL2_SFOUTASRT_SHIFT		(3)
+#define CTRL2_SFOUTORD_SHIFT		(4)
+#define CTRL2_ACCDET_SHIFT		(5)
+#define CTRL2_USBCPINT_SHIFT		(6)
+#define CTRL2_RCPS_SHIFT		(7)
+#define CTRL2_LOWPWR_MASK		(0x1 << CTRL2_LOWPWR_SHIFT)
+#define CTRL2_ADCEN_MASK		(0x1 << CTRL2_ADCEN_SHIFT)
+#define CTRL2_CPEN_MASK			(0x1 << CTRL2_CPEN_SHIFT)
+#define CTRL2_SFOUTASRT_MASK		(0x1 << CTRL2_SFOUTASRT_SHIFT)
+#define CTRL2_SFOUTORD_MASK		(0x1 << CTRL2_SFOUTORD_SHIFT)
+#define CTRL2_ACCDET_MASK		(0x1 << CTRL2_ACCDET_SHIFT)
+#define CTRL2_USBCPINT_MASK		(0x1 << CTRL2_USBCPINT_SHIFT)
+#define CTRL2_RCPS_MASK			(0x1 << CTR2_RCPS_SHIFT)
+
+#define CTRL2_CPEN1_LOWPWR0 ((1 << CTRL2_CPEN_SHIFT) | \
+				(0 << CTRL2_LOWPWR_SHIFT))
+#define CTRL2_CPEN0_LOWPWR1 ((0 << CTRL2_CPEN_SHIFT) | \
+				(1 << CTRL2_LOWPWR_SHIFT))
+
+/* MAX14577 CONTROL3 register */
+#define CTRL3_JIGSET_SHIFT		0
+#define CTRL3_BOOTSET_SHIFT		2
+#define CTRL3_ADCDBSET_SHIFT		4
+#define CTRL3_JIGSET_MASK		(0x3 << CTRL3_JIGSET_SHIFT)
+#define CTRL3_BOOTSET_MASK		(0x3 << CTRL3_BOOTSET_SHIFT)
+#define CTRL3_ADCDBSET_MASK		(0x3 << CTRL3_ADCDBSET_SHIFT)
+
+/* Slave addr = 0x4A: Charger */
+enum max14577_charger_reg {
+	MAX14577_CHG_REG_STATUS3	= 0x06,
+	MAX14577_CHG_REG_CHG_CTRL1	= 0x0F,
+	MAX14577_CHG_REG_CHG_CTRL2	= 0x10,
+	MAX14577_CHG_REG_CHG_CTRL3	= 0x11,
+	MAX14577_CHG_REG_CHG_CTRL4	= 0x12,
+	MAX14577_CHG_REG_CHG_CTRL5	= 0x13,
+	MAX14577_CHG_REG_CHG_CTRL6	= 0x14,
+	MAX14577_CHG_REG_CHG_CTRL7	= 0x15,
+
+	MAX14577_CHG_REG_END,
+};
+
+/* MAX14577 STATUS3 register */
+#define STATUS3_EOC_SHIFT		0
+#define STATUS3_CGMBC_SHIFT		1
+#define STATUS3_OVP_SHIFT		2
+#define STATUS3_MBCCHGERR_SHIFT		3
+#define STATUS3_EOC_MASK		(0x1 << STATUS3_EOC_SHIFT)
+#define STATUS3_CGMBC_MASK		(0x1 << STATUS3_CGMBC_SHIFT)
+#define STATUS3_OVP_MASK		(0x1 << STATUS3_OVP_SHIFT)
+#define STATUS3_MBCCHGERR_MASK		(0x1 << STATUS3_MBCCHGERR_SHIFT)
+
+/* MAX14577 CDETCTRL1 register */
+#define CDETCTRL1_CHGDETEN_SHIFT	0
+#define CDETCTRL1_CHGTYPMAN_SHIFT	1
+#define CDETCTRL1_DCDEN_SHIFT		2
+#define CDETCTRL1_DCD2SCT_SHIFT		3
+#define CDETCTRL1_DCHKTM_SHIFT		4
+#define CDETCTRL1_DBEXIT_SHIFT		5
+#define CDETCTRL1_DBIDLE_SHIFT		6
+#define CDETCTRL1_CDPDET_SHIFT		7
+#define CDETCTRL1_CHGDETEN_MASK		(0x1 << CDETCTRL1_CHGDETEN_SHIFT)
+#define CDETCTRL1_CHGTYPMAN_MASK	(0x1 << CDETCTRL1_CHGTYPMAN_SHIFT)
+#define CDETCTRL1_DCDEN_MASK		(0x1 << CDETCTRL1_DCDEN_SHIFT)
+#define CDETCTRL1_DCD2SCT_MASK		(0x1 << CDETCTRL1_DCD2SCT_SHIFT)
+#define CDETCTRL1_DCHKTM_MASK		(0x1 << CDETCTRL1_DCHKTM_SHIFT)
+#define CDETCTRL1_DBEXIT_MASK		(0x1 << CDETCTRL1_DBEXIT_SHIFT)
+#define CDETCTRL1_DBIDLE_MASK		(0x1 << CDETCTRL1_DBIDLE_SHIFT)
+#define CDETCTRL1_CDPDET_MASK		(0x1 << CDETCTRL1_CDPDET_SHIFT)
+
+/* MAX14577 CHGCTRL1 register */
+#define CHGCTRL1_TCHW_SHIFT		4
+#define CHGCTRL1_TCHW_MASK		(0x7 << CHGCTRL1_TCHW_SHIFT)
+
+/* MAX14577 CHGCTRL2 register */
+#define CHGCTRL2_MBCHOSTEN_SHIFT	6
+#define CHGCTRL2_MBCHOSTEN_MASK		(0x1 << CHGCTRL2_MBCHOSTEN_SHIFT)
+#define CHGCTRL2_VCHGR_RC_SHIFT		7
+#define CHGCTRL2_VCHGR_RC_MASK		(0x1 << CHGCTRL2_VCHGR_RC_SHIFT)
+
+/* MAX14577 CHGCTRL3 register */
+#define CHGCTRL3_MBCCVWRC_SHIFT		0
+#define CHGCTRL3_MBCCVWRC_MASK		(0xf << CHGCTRL3_MBCCVWRC_SHIFT)
+
+/* MAX14577 CHGCTRL4 register */
+#define CHGCTRL4_MBCICHWRCH_SHIFT	0
+#define CHGCTRL4_MBCICHWRCH_MASK	(0xf << CHGCTRL4_MBCICHWRCH_SHIFT)
+#define CHGCTRL4_MBCICHWRCL_SHIFT	4
+#define CHGCTRL4_MBCICHWRCL_MASK	(0x1 << CHGCTRL4_MBCICHWRCL_SHIFT)
+
+/* MAX14577 CHGCTRL5 register */
+#define CHGCTRL5_EOCS_SHIFT		0
+#define CHGCTRL5_EOCS_MASK		(0xf << CHGCTRL5_EOCS_SHIFT)
+
+/* MAX14577 CHGCTRL6 register */
+#define CHGCTRL6_AUTOSTOP_SHIFT		5
+#define CHGCTRL6_AUTOSTOP_MASK		(0x1 << CHGCTRL6_AUTOSTOP_SHIFT)
+
+/* MAX14577 CHGCTRL7 register */
+#define CHGCTRL7_OTPCGHCVS_SHIFT	0
+#define CHGCTRL7_OTPCGHCVS_MASK		(0x3 << CHGCTRL7_OTPCGHCVS_SHIFT)
+
+/* MAX14577 regulator current limits (as in CHGCTRL4 register), uA */
+#define MAX14577_REGULATOR_CURRENT_LIMIT_MIN		 90000
+#define MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_START	200000
+#define MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_STEP	 50000
+#define MAX14577_REGULATOR_CURRENT_LIMIT_MAX		950000
+
+/* MAX14577 regulator SFOUT LDO voltage, fixed, uV */
+#define MAX14577_REGULATOR_SAFEOUT_VOLTAGE		4900000
+
+enum max14577_irq_source {
+	MAX14577_IRQ_INT1 = 0,
+	MAX14577_IRQ_INT2,
+	MAX14577_IRQ_INT3,
+
+	MAX14577_IRQ_REGS_NUM,
+};
+
+enum max14577_irq {
+	/* INT1 */
+	MAX14577_IRQ_INT1_ADC,
+	MAX14577_IRQ_INT1_ADCLOW,
+	MAX14577_IRQ_INT1_ADCERR,
+
+	/* INT2 */
+	MAX14577_IRQ_INT2_CHGTYP,
+	MAX14577_IRQ_INT2_CHGDETRUN,
+	MAX14577_IRQ_INT2_DCDTMR,
+	MAX14577_IRQ_INT2_DBCHG,
+	MAX14577_IRQ_INT2_VBVOLT,
+
+	/* INT3 */
+	MAX14577_IRQ_INT3_EOC,
+	MAX14577_IRQ_INT3_CGMBC,
+	MAX14577_IRQ_INT3_OVP,
+	MAX14577_IRQ_INT3_MBCCHGERR,
+
+	MAX14577_IRQ_NUM,
+};
+
+struct max14577 {
+	struct device *dev;
+	struct i2c_client *i2c; /* Slave addr = 0x4A */
+
+	struct regmap *regmap;
+
+	struct irq_domain *irq_domain;
+	int irq;
+	struct mutex irq_lock;
+	int irq_masks_cur[MAX14577_IRQ_REGS_NUM];
+	int irq_masks_cache[MAX14577_IRQ_REGS_NUM];
+
+	/* Device ID */
+	u8 vendor_id;	/* Vendor Identification */
+	u8 device_id;	/* Chip Version */
+
+	struct max14577_platform_data *pdata;
+};
+
+extern int max14577_irq_init(struct max14577 *max14577);
+extern void max14577_irq_exit(struct max14577 *max14577);
+extern int max14577_irq_resume(struct max14577 *max14577);
+
+/* MAX14577 shared regmap API function */
+static inline int max14577_read_reg(struct regmap *map, u8 reg, u8 *dest)
+{
+	unsigned int val;
+	int ret;
+
+	ret = regmap_read(map, reg, &val);
+	*dest = val;
+
+	return ret;
+}
+
+static inline int max14577_bulk_read(struct regmap *map, u8 reg, u8 *buf,
+		int count)
+{
+	return regmap_bulk_read(map, reg, buf, count);
+}
+
+static inline int max14577_write_reg(struct regmap *map, u8 reg, u8 value)
+{
+	return regmap_write(map, reg, value);
+}
+
+static inline int max14577_bulk_write(struct regmap *map, u8 reg, u8 *buf,
+		int count)
+{
+	return regmap_bulk_write(map, reg, buf, count);
+}
+
+static inline int max14577_update_reg(struct regmap *map, u8 reg, u8 mask,
+		u8 val)
+{
+	return regmap_update_bits(map, reg, mask, val);
+}
+
+#endif /* __MAX14577_PRIVATE_H__ */
diff --git a/include/linux/mfd/max14577.h b/include/linux/mfd/max14577.h
new file mode 100644
index 0000000..9514123
--- /dev/null
+++ b/include/linux/mfd/max14577.h
@@ -0,0 +1,72 @@
+/*
+ * max14577.h - Driver for the Maxim 14577
+ *
+ * Copyright (C) 2013 Samsung Electrnoics
+ * Chanwoo Choi <cw00.choi@samsung.com>
+ * Krzysztof Kozlowski <k.kozlowski@samsung.com>
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
+ * This driver is based on max8997.h
+ *
+ * MAX14577 has MUIC, Charger devices.
+ * The devices share the same I2C bus and interrupt line
+ * included in this mfd driver.
+ */
+
+#ifndef __MAX14577_H__
+#define __MAX14577_H__
+
+#include <linux/mfd/max14577-private.h>
+#include <linux/regulator/consumer.h>
+
+#define MAX14577_MFD_DEV_NAME "max14577"
+
+/*
+ * MAX14577 Regulator
+ */
+
+/* MAX14577 regulator IDs */
+enum max14577_regulators {
+	MAX14577_SAFEOUT = 0,
+	MAX14577_CHARGER,
+
+	MAX14577_REG_MAX,
+};
+
+struct max14577_regulator_platform_data {
+	int id;
+	struct regulator_init_data *initdata;
+	struct device_node *of_node;
+};
+
+/*
+ * MAX14577 MFD platform data
+ */
+struct max14577_platform_data {
+	/* IRQ */
+	int irq_base;
+
+	/* current control GPIOs */
+	int gpio_pogo_vbatt_en;
+	int gpio_pogo_vbus_en;
+
+	/* current control GPIO control function */
+	int (*set_gpio_pogo_vbatt_en) (int gpio_val);
+	int (*set_gpio_pogo_vbus_en) (int gpio_val);
+
+	int (*set_gpio_pogo_cb) (int new_dev);
+
+	int num_regulators;
+	struct max14577_regulator_platform_data *regulators;
+};
+
+#endif /* __MAX14577_H__ */
-- 
1.7.9.5

