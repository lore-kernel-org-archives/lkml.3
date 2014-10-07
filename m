Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbaJGTmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:42:17 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:46026 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941AbaJGTmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:42:15 -0400
From: Romain Perier <romain.perier@gmail.com>
To: devicetree@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        heiko@sntech.de, sameo@linux.intel.com, lee.jones@linaro.org,
        grant.likely@linaro.org, robh@kernel.org, sre@kernel.org,
        dbaryshkov@gmail.com, dwmw2@infradead.org, anton@enomsg.org,
        ldewangan@nvidia.com, linux-omap@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [RFC PATCH v2 1/4] regulator: Add helper function to get "poweroff-source" property
Date: Tue,  7 Oct 2014 19:45:01 +0000
Message-Id: <1412711104-15902-1-git-send-email-romain.perier@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several drivers create their own devicetree property when they register
poweroff capabilities. This is for example the case for mfd, regulator
or power drivers which define "vendor,system-power-controller" property.
This patch adds support for a standard property "poweroff-source"
which marks the device as able to shutdown the system.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 drivers/regulator/of_regulator.c       | 12 ++++++++++++
 include/linux/regulator/of_regulator.h |  6 ++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index 7a51814..8b898e6 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -240,3 +240,15 @@ struct regulator_init_data *regulator_of_get_init_data(struct device *dev,
 
 	return init_data;
 }
+
+/**
+ * is_system_poweroff_source - Tells if poweroff-source is found for device_node
+ * @np: Pointer to the given device_node
+ *
+ * return true if present false otherwise
+ */
+bool is_system_poweroff_source(const struct device_node *np)
+{
+	return of_property_read_bool(np, "poweroff-source");
+}
+EXPORT_SYMBOL_GPL(is_system_poweroff_source);
diff --git a/include/linux/regulator/of_regulator.h b/include/linux/regulator/of_regulator.h
index f921796..9d8fbb2 100644
--- a/include/linux/regulator/of_regulator.h
+++ b/include/linux/regulator/of_regulator.h
@@ -20,6 +20,7 @@ extern struct regulator_init_data
 extern int of_regulator_match(struct device *dev, struct device_node *node,
 			      struct of_regulator_match *matches,
 			      unsigned int num_matches);
+extern bool is_system_poweroff_source(const struct device_node *np);
 #else
 static inline struct regulator_init_data
 	*of_get_regulator_init_data(struct device *dev,
@@ -35,6 +36,11 @@ static inline int of_regulator_match(struct device *dev,
 {
 	return 0;
 }
+
+static inline bool is_system_poweroff_source(const struct device_node *np)
+{
+	return false;
+}
 #endif /* CONFIG_OF */
 
 #endif /* __LINUX_OF_REG_H */
-- 
1.9.1

