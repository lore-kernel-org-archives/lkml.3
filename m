Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbaE3AZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 20:25:18 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:44272 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaE3AZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 20:25:15 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-ca-5387cfe875fd
From: Chanwoo Choi <cw00.choi@samsung.com>
To: sbkim73@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        broonie@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com, k.kozlowski@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 1/3] mfd: sec-core: Add support for S2MPU02 device
Date: Fri, 30 May 2014 09:25:08 +0900
Message-id: <1401409510-28238-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1401409510-28238-1-git-send-email-cw00.choi@samsung.com>
References: <1401409510-28238-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42JZI2JSpPvyfHuwwY/HLBZTHz5hs7j+5Tmr
	RefZJ8wWr18YWpxtesNucf/rUUaLb1c6mCwu75rDZnG7cQWbxeluVouLK74wOXB77Jx1l91j
	06pONo871/awecw7GejRt2UVo8fnTXIBbFFcNimpOZllqUX6dglcGQubtrAX9OlXHP86kb2B
	sVWti5GTQ0LAROJAzy82CFtM4sK99UA2F4eQwFJGic1Nu5lhivZ9+AaVWMQocW/fdxYIp4lJ
	Yv2eV4wgVWwCWhL7X9wAqxIR6GWU6J/ZzwTiMAtMYZT42NkEtkRYwEXi59ep7CA2i4CqRMfK
	aWBxXgFXiRPt11gh9slJfNjzCKyGU8BNYn/3bRYQWwio5vzRnSwQNfvYJebc9YCYIyDxbfIh
	oDgHUFxWYtMBqLMlJQ6uuMEygVF4ASPDKkbR1ILkguKk9CJDveLE3OLSvHS95PzcTYzAuDj9
	71nvDsbbB6wPMSYDjZvILCWanA+Mq7ySeENjMyMLUxNTYyNzSzPShJXEeZMeJgUJCaQnlqRm
	p6YWpBbFF5XmpBYfYmTi4JRqYDziqRyp8OGJ7pNrDR1Xt6btlb2hvPXIz80Vf75teL1C2WnP
	Lfv5VQJVjvuW1ve+81shVJDx3/cCv+I+m66e0ozeW81duXlbNu6/pdqy+LTNUre21GKDoKjS
	6VOERNb3Rwt/EOJS+HmouLjj+Kav27WuZN49l7A+m/XwCnHmtb1vFn8+dvLu7QwlluKMREMt
	5qLiRABhg+KWoQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t9jAd0X59uDDR59NLeY+vAJm8X1L89Z
	LTrPPmG2eP3C0OJs0xt2i/tfjzJafLvSwWRxedccNovbjSvYLE53s1pcXPGFyYHbY+esu+we
	m1Z1snncubaHzWPeyUCPvi2rGD0+b5ILYItqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUz
	MNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpOSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBc
	j5EBGkhYw5ixsGkLe0GffsXxrxPZGxhb1boYOTkkBEwk9n34xgZhi0lcuLceyObiEBJYxChx
	b993FginiUli/Z5XjCBVbAJaEvtf3ACrEhHoZZTon9nPBOIwC0xhlPjY2QQ2S1jAReLn16ns
	IDaLgKpEx8ppYHFeAVeJE+3XWCH2yUl82PMIrIZTwE1if/dtFhBbCKjm/NGdLBMYeRcwMqxi
	FE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI67Z9I7GFc1WBxiFOBgVOLhnZDeHizEmlhWXJl7
	iFGCg1lJhNfxMFCINyWxsiq1KD++qDQntfgQYzLQVROZpUST84EpIa8k3tDYxMzI0sjc0MLI
	2Jw0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGHnmtH8uKt2Rx149/dRxdb+MZ+HXX82W
	+Pm57V7QlWSbfJuaxbIPL2tOvWjTLnq4stbS6djTwl33G423OX/dKfLHMEdp2cIKGzFRvpKd
	pf+tOu0mLs5v2blxr9sht2Ov2VgUOjcZzONsfj3p2ca8mcy1Fls3fEjm3PY1Ly5uJ3trwrpv
	hyTrFiixFGckGmoxFxUnAgAKsuVh/wIAAA==
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
 drivers/mfd/sec-core.c           | 19 +++++++++
 drivers/mfd/sec-irq.c            | 88 ++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/samsung/core.h |  1 +
 include/linux/mfd/samsung/irq.h  | 24 +++++++++++
 4 files changed, 132 insertions(+)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 1cf2752..317b157 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -90,6 +90,17 @@ static const struct mfd_cell s2mpa01_devs[] = {
 	},
 };
 
+static const struct mfd_cell s2mpu02_devs[] = {
+	{
+		.name = "s2mpu02-pmic",
+	}, {
+		.name = "s2mpu02-rtc",
+	}, {
+		.name = "s2mpu02-clk",
+		.of_compatible = "samsung,s2mpu02-clk",
+	}
+};
+
 #ifdef CONFIG_OF
 static struct of_device_id sec_dt_match[] = {
 	{	.compatible = "samsung,s5m8767-pmic",
@@ -104,6 +115,9 @@ static struct of_device_id sec_dt_match[] = {
 		.compatible = "samsung,s2mpa01-pmic",
 		.data = (void *)S2MPA01,
 	}, {
+		.compatible = "samsung,s2mpu02-pmic",
+		.data = (void *)S2MPU02,
+	}, {
 		/* Sentinel */
 	},
 };
@@ -389,6 +403,11 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 		ret = mfd_add_devices(sec_pmic->dev, -1, s2mps14_devs,
 				      ARRAY_SIZE(s2mps14_devs), NULL, 0, NULL);
 		break;
+	case S2MPU02:
+		ret = mfd_add_devices(sec_pmic->dev, -1, s2mpu02_devs,
+				      ARRAY_SIZE(s2mpu02_devs), NULL, 0, NULL);
+		break;
+
 	default:
 		/* If this happens the probe function is problem */
 		BUG();
diff --git a/drivers/mfd/sec-irq.c b/drivers/mfd/sec-irq.c
index 64e7913..c25cccc 100644
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
@@ -384,6 +466,12 @@ int sec_irq_init(struct sec_pmic_dev *sec_pmic)
 				  sec_pmic->irq_base, &s2mps14_irq_chip,
 				  &sec_pmic->irq_data);
 		break;
+	case S2MPU02:
+		ret = regmap_add_irq_chip(sec_pmic->regmap_pmic, sec_pmic->irq,
+				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+				  sec_pmic->irq_base, &s2mpu02_irq_chip,
+				  &sec_pmic->irq_data);
+		break;
 	default:
 		dev_err(sec_pmic->dev, "Unknown device type %d\n",
 			sec_pmic->device_type);
diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
index 157e32b..cb89442 100644
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

