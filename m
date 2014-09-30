Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbaI3R1D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:27:03 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:54801 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaI3R1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:27:01 -0400
From: Romain Perier <romain.perier@gmail.com>
To: devicetree@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        heiko@sntech.de
Subject: [RFC][PATCH 1/4] regulator: Add helper function to get "poweroff-source" property
Date: Tue, 30 Sep 2014 17:29:43 +0000
Message-Id: <1412098186-5042-1-git-send-email-romain.perier@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several drivers create their own devicetree property when they register
poweroff capabilites. This is for example the case for mfd, regulator
or power drivers which define "vendor,system-power-controller" property.
This patch adds support for a standard property "poweroff-source"
which marks the device as able to shutdown the system.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 drivers/regulator/of_regulator.c       | 12 ++++++++++++
 include/linux/regulator/of_regulator.h |  6 ++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index 7a51814..94e0ec4 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -240,3 +240,15 @@ struct regulator_init_data *regulator_of_get_init_data(struct device *dev,
 
 	return init_data;
 }
+
+/**
+ * of_get_regulator_poweroff_source - Get poweroff-source for given device_node
+ * @np: Pointer to the given device_node
+ *
+ * return true if present false otherwise
+ */
+bool of_get_regulator_poweroff_source(const struct device_node *np)
+{
+	return of_property_read_bool(np, "poweroff-source");
+}
+EXPORT_SYMBOL_GPL(of_get_regulator_poweroff_source);
diff --git a/include/linux/regulator/of_regulator.h b/include/linux/regulator/of_regulator.h
index f921796..2e7aa89 100644
--- a/include/linux/regulator/of_regulator.h
+++ b/include/linux/regulator/of_regulator.h
@@ -20,6 +20,7 @@ extern struct regulator_init_data
 extern int of_regulator_match(struct device *dev, struct device_node *node,
 			      struct of_regulator_match *matches,
 			      unsigned int num_matches);
+extern bool of_get_regulator_poweroff_source(const struct device_node *np);
 #else
 static inline struct regulator_init_data
 	*of_get_regulator_init_data(struct device *dev,
@@ -35,6 +36,11 @@ static inline int of_regulator_match(struct device *dev,
 {
 	return 0;
 }
+
+static inline bool of_get_regulator_poweroff_source(const struct device_node *np)
+{
+	return false;
+}
 #endif /* CONFIG_OF */
 
 #endif /* __LINUX_OF_REG_H */
-- 
1.9.1

