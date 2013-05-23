Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607Ab3EWLLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 07:11:41 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:45675 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758215Ab3EWLLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 07:11:39 -0400
From: <yizhang.mrvl@gmail.com>
To: <sameo@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <yizhang.mrvl@gmail.com>
CC: <cxie4@marvell.com>, <arnd@arndb.de>, <yizhang@marvell.com>,
        <linux-kernel@vger.kernel.org>, <jtzhou@marvell.com>
Subject: [PATCH 4/4] mfd: 88pm800: add regulator support
Date: Thu, 23 May 2013 19:10:47 +0800
Message-ID: <1369307447-17874-5-git-send-email-yizhang.mrvl@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1369307447-17874-1-git-send-email-yizhang.mrvl@gmail.com>
References: <1369307447-17874-1-git-send-email-yizhang.mrvl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yi Zhang <yizhang@marvell.com>

Signed-off-by: Yi Zhang <yizhang@marvell.com>
---
 drivers/mfd/88pm800.c       |  108 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/88pm80x.h |   48 +++++++++++++++++++
 2 files changed, 156 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
index 475b5fa..46085e9 100644
--- a/drivers/mfd/88pm800.c
+++ b/drivers/mfd/88pm800.c
@@ -167,6 +167,62 @@ static struct mfd_cell onkey_devs[] = {
 	 },
 };
 
+static struct resource regulator_resources[] = {
+	{PM800_ID_BUCK1, PM800_ID_BUCK1, "buck-1", IORESOURCE_IO,},
+	{PM800_ID_BUCK2, PM800_ID_BUCK2, "buck-2", IORESOURCE_IO,},
+	{PM800_ID_BUCK3, PM800_ID_BUCK3, "buck-3", IORESOURCE_IO,},
+	{PM800_ID_BUCK4, PM800_ID_BUCK4, "buck-4", IORESOURCE_IO,},
+	{PM800_ID_BUCK5, PM800_ID_BUCK5, "buck-5", IORESOURCE_IO,},
+	{PM800_ID_LDO1, PM800_ID_LDO1, "ldo-01", IORESOURCE_IO,},
+	{PM800_ID_LDO2, PM800_ID_LDO2, "ldo-02", IORESOURCE_IO,},
+	{PM800_ID_LDO3, PM800_ID_LDO3, "ldo-03", IORESOURCE_IO,},
+	{PM800_ID_LDO4, PM800_ID_LDO4, "ldo-04", IORESOURCE_IO,},
+	{PM800_ID_LDO5, PM800_ID_LDO5, "ldo-05", IORESOURCE_IO,},
+	{PM800_ID_LDO6, PM800_ID_LDO6, "ldo-06", IORESOURCE_IO,},
+	{PM800_ID_LDO7, PM800_ID_LDO7, "ldo-07", IORESOURCE_IO,},
+	{PM800_ID_LDO8, PM800_ID_LDO8, "ldo-08", IORESOURCE_IO,},
+	{PM800_ID_LDO9, PM800_ID_LDO9, "ldo-09", IORESOURCE_IO,},
+	{PM800_ID_LDO10, PM800_ID_LDO10, "ldo-10", IORESOURCE_IO,},
+	{PM800_ID_LDO11, PM800_ID_LDO11, "ldo-11", IORESOURCE_IO,},
+	{PM800_ID_LDO12, PM800_ID_LDO12, "ldo-12", IORESOURCE_IO,},
+	{PM800_ID_LDO13, PM800_ID_LDO13, "ldo-13", IORESOURCE_IO,},
+	{PM800_ID_LDO14, PM800_ID_LDO14, "ldo-14", IORESOURCE_IO,},
+	{PM800_ID_LDO15, PM800_ID_LDO15, "ldo-15", IORESOURCE_IO,},
+	{PM800_ID_LDO16, PM800_ID_LDO16, "ldo-16", IORESOURCE_IO,},
+	{PM800_ID_LDO17, PM800_ID_LDO17, "ldo-17", IORESOURCE_IO,},
+	{PM800_ID_LDO18, PM800_ID_LDO18, "ldo-18", IORESOURCE_IO,},
+	{PM800_ID_LDO19, PM800_ID_LDO19, "ldo-19", IORESOURCE_IO,},
+};
+
+static struct mfd_cell regulator_devs[] = {
+	{"88pm80x-regulator", 0,},
+	{"88pm80x-regulator", 1,},
+	{"88pm80x-regulator", 2,},
+	{"88pm80x-regulator", 3,},
+	{"88pm80x-regulator", 4,},
+	{"88pm80x-regulator", 5,},
+	{"88pm80x-regulator", 6,},
+	{"88pm80x-regulator", 7,},
+	{"88pm80x-regulator", 8,},
+	{"88pm80x-regulator", 9,},
+	{"88pm80x-regulator", 10,},
+	{"88pm80x-regulator", 11,},
+	{"88pm80x-regulator", 12,},
+	{"88pm80x-regulator", 13,},
+	{"88pm80x-regulator", 14,},
+	{"88pm80x-regulator", 15,},
+	{"88pm80x-regulator", 16,},
+	{"88pm80x-regulator", 17,},
+	{"88pm80x-regulator", 18,},
+	{"88pm80x-regulator", 19,},
+	{"88pm80x-regulator", 20,},
+	{"88pm80x-regulator", 21,},
+	{"88pm80x-regulator", 22,},
+	{"88pm80x-regulator", 23,},
+};
+
+static struct regulator_init_data regulator_pdata[ARRAY_SIZE(regulator_devs)];
+
 static const struct regmap_irq pm800_irqs[] = {
 	/* INT0 */
 	[PM800_IRQ_ONKEY] = {
@@ -315,6 +371,52 @@ out:
 	return ret;
 }
 
+static int device_regulator_init(struct pm80x_chip *chip,
+					   struct pm80x_platform_data *pdata)
+{
+	struct regulator_init_data *initdata;
+	int ret = 0;
+	int i, seq;
+
+	if (!pdata || !pdata->regulator) {
+		dev_warn(chip->dev, "Regulator pdata is unavailable!\n");
+		return 0;
+	}
+
+	if (pdata->num_regulators > ARRAY_SIZE(regulator_devs))
+		pdata->num_regulators = ARRAY_SIZE(regulator_devs);
+
+	for (i = 0; i < pdata->num_regulators; i++) {
+		initdata = &pdata->regulator[i];
+		seq = *(unsigned int *)initdata->driver_data;
+		if ((seq < 0) || (seq > PM800_ID_RG_MAX)) {
+			dev_err(chip->dev, "Wrong ID(%d) on regulator(%s)\n",
+				seq, initdata->constraints.name);
+			ret = -EINVAL;
+			goto out_err;
+		}
+		memcpy(&regulator_pdata[i], &pdata->regulator[i],
+		       sizeof(struct regulator_init_data));
+		regulator_devs[i].platform_data = &regulator_pdata[i];
+		regulator_devs[i].pdata_size =
+			sizeof(struct regulator_init_data);
+		regulator_devs[i].num_resources = 1;
+		regulator_devs[i].resources = &regulator_resources[seq];
+
+		ret = mfd_add_devices(chip->dev, 0, &regulator_devs[i], 1,
+				      &regulator_resources[seq], 0, NULL);
+		if (ret < 0) {
+			dev_err(chip->dev, "Failed to add regulator subdev\n");
+			goto out_err;
+		}
+	}
+
+	return 0;
+
+out_err:
+	return ret;
+}
+
 static int device_irq_init_800(struct pm80x_chip *chip)
 {
 	struct regmap *map = chip->regmap;
@@ -479,6 +581,12 @@ static int device_800_init(struct pm80x_chip *chip,
 		goto out;
 	}
 
+	ret = device_regulator_init(chip, pdata);
+	if (ret < 0) {
+		dev_err(chip->dev, "[%s]Failed to init regulators\n", __func__);
+		goto out;
+	}
+
 	ret =
 	    mfd_add_devices(chip->dev, 0, &onkey_devs[0],
 			    ARRAY_SIZE(onkey_devs), &onkey_resources[0], 0,
diff --git a/include/linux/mfd/88pm80x.h b/include/linux/mfd/88pm80x.h
index e94537b..2a3a959 100644
--- a/include/linux/mfd/88pm80x.h
+++ b/include/linux/mfd/88pm80x.h
@@ -16,6 +16,7 @@
 #include <linux/interrupt.h>
 #include <linux/regmap.h>
 #include <linux/atomic.h>
+#include <linux/regulator/machine.h>
 
 #define PM80X_VERSION_MASK		(0xFF)	/* 80X chip ID mask */
 enum {
@@ -139,6 +140,51 @@ enum {
 #define PM800_BUCK1_SLP1_SHIFT	0
 #define PM800_BUCK1_SLP1_MASK	(0x3 << PM800_BUCK1_SLP1_SHIFT)
 
+/* page 1 POWER */
+
+/* BUCK4 with DVC[0..3] */
+#define PM800_AUDIO_MODE_CONFIG1	(0x38)
+#define PM800_BUCK3		(0x41)
+#define PM800_BUCK4		(0x42)
+#define PM800_BUCK4_1		(0x43)
+#define PM800_BUCK4_2		(0x44)
+#define PM800_BUCK4_3		(0x45)
+#define PM800_BUCK5		(0x46)
+/* BUCK Sleep Mode Register 2: BUCK5 */
+#define PM800_BUCK_SLP2		(0x5B)
+#define PM800_BUCK5_SLP2_SHIFT	0
+#define PM800_BUCK5_SLP2_MASK	(0x3 << PM800_BUCK5_SLP2_SHIFT)
+
+#define PM800_LDO1_1		(0x08)
+#define PM800_LDO1_2		(0x09)
+#define PM800_LDO1_3		(0x0a)
+#define PM800_LDO2		(0x0b)
+#define PM800_LDO3		(0x0c)
+#define PM800_LDO4		(0x0d)
+#define PM800_LDO5		(0x0e)
+#define PM800_LDO6		(0x0f)
+#define PM800_LDO7		(0x10)
+#define PM800_LDO8		(0x11)
+#define PM800_LDO9		(0x12)
+#define PM800_LDO10		(0x13)
+#define PM800_LDO11		(0x14)
+#define PM800_LDO12		(0x15)
+#define PM800_LDO13		(0x16)
+#define PM800_LDO14		(0x17)
+#define PM800_LDO15		(0x18)
+#define PM800_LDO16		(0x19)
+#define PM800_LDO17		(0x1a)
+#define PM800_LDO18		(0x1b)
+#define PM800_LDO19		(0x1c)
+/* LDO Sleep Mode Register 5: LDO[17..19] */
+#define PM800_LDO_SLP5		(0x60)
+#define PM800_LDO17_SLP5_SHIFT	0
+#define PM800_LDO17_SLP5_MASK	(0x3 << PM800_LDO17_SLP5_SHIFT)
+#define PM800_LDO18_SLP5_SHIFT	2
+#define PM800_LDO18_SLP5_MASK	(0x3 << PM800_LDO18_SLP5_SHIFT)
+#define PM800_LDO19_SLP5_SHIFT	4
+#define PM800_LDO19_SLP5_MASK	(0x3 << PM800_LDO19_SLP5_SHIFT)
+
 /* page 2 GPADC: slave adder 0x02 */
 #define PM800_GPADC_MEAS_EN1		(0x01)
 #define PM800_MEAS_EN1_VBAT         (1 << 2)
@@ -309,10 +355,12 @@ struct pm80x_chip {
 
 struct pm80x_platform_data {
 	struct pm80x_rtc_pdata *rtc;
+	struct regulator_init_data *regulator;
 	unsigned short power_page_addr;	/* power page I2C address */
 	unsigned short gpadc_page_addr;	/* gpadc page I2C address */
 	int irq_mode;		/* Clear interrupt by read/write(0/1) */
 	int batt_det;		/* enable/disable */
+	int num_regulators;
 	int (*plat_config)(struct pm80x_chip *chip,
 				struct pm80x_platform_data *pdata);
 };
-- 
1.7.0.4

