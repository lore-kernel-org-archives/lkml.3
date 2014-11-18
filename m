Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbaKRJAE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 04:00:04 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:36025 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbaKRI76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:59:58 -0500
X-AuditID: cbfee68f-f791c6d000004834-f2-546b0a8026b6
From: Chanwoo Choi <cw00.choi@samsung.com>
To: lee.jones@linaro.org, broonie@kernel.org, mturquette@linaro.org,
        a.zummo@towertech.it
Cc: lgirdwood@gmail.com, sbkim73@samsung.com, sameo@linux.intel.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com,
        kyungmin.park@samsung.com, k.kozlowski@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 1/5] mfd: sec-core: Add support for S2MPS13 device
Date: Tue, 18 Nov 2014 17:59:39 +0900
Message-id: <1416301183-10478-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1416301183-10478-1-git-send-email-cw00.choi@samsung.com>
References: <1416301183-10478-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42JZI2JSotvAlR1i8PWbrMWSi1fZLaY+fMJm
	cf3Lc1aL+UfOsVr8mdDKZjHp/gQWi9cvDC3ONr1ht7j/9SijxbcrHUwWl3fNYbN4OuEim8Xp
	blaLiyu+MDnweeycdZfdY9OqTjaPO9f2sHnMOxno0bdlFaPH9Hk/mTw+b5ILYI/isklJzcks
	Sy3St0vgyjjxZzdTwXapiquPT7I1MB4S7WLk5JAQMJE4/+IRO4QtJnHh3no2EFtIYCmjxPNJ
	6jA1N6f9AIpzAcWnM0ocevCeEcJpYpLY2PSFEaSKTUBLYv+LG2DdIgLREsefHgcrYhboYZJ4
	37sRrEhYwEXi5NtlYDaLgKrE3M6PzCA2r4CrxNnzj9kg1ilILFs+kxXE5hRwkzhwfDHUSa4S
	pzsPMoMMlRC4xC6xZPY0qEECEt8mH2LpYuQASshKbDrADDFHUuLgihssExiFFzAyrGIUTS1I
	LihOSi8y1itOzC0uzUvXS87P3cQIjJ7T/57172C8e8D6EKMAB6MSD2/C1KwQIdbEsuLK3EOM
	pkAbJjJLiSbnA2M0ryTe0NjMyMLUxNTYyNzSTEmcd6HUz2AhgfTEktTs1NSC1KL4otKc1OJD
	jEwcnFINjCzT2uTibKosv5u/bBFSr517KmZKicC0y77PZ8aqidU27f14Zs+PH28O/joeW7FX
	3qXZ81ffbt/oez5fW2f57vsQ+1/2ppZ56qachutNJes9Zyz1c1UqMY843fO12D+nvip9umfg
	lZlCe5kzhb3aru+OPM6dmL4+KydwXoDDZMmdd+wTz7mXKrEUZyQaajEXFScCAEsvm92ZAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jQd0GruwQgwunRCyWXLzKbjH14RM2
	i+tfnrNazD9yjtXiz4RWNotJ9yewWLx+YWhxtukNu8X9r0cZLb5d6WCyuLxrDpvF0wkX2SxO
	d7NaXFzxhcmBz2PnrLvsHptWdbJ53Lm2h81j3slAj74tqxg9ps/7yeTxeZNcAHtUA6NNRmpi
	SmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDFSgpliTmlQKGA
	xOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaME392MxVsl6q4+vgkWwPjIdEuRk4OCQET
	iZvTfrBB2GISF+6tB7K5OIQEpjNKHHrwnhHCaWKS2Nj0hRGkik1AS2L/ixtgHSIC0RLHnx4H
	K2IW6GGSeN+7EaxIWMBF4uTbZWA2i4CqxNzOj8wgNq+Aq8TZ84+h1ilILFs+kxXE5hRwkzhw
	fDFYXAio5nTnQeYJjLwLGBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgRH5zPpHYyrGiwO
	MQpwMCrx8CZOzQoRYk0sK67MPcQowcGsJMJ7rhsoxJuSWFmVWpQfX1Sak1p8iNEU6KqJzFKi
	yfnAxJFXEm9obGJmZGlkbmhhZGyuJM57sNU6UEggPbEkNTs1tSC1CKaPiYNTqoGxLTJg+/IF
	Pz6GhlUH1l3bYh/ygvHnbIG0BXzb95VXbYt8rK9Zq/P89YugS40f98YElQTdE636ErDs8F/m
	f96Cb6qXHP+dx2Yi3rEx5MEXJ12BUp/178qnXXu0L6E4Lrhs9T13u1il2tN8E5dteHas9G/s
	tbOPG3Z/em+weY5Pd9eN6csU21MMlViKMxINtZiLihMBQquA5eQCAAA=
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
Acked-by: Sangbeom Kim <sbkim73@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/sec-core.c           | 16 ++++++++++++++++
 drivers/mfd/sec-irq.c            | 23 +++++++++++++++++------
 include/linux/mfd/samsung/core.h |  1 +
 3 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 5993608..868f03d 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -73,6 +73,15 @@ static const struct mfd_cell s2mps11_devs[] = {
 	}
 };
 
+static const struct mfd_cell s2mps13_devs[] = {
+	{ .name = "s2mps13-pmic", },
+	{ .name = "s2mps13-rtc", },
+	{
+		.name = "s2mps13-clk",
+		.of_compatible = "samsung,s2mps13-clk",
+	},
+};
+
 static const struct mfd_cell s2mps14_devs[] = {
 	{
 		.name = "s2mps14-pmic",
@@ -107,6 +116,9 @@ static const struct of_device_id sec_dt_match[] = {
 		.compatible = "samsung,s2mps11-pmic",
 		.data = (void *)S2MPS11X,
 	}, {
+		.compatible = "samsung,s2mps13-pmic",
+		.data = (void *)S2MPS13X,
+	}, {
 		.compatible = "samsung,s2mps14-pmic",
 		.data = (void *)S2MPS14X,
 	}, {
@@ -377,6 +389,10 @@ static int sec_pmic_probe(struct i2c_client *i2c,
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

