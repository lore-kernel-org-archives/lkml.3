Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab3FGIHC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:07:02 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:43819 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab3FGIG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:06:57 -0400
Date: Fri, 7 Jun 2013 08:06:56 +0000 (UTC)
From: Paul Walmsley <pwalmsley@nvidia.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
cc: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Andrew Chew <achew@nvidia.com>,
        Matthew Longnecker <mlongnecker@nvidia.com>
Subject: [PATCH] regulator: core: add regulator_get_linear_step()
Message-ID: <alpine.DEB.2.02.1306070753420.32163@utopia.booyaka.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add regulator_get_linear_step(), which returns the voltage step size
between VSEL values for linear regulators.  This is intended for use
by regulator consumers which build their own voltage-to-VSEL tables.

Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
Reviewed-by: Andrew Chew <achew@nvidia.com>
Cc: Matthew Longnecker <mlongnecker@nvidia.com>
---

Applies on v3.10-rc4.  Will be used by the upcoming Tegra DFLL clocksource 
driver, which will build its own table of voltage-to-VSEL values by 
querying the regulator framework.

 drivers/regulator/core.c           |   15 +++++++++++++++
 include/linux/regulator/consumer.h |    1 +
 2 files changed, 16 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 6e50178..f07d7ad 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2135,6 +2135,21 @@ int regulator_list_voltage(struct regulator *regulator, unsigned selector)
 EXPORT_SYMBOL_GPL(regulator_list_voltage);
 
 /**
+ * regulator_get_linear_step - return the voltage step size between VSEL values
+ * @regulator: regulator source
+ *
+ * Returns the voltage step size between VSEL values for linear
+ * regulators, or return 0 if the regulator isn't a linear regulator.
+ */
+unsigned int regulator_get_linear_step(struct regulator *regulator)
+{
+	struct regulator_dev *rdev = regulator->rdev;
+
+	return rdev->desc->uV_step;
+}
+EXPORT_SYMBOL_GPL(regulator_get_linear_step);
+
+/**
  * regulator_is_supported_voltage - check if a voltage range can be supported
  *
  * @regulator: Regulator to check.
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 145022a..3a76389c 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -165,6 +165,7 @@ int regulator_count_voltages(struct regulator *regulator);
 int regulator_list_voltage(struct regulator *regulator, unsigned selector);
 int regulator_is_supported_voltage(struct regulator *regulator,
 				   int min_uV, int max_uV);
+unsigned int regulator_get_linear_step(struct regulator *regulator);
 int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV);
 int regulator_set_voltage_time(struct regulator *regulator,
 			       int old_uV, int new_uV);
-- 
1.7.10.4

