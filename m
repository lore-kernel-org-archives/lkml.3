Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab3K2PQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 10:16:22 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42854 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab3K2PQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 10:16:21 -0500
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, s.nawrocki@samsung.com, shc_work@mail.ru,
        kernel@pengutronix.de
Subject: [PATCH] mfd: syscon: add inline nop functions to compile without option
Date: Fri, 29 Nov 2013 16:15:56 +0100
Message-Id: <1385738156-31852-1-git-send-email-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 1.8.4.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The syscon interface can be used in different drivers to reach registers
of other register range via phandle. The exported functions can only be
used if the syscon interface is enabled. This patch fixes this by
adding nop functions if the syscon is not selected in the config.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 include/linux/mfd/syscon.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/include/linux/mfd/syscon.h b/include/linux/mfd/syscon.h
index b473577f..257938e 100644
--- a/include/linux/mfd/syscon.h
+++ b/include/linux/mfd/syscon.h
@@ -17,10 +17,35 @@
 
 struct device_node;
 
+#ifdef CONFIG_MFD_SYSCON
+
 extern struct regmap *syscon_node_to_regmap(struct device_node *np);
 extern struct regmap *syscon_regmap_lookup_by_compatible(const char *s);
 extern struct regmap *syscon_regmap_lookup_by_pdevname(const char *s);
 extern struct regmap *syscon_regmap_lookup_by_phandle(
 					struct device_node *np,
 					const char *property);
+
+#else
+
+static inline struct regmap *syscon_node_to_regmap(struct device_node *np)
+{
+	return ERR_PTR(-ENODEV);
+}
+static inline struct regmap *syscon_regmap_lookup_by_compatible(const char *s)
+{
+	return ERR_PTR(-ENODEV);
+}
+static inline struct regmap *syscon_regmap_lookup_by_pdevname(const char *s)
+{
+	return ERR_PTR(-ENODEV);
+}
+static inline struct regmap *syscon_regmap_lookup_by_phandle(
+					struct device_node *np,
+					const char *property)
+{
+	return ERR_PTR(-ENODEV);
+}
+#endif
+
 #endif /* __LINUX_MFD_SYSCON_H__ */
-- 
1.8.4.3

