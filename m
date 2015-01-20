Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbbATOAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 09:00:37 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.171]:46605 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752206AbbATOAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 09:00:34 -0500
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-14.tower-39.messagelabs.com!1421762430!20320960!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.12.5; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <2ab606365e855b081819174235105ba6674c8143.1421762065.git.stwiss.opensource@diasemi.com>
In-Reply-To: <cover.1421762065.git.stwiss.opensource@diasemi.com>
References: <cover.1421762065.git.stwiss.opensource@diasemi.com>
From: Steve Twiss <stwiss.opensource@diasemi.com>
Date: Tue, 20 Jan 2015 13:54:25 +0000
Subject: [PATCH V3 1/2] mfd: da9063: Add device tree support
To: Grant Likely <grant.likely@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Rob Herring" <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: DT <devicetree@vger.kernel.org>, David Dajun Chen <david.chen@diasemi.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Mark Rutland" <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        "Philipp Zabel" <p.zabel@pengutronix.de>,
        Support Opensource <support.opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Twiss <stwiss.opensource@diasemi.com>

Add device tree support for DA9063 regulators; Real-Time Clock
and Watchdog.

This patch is dependent on PATCH V2 2/2 

Signed-off-by: Steve Twiss <stwiss.opensource@diasemi.com>

---
This patch applies against linux-next and v3.19-rc4 

 drivers/mfd/da9063-core.c       | 2 ++
 drivers/mfd/da9063-i2c.c        | 9 +++++++++
 include/linux/mfd/da9063/core.h | 1 +
 3 files changed, 12 insertions(+)

diff --git a/drivers/mfd/da9063-core.c b/drivers/mfd/da9063-core.c
index f38bc98..facd361 100644
--- a/drivers/mfd/da9063-core.c
+++ b/drivers/mfd/da9063-core.c
@@ -86,6 +86,7 @@ static const struct mfd_cell da9063_devs[] = {
 	},
 	{
 		.name		= DA9063_DRVNAME_WATCHDOG,
+		.of_compatible	= "dlg,da9063-watchdog",
 	},
 	{
 		.name		= DA9063_DRVNAME_HWMON,
@@ -101,6 +102,7 @@ static const struct mfd_cell da9063_devs[] = {
 		.name		= DA9063_DRVNAME_RTC,
 		.num_resources	= ARRAY_SIZE(da9063_rtc_resources),
 		.resources	= da9063_rtc_resources,
+		.of_compatible	= "dlg,da9063-rtc",
 	},
 	{
 		.name		= DA9063_DRVNAME_VIBRATION,
diff --git a/drivers/mfd/da9063-i2c.c b/drivers/mfd/da9063-i2c.c
index 21fd8d9..6f3a7c0 100644
--- a/drivers/mfd/da9063-i2c.c
+++ b/drivers/mfd/da9063-i2c.c
@@ -25,6 +25,9 @@
 #include <linux/mfd/da9063/pdata.h>
 #include <linux/mfd/da9063/registers.h>
 
+#include <linux/of.h>
+#include <linux/regulator/of_regulator.h>
+
 static const struct regmap_range da9063_ad_readable_ranges[] = {
 	{
 		.range_min = DA9063_REG_PAGE_CON,
@@ -203,6 +206,11 @@ static struct regmap_config da9063_regmap_config = {
 	.cache_type = REGCACHE_RBTREE,
 };
 
+static const struct of_device_id da9063_dt_ids[] = {
+	{ .compatible = "dlg,da9063", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, da9063_dt_ids);
 static int da9063_i2c_probe(struct i2c_client *i2c,
 	const struct i2c_device_id *id)
 {
@@ -257,6 +265,7 @@ static struct i2c_driver da9063_i2c_driver = {
 	.driver = {
 		.name = "da9063",
 		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(da9063_dt_ids),
 	},
 	.probe    = da9063_i2c_probe,
 	.remove   = da9063_i2c_remove,
diff --git a/include/linux/mfd/da9063/core.h b/include/linux/mfd/da9063/core.h
index b92a326..79f4d82 100644
--- a/include/linux/mfd/da9063/core.h
+++ b/include/linux/mfd/da9063/core.h
@@ -36,6 +36,7 @@ enum da9063_models {
 enum da9063_variant_codes {
 	PMIC_DA9063_AD = 0x3,
 	PMIC_DA9063_BB = 0x5,
+	PMIC_DA9063_CA = 0x6,
 };
 
 /* Interrupts */
-- 
end-of-patch for PATCH V3

