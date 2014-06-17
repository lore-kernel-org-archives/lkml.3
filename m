Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbaFQA1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 20:27:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:25933 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaFQA1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 20:27:19 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-2e-539f8b64ae92
From: Chanwoo Choi <cw00.choi@samsung.com>
To: lee.jones@linaro.org, broonie@kernel.org, sameo@linux.intel.com
Cc: sbkim73@samsung.com, k.kozlowski@samsung.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, t.figa@samsung.com,
        sachin.kamat@linaro.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv6 1/3] mfd: sec-core: Add support for S2MPU02 device
Date: Tue, 17 Jun 2014 09:27:08 +0900
Message-id: <1402964830-24890-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1402964830-24890-1-git-send-email-cw00.choi@samsung.com>
References: <1402964830-24890-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsWyRsSkSDele36wwYWHphZTHz5hs7j+5Tmr
	xfwj51gt+t8sZLU492olo8XrF4YWZ5vesFvc/3qU0eLyrjlsFkuvX2SyuN24gs1iwvS1LBZv
	70xnsWjde4Td4uSfXkaL092sFhdXfGGyWD/jNYuDkMeaeWsYPS739TJ5rFz+hc1j8wotj02r
	Otk87lzbw+Yx72SgR9+WVYwenzfJBXBGcdmkpOZklqUW6dslcGU0rmlkLbjgXnH2eSNLA+NV
	yy5GTg4JAROJFx8mMUPYYhIX7q1n62Lk4hASWMoo8eTqdCCHA6zo2L9EiPgiRom97R3MEE4T
	k8T5X3uYQLrZBLQk9r+4wQZiiwg4S3z/NBFsErNAG7PEyqVT2UESwgIuEuf/LAJbxyKgKrH1
	8C0wm1fAVWLJ+nlsEGfISXzY8wisnlPATeJo6zFWEFsIqGZp81p2kKESAp0cEj09H1khBglI
	fJt8iAXiVFmJTQeg3pGUOLjiBssERuEFjAyrGEVTC5ILipPSi4z0ihNzi0vz0vWS83M3MQLj
	7vS/Z307GG8esD7EmAw0biKzlGhyPjBu80riDY3NjCxMTUyNjcwtzUgTVhLnXfQwKUhIID2x
	JDU7NbUgtSi+qDQntfgQIxMHp1QDo4lQ302Fj1c+tD8+G1KjdjpB41aLa2bnaVtH52Ntrx4s
	/fd8s7S5vg7Di6JVsUvYv9+9nPd179tO2RbtuKdrVuq9LCpcter6otNaObdmXphdx5G23OuY
	tpfuDYm3/PI9vkr9LEpRdjuZ9+kaS7mpTVu1a2NTpNIfg8ode/u/h7RNMYm69qLOUImlOCPR
	UIu5qDgRAJIbSTzRAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jAd2U7vnBBpdadSymPnzCZnH9y3NW
	i/lHzrFa9L9ZyGpx7tVKRovXLwwtzja9Ybe4//Uoo8XlXXPYLJZev8hkcbtxBZvFhOlrWSze
	3pnOYtG69wi7xck/vYwWp7tZLS6u+MJksX7GaxYHIY8189Ywelzu62XyWLn8C5vH5hVaHptW
	dbJ53Lm2h81j3slAj74tqxg9Pm+SC+CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDU
	NbS0MFdSyEvMTbVVcvEJ0HXLzAF6R0mhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+R
	ARpIWMOY0bimkbXggnvF2eeNLA2MVy27GDk4JARMJI79S+xi5AQyxSQu3FvP1sXIxSEksIhR
	Ym97BzOE08Qkcf7XHiaQKjYBLYn9L26wgdgiAs4S3z9NBOtgFmhjlli5dCo7SEJYwEXi/J9F
	zCA2i4CqxNbDt8BsXgFXiSXr57FBrJOT+LDnEVg9p4CbxNHWY6wgthBQzdLmtewTGHkXMDKs
	YhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiO6mdSOxhXNlgcYhTgYFTi4X0oOz9YiDWxrLgy
	9xCjBAezkggvlzlQiDclsbIqtSg/vqg0J7X4EGMy0FUTmaVEk/OBCSevJN7Q2MTMyNLI3NDC
	yNicNGElcd4DrdaBQgLpiSWp2ampBalFMFuYODilGhjDbfj53oppnOKc5Jb+8ZiLPEvEde6V
	U3tcDLzyuY/c77i8aNPJ6R11D2N2385L+PbIUGrxeaPMsoZNzasDz/hI8zGL5TMHPunok5aJ
	fvzKy0vM2r6o6GvEyXlmV0V7X2yX/M1T8Wht3QSbXXodT4Ld7Dea7+Hc/Vklpe70f5mpWXN6
	ZxxZ/UGJpTgj0VCLuag4EQBrYvIBLgMAAA==
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
 drivers/mfd/sec-core.c           |  46 +++++++++++-----
 drivers/mfd/sec-irq.c            | 110 +++++++++++++++++++++++++++++++++------
 include/linux/mfd/samsung/core.h |   1 +
 include/linux/mfd/samsung/irq.h  |  24 +++++++++
 4 files changed, 151 insertions(+), 30 deletions(-)

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
 
-- 
1.8.0

