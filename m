Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbaFYHO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 03:14:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48852 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875AbaFYHOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 03:14:51 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-a0-53aa76e99586
From: Chanwoo Choi <cw00.choi@samsung.com>
To: lee.jones@linaro.org, sbkim73@samsung.com, sameo@linux.intel.com,
        broonie@kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv8 1/4] mfd: sec-core: Add support for S2MPU02 device
Date: Wed, 25 Jun 2014 16:14:44 +0900
Message-id: <1403680487-12141-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1403680487-12141-1-git-send-email-cw00.choi@samsung.com>
References: <1403680487-12141-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsWyRsSkWPdl2apggyuT1CymPnzCZnH9y3NW
	i7NNb9gt7n89ymhxedccNovbjSvYLE53s1pcXPGFyYHDY9OqTjaPO9f2sHnMOxno0bdlFaPH
	501yAaxRXDYpqTmZZalF+nYJXBn3d6xlKlhfXLFo0TLGBsZPcV2MnBwSAiYS167/YoWwxSQu
	3FvP1sXIxSEksJRR4s7cZ+wwRZ/ObWKFSExnlGi+d5QJJCEk0MQkcf2QKIjNJqAlsf/FDTYQ
	W0QgSmLuwu9gNrNArcS+a01gG4QFXCS2zu0Ci7MIqEpM77rBDGLzCrhKrGi7ywKxTE7iw55H
	YIs5BdwketafZIPY5Spx/cg5RpAjJATmsUs0bZoHNUhA4tvkQ0DNHEAJWYlNB5gh5khKHFxx
	g2UCo/ACRoZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGIHBfvrfs74djDcPWB9iTAYaN5FZ
	SjQ5HxgteSXxhsZmRhamJqbGRuaWZqQJK4nzLnqYFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmD
	U6qBce1mffuLc3tXdUTa776huGEv55cL6fM7qzebxWqw8vB+PL61SXJeT/O/E1WTHsRm1ukL
	pH8RvjJHOuAXt+nea7uPfzf2l3+o+kC4/ZTUiZW8OikF5/lW7Pp04uPOv2+m+4u0fDvfc3ph
	e1zklncTy6MaTjwxMHveZNp4PFjz57np85b3mxz4ekqJpTgj0VCLuag4EQBYYnOmjAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsVy+t9jQd2XZauCDT59k7KY+vAJm8X1L89Z
	Lc42vWG3uP/1KKPF5V1z2CxuN65gszjdzWpxccUXJgcOj02rOtk87lzbw+Yx72SgR9+WVYwe
	nzfJBbBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl
	5gCdoqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMuL9jLVPB+uKKRYuW
	MTYwforrYuTkkBAwkfh0bhMrhC0mceHeerYuRi4OIYHpjBLN944ygSSEBJqYJK4fEgWx2QS0
	JPa/uMEGYosIREnMXfgdzGYWqJXYd60JbJCwgIvE1rldYHEWAVWJ6V03mEFsXgFXiRVtd1kg
	lslJfNjziB3E5hRwk+hZf5INYperxPUj5xgnMPIuYGRYxSiaWpBcUJyUnmuoV5yYW1yal66X
	nJ+7iREcS8+kdjCubLA4xCjAwajEw3th9spgIdbEsuLK3EOMEhzMSiK8l7xWBQvxpiRWVqUW
	5ccXleakFh9iNAW6aiKzlGhyPjDO80riDY1NzIwsjcwNLYyMzZXEeQ+0WgcKCaQnlqRmp6YW
	pBbB9DFxcEo1MMr3cn5YrJg4+8PK1ErVzZtr/ZbozVsXtWKdZJXjFt/o2YJHb6cYfs0zM+Ou
	FTHocNwYuMmmWtb8tLzDzMvNP94tvieUN2lFdlFUceOthqzSKZP/Len8FFnf/+JNqWHnOgXf
	lzn35h7NinebpXjyTza/xv3tNxKMtLOZfqWn7cjv794YYsnhp8RSnJFoqMVcVJwIAFdTqPa7	AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for Samsung S2MPU02 PMIC device to the MFD sec-core driver.
The S2MPU02 device includes PMIC/RTC/Clock devices.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/sec-core.c              |  46 ++++++---
 drivers/mfd/sec-irq.c               | 110 +++++++++++++++++---
 include/linux/mfd/samsung/core.h    |   1 +
 include/linux/mfd/samsung/irq.h     |  24 +++++
 include/linux/mfd/samsung/s2mpu02.h | 201 ++++++++++++++++++++++++++++++++++++
 5 files changed, 352 insertions(+), 30 deletions(-)
 create mode 100644 include/linux/mfd/samsung/s2mpu02.h

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index be06d0a..15ba847 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -89,6 +89,15 @@ static const struct mfd_cell s2mpa01_devs[] = {
 	},
 };
 
+static const struct mfd_cell s2mpu02_devs[] = {
+	{ .name = "s2mpu02-pmic", },
+	{ .name = "s2mpu02-rtc", },
+	{
+		.name = "s2mpu02-clk",
+		.of_compatible = "samsung,s2mpu02-clk",
+	}
+};
+
 #ifdef CONFIG_OF
 static const struct of_device_id sec_dt_match[] = {
 	{	.compatible = "samsung,s5m8767-pmic",
@@ -103,6 +112,9 @@ static const struct of_device_id sec_dt_match[] = {
 		.compatible = "samsung,s2mpa01-pmic",
 		.data = (void *)S2MPA01,
 	}, {
+		.compatible = "samsung,s2mpu02-pmic",
+		.data = (void *)S2MPU02,
+	}, {
 		/* Sentinel */
 	},
 };
@@ -250,9 +262,10 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 {
 	struct sec_platform_data *pdata = dev_get_platdata(&i2c->dev);
 	const struct regmap_config *regmap;
+	const struct mfd_cell *sec_devs;
 	struct sec_pmic_dev *sec_pmic;
 	unsigned long device_type;
-	int ret;
+	int ret, num_sec_devs;
 
 	sec_pmic = devm_kzalloc(&i2c->dev, sizeof(struct sec_pmic_dev),
 				GFP_KERNEL);
@@ -319,34 +332,39 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 
 	switch (sec_pmic->device_type) {
 	case S5M8751X:
-		ret = mfd_add_devices(sec_pmic->dev, -1, s5m8751_devs,
-				      ARRAY_SIZE(s5m8751_devs), NULL, 0, NULL);
+		sec_devs = s5m8751_devs;
+		num_sec_devs = ARRAY_SIZE(s5m8751_devs);
 		break;
 	case S5M8763X:
-		ret = mfd_add_devices(sec_pmic->dev, -1, s5m8763_devs,
-				      ARRAY_SIZE(s5m8763_devs), NULL, 0, NULL);
+		sec_devs = s5m8763_devs;
+		num_sec_devs = ARRAY_SIZE(s5m8763_devs);
 		break;
 	case S5M8767X:
-		ret = mfd_add_devices(sec_pmic->dev, -1, s5m8767_devs,
-				      ARRAY_SIZE(s5m8767_devs), NULL, 0, NULL);
+		sec_devs = s5m8767_devs;
+		num_sec_devs = ARRAY_SIZE(s5m8767_devs);
 		break;
 	case S2MPA01:
-		ret = mfd_add_devices(sec_pmic->dev, -1, s2mpa01_devs,
-				      ARRAY_SIZE(s2mpa01_devs), NULL, 0, NULL);
+		sec_devs = s2mpa01_devs;
+		num_sec_devs = ARRAY_SIZE(s2mpa01_devs);
 		break;
 	case S2MPS11X:
-		ret = mfd_add_devices(sec_pmic->dev, -1, s2mps11_devs,
-				      ARRAY_SIZE(s2mps11_devs), NULL, 0, NULL);
+		sec_devs = s2mps11_devs;
+		num_sec_devs = ARRAY_SIZE(s2mps11_devs);
 		break;
 	case S2MPS14X:
-		ret = mfd_add_devices(sec_pmic->dev, -1, s2mps14_devs,
-				      ARRAY_SIZE(s2mps14_devs), NULL, 0, NULL);
+		sec_devs = s2mps14_devs;
+		num_sec_devs = ARRAY_SIZE(s2mps14_devs);
+		break;
+	case S2MPU02:
+		sec_devs = s2mpu02_devs;
+		num_sec_devs = ARRAY_SIZE(s2mpu02_devs);
 		break;
 	default:
 		/* If this happens the probe function is problem */
 		BUG();
 	}
-
+	ret = mfd_add_devices(sec_pmic->dev, -1, sec_devs, num_sec_devs, NULL,
+			      0, NULL);
 	if (ret)
 		goto err_mfd;
 
diff --git a/drivers/mfd/sec-irq.c b/drivers/mfd/sec-irq.c
index 654e2c1..f9a5786 100644
--- a/drivers/mfd/sec-irq.c
+++ b/drivers/mfd/sec-irq.c
@@ -20,6 +20,7 @@
 #include <linux/mfd/samsung/irq.h>
 #include <linux/mfd/samsung/s2mps11.h>
 #include <linux/mfd/samsung/s2mps14.h>
+#include <linux/mfd/samsung/s2mpu02.h>
 #include <linux/mfd/samsung/s5m8763.h>
 #include <linux/mfd/samsung/s5m8767.h>
 
@@ -161,6 +162,77 @@ static const struct regmap_irq s2mps14_irqs[] = {
 	},
 };
 
+static const struct regmap_irq s2mpu02_irqs[] = {
+	[S2MPU02_IRQ_PWRONF] = {
+		.reg_offset = 0,
+		.mask = S2MPS11_IRQ_PWRONF_MASK,
+	},
+	[S2MPU02_IRQ_PWRONR] = {
+		.reg_offset = 0,
+		.mask = S2MPS11_IRQ_PWRONR_MASK,
+	},
+	[S2MPU02_IRQ_JIGONBF] = {
+		.reg_offset = 0,
+		.mask = S2MPS11_IRQ_JIGONBF_MASK,
+	},
+	[S2MPU02_IRQ_JIGONBR] = {
+		.reg_offset = 0,
+		.mask = S2MPS11_IRQ_JIGONBR_MASK,
+	},
+	[S2MPU02_IRQ_ACOKBF] = {
+		.reg_offset = 0,
+		.mask = S2MPS11_IRQ_ACOKBF_MASK,
+	},
+	[S2MPU02_IRQ_ACOKBR] = {
+		.reg_offset = 0,
+		.mask = S2MPS11_IRQ_ACOKBR_MASK,
+	},
+	[S2MPU02_IRQ_PWRON1S] = {
+		.reg_offset = 0,
+		.mask = S2MPS11_IRQ_PWRON1S_MASK,
+	},
+	[S2MPU02_IRQ_MRB] = {
+		.reg_offset = 0,
+		.mask = S2MPS11_IRQ_MRB_MASK,
+	},
+	[S2MPU02_IRQ_RTC60S] = {
+		.reg_offset = 1,
+		.mask = S2MPS11_IRQ_RTC60S_MASK,
+	},
+	[S2MPU02_IRQ_RTCA1] = {
+		.reg_offset = 1,
+		.mask = S2MPS11_IRQ_RTCA1_MASK,
+	},
+	[S2MPU02_IRQ_RTCA0] = {
+		.reg_offset = 1,
+		.mask = S2MPS11_IRQ_RTCA0_MASK,
+	},
+	[S2MPU02_IRQ_SMPL] = {
+		.reg_offset = 1,
+		.mask = S2MPS11_IRQ_SMPL_MASK,
+	},
+	[S2MPU02_IRQ_RTC1S] = {
+		.reg_offset = 1,
+		.mask = S2MPS11_IRQ_RTC1S_MASK,
+	},
+	[S2MPU02_IRQ_WTSR] = {
+		.reg_offset = 1,
+		.mask = S2MPS11_IRQ_WTSR_MASK,
+	},
+	[S2MPU02_IRQ_INT120C] = {
+		.reg_offset = 2,
+		.mask = S2MPS11_IRQ_INT120C_MASK,
+	},
+	[S2MPU02_IRQ_INT140C] = {
+		.reg_offset = 2,
+		.mask = S2MPS11_IRQ_INT140C_MASK,
+	},
+	[S2MPU02_IRQ_TSD] = {
+		.reg_offset = 2,
+		.mask = S2MPS14_IRQ_TSD_MASK,
+	},
+};
+
 static const struct regmap_irq s5m8767_irqs[] = {
 	[S5M8767_IRQ_PWRR] = {
 		.reg_offset = 0,
@@ -327,6 +399,16 @@ static const struct regmap_irq_chip s2mps14_irq_chip = {
 	.ack_base = S2MPS14_REG_INT1,
 };
 
+static const struct regmap_irq_chip s2mpu02_irq_chip = {
+	.name = "s2mpu02",
+	.irqs = s2mpu02_irqs,
+	.num_irqs = ARRAY_SIZE(s2mpu02_irqs),
+	.num_regs = 3,
+	.status_base = S2MPU02_REG_INT1,
+	.mask_base = S2MPU02_REG_INT1M,
+	.ack_base = S2MPU02_REG_INT1,
+};
+
 static const struct regmap_irq_chip s5m8767_irq_chip = {
 	.name = "s5m8767",
 	.irqs = s5m8767_irqs,
@@ -351,6 +433,7 @@ int sec_irq_init(struct sec_pmic_dev *sec_pmic)
 {
 	int ret = 0;
 	int type = sec_pmic->device_type;
+	const struct regmap_irq_chip *sec_irq_chip;
 
 	if (!sec_pmic->irq) {
 		dev_warn(sec_pmic->dev,
@@ -361,28 +444,19 @@ int sec_irq_init(struct sec_pmic_dev *sec_pmic)
 
 	switch (type) {
 	case S5M8763X:
-		ret = regmap_add_irq_chip(sec_pmic->regmap_pmic, sec_pmic->irq,
-				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-				  sec_pmic->irq_base, &s5m8763_irq_chip,
-				  &sec_pmic->irq_data);
+		sec_irq_chip = &s5m8763_irq_chip;
 		break;
 	case S5M8767X:
-		ret = regmap_add_irq_chip(sec_pmic->regmap_pmic, sec_pmic->irq,
-				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-				  sec_pmic->irq_base, &s5m8767_irq_chip,
-				  &sec_pmic->irq_data);
+		sec_irq_chip = &s5m8767_irq_chip;
 		break;
 	case S2MPS11X:
-		ret = regmap_add_irq_chip(sec_pmic->regmap_pmic, sec_pmic->irq,
-				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-				  sec_pmic->irq_base, &s2mps11_irq_chip,
-				  &sec_pmic->irq_data);
+		sec_irq_chip = &s2mps11_irq_chip;
 		break;
 	case S2MPS14X:
-		ret = regmap_add_irq_chip(sec_pmic->regmap_pmic, sec_pmic->irq,
-				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-				  sec_pmic->irq_base, &s2mps14_irq_chip,
-				  &sec_pmic->irq_data);
+		sec_irq_chip = &s2mps14_irq_chip;
+		break;
+	case S2MPU02:
+		sec_irq_chip = &s2mpu02_irq_chip;
 		break;
 	default:
 		dev_err(sec_pmic->dev, "Unknown device type %lu\n",
@@ -390,6 +464,10 @@ int sec_irq_init(struct sec_pmic_dev *sec_pmic)
 		return -EINVAL;
 	}
 
+	ret = regmap_add_irq_chip(sec_pmic->regmap_pmic, sec_pmic->irq,
+			  IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+			  sec_pmic->irq_base, sec_irq_chip,
+			  &sec_pmic->irq_data);
 	if (ret != 0) {
 		dev_err(sec_pmic->dev, "Failed to register IRQ chip: %d\n", ret);
 		return ret;
diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
index 47d8424..b5f73de 100644
--- a/include/linux/mfd/samsung/core.h
+++ b/include/linux/mfd/samsung/core.h
@@ -21,6 +21,7 @@ enum sec_device_type {
 	S2MPA01,
 	S2MPS11X,
 	S2MPS14X,
+	S2MPU02,
 };
 
 /**
diff --git a/include/linux/mfd/samsung/irq.h b/include/linux/mfd/samsung/irq.h
index 1224f44..f35af73 100644
--- a/include/linux/mfd/samsung/irq.h
+++ b/include/linux/mfd/samsung/irq.h
@@ -129,6 +129,30 @@ enum s2mps14_irq {
 	S2MPS14_IRQ_NR,
 };
 
+enum s2mpu02_irq {
+	S2MPU02_IRQ_PWRONF,
+	S2MPU02_IRQ_PWRONR,
+	S2MPU02_IRQ_JIGONBF,
+	S2MPU02_IRQ_JIGONBR,
+	S2MPU02_IRQ_ACOKBF,
+	S2MPU02_IRQ_ACOKBR,
+	S2MPU02_IRQ_PWRON1S,
+	S2MPU02_IRQ_MRB,
+
+	S2MPU02_IRQ_RTC60S,
+	S2MPU02_IRQ_RTCA1,
+	S2MPU02_IRQ_RTCA0,
+	S2MPU02_IRQ_SMPL,
+	S2MPU02_IRQ_RTC1S,
+	S2MPU02_IRQ_WTSR,
+
+	S2MPU02_IRQ_INT120C,
+	S2MPU02_IRQ_INT140C,
+	S2MPU02_IRQ_TSD,
+
+	S2MPU02_IRQ_NR,
+};
+
 /* Masks for interrupts are the same as in s2mps11 */
 #define S2MPS14_IRQ_TSD_MASK		(1 << 2)
 
diff --git a/include/linux/mfd/samsung/s2mpu02.h b/include/linux/mfd/samsung/s2mpu02.h
new file mode 100644
index 0000000..47ae9bc
--- /dev/null
+++ b/include/linux/mfd/samsung/s2mpu02.h
@@ -0,0 +1,201 @@
+/*
+ * s2mpu02.h
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd
+ *              http://www.samsung.com
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
+ *
+ */
+
+#ifndef __LINUX_MFD_S2MPU02_H
+#define __LINUX_MFD_S2MPU02_H
+
+/* S2MPU02 registers */
+enum S2MPU02_reg {
+	S2MPU02_REG_ID,
+	S2MPU02_REG_INT1,
+	S2MPU02_REG_INT2,
+	S2MPU02_REG_INT3,
+	S2MPU02_REG_INT1M,
+	S2MPU02_REG_INT2M,
+	S2MPU02_REG_INT3M,
+	S2MPU02_REG_ST1,
+	S2MPU02_REG_ST2,
+	S2MPU02_REG_PWRONSRC,
+	S2MPU02_REG_OFFSRC,
+	S2MPU02_REG_BU_CHG,
+	S2MPU02_REG_RTCCTRL,
+	S2MPU02_REG_PMCTRL1,
+	S2MPU02_REG_RSVD1,
+	S2MPU02_REG_RSVD2,
+	S2MPU02_REG_RSVD3,
+	S2MPU02_REG_RSVD4,
+	S2MPU02_REG_RSVD5,
+	S2MPU02_REG_RSVD6,
+	S2MPU02_REG_RSVD7,
+	S2MPU02_REG_WRSTEN,
+	S2MPU02_REG_RSVD8,
+	S2MPU02_REG_RSVD9,
+	S2MPU02_REG_RSVD10,
+	S2MPU02_REG_B1CTRL1,
+	S2MPU02_REG_B1CTRL2,
+	S2MPU02_REG_B2CTRL1,
+	S2MPU02_REG_B2CTRL2,
+	S2MPU02_REG_B3CTRL1,
+	S2MPU02_REG_B3CTRL2,
+	S2MPU02_REG_B4CTRL1,
+	S2MPU02_REG_B4CTRL2,
+	S2MPU02_REG_B5CTRL1,
+	S2MPU02_REG_B5CTRL2,
+	S2MPU02_REG_B5CTRL3,
+	S2MPU02_REG_B5CTRL4,
+	S2MPU02_REG_B5CTRL5,
+	S2MPU02_REG_B6CTRL1,
+	S2MPU02_REG_B6CTRL2,
+	S2MPU02_REG_B7CTRL1,
+	S2MPU02_REG_B7CTRL2,
+	S2MPU02_REG_RAMP1,
+	S2MPU02_REG_RAMP2,
+	S2MPU02_REG_L1CTRL,
+	S2MPU02_REG_L2CTRL1,
+	S2MPU02_REG_L2CTRL2,
+	S2MPU02_REG_L2CTRL3,
+	S2MPU02_REG_L2CTRL4,
+	S2MPU02_REG_L3CTRL,
+	S2MPU02_REG_L4CTRL,
+	S2MPU02_REG_L5CTRL,
+	S2MPU02_REG_L6CTRL,
+	S2MPU02_REG_L7CTRL,
+	S2MPU02_REG_L8CTRL,
+	S2MPU02_REG_L9CTRL,
+	S2MPU02_REG_L10CTRL,
+	S2MPU02_REG_L11CTRL,
+	S2MPU02_REG_L12CTRL,
+	S2MPU02_REG_L13CTRL,
+	S2MPU02_REG_L14CTRL,
+	S2MPU02_REG_L15CTRL,
+	S2MPU02_REG_L16CTRL,
+	S2MPU02_REG_L17CTRL,
+	S2MPU02_REG_L18CTRL,
+	S2MPU02_REG_L19CTRL,
+	S2MPU02_REG_L20CTRL,
+	S2MPU02_REG_L21CTRL,
+	S2MPU02_REG_L22CTRL,
+	S2MPU02_REG_L23CTRL,
+	S2MPU02_REG_L24CTRL,
+	S2MPU02_REG_L25CTRL,
+	S2MPU02_REG_L26CTRL,
+	S2MPU02_REG_L27CTRL,
+	S2MPU02_REG_L28CTRL,
+	S2MPU02_REG_LDODSCH1,
+	S2MPU02_REG_LDODSCH2,
+	S2MPU02_REG_LDODSCH3,
+	S2MPU02_REG_LDODSCH4,
+	S2MPU02_REG_SELMIF,
+	S2MPU02_REG_RSVD11,
+	S2MPU02_REG_RSVD12,
+	S2MPU02_REG_RSVD13,
+	S2MPU02_REG_DVSSEL,
+	S2MPU02_REG_DVSPTR,
+	S2MPU02_REG_DVSDATA,
+};
+
+/* S2MPU02 regulator ids */
+enum S2MPU02_regulators {
+	S2MPU02_LDO1,
+	S2MPU02_LDO2,
+	S2MPU02_LDO3,
+	S2MPU02_LDO4,
+	S2MPU02_LDO5,
+	S2MPU02_LDO6,
+	S2MPU02_LDO7,
+	S2MPU02_LDO8,
+	S2MPU02_LDO9,
+	S2MPU02_LDO10,
+	S2MPU02_LDO11,
+	S2MPU02_LDO12,
+	S2MPU02_LDO13,
+	S2MPU02_LDO14,
+	S2MPU02_LDO15,
+	S2MPU02_LDO16,
+	S2MPU02_LDO17,
+	S2MPU02_LDO18,
+	S2MPU02_LDO19,
+	S2MPU02_LDO20,
+	S2MPU02_LDO21,
+	S2MPU02_LDO22,
+	S2MPU02_LDO23,
+	S2MPU02_LDO24,
+	S2MPU02_LDO25,
+	S2MPU02_LDO26,
+	S2MPU02_LDO27,
+	S2MPU02_LDO28,
+	S2MPU02_BUCK1,
+	S2MPU02_BUCK2,
+	S2MPU02_BUCK3,
+	S2MPU02_BUCK4,
+	S2MPU02_BUCK5,
+	S2MPU02_BUCK6,
+	S2MPU02_BUCK7,
+
+	S2MPU02_REGULATOR_MAX,
+};
+
+/* Regulator constraints for BUCKx */
+#define S2MPU02_BUCK1234_MIN_600MV	600000
+#define S2MPU02_BUCK5_MIN_1081_25MV	1081250
+#define S2MPU02_BUCK6_MIN_1700MV	1700000
+#define S2MPU02_BUCK7_MIN_900MV		900000
+
+#define S2MPU02_BUCK1234_STEP_6_25MV	6250
+#define S2MPU02_BUCK5_STEP_6_25MV	6250
+#define S2MPU02_BUCK6_STEP_2_50MV	2500
+#define S2MPU02_BUCK7_STEP_6_25MV	6250
+
+#define S2MPU02_BUCK1234_START_SEL	0x00
+#define S2MPU02_BUCK5_START_SEL		0x4D
+#define S2MPU02_BUCK6_START_SEL		0x28
+#define S2MPU02_BUCK7_START_SEL		0x30
+
+#define S2MPU02_BUCK_RAMP_DELAY		12500
+
+/* Regulator constraints for different types of LDOx */
+#define S2MPU02_LDO_MIN_900MV		900000
+#define S2MPU02_LDO_MIN_1050MV		1050000
+#define S2MPU02_LDO_MIN_1600MV		1600000
+#define S2MPU02_LDO_STEP_12_5MV		12500
+#define S2MPU02_LDO_STEP_25MV		25000
+#define S2MPU02_LDO_STEP_50MV		50000
+
+#define S2MPU02_LDO_GROUP1_START_SEL	0x8
+#define S2MPU02_LDO_GROUP2_START_SEL	0xA
+#define S2MPU02_LDO_GROUP3_START_SEL	0x10
+
+#define S2MPU02_LDO_VSEL_MASK		0x3F
+#define S2MPU02_BUCK_VSEL_MASK		0xFF
+#define S2MPU02_ENABLE_MASK		(0x03 << S2MPU02_ENABLE_SHIFT)
+#define S2MPU02_ENABLE_SHIFT		6
+
+/* On/Off controlled by PWREN */
+#define S2MPU02_ENABLE_SUSPEND		(0x01 << S2MPU02_ENABLE_SHIFT)
+#define S2MPU02_DISABLE_SUSPEND		(0x11 << S2MPU02_ENABLE_SHIFT)
+#define S2MPU02_LDO_N_VOLTAGES		(S2MPU02_LDO_VSEL_MASK + 1)
+#define S2MPU02_BUCK_N_VOLTAGES		(S2MPU02_BUCK_VSEL_MASK + 1)
+
+/* RAMP delay for BUCK1234*/
+#define S2MPU02_BUCK1_RAMP_SHIFT	6
+#define S2MPU02_BUCK2_RAMP_SHIFT	4
+#define S2MPU02_BUCK3_RAMP_SHIFT	2
+#define S2MPU02_BUCK4_RAMP_SHIFT	0
+#define S2MPU02_BUCK1234_RAMP_MASK	0x3
+
+#endif /*  __LINUX_MFD_S2MPU02_H */
-- 
1.8.0

