Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918Ab3FQMRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 08:17:00 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48037 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932825Ab3FQMQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 08:16:59 -0400
From: J Keerthy <j-keerthy@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <broonie@kernel.org>, <j-keerthy@ti.com>, <ldewangan@nvidia.com>,
        <sameo@linux.intel.com>, <grant.likely@secretlab.ca>,
        <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <gg@slimlogic.co.uk>
Subject: [PATCH 3/4] MFD: Palmas: Add SMPS10_BOOST feature
Date: Mon, 17 Jun 2013 17:39:13 +0530
Message-ID: <1371470954-9124-4-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1371470954-9124-1-git-send-email-j-keerthy@ti.com>
References: <1371470954-9124-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SMPS10 regulator is not presesnt in all the variants
of the PALMAS PMIC family. Hence adding a feature to distingush
between them.

Signed-off-by: J Keerthy <j-keerthy@ti.com>
---
 drivers/mfd/palmas.c                 |    3 ++-
 drivers/regulator/palmas-regulator.c |    3 +++
 include/linux/mfd/palmas.h           |    4 ++++
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index 261beb5..ad00c18 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -231,7 +231,8 @@ static void palmas_dt_to_pdata(struct i2c_client *i2c,
 		palmas_set_pdata_irq_flag(i2c, pdata);
 }
 
-static unsigned int palmas_features = PALMAS_PMIC_FEATURE_INTERRUPT;
+static unsigned int palmas_features = PALMAS_PMIC_FEATURE_INTERRUPT |
+					PALMAS_PMIC_FEATURE_SMPS10_BOOST;
 
 static unsigned int tps659038_features;
 
diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 3ae44ac..1ae1e83 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -838,6 +838,9 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 				continue;
 			ramp_delay_support = true;
 			break;
+		case PALMAS_REG_SMPS10:
+			if (!PALMAS_PMIC_HAS(palmas, SMPS10_BOOST))
+				continue;
 		}
 
 		if ((id == PALMAS_REG_SMPS6) || (id == PALMAS_REG_SMPS8))
diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
index 1b5b5f3..2a9f4d6 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -38,10 +38,14 @@
  * PALMAS_PMIC_FEATURE_INTERRUPT - used when the PMIC has Interrupt line going
  *	to an application processor.
  *
+ * PALMAS_PMIC_FEATURE_SMPS10_BOOST - used when the PMIC provides SMPS10 boost
+ *	voltage supply.
+ *
  * PALMAS_PMIC_HAS(b, f) - macro to check if a bandgap device is capable of a
  *	specific feature (above) or not. Return non-zero, if yes.
  */
 #define PALMAS_PMIC_FEATURE_INTERRUPT	BIT(0)
+#define PALMAS_PMIC_FEATURE_SMPS10_BOOST	BIT(1)
 #define PALMAS_PMIC_HAS(b, f)			\
 			((b)->features & PALMAS_PMIC_FEATURE_ ## f)
 
-- 
1.7.5.4

