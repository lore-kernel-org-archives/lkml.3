Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbaE1LLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 07:11:00 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:8302 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaE1LKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 07:10:18 -0400
X-AuditID: cbfee68f-b7fef6d000003970-bd-5385c418544f
From: Chanwoo Choi <cw00.choi@samsung.com>
To: sbkim73@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        broonie@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 1/4] mfd: sec-core: Add support for S2MPU02 device
Date: Wed, 28 May 2014 20:10:08 +0900
Message-id: <1401275411-21947-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1401275411-21947-1-git-send-email-cw00.choi@samsung.com>
References: <1401275411-21947-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42JZI2JSoitxpDXYYMM+doupD5+wWVz/8pzV
	ovPsE2aLs01v2C3ufz3KaPHtSgeTxeVdc9gsbjeuYLM43c1qcXHFFyYHLo+ds+6ye2xa1cnm
	cefaHjaPeScDPfq2rGL0+LxJLoAtissmJTUnsyy1SN8ugStj294tjAWX9Cr2nDnD2sB4TrWL
	kZNDQsBE4s2tNYwQtpjEhXvr2UBsIYGljBK/HvrA1Cw6epS1i5ELKD6dUeLr7JnsEE4Tk8Sd
	bf3sIFVsAloS+1/cYANJiAj0Mkr0z+xnAkkwC1RK3F53iwXEFhZwklh6aSlYnEVAVWLphjZW
	EJtXwFXi7tJX7BDr5CQ+7HkEZnMKuEks7l7FAnGSq8T5jb3MIAskBHaxS8xZuJIRYpCAxLfJ
	h4CKOIASshKbDjBDzJGUOLjiBssERuEFjAyrGEVTC5ILipPSi4z1ihNzi0vz0vWS83M3MQKj
	4fS/Z/07GO8esD7EmAw0biKzlGhyPjCa8kriDY3NjCxMTUyNjcwtzUgTVhLnvf8wKUhIID2x
	JDU7NbUgtSi+qDQntfgQIxMHp1QDY/OC2Uwm6z3ObPt6/PGVWbvVdt1bfjf5a4JWner9Tr/7
	WgnsK3S7dmidXBBqc+m9Fud1fokH74Tf8t+eWvhJfsHTa1fe+N57FJbAt7Mkz/Llk0jDr9nR
	5956ssdsu+PuFNYdUfb6d83eJd/avz3aou7ucM9Yrq5FxqH8Td3XzTekJ7D7aaaoLVBiKc5I
	NNRiLipOBADLy3eNnAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t9jQV3xI63BBkuuWFlMffiEzeL6l+es
	Fp1nnzBbnG16w25x/+tRRotvVzqYLC7vmsNmcbtxBZvF6W5Wi4srvjA5cHnsnHWX3WPTqk42
	jzvX9rB5zDsZ6NG3ZRWjx+dNcgFsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaW
	FuZKCnmJuam2Si4+AbpumTlAlykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkAD
	CWsYM7bt3cJYcEmvYs+ZM6wNjOdUuxg5OSQETCQWHT3KCmGLSVy4t56ti5GLQ0hgOqPE19kz
	2SGcJiaJO9v62UGq2AS0JPa/uAFWJSLQyyjRP7OfCSTBLFApcXvdLRYQW1jASWLppaVgcRYB
	VYmlG9rAVvAKuErcXfqKHWKdnMSHPY/AbE4BN4nF3avAeoWAas5v7GWewMi7gJFhFaNoakFy
	QXFSeq6hXnFibnFpXrpecn7uJkZwtD2T2sG4ssHiEKMAB6MSD++BxS3BQqyJZcWVuYcYJTiY
	lUR4zfe2BgvxpiRWVqUW5ccXleakFh9iTAa6aiKzlGhyPjAR5JXEGxqbmBlZGpkbWhgZm5Mm
	rCTOe6DVOlBIID2xJDU7NbUgtQhmCxMHp1QDowyLUN2UNcer1q0MX7Ni32r9Wz0KTbfv3I+c
	FS/o/+moL5PE0twZ7LcbZz1vi7n1vmDvHPk77Vd6Qp6WH93+4+2qJZ2Xe2uNl0YFrhQqa+OI
	e1ft8/m8cZ7VNEXjR27prOHss/SFg38zTN15VX75ntgD32fy+lz08zs/fVbGydCHR2Nn7ii4
	tVOJpTgj0VCLuag4EQDJc0vG+gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for Samsung S2MPU02 PMIC device to the MFD sec-core driver.
The S2MPU02 device includes PMIC/RTC/Clock devices.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
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

