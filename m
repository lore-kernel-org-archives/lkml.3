Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643AbaGENWs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 09:22:48 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:37140 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459AbaGENWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 09:22:43 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Wenyou Yang <wenyou.yang@atmel.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Heiko Stuebner <heiko@sntech.de>,
        Axel Lin <axel.lin@ingics.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH v2 3/4] regulator: act8865: add support for act8846
Date: Sat,  5 Jul 2014 15:20:55 +0200
Message-Id: <1404566456-9121-4-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404566456-9121-1-git-send-email-b.galvani@gmail.com>
References: <1404566456-9121-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device id and definition of registers and regulators to support
the act8846 PMU.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
Tested-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 drivers/regulator/act8865-regulator.c |   71 +++++++++++++++++++++++++++++++++
 include/linux/regulator/act8865.h     |   17 ++++++++
 2 files changed, 88 insertions(+)

diff --git a/drivers/regulator/act8865-regulator.c b/drivers/regulator/act8865-regulator.c
index b26eaf7..a5ad69a 100644
--- a/drivers/regulator/act8865-regulator.c
+++ b/drivers/regulator/act8865-regulator.c
@@ -29,6 +29,40 @@
 #include <linux/regmap.h>
 
 /*
+ * ACT8846 Global Register Map.
+ */
+#define	ACT8846_SYS0		0x00
+#define	ACT8846_SYS1		0x01
+#define	ACT8846_REG1_VSET	0x10
+#define	ACT8846_REG1_CTRL	0x12
+#define	ACT8846_REG2_VSET0	0x20
+#define	ACT8846_REG2_VSET1	0x21
+#define	ACT8846_REG2_CTRL	0x22
+#define	ACT8846_REG3_VSET0	0x30
+#define	ACT8846_REG3_VSET1	0x31
+#define	ACT8846_REG3_CTRL	0x32
+#define	ACT8846_REG4_VSET0	0x40
+#define	ACT8846_REG4_VSET1	0x41
+#define	ACT8846_REG4_CTRL	0x42
+#define	ACT8846_REG5_VSET	0x50
+#define	ACT8846_REG5_CTRL	0x51
+#define	ACT8846_REG6_VSET	0x58
+#define	ACT8846_REG6_CTRL	0x59
+#define	ACT8846_REG7_VSET	0x60
+#define	ACT8846_REG7_CTRL	0x61
+#define	ACT8846_REG8_VSET	0x68
+#define	ACT8846_REG8_CTRL	0x69
+#define	ACT8846_REG9_VSET	0x70
+#define	ACT8846_REG9_CTRL	0x71
+#define	ACT8846_REG10_VSET	0x80
+#define	ACT8846_REG10_CTRL	0x81
+#define	ACT8846_REG11_VSET	0x90
+#define	ACT8846_REG11_CTRL	0x91
+#define	ACT8846_REG12_VSET	0xa0
+#define	ACT8846_REG12_CTRL	0xa1
+#define	ACT8846_REG13_CTRL	0xb1
+
+/*
  * ACT8865 Global Register Map.
  */
 #define	ACT8865_SYS_MODE	0x00
@@ -103,6 +137,21 @@ static struct regulator_ops act8865_ops = {
 		.owner			= THIS_MODULE,			\
 	}
 
+static const struct regulator_desc act8846_regulators[] = {
+	ACT88xx_REG("REG1", ACT8846, REG1, VSET),
+	ACT88xx_REG("REG2", ACT8846, REG2, VSET0),
+	ACT88xx_REG("REG3", ACT8846, REG3, VSET0),
+	ACT88xx_REG("REG4", ACT8846, REG4, VSET0),
+	ACT88xx_REG("REG5", ACT8846, REG5, VSET),
+	ACT88xx_REG("REG6", ACT8846, REG6, VSET),
+	ACT88xx_REG("REG7", ACT8846, REG7, VSET),
+	ACT88xx_REG("REG8", ACT8846, REG8, VSET),
+	ACT88xx_REG("REG9", ACT8846, REG9, VSET),
+	ACT88xx_REG("REG10", ACT8846, REG10, VSET),
+	ACT88xx_REG("REG11", ACT8846, REG11, VSET),
+	ACT88xx_REG("REG12", ACT8846, REG12, VSET),
+};
+
 static const struct regulator_desc act8865_regulators[] = {
 	ACT88xx_REG("DCDC_REG1", ACT8865, DCDC1, VSET1),
 	ACT88xx_REG("DCDC_REG2", ACT8865, DCDC2, VSET1),
@@ -115,11 +164,27 @@ static const struct regulator_desc act8865_regulators[] = {
 
 #ifdef CONFIG_OF
 static const struct of_device_id act8865_dt_ids[] = {
+	{ .compatible = "active-semi,act8846", .data = (void *)ACT8846 },
 	{ .compatible = "active-semi,act8865", .data = (void *)ACT8865 },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, act8865_dt_ids);
 
+static struct of_regulator_match act8846_matches[] = {
+	[ACT8846_ID_REG1]	= { .name = "REG1" },
+	[ACT8846_ID_REG2]	= { .name = "REG2" },
+	[ACT8846_ID_REG3]	= { .name = "REG3" },
+	[ACT8846_ID_REG4]	= { .name = "REG4" },
+	[ACT8846_ID_REG5]	= { .name = "REG5" },
+	[ACT8846_ID_REG6]	= { .name = "REG6" },
+	[ACT8846_ID_REG7]	= { .name = "REG7" },
+	[ACT8846_ID_REG8]	= { .name = "REG8" },
+	[ACT8846_ID_REG9]	= { .name = "REG9" },
+	[ACT8846_ID_REG10]	= { .name = "REG10" },
+	[ACT8846_ID_REG11]	= { .name = "REG11" },
+	[ACT8846_ID_REG12]	= { .name = "REG12" },
+};
+
 static struct of_regulator_match act8865_matches[] = {
 	[ACT8865_ID_DCDC1]	= { .name = "DCDC_REG1"},
 	[ACT8865_ID_DCDC2]	= { .name = "DCDC_REG2"},
@@ -222,6 +287,11 @@ static int act8865_pmic_probe(struct i2c_client *client,
 	}
 
 	switch (type) {
+	case ACT8846:
+		matches = act8846_matches;
+		regulators = act8846_regulators;
+		num_regulators = ARRAY_SIZE(act8846_regulators);
+		break;
 	case ACT8865:
 		matches = act8865_matches;
 		regulators = act8865_regulators;
@@ -290,6 +360,7 @@ static int act8865_pmic_probe(struct i2c_client *client,
 }
 
 static const struct i2c_device_id act8865_ids[] = {
+	{ .name = "act8846", .driver_data = ACT8846 },
 	{ .name = "act8865", .driver_data = ACT8865 },
 	{ },
 };
diff --git a/include/linux/regulator/act8865.h b/include/linux/regulator/act8865.h
index b49be81..b6c4909 100644
--- a/include/linux/regulator/act8865.h
+++ b/include/linux/regulator/act8865.h
@@ -30,7 +30,24 @@ enum {
 };
 
 enum {
+	ACT8846_ID_REG1,
+	ACT8846_ID_REG2,
+	ACT8846_ID_REG3,
+	ACT8846_ID_REG4,
+	ACT8846_ID_REG5,
+	ACT8846_ID_REG6,
+	ACT8846_ID_REG7,
+	ACT8846_ID_REG8,
+	ACT8846_ID_REG9,
+	ACT8846_ID_REG10,
+	ACT8846_ID_REG11,
+	ACT8846_ID_REG12,
+	ACT8846_REG_NUM,
+};
+
+enum {
 	ACT8865,
+	ACT8846,
 };
 
 /**
-- 
1.7.10.4

