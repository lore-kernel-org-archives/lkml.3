Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbaKQAog (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 19:44:36 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:27864 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbaKQAnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 19:43:05 -0500
X-AuditID: cbfee691-f79b86d000004a5a-c1-54694496d998
From: Chanwoo Choi <cw00.choi@samsung.com>
To: lee.jones@linaro.org, broonie@kernel.org, mturquette@linaro.org,
        a.zummo@towertech.it
Cc: lgirdwood@gmail.com, sbkim73@samsung.com, sameo@linux.intel.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 1/5] mfd: sec-core: Add support for S2MPS13 device
Date: Mon, 17 Nov 2014 09:42:56 +0900
Message-id: <1416184980-532-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1416184980-532-1-git-send-email-cw00.choi@samsung.com>
References: <1416184980-532-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42JZI2JSpDvNJTPE4EuvusWSi1fZLaY+fMJm
	cf3Lc1aL+UfOsVr8mdDKZjHp/gQWi7NNb9gt7n89ymjx7UoHk8XlXXPYLJ5OuMhmcbqb1eLi
	ii9MDrweO2fdZffYtKqTzePOtT1sHvNOBnr0bVnF6DF93k8mj8+b5ALYo7hsUlJzMstSi/Tt
	Ergylt+Zwl7wTLLi6MFr7A2MX0W6GDk5JARMJK69f8kCYYtJXLi3nq2LkYtDSGApo8SsGxvY
	YIredOxnBrGFBKYzStw6JQ1R1MQksXdPG1iCTUBLYv+LG2ANIgLREsefHmcEKWIW+Mwo8ezS
	JvYuRg4OYQEniWsPdUFqWARUJVon3mYDCfMKOEuc/1UJsUtBYtnymawgNqeAi8SG5mVQe50l
	3ny+AXachMA1don1zxeyQcwRkPg2+RALyBwJAVmJTQeYIeZIShxccYNlAqPwAkaGVYyiqQXJ
	BcVJ6UWmesWJucWleel6yfm5mxiBEXP637OJOxjvH7A+xCjAwajEw8thnREixJpYVlyZe4jR
	FGjDRGYp0eR8YFzmlcQbGpsZWZiamBobmVuaKYnz6kj/DBYSSE8sSc1OTS1ILYovKs1JLT7E
	yMTBKdXAyCj76am3s2esb/Xn5YIxPnPl6qpaM77k/Zm1tenoBUZvG+ttxbc7l/1eN/Vy9D2P
	jAo34ZWL/yk/2+ghYXSaffbMV8teTY5NWa9YKjO78utGtc+/b7DfXDXZ+YYq08LEK8skc7Js
	J9fXnoviU1G0nXappJDVkd1hqsmx0ilpNk7xylJuNl1RSizFGYmGWsxFxYkAbgiwUpMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t9jQd1pLpkhBt+OylksuXiV3WLqwyds
	Fte/PGe1mH/kHKvFnwmtbBaT7k9gsTjb9Ibd4v7Xo4wW3650MFlc3jWHzeLphItsFqe7WS0u
	rvjC5MDrsXPWXXaPTas62TzuXNvD5jHvZKBH35ZVjB7T5/1k8vi8SS6APaqB0SYjNTEltUgh
	NS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6FolhbLEnFKgUEBicbGS
	vh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8byO1PYC55JVhw9eI29gfGrSBcjJ4eEgInEm479
	zBC2mMSFe+vZQGwhgemMErdOSXcxcgHZTUwSe/e0gRWxCWhJ7H9xA6xIRCBa4vjT44wgRcwC
	nxklnl3axN7FyMEhLOAkce2hLkgNi4CqROvE22wgYV4BZ4nzvyohdilILFs+kxXE5hRwkdjQ
	vIwZYq+zxJvPN9gmMPIuYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcj8+kdzCuarA4
	xCjAwajEw7vBIiNEiDWxrLgy9xCjBAezkgjvEp3MECHelMTKqtSi/Pii0pzU4kOMpkBHTWSW
	Ek3OB6aKvJJ4Q2MTMyNLI3NDCyNjcyVx3oOt1oFCAumJJanZqakFqUUwfUwcnFINjAbRApdu
	RGUY/3kzecqB41+mb9Z89iuz1dWA+2aUd77y4yX62frapZMEbr8q2WB3Y0tQ1IupF28EXb0T
	vuV21MWy3kMnXx+9sjm6cd9euZDSpXkyJZdnPi2edH6x7K2tU6XbS1eIsMvMuXMzZ8K62t76
	q7tlv/QY2OjsvLM0VK3OrzAx1iEkuEGJpTgj0VCLuag4EQBLnqfh3QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the support for Samsung S2MPS13 PMIC device to the sec-core MFD
driver. The S2MPS13 is very similar with existing S2MPS14 and includes PMIC/
RTC/CLOCK devices.

Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/mfd/sec-core.c           | 18 ++++++++++++++++++
 drivers/mfd/sec-irq.c            | 23 +++++++++++++++++------
 include/linux/mfd/samsung/core.h |  1 +
 3 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 5993608..48c0d4a 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -73,6 +73,17 @@ static const struct mfd_cell s2mps11_devs[] = {
 	}
 };
 
+static const struct mfd_cell s2mps13_devs[] = {
+	{
+		.name = "s2mps13-pmic",
+	}, {
+		.name = "s2mps13-rtc",
+	}, {
+		.name = "s2mps13-clk",
+		.of_compatible = "samsung,s2mps13-clk",
+	}
+};
+
 static const struct mfd_cell s2mps14_devs[] = {
 	{
 		.name = "s2mps14-pmic",
@@ -107,6 +118,9 @@ static const struct of_device_id sec_dt_match[] = {
 		.compatible = "samsung,s2mps11-pmic",
 		.data = (void *)S2MPS11X,
 	}, {
+		.compatible = "samsung,s2mps13-pmic",
+		.data = (void *)S2MPS13X,
+	}, {
 		.compatible = "samsung,s2mps14-pmic",
 		.data = (void *)S2MPS14X,
 	}, {
@@ -377,6 +391,10 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 		sec_devs = s2mps11_devs;
 		num_sec_devs = ARRAY_SIZE(s2mps11_devs);
 		break;
+	case S2MPS13X:
+		sec_devs = s2mps13_devs;
+		num_sec_devs = ARRAY_SIZE(s2mps13_devs);
+		break;
 	case S2MPS14X:
 		sec_devs = s2mps14_devs;
 		num_sec_devs = ARRAY_SIZE(s2mps14_devs);
diff --git a/drivers/mfd/sec-irq.c b/drivers/mfd/sec-irq.c
index f9a5786..ba86a91 100644
--- a/drivers/mfd/sec-irq.c
+++ b/drivers/mfd/sec-irq.c
@@ -389,14 +389,22 @@ static const struct regmap_irq_chip s2mps11_irq_chip = {
 	.ack_base = S2MPS11_REG_INT1,
 };
 
+#define S2MPS1X_IRQ_CHIP_COMMON_DATA		\
+	.irqs = s2mps14_irqs,			\
+	.num_irqs = ARRAY_SIZE(s2mps14_irqs),	\
+	.num_regs = 3,				\
+	.status_base = S2MPS14_REG_INT1,	\
+	.mask_base = S2MPS14_REG_INT1M,		\
+	.ack_base = S2MPS14_REG_INT1		\
+
+static const struct regmap_irq_chip s2mps13_irq_chip = {
+	.name = "s2mps13",
+	S2MPS1X_IRQ_CHIP_COMMON_DATA,
+};
+
 static const struct regmap_irq_chip s2mps14_irq_chip = {
 	.name = "s2mps14",
-	.irqs = s2mps14_irqs,
-	.num_irqs = ARRAY_SIZE(s2mps14_irqs),
-	.num_regs = 3,
-	.status_base = S2MPS14_REG_INT1,
-	.mask_base = S2MPS14_REG_INT1M,
-	.ack_base = S2MPS14_REG_INT1,
+	S2MPS1X_IRQ_CHIP_COMMON_DATA,
 };
 
 static const struct regmap_irq_chip s2mpu02_irq_chip = {
@@ -452,6 +460,9 @@ int sec_irq_init(struct sec_pmic_dev *sec_pmic)
 	case S2MPS11X:
 		sec_irq_chip = &s2mps11_irq_chip;
 		break;
+	case S2MPS13X:
+		sec_irq_chip = &s2mps13_irq_chip;
+		break;
 	case S2MPS14X:
 		sec_irq_chip = &s2mps14_irq_chip;
 		break;
diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
index 1825eda..0c0343e 100644
--- a/include/linux/mfd/samsung/core.h
+++ b/include/linux/mfd/samsung/core.h
@@ -41,6 +41,7 @@ enum sec_device_type {
 	S5M8767X,
 	S2MPA01,
 	S2MPS11X,
+	S2MPS13X,
 	S2MPS14X,
 	S2MPU02,
 };
-- 
1.8.5.5

