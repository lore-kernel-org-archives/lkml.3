Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbaE1Jj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 05:39:59 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36801 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbaE1Jjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 05:39:53 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-8b-5385aee38098
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 1/4] extcon: sm5502: Add support new SM5502 extcon device driver
Date: Wed, 28 May 2014 18:39:33 +0900
Message-id: <1401269976-12754-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1401269976-12754-1-git-send-email-cw00.choi@samsung.com>
References: <1401269976-12754-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsWyRsSkUPfJutZgg/cPmC2uf3nOanG26Q27
	xeVdc9gsbjeuYHNg8ejbsorR4/MmuQCmKC6blNSczLLUIn27BK6Mgwc+shac+sxYsXfWHJYG
	xh9nGbsYOTkkBEwkds0/AGWLSVy4t56ti5GLQ0hgKaPEz8urWWCKutqOsEAkpjNK7Freywzh
	NDFJLNvyjxWkik1AS2L/ixtsILaIgILE5t5nYHFmgXiJs93dYCuEBQIkGi7fArNZBFQlzm89
	BWbzCrhKvNrfCHWGnMSHPY/YQWxOATeJGTMOg80UAqpZfuQgE8hiCYH3bBJH112BGiQg8W3y
	IaDzOIASshKbDjBDzJGUOLjiBssERuEFjAyrGEVTC5ILipPSi0z1ihNzi0vz0vWS83M3MQID
	9vS/ZxN3MN4/YH2IMRlo3ERmKdHkfGDA55XEGxqbGVmYmpgaG5lbmpEmrCTOm/4oKUhIID2x
	JDU7NbUgtSi+qDQntfgQIxMHp1QDY4n6ovIFT4oDA7P2NTzyur3pm1DzgftTv2xi49zJ/c9Q
	QH/5/sdn+iNkHUzNJetXm+6QeXf/y5MDbt8ibuz02avmWiZcIrND6/70nPRnimcYXmx6eCZk
	hkdyWt0SFt+nOxO1+yUnsV9f2G3UkfDLuGFC1VsXzcC47T/iBPqTV3ieLcx9rfr9sRJLcUai
	oRZzUXEiAIj+nw5uAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jQd3H61qDDVr/6Vtc//Kc1eJs0xt2
	i8u75rBZ3G5cwebA4tG3ZRWjx+dNcgFMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaG
	uoaWFuZKCnmJuam2Si4+AbpumTlAm5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUY
	GaCBhDWMGQcPfGQtOPWZsWLvrDksDYw/zjJ2MXJySAiYSHS1HWGBsMUkLtxbz9bFyMUhJDCd
	UWLX8l5mCKeJSWLZln+sIFVsAloS+1/cYAOxRQQUJDb3PgOLMwvES5zt7gabKiwQINFw+RaY
	zSKgKnF+6ykwm1fAVeLV/kaozXISH/Y8YgexOQXcJGbMOAw2UwioZvmRg0wTGHkXMDKsYhRN
	LUguKE5KzzXUK07MLS7NS9dLzs/dxAiOh2dSOxhXNlgcYhTgYFTi4T2wuCVYiDWxrLgy9xCj
	BAezkgiv09LWYCHelMTKqtSi/Pii0pzU4kOMyUBXTWSWEk3OB8ZqXkm8obGJmZGlkbmhhZGx
	OWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUwzvv21J5N9nzgCwZmpTt2eeefWp6eGGB7
	l2vyhNlvWA9zbvHaXMvpMolxUd1CbvYqk013nm5bYvX46CX/m6ef/5ROT7Bw7tPbKzyhqlrf
	g8vzZYbc/VTxGb6SjJeOnlVwWSxdE+W64nzbhWdzTSb+tC5WPX9O+J7Ktr8Gx5sPv/iUqbFF
	cWqMqhJLcUaioRZzUXEiAGPn1LTLAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add new SM5502 MUIC(Micro-USB Interface Controller) device by using
EXTCON subsystem. The extcon-sm5502 driver is capable of identifying the type
of the external power source and attached accessory. An external power sources,
such as Deticated Charger or a standard USB port, are able to charge the battery
in the smart phone via the connector.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/Kconfig         |   7 +
 drivers/extcon/Makefile        |   1 +
 drivers/extcon/extcon-sm5502.c | 622 +++++++++++++++++++++++++++++++++++++++++
 include/linux/extcon/sm5502.h  | 264 +++++++++++++++++
 4 files changed, 894 insertions(+)
 create mode 100644 drivers/extcon/extcon-sm5502.c
 create mode 100644 include/linux/extcon/sm5502.h

diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
index 9125eba..69c240b 100644
--- a/drivers/extcon/Kconfig
+++ b/drivers/extcon/Kconfig
@@ -70,4 +70,11 @@ config EXTCON_PALMAS
 	  Say Y here to enable support for USB peripheral and USB host
 	  detection by palmas usb.
 
+config EXTCON_SM5502
+	tristate "SM5502 EXTCON support"
+	help
+	  If you say yes here you get support for the MUIC device of
+	  Silicon Mitus SM5502. The SM5502 is a USB port accessory
+	  detector and switch.
+
 endif # MULTISTATE_SWITCH
diff --git a/drivers/extcon/Makefile b/drivers/extcon/Makefile
index e48abc6..b38546e 100644
--- a/drivers/extcon/Makefile
+++ b/drivers/extcon/Makefile
@@ -10,3 +10,4 @@ obj-$(CONFIG_EXTCON_MAX14577)	+= extcon-max14577.o
 obj-$(CONFIG_EXTCON_MAX77693)	+= extcon-max77693.o
 obj-$(CONFIG_EXTCON_MAX8997)	+= extcon-max8997.o
 obj-$(CONFIG_EXTCON_PALMAS)	+= extcon-palmas.o
+obj-$(CONFIG_EXTCON_SM5502)	+= extcon-sm5502.o
diff --git a/drivers/extcon/extcon-sm5502.c b/drivers/extcon/extcon-sm5502.c
new file mode 100644
index 0000000..ebf3d5c
--- /dev/null
+++ b/drivers/extcon/extcon-sm5502.c
@@ -0,0 +1,622 @@
+/*
+ * extcon-sm5502.c - Silicon Mitus SM5502 extcon drvier to support USB switches
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd
+ * Author: Chanwoo Choi <cw00.choi@samsung.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <linux/irqdomain.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+#include <linux/extcon.h>
+#include <linux/extcon/sm5502.h>
+
+struct muic_irq {
+	unsigned int irq;
+	const char *name;
+	unsigned int virq;
+};
+
+struct reg_data {
+	u8 reg;
+	unsigned int val;
+	bool invert;
+};
+
+struct sm5502_muic_info {
+	struct device *dev;
+	struct extcon_dev *edev;
+
+	struct i2c_client *i2c;
+	struct regmap *regmap;
+
+	struct regmap_irq_chip_data *irq_data;
+	struct muic_irq *muic_irqs;
+	unsigned int num_muic_irqs;
+	int irq;
+	bool irq_attach;
+	bool irq_detach;
+	struct work_struct irq_work;
+
+	struct reg_data *reg_data;
+	unsigned int num_reg_data;
+
+	struct mutex mutex;
+};
+
+/* Default value of SM5502 register to bring up MUIC device. */
+static struct reg_data sm5502_reg_data[] = {
+	{
+		.reg = SM5502_REG_CONTROL,
+		.val = SM5502_REG_CONTROL_MASK_INT_MASK,
+		.invert = false,
+	}, {
+		.reg = SM5502_REG_INTMASK1,
+		.val = SM5502_REG_INTM1_KP_MASK
+			| SM5502_REG_INTM1_LKP_MASK
+			| SM5502_REG_INTM1_LKR_MASK,
+		.invert = true,
+	}, {
+		.reg = SM5502_REG_INTMASK2,
+		.val = SM5502_REG_INTM2_VBUS_DET_MASK
+			| SM5502_REG_INTM2_REV_ACCE_MASK
+			| SM5502_REG_INTM2_ADC_CHG_MASK
+			| SM5502_REG_INTM2_STUCK_KEY_MASK
+			| SM5502_REG_INTM2_STUCK_KEY_RCV_MASK
+			| SM5502_REG_INTM2_MHL_MASK,
+		.invert = true,
+	},
+	{ }
+};
+
+/* List of detectable cables */
+enum {
+	EXTCON_CABLE_USB = 0,
+	EXTCON_CABLE_USB_HOST,
+	EXTCON_CABLE_TA,
+
+	EXTCON_CABLE_END,
+};
+
+static const char const *sm5502_extcon_cable[] = {
+	[EXTCON_CABLE_USB]	= "USB",
+	[EXTCON_CABLE_USB_HOST]	= "USB-Host",
+	[EXTCON_CABLE_TA]	= "TA",
+	NULL,
+};
+
+/* Define supported accessory type */
+enum sm5502_muic_acc_type {
+	SM5502_MUIC_ADC_GROUND = 0x0,
+	SM5502_MUIC_ADC_SEND_END_BUTTON,
+	SM5502_MUIC_ADC_REMOTE_S1_BUTTON,
+	SM5502_MUIC_ADC_REMOTE_S2_BUTTON,
+	SM5502_MUIC_ADC_REMOTE_S3_BUTTON,
+	SM5502_MUIC_ADC_REMOTE_S4_BUTTON,
+	SM5502_MUIC_ADC_REMOTE_S5_BUTTON,
+	SM5502_MUIC_ADC_REMOTE_S6_BUTTON,
+	SM5502_MUIC_ADC_REMOTE_S7_BUTTON,
+	SM5502_MUIC_ADC_REMOTE_S8_BUTTON,
+	SM5502_MUIC_ADC_REMOTE_S9_BUTTON,
+	SM5502_MUIC_ADC_REMOTE_S10_BUTTON,
+	SM5502_MUIC_ADC_REMOTE_S11_BUTTON,
+	SM5502_MUIC_ADC_REMOTE_S12_BUTTON,
+	SM5502_MUIC_ADC_RESERVED_ACC_1,
+	SM5502_MUIC_ADC_RESERVED_ACC_2,
+	SM5502_MUIC_ADC_RESERVED_ACC_3,
+	SM5502_MUIC_ADC_RESERVED_ACC_4,
+	SM5502_MUIC_ADC_RESERVED_ACC_5,
+	SM5502_MUIC_ADC_AUDIO_TYPE2,
+	SM5502_MUIC_ADC_PHONE_POWERED_DEV,
+	SM5502_MUIC_ADC_TTY_CONVERTER,
+	SM5502_MUIC_ADC_UART_CABLE,
+	SM5502_MUIC_ADC_TYPE1_CHARGER,
+	SM5502_MUIC_ADC_FACTORY_MODE_BOOT_OFF_USB,
+	SM5502_MUIC_ADC_FACTORY_MODE_BOOT_ON_USB,
+	SM5502_MUIC_ADC_AUDIO_VIDEO_CABLE,
+	SM5502_MUIC_ADC_TYPE2_CHARGER,
+	SM5502_MUIC_ADC_FACTORY_MODE_BOOT_OFF_UART,
+	SM5502_MUIC_ADC_FACTORY_MODE_BOOT_ON_UART,
+	SM5502_MUIC_ADC_AUDIO_TYPE1,
+	SM5502_MUIC_ADC_OPEN = 0x1f,
+
+	/* The below accessories have same ADC value (0x1f or 0x1e).
+	   So, Device type1 is used to separate specific accessory. */
+							/* |---------|--ADC| */
+							/* |    [7:5]|[4:0]| */
+	SM5502_MUIC_ADC_AUDIO_TYPE1_FULL_REMOTE = 0x3e,	/* |      001|11110| */
+	SM5502_MUIC_ADC_AUDIO_TYPE1_SEND_END = 0x5e,	/* |      010|11110| */
+							/* |Dev Type1|--ADC| */
+	SM5502_MUIC_ADC_OPEN_USB = 0x5f,		/* |      010|11111| */
+	SM5502_MUIC_ADC_OPEN_TA = 0xdf,			/* |      110|11111| */
+	SM5502_MUIC_ADC_OPEN_USB_OTG = 0xff,		/* |      111|11111| */
+};
+
+/* List of supported interrupt for SM5502 */
+static struct muic_irq sm5502_muic_irqs[] = {
+	{ SM5502_IRQ_INT1_ATTACH,	"muic-attach" },
+	{ SM5502_IRQ_INT1_DETACH,	"muic-detach" },
+	{ SM5502_IRQ_INT1_KP,		"muic-kp" },
+	{ SM5502_IRQ_INT1_LKP,		"muic-lkp" },
+	{ SM5502_IRQ_INT1_LKR,		"muic-lkr" },
+	{ SM5502_IRQ_INT1_OVP_EVENT,	"muic-ovp-event" },
+	{ SM5502_IRQ_INT1_OCP_EVENT,	"muic-ocp-event" },
+	{ SM5502_IRQ_INT1_OVP_OCP_DIS,	"muic-ovp-ocp-dis" },
+	{ SM5502_IRQ_INT2_VBUS_DET,	"muic-vbus-det" },
+	{ SM5502_IRQ_INT2_REV_ACCE,	"muic-rev-acce" },
+	{ SM5502_IRQ_INT2_ADC_CHG,	"muic-adc-chg" },
+	{ SM5502_IRQ_INT2_STUCK_KEY,	"muic-stuck-key" },
+	{ SM5502_IRQ_INT2_STUCK_KEY_RCV, "muic-stuck-key-rcv" },
+	{ SM5502_IRQ_INT2_MHL,		"muic-mhl" },
+};
+
+/* Define interrupt list of SM5502 to register regmap_irq */
+static const struct regmap_irq sm5502_irqs[] = {
+	/* INT1 interrupts */
+	{ .reg_offset = 0, .mask = SM5502_IRQ_INT1_ATTACH_MASK, },
+	{ .reg_offset = 0, .mask = SM5502_IRQ_INT1_DETACH_MASK, },
+	{ .reg_offset = 0, .mask = SM5502_IRQ_INT1_KP_MASK, },
+	{ .reg_offset = 0, .mask = SM5502_IRQ_INT1_LKP_MASK, },
+	{ .reg_offset = 0, .mask = SM5502_IRQ_INT1_LKR_MASK, },
+	{ .reg_offset = 0, .mask = SM5502_IRQ_INT1_OVP_EVENT_MASK, },
+	{ .reg_offset = 0, .mask = SM5502_IRQ_INT1_OCP_EVENT_MASK, },
+	{ .reg_offset = 0, .mask = SM5502_IRQ_INT1_OVP_OCP_DIS_MASK, },
+
+	/* INT2 interrupts */
+	{ .reg_offset = 1, .mask = SM5502_IRQ_INT2_VBUS_DET_MASK,},
+	{ .reg_offset = 1, .mask = SM5502_IRQ_INT2_REV_ACCE_MASK, },
+	{ .reg_offset = 1, .mask = SM5502_IRQ_INT2_ADC_CHG_MASK, },
+	{ .reg_offset = 1, .mask = SM5502_IRQ_INT2_STUCK_KEY_MASK, },
+	{ .reg_offset = 1, .mask = SM5502_IRQ_INT2_STUCK_KEY_RCV_MASK, },
+	{ .reg_offset = 1, .mask = SM5502_IRQ_INT2_MHL_MASK, },
+};
+
+static const struct regmap_irq_chip sm5502_muic_irq_chip = {
+	.name			= "sm5502",
+	.status_base		= SM5502_REG_INT1,
+	.mask_base		= SM5502_REG_INTMASK1,
+	.mask_invert		= false,
+	.num_regs		= 2,
+	.irqs			= sm5502_irqs,
+	.num_irqs		= ARRAY_SIZE(sm5502_irqs),
+};
+
+/* Define regmap configuration of SM5502 for I2C communication  */
+static bool sm5502_muic_volatile_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case SM5502_REG_INTMASK1:
+	case SM5502_REG_INTMASK2:
+		return true;
+	default:
+		break;
+	}
+	return false;
+}
+
+static const struct regmap_config sm5502_muic_regmap_config = {
+	.reg_bits	= 8,
+	.val_bits	= 8,
+	.volatile_reg	= sm5502_muic_volatile_reg,
+	.max_register	= SM5502_REG_END,
+};
+
+/* Return cable type of attached or detached accessories */
+static unsigned int sm5502_muic_get_cable_type(struct sm5502_muic_info *info)
+{
+	unsigned int cable_type = -1, adc, dev_type1;
+	int ret;
+
+	/* Read ADC value according to external cable or button */
+	ret = regmap_read(info->regmap, SM5502_REG_ADC, &adc);
+	if (ret) {
+		dev_err(info->dev, "failed to read ADC register\n");
+		return ret;
+	}
+
+	/*
+	 * If ADC is SM5502_MUIC_ADC_GROUND(0x0), external cable hasn't
+	 * connected with to MUIC device.
+	 */
+	cable_type &= SM5502_REG_ADC_MASK;
+	if (cable_type == SM5502_MUIC_ADC_GROUND)
+		return SM5502_MUIC_ADC_GROUND;
+
+	switch (cable_type) {
+	case SM5502_MUIC_ADC_GROUND:
+	case SM5502_MUIC_ADC_SEND_END_BUTTON:
+	case SM5502_MUIC_ADC_REMOTE_S1_BUTTON:
+	case SM5502_MUIC_ADC_REMOTE_S2_BUTTON:
+	case SM5502_MUIC_ADC_REMOTE_S3_BUTTON:
+	case SM5502_MUIC_ADC_REMOTE_S4_BUTTON:
+	case SM5502_MUIC_ADC_REMOTE_S5_BUTTON:
+	case SM5502_MUIC_ADC_REMOTE_S6_BUTTON:
+	case SM5502_MUIC_ADC_REMOTE_S7_BUTTON:
+	case SM5502_MUIC_ADC_REMOTE_S8_BUTTON:
+	case SM5502_MUIC_ADC_REMOTE_S9_BUTTON:
+	case SM5502_MUIC_ADC_REMOTE_S10_BUTTON:
+	case SM5502_MUIC_ADC_REMOTE_S11_BUTTON:
+	case SM5502_MUIC_ADC_REMOTE_S12_BUTTON:
+	case SM5502_MUIC_ADC_RESERVED_ACC_1:
+	case SM5502_MUIC_ADC_RESERVED_ACC_2:
+	case SM5502_MUIC_ADC_RESERVED_ACC_3:
+	case SM5502_MUIC_ADC_RESERVED_ACC_4:
+	case SM5502_MUIC_ADC_RESERVED_ACC_5:
+	case SM5502_MUIC_ADC_AUDIO_TYPE2:
+	case SM5502_MUIC_ADC_PHONE_POWERED_DEV:
+	case SM5502_MUIC_ADC_TTY_CONVERTER:
+	case SM5502_MUIC_ADC_UART_CABLE:
+	case SM5502_MUIC_ADC_TYPE1_CHARGER:
+	case SM5502_MUIC_ADC_FACTORY_MODE_BOOT_OFF_USB:
+	case SM5502_MUIC_ADC_FACTORY_MODE_BOOT_ON_USB:
+	case SM5502_MUIC_ADC_AUDIO_VIDEO_CABLE:
+	case SM5502_MUIC_ADC_TYPE2_CHARGER:
+	case SM5502_MUIC_ADC_FACTORY_MODE_BOOT_OFF_UART:
+	case SM5502_MUIC_ADC_FACTORY_MODE_BOOT_ON_UART:
+		break;
+	case SM5502_MUIC_ADC_AUDIO_TYPE1:
+		/*
+		 * Check whether cable type is
+		 * SM5502_MUIC_ADC_AUDIO_TYPE1_FULL_REMOTE
+		 * or SM5502_MUIC_ADC_AUDIO_TYPE1_SEND_END
+		 * by using Button event.
+		 */
+		break;
+	case SM5502_MUIC_ADC_OPEN:
+		ret = regmap_read(info->regmap, SM5502_REG_DEV_TYPE1,
+				  &dev_type1);
+		if (ret) {
+			dev_err(info->dev, "failed to read DEV_TYPE1 reg\n");
+			return ret;
+		}
+
+		switch (dev_type1) {
+		case SM5502_REG_DEV_TYPE1_USB_SDP_MASK:
+			cable_type = SM5502_MUIC_ADC_OPEN_USB;
+			break;
+		case SM5502_REG_DEV_TYPE1_DEDICATED_CHG_MASK:
+			cable_type = SM5502_MUIC_ADC_OPEN_TA;
+			break;
+		case SM5502_REG_DEV_TYPE1_USB_OTG_MASK:
+			cable_type = SM5502_MUIC_ADC_OPEN_USB_OTG;
+			break;
+		default:
+			dev_dbg(info->dev,
+				"cannot identify the cable type: adc(0x%x) "
+				"dev_type1(0x%x)\n", adc, dev_type1);
+			return -EINVAL;
+		};
+		break;
+	default:
+		dev_err(info->dev,
+			"failed to identify the cable type: adc(0x%x)\n", adc);
+		return -EINVAL;
+	};
+
+	return cable_type;
+}
+
+static int sm5502_muic_cable_handler(struct sm5502_muic_info *info,
+				     bool attached)
+{
+	static unsigned int prev_cable_type = SM5502_MUIC_ADC_GROUND;
+	const char **cable_names = info->edev->supported_cable;
+	unsigned int cable_type = SM5502_MUIC_ADC_GROUND;
+	unsigned int idx = 0;
+
+	if (!cable_names)
+		return 0;
+
+	/* Get the type of attached or detached cable */
+	if (attached)
+		cable_type = sm5502_muic_get_cable_type(info);
+	else if (!attached)
+		cable_type = prev_cable_type;
+	prev_cable_type = cable_type;
+
+	switch (cable_type) {
+	case SM5502_MUIC_ADC_OPEN_USB:
+		idx = EXTCON_CABLE_USB;
+		break;
+	case SM5502_MUIC_ADC_OPEN_TA:
+		idx = EXTCON_CABLE_TA;
+		break;
+	case SM5502_MUIC_ADC_OPEN_USB_OTG:
+		idx = EXTCON_CABLE_USB_HOST;
+		break;
+	default:
+		dev_dbg(info->dev,
+			"cannot handle this cable_type (0x%x)\n", cable_type);
+		return 0;
+	};
+
+	extcon_set_cable_state(info->edev, cable_names[idx], attached);
+
+	return 0;
+}
+
+static void sm5502_muic_irq_work(struct work_struct *work)
+{
+	struct sm5502_muic_info *info = container_of(work,
+			struct sm5502_muic_info, irq_work);
+	int ret = 0;
+
+	if (!info->edev)
+		return;
+
+	mutex_lock(&info->mutex);
+
+	/* Detect attached or detached cables */
+	if (info->irq_attach) {
+		ret = sm5502_muic_cable_handler(info, true);
+		info->irq_attach = false;
+	}
+	if (info->irq_detach) {
+		ret = sm5502_muic_cable_handler(info, false);
+		info->irq_detach = false;
+	}
+
+	if (ret < 0)
+		dev_err(info->dev, "failed to handle MUIC interrupt\n");
+
+	mutex_unlock(&info->mutex);
+
+	return;
+}
+
+/*
+ * Sets irq_attach or irq_detach in sm5502_muic_info and returns 0.
+ * Returns -ESRCH if irq_type does not match registered IRQ for this dev type.
+ */
+static int sm5502_parse_irq(struct sm5502_muic_info *info, int irq_type)
+{
+	switch (irq_type) {
+	case SM5502_IRQ_INT1_ATTACH:
+		info->irq_attach = true;
+		break;
+	case SM5502_IRQ_INT1_DETACH:
+		info->irq_detach = true;
+		break;
+	case SM5502_IRQ_INT1_KP:
+	case SM5502_IRQ_INT1_LKP:
+	case SM5502_IRQ_INT1_LKR:
+	case SM5502_IRQ_INT1_OVP_EVENT:
+	case SM5502_IRQ_INT1_OCP_EVENT:
+	case SM5502_IRQ_INT1_OVP_OCP_DIS:
+	case SM5502_IRQ_INT2_VBUS_DET:
+	case SM5502_IRQ_INT2_REV_ACCE:
+	case SM5502_IRQ_INT2_ADC_CHG:
+	case SM5502_IRQ_INT2_STUCK_KEY:
+	case SM5502_IRQ_INT2_STUCK_KEY_RCV:
+	case SM5502_IRQ_INT2_MHL:
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static irqreturn_t sm5502_muic_irq_handler(int irq, void *data)
+{
+	struct sm5502_muic_info *info = data;
+	int i, irq_type = -1, ret;
+
+	for (i = 0; i < info->num_muic_irqs; i++)
+		if (irq == info->muic_irqs[i].virq)
+			irq_type = info->muic_irqs[i].irq;
+
+	ret = sm5502_parse_irq(info, irq_type);
+	if (ret < 0) {
+		dev_warn(info->dev, "cannot handle is interrupt:%d\n",
+				    irq_type);
+		return IRQ_HANDLED;
+	}
+	schedule_work(&info->irq_work);
+
+	return IRQ_HANDLED;
+}
+
+static void sm5502_init_dev_type(struct sm5502_muic_info *info)
+{
+	unsigned int reg_data, vendor_id, version_id;
+	int i, ret;
+
+	/* To test I2C, Print version_id and vendor_id of SM5502 */
+	ret = regmap_read(info->regmap, SM5502_REG_DEVICE_ID, &reg_data);
+	if (ret) {
+		dev_err(info->dev,
+			"failed to read DEVICE_ID register: %d\n", ret);
+		return;
+	}
+
+	vendor_id = ((reg_data & SM5502_REG_DEVICE_ID_VENDOR_MASK) >>
+				SM5502_REG_DEVICE_ID_VENDOR_SHIFT);
+	version_id = ((reg_data & SM5502_REG_DEVICE_ID_VERSION_MASK) >>
+				SM5502_REG_DEVICE_ID_VERSION_SHIFT);
+
+	dev_info(info->dev, "Device type: version: 0x%x, vendor: 0x%x\n",
+			    version_id, vendor_id);
+
+	/* Initiazle the register of SM5502 device to bring-up */
+	for (i = 0; i < info->num_reg_data; i++) {
+		unsigned int val = 0;
+
+		if (!info->reg_data[i].invert)
+			val |= ~info->reg_data[i].val;
+		else
+			val = info->reg_data[i].val;
+		regmap_write(info->regmap, info->reg_data[i].reg, val);
+	}
+}
+
+static int sm5022_muic_i2c_probe(struct i2c_client *i2c,
+				 const struct i2c_device_id *id)
+{
+	struct device_node *np = i2c->dev.of_node;
+	struct sm5502_muic_info *info;
+	int i, ret, irq_flags;
+
+	if (!np)
+		return -EINVAL;
+
+	info = devm_kzalloc(&i2c->dev, sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		dev_err(&i2c->dev, "failed to allocate memory\n");
+		return -ENOMEM;
+	}
+	i2c_set_clientdata(i2c, info);
+
+	info->dev = &i2c->dev;
+	info->i2c = i2c;
+	info->irq = i2c->irq;
+	info->muic_irqs = sm5502_muic_irqs;
+	info->num_muic_irqs = ARRAY_SIZE(sm5502_muic_irqs);
+	info->reg_data = sm5502_reg_data;
+	info->num_reg_data = ARRAY_SIZE(sm5502_reg_data);
+
+	mutex_init(&info->mutex);
+
+	INIT_WORK(&info->irq_work, sm5502_muic_irq_work);
+
+	info->regmap = devm_regmap_init_i2c(i2c, &sm5502_muic_regmap_config);
+	if (IS_ERR(info->regmap)) {
+		ret = PTR_ERR(info->regmap);
+		dev_err(info->dev, "failed to allocate register map: %d\n",
+				   ret);
+		return ret;
+	}
+
+	/* Support irq domain for SM5502 MUIC device */
+	irq_flags = IRQF_TRIGGER_FALLING | IRQF_ONESHOT | IRQF_SHARED;
+	ret = regmap_add_irq_chip(info->regmap, info->irq, irq_flags, 0,
+				  &sm5502_muic_irq_chip, &info->irq_data);
+	if (ret != 0) {
+		dev_err(info->dev, "failed to request IRQ %d: %d\n",
+				    info->irq, ret);
+		return ret;
+	}
+
+	for (i = 0; i < info->num_muic_irqs; i++) {
+		struct muic_irq *muic_irq = &info->muic_irqs[i];
+		unsigned int virq = 0;
+
+		virq = regmap_irq_get_virq(info->irq_data, muic_irq->irq);
+		if (virq <= 0)
+			return -EINVAL;
+		muic_irq->virq = virq;
+
+		ret = devm_request_threaded_irq(info->dev, virq, NULL,
+						sm5502_muic_irq_handler,
+						IRQF_NO_SUSPEND,
+						muic_irq->name, info);
+		if (ret) {
+			dev_err(info->dev, "failed: irq request (IRQ: %d,"
+				" error :%d)\n", muic_irq->irq, ret);
+			return ret;
+		}
+	}
+
+	/* Allocate extcon device */
+	info->edev = devm_extcon_dev_allocate(info->dev, sm5502_extcon_cable);
+	if (IS_ERR(info->edev)) {
+		dev_err(info->dev, "failed to allocate memory for extcon\n");
+		return -ENOMEM;
+	}
+	info->edev->name = np->name;
+
+	/* Register extcon device */
+	ret = devm_extcon_dev_register(info->dev, info->edev);
+	if (ret) {
+		dev_err(info->dev, "failed to register extcon device\n");
+		return ret;
+	}
+
+	/* Initialize SM5502 device and print vendor id and version id */
+	sm5502_init_dev_type(info);
+
+	return 0;
+}
+
+static int sm5502_muic_i2c_remove(struct i2c_client *i2c)
+{
+	struct sm5502_muic_info *info = i2c_get_clientdata(i2c);
+
+	regmap_del_irq_chip(info->irq, info->irq_data);
+
+	return 0;
+}
+
+static struct of_device_id sm5502_dt_match[] = {
+	{ .compatible = "siliconmitus,sm5502-muic" },
+	{ },
+};
+
+#ifdef CONFIG_PM_SLEEP
+static int sm5502_muic_suspend(struct device *dev)
+{
+	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
+	struct sm5502_muic_info *info = i2c_get_clientdata(i2c);
+
+	enable_irq_wake(info->irq);
+
+	return 0;
+}
+
+static int sm5502_muic_resume(struct device *dev)
+{
+	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
+	struct sm5502_muic_info *info = i2c_get_clientdata(i2c);
+
+	disable_irq_wake(info->irq);
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(sm5502_muic_pm_ops,
+			 sm5502_muic_suspend, sm5502_muic_resume);
+
+static const struct i2c_device_id sm5502_i2c_id[] = {
+	{ "sm5502", TYPE_SM5502 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, sm5502_i2c_id);
+
+static struct i2c_driver sm5502_muic_i2c_driver = {
+	.driver		= {
+		.name	= "sm5502",
+		.owner	= THIS_MODULE,
+		.pm	= &sm5502_muic_pm_ops,
+		.of_match_table = sm5502_dt_match,
+	},
+	.probe	= sm5022_muic_i2c_probe,
+	.remove	= sm5502_muic_i2c_remove,
+	.id_table = sm5502_i2c_id,
+};
+
+static int __init sm5502_muic_i2c_init(void)
+{
+	return i2c_add_driver(&sm5502_muic_i2c_driver);
+}
+subsys_initcall(sm5502_muic_i2c_init);
+
+MODULE_DESCRIPTION("Silicon Mitus SM5502 Extcon driver");
+MODULE_AUTHOR("Chanwoo Choi <cw00.choi@samsung.com>");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/extcon/sm5502.h b/include/linux/extcon/sm5502.h
new file mode 100644
index 0000000..17bd655
--- /dev/null
+++ b/include/linux/extcon/sm5502.h
@@ -0,0 +1,264 @@
+/*
+ * sm5502.h
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __LINUX_EXTCON_SM5502_H
+#define __LINUX_EXTCON_SM5502_H
+
+enum sm5502_types {
+	TYPE_SM5502,
+};
+
+/* SM5502 registers */
+enum sm5502_reg {
+	SM5502_REG_DEVICE_ID = 0x01,
+	SM5502_REG_CONTROL,
+	SM5502_REG_INT1,
+	SM5502_REG_INT2,
+	SM5502_REG_INTMASK1,
+	SM5502_REG_INTMASK2,
+	SM5502_REG_ADC,
+	SM5502_REG_TIMING_SET1,
+	SM5502_REG_TIMING_SET2,
+	SM5502_REG_DEV_TYPE1,
+	SM5502_REG_DEV_TYPE2,
+	SM5502_REG_BUTTON1,
+	SM5502_REG_BUTTON2,
+	SM5502_REG_CAR_KIT_STATUS,
+	SM5502_REG_RSVD1,
+	SM5502_REG_RSVD2,
+	SM5502_REG_RSVD3,
+	SM5502_REG_RSVD4,
+	SM5502_REG_MANUAL_SW1,
+	SM5502_REG_MANUAL_SW2,
+	SM5502_REG_DEV_TYPE3,
+	SM5502_REG_RSVD5,
+	SM5502_REG_RSVD6,
+	SM5502_REG_RSVD7,
+	SM5502_REG_RSVD8,
+	SM5502_REG_RSVD9,
+	SM5502_REG_RESET,
+	SM5502_REG_RSVD10,
+	SM5502_REG_RESERVED_ID1,
+	SM5502_REG_RSVD11,
+	SM5502_REG_RSVD12,
+	SM5502_REG_RESERVED_ID2,
+	SM5502_REG_RSVD13,
+	SM5502_REG_OCP,
+	SM5502_REG_RSVD14,
+	SM5502_REG_RSVD15,
+	SM5502_REG_RSVD16,
+	SM5502_REG_RSVD17,
+	SM5502_REG_RSVD18,
+	SM5502_REG_RSVD19,
+	SM5502_REG_RSVD20,
+	SM5502_REG_RSVD21,
+	SM5502_REG_RSVD22,
+	SM5502_REG_RSVD23,
+	SM5502_REG_RSVD24,
+	SM5502_REG_RSVD25,
+	SM5502_REG_RSVD26,
+	SM5502_REG_RSVD27,
+	SM5502_REG_RSVD28,
+	SM5502_REG_RSVD29,
+	SM5502_REG_RSVD30,
+	SM5502_REG_RSVD31,
+	SM5502_REG_RSVD32,
+	SM5502_REG_RSVD33,
+	SM5502_REG_RSVD34,
+	SM5502_REG_RSVD35,
+	SM5502_REG_RSVD36,
+	SM5502_REG_RESERVED_ID3,
+
+	SM5502_REG_END,
+};
+
+/* Define SM5502 MASK/SHIFT constant */
+#define SM5502_REG_DEVICE_ID_VENDOR_SHIFT	0
+#define SM5502_REG_DEVICE_ID_VERSION_SHIFT	3
+#define SM5502_REG_DEVICE_ID_VENDOR_MASK	(0x3 << SM5502_REG_DEVICE_ID_VENDOR_SHIFT)
+#define SM5502_REG_DEVICE_ID_VERSION_MASK	(0x1f << SM5502_REG_DEVICE_ID_VERSION_SHIFT)
+
+#define SM5502_REG_CONTROL_MASK_INT_SHIFT	0
+#define SM5502_REG_CONTROL_WAIT_SHIFT		1
+#define SM5502_REG_CONTROL_MANUAL_SW_SHIFT	2
+#define SM5502_REG_CONTROL_RAW_DATA_SHIFT	3
+#define SM5502_REG_CONTROL_SW_OPEN_SHIFT	4
+#define SM5502_REG_CONTROL_MASK_INT_MASK	(0x1 << SM5502_REG_CONTROL_MASK_INT_SHIFT)
+#define SM5502_REG_CONTROL_WAIT_MASK		(0x1 << SM5502_REG_CONTROL_WAIT_SHIFT)
+#define SM5502_REG_CONTROL_MANUAL_SW_MASK	(0x1 << SM5502_REG_CONTROL_MANUAL_SW_SHIFT)
+#define SM5502_REG_CONTROL_RAW_DATA_MASK	(0x1 << SM5502_REG_CONTROL_RAW_DATA_SHIFT)
+#define SM5502_REG_CONTROL_SW_OPEN_MASK		(0x1 << SM5502_REG_CONTROL_SW_OPEN_SHIFT)
+
+#define SM5502_REG_INTM1_ATTACH_SHIFT		0
+#define SM5502_REG_INTM1_DETACH_SHIFT		1
+#define SM5502_REG_INTM1_KP_SHIFT		2
+#define SM5502_REG_INTM1_LKP_SHIFT		3
+#define SM5502_REG_INTM1_LKR_SHIFT		4
+#define SM5502_REG_INTM1_OVP_EVENT_SHIFT	5
+#define SM5502_REG_INTM1_OCP_EVENT_SHIFT	6
+#define SM5502_REG_INTM1_OVP_OCP_DIS_SHIFT	7
+#define SM5502_REG_INTM1_ATTACH_MASK		(0x1 << SM5502_REG_INTM1_ATTACH_SHIFT)
+#define SM5502_REG_INTM1_DETACH_MASK		(0x1 << SM5502_REG_INTM1_DETACH_SHIFT)
+#define SM5502_REG_INTM1_KP_MASK		(0x1 << SM5502_REG_INTM1_KP_SHIFT)
+#define SM5502_REG_INTM1_LKP_MASK		(0x1 << SM5502_REG_INTM1_LKP_SHIFT)
+#define SM5502_REG_INTM1_LKR_MASK		(0x1 << SM5502_REG_INTM1_LKR_SHIFT)
+#define SM5502_REG_INTM1_OVP_EVENT_MASK		(0x1 << SM5502_REG_INTM1_OVP_EVENT_SHIFT)
+#define SM5502_REG_INTM1_OCP_EVENT_MASK		(0x1 << SM5502_REG_INTM1_OCP_EVENT_SHIFT)
+#define SM5502_REG_INTM1_OVP_OCP_DIS_MASK	(0x1 << SM5502_REG_INTM1_OVP_OCP_DIS_SHIFT)
+
+#define SM5502_REG_INTM2_VBUS_DET_SHIFT		0
+#define SM5502_REG_INTM2_REV_ACCE_SHIFT		1
+#define SM5502_REG_INTM2_ADC_CHG_SHIFT		2
+#define SM5502_REG_INTM2_STUCK_KEY_SHIFT	3
+#define SM5502_REG_INTM2_STUCK_KEY_RCV_SHIFT	4
+#define SM5502_REG_INTM2_MHL_SHIFT		5
+#define SM5502_REG_INTM2_VBUS_DET_MASK		(0x1 << SM5502_REG_INTM2_VBUS_DET_SHIFT)
+#define SM5502_REG_INTM2_REV_ACCE_MASK		(0x1 << SM5502_REG_INTM2_REV_ACCE_SHIFT)
+#define SM5502_REG_INTM2_ADC_CHG_MASK		(0x1 << SM5502_REG_INTM2_ADC_CHG_SHIFT)
+#define SM5502_REG_INTM2_STUCK_KEY_MASK		(0x1 << SM5502_REG_INTM2_STUCK_KEY_SHIFT)
+#define SM5502_REG_INTM2_STUCK_KEY_RCV_MASK	(0x1 << SM5502_REG_INTM2_STUCK_KEY_RCV_SHIFT)
+#define SM5502_REG_INTM2_MHL_MASK		(0x1 << SM5502_REG_INTM2_MHL_SHIFT)
+
+#define SM5502_REG_ADC_SHIFT			0
+#define SM5502_REG_ADC_MASK			(0x1f << SM5502_REG_ADC_SHIFT)
+
+#define SM5502_REG_TIMING_SET1_KEY_PRESS_SHIFT	4
+#define SM5502_REG_TIMING_SET1_KEY_PRESS_MASK	(0xf << SM5502_REG_TIMING_SET1_KEY_PRESS_SHIFT)
+#define TIMING_KEY_PRESS_100MS			0x0
+#define TIMING_KEY_PRESS_200MS			0x1
+#define TIMING_KEY_PRESS_300MS			0x2
+#define TIMING_KEY_PRESS_400MS			0x3
+#define TIMING_KEY_PRESS_500MS			0x4
+#define TIMING_KEY_PRESS_600MS			0x5
+#define TIMING_KEY_PRESS_700MS			0x6
+#define TIMING_KEY_PRESS_800MS			0x7
+#define TIMING_KEY_PRESS_900MS			0x8
+#define TIMING_KEY_PRESS_1000MS			0x9
+#define SM5502_REG_TIMING_SET1_ADC_DET_SHIFT	0
+#define SM5502_REG_TIMING_SET1_ADC_DET_MASK	(0xf << SM5502_REG_TIMING_SET1_ADC_DET_SHIFT)
+#define TIMING_ADC_DET_50MS			0x0
+#define TIMING_ADC_DET_100MS			0x1
+#define TIMING_ADC_DET_150MS			0x2
+#define TIMING_ADC_DET_200MS			0x3
+#define TIMING_ADC_DET_300MS			0x4
+#define TIMING_ADC_DET_400MS			0x5
+#define TIMING_ADC_DET_500MS			0x6
+#define TIMING_ADC_DET_600MS			0x7
+#define TIMING_ADC_DET_700MS			0x8
+#define TIMING_ADC_DET_800MS			0x9
+#define TIMING_ADC_DET_900MS			0xA
+#define TIMING_ADC_DET_1000MS			0xB
+
+#define SM5502_REG_TIMING_SET2_SW_WAIT_SHIFT	4
+#define SM5502_REG_TIMING_SET2_SW_WAIT_MASK	(0xf << SM5502_REG_TIMING_SET2_SW_WAIT_SHIFT)
+#define TIMING_SW_WAIT_10MS			0x0
+#define TIMING_SW_WAIT_30MS			0x1
+#define TIMING_SW_WAIT_50MS			0x2
+#define TIMING_SW_WAIT_70MS			0x3
+#define TIMING_SW_WAIT_90MS			0x4
+#define TIMING_SW_WAIT_110MS			0x5
+#define TIMING_SW_WAIT_130MS			0x6
+#define TIMING_SW_WAIT_150MS			0x7
+#define TIMING_SW_WAIT_170MS			0x8
+#define TIMING_SW_WAIT_190MS			0x9
+#define TIMING_SW_WAIT_210MS			0xA
+#define SM5502_REG_TIMING_SET2_LONG_KEY_SHIFT	0
+#define SM5502_REG_TIMING_SET2_LONG_KEY_MASK	(0xf << SM5502_REG_TIMING_SET2_LONG_KEY_SHIFT)
+#define TIMING_LONG_KEY_300MS			0x0
+#define TIMING_LONG_KEY_400MS			0x1
+#define TIMING_LONG_KEY_500MS			0x2
+#define TIMING_LONG_KEY_600MS			0x3
+#define TIMING_LONG_KEY_700MS			0x4
+#define TIMING_LONG_KEY_800MS			0x5
+#define TIMING_LONG_KEY_900MS			0x6
+#define TIMING_LONG_KEY_1000MS			0x7
+#define TIMING_LONG_KEY_1100MS			0x8
+#define TIMING_LONG_KEY_1200MS			0x9
+#define TIMING_LONG_KEY_1300MS			0xA
+#define TIMING_LONG_KEY_1400MS			0xB
+#define TIMING_LONG_KEY_1500MS			0xC
+
+#define SM5502_REG_DEV_TYPE1_AUDIO_TYPE1_SHIFT		0
+#define SM5502_REG_DEV_TYPE1_AUDIO_TYPE2_SHIFT		1
+#define SM5502_REG_DEV_TYPE1_USB_SDP_SHIFT		2
+#define SM5502_REG_DEV_TYPE1_UART_SHIFT			3
+#define SM5502_REG_DEV_TYPE1_CAR_KIT_CHARGER_SHIFT	4
+#define SM5502_REG_DEV_TYPE1_USB_CHG_SHIFT		5
+#define SM5502_REG_DEV_TYPE1_DEDICATED_CHG_SHIFT	6
+#define SM5502_REG_DEV_TYPE1_USB_OTG_SHIFT		7
+#define SM5502_REG_DEV_TYPE1_AUDIO_TYPE1_MASK		(0x1 << SM5502_REG_DEV_TYPE1_AUDIO_TYPE1_SHIFT)
+#define SM5502_REG_DEV_TYPE1_AUDIO_TYPE1__MASK		(0x1 << SM5502_REG_DEV_TYPE1_AUDIO_TYPE2_SHIFT)
+#define SM5502_REG_DEV_TYPE1_USB_SDP_MASK		(0x1 << SM5502_REG_DEV_TYPE1_USB_SDP_SHIFT)
+#define SM5502_REG_DEV_TYPE1_UART_MASK			(0x1 << SM5502_REG_DEV_TYPE1_UART_SHIFT)
+#define SM5502_REG_DEV_TYPE1_CAR_KIT_CHARGER_MASK	(0x1 << SM5502_REG_DEV_TYPE1_CAR_KIT_CHARGER_SHIFT)
+#define SM5502_REG_DEV_TYPE1_USB_CHG_MASK		(0x1 << SM5502_REG_DEV_TYPE1_USB_CHG_SHIFT)
+#define SM5502_REG_DEV_TYPE1_DEDICATED_CHG_MASK		(0x1 << SM5502_REG_DEV_TYPE1_DEDICATED_CHG_SHIFT)
+#define SM5502_REG_DEV_TYPE1_USB_OTG_MASK		(0x1 << SM5502_REG_DEV_TYPE1_USB_OTG_SHIFT)
+
+#define SM5502_REG_DEV_TYPE2_JIG_USB_ON_SHIFT		0
+#define SM5502_REG_DEV_TYPE2_JIG_USB_OFF_SHIFT		1
+#define SM5502_REG_DEV_TYPE2_JIG_UART_ON_SHIFT		2
+#define SM5502_REG_DEV_TYPE2_JIG_UART_OFF_SHIFT		3
+#define SM5502_REG_DEV_TYPE2_PPD_SHIFT			4
+#define SM5502_REG_DEV_TYPE2_TTY_SHIFT			5
+#define SM5502_REG_DEV_TYPE2_AV_CABLE_SHIFT		6
+#define SM5502_REG_DEV_TYPE2_JIG_USB_ON_MASK		(0x1 << SM5502_REG_DEV_TYPE2_JIG_USB_ON_SHIFT)
+#define SM5502_REG_DEV_TYPE2_JIG_USB_OFF_MASK		(0x1 << SM5502_REG_DEV_TYPE2_JIG_USB_OFF_SHIFT)
+#define SM5502_REG_DEV_TYPE2_JIG_UART_ON_MASK		(0x1 << SM5502_REG_DEV_TYPE2_JIG_UART_ON_SHIFT)
+#define SM5502_REG_DEV_TYPE2_JIG_UART_OFF_MASK		(0x1 << SM5502_REG_DEV_TYPE2_JIG_UART_OFF_SHIFT)
+#define SM5502_REG_DEV_TYPE2_PPD_MASK			(0x1 << SM5502_REG_DEV_TYPE2_PPD_SHIFT)
+#define SM5502_REG_DEV_TYPE2_TTY_MASK			(0x1 << SM5502_REG_DEV_TYPE2_TTY_SHIFT)
+#define SM5502_REG_DEV_TYPE2_AV_CABLE_MASK		(0x1 << SM5502_REG_DEV_TYPE2_AV_CABLE_SHIFT)
+
+/* SM5502 Interrupts */
+enum sm5502_irq {
+	/* INT1 */
+	SM5502_IRQ_INT1_ATTACH,
+	SM5502_IRQ_INT1_DETACH,
+	SM5502_IRQ_INT1_KP,
+	SM5502_IRQ_INT1_LKP,
+	SM5502_IRQ_INT1_LKR,
+	SM5502_IRQ_INT1_OVP_EVENT,
+	SM5502_IRQ_INT1_OCP_EVENT,
+	SM5502_IRQ_INT1_OVP_OCP_DIS,
+
+	/* INT2 */
+	SM5502_IRQ_INT2_VBUS_DET,
+	SM5502_IRQ_INT2_REV_ACCE,
+	SM5502_IRQ_INT2_ADC_CHG,
+	SM5502_IRQ_INT2_STUCK_KEY,
+	SM5502_IRQ_INT2_STUCK_KEY_RCV,
+	SM5502_IRQ_INT2_MHL,
+
+	SM5502_IRQ_NUM,
+};
+
+#define SM5502_IRQ_INT1_ATTACH_MASK		BIT(0)
+#define SM5502_IRQ_INT1_DETACH_MASK		BIT(1)
+#define SM5502_IRQ_INT1_KP_MASK			BIT(2)
+#define SM5502_IRQ_INT1_LKP_MASK		BIT(3)
+#define SM5502_IRQ_INT1_LKR_MASK		BIT(4)
+#define SM5502_IRQ_INT1_OVP_EVENT_MASK		BIT(5)
+#define SM5502_IRQ_INT1_OCP_EVENT_MASK		BIT(6)
+#define SM5502_IRQ_INT1_OVP_OCP_DIS_MASK	BIT(7)
+#define SM5502_IRQ_INT2_VBUS_DET_MASK		BIT(0)
+#define SM5502_IRQ_INT2_REV_ACCE_MASK		BIT(1)
+#define SM5502_IRQ_INT2_ADC_CHG_MASK		BIT(2)
+#define SM5502_IRQ_INT2_STUCK_KEY_MASK		BIT(3)
+#define SM5502_IRQ_INT2_STUCK_KEY_RCV_MASK	BIT(4)
+#define SM5502_IRQ_INT2_MHL_MASK		BIT(5)
+
+#endif /*  __LINUX_EXTCON_SM5502_H */
-- 
1.8.0

