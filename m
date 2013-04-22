Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab3DVCOD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 22:14:03 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:52031 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295Ab3DVCNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 22:13:43 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 5/5] of: remove CONFIG_OF_DEVICE
Date: Sun, 21 Apr 2013 21:13:18 -0500
Message-Id: <1366596798-9457-6-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366596798-9457-1-git-send-email-robherring2@gmail.com>
References: <1366596798-9457-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

CONFIG_OF_DEVICE is always selected when CONFIG_OF is enabled, so remove
it and simplify of_platform.h and of_device.h headers. This also fixes
!OF compiles using of_platform_populate.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@linaro.org>
---
 drivers/of/Kconfig          |    3 ---
 drivers/of/Makefile         |    3 +--
 include/linux/of_device.h   |    6 +++---
 include/linux/of_platform.h |    9 +--------
 4 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index d37bfcf..80e5c13 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -48,9 +48,6 @@ config OF_IRQ
 	def_bool y
 	depends on !SPARC
 
-config OF_DEVICE
-	def_bool y
-
 config OF_I2C
 	def_tristate I2C
 	depends on I2C
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index e027f44..1f9c0c4 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -1,9 +1,8 @@
-obj-y = base.o
+obj-y = base.o device.o platform.o
 obj-$(CONFIG_OF_FLATTREE) += fdt.o
 obj-$(CONFIG_OF_PROMTREE) += pdt.o
 obj-$(CONFIG_OF_ADDRESS)  += address.o
 obj-$(CONFIG_OF_IRQ)    += irq.o
-obj-$(CONFIG_OF_DEVICE) += device.o platform.o
 obj-$(CONFIG_OF_I2C)	+= of_i2c.o
 obj-$(CONFIG_OF_NET)	+= of_net.o
 obj-$(CONFIG_OF_SELFTEST) += selftest.o
diff --git a/include/linux/of_device.h b/include/linux/of_device.h
index 901b743..9d27475 100644
--- a/include/linux/of_device.h
+++ b/include/linux/of_device.h
@@ -4,12 +4,12 @@
 #include <linux/platform_device.h>
 #include <linux/of_platform.h> /* temporary until merge */
 
-#ifdef CONFIG_OF_DEVICE
 #include <linux/of.h>
 #include <linux/mod_devicetable.h>
 
 struct device;
 
+#ifdef CONFIG_OF
 extern const struct of_device_id *of_match_device(
 	const struct of_device_id *matches, const struct device *dev);
 extern void of_device_make_bus_id(struct device *dev);
@@ -43,7 +43,7 @@ static inline void of_device_node_put(struct device *dev)
 	of_node_put(dev->of_node);
 }
 
-#else /* CONFIG_OF_DEVICE */
+#else /* CONFIG_OF */
 
 static inline int of_driver_match_device(struct device *dev,
 					 struct device_driver *drv)
@@ -67,6 +67,6 @@ static inline const struct of_device_id *of_match_device(
 {
 	return NULL;
 }
-#endif /* CONFIG_OF_DEVICE */
+#endif /* CONFIG_OF */
 
 #endif /* _LINUX_OF_DEVICE_H */
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index aa7eb02..6b840f0 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -13,8 +13,6 @@
 
 #include <linux/device.h>
 #include <linux/mod_devicetable.h>
-
-#ifdef CONFIG_OF_DEVICE
 #include <linux/pm.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
@@ -74,13 +72,8 @@ extern int of_platform_populate(struct device_node *root,
 				const struct of_device_id *matches,
 				const struct of_dev_auxdata *lookup,
 				struct device *parent);
-#endif /* CONFIG_OF_ADDRESS */
-
-#endif /* CONFIG_OF_DEVICE */
+#else
 
-#if !defined(CONFIG_OF_ADDRESS)
-struct of_dev_auxdata;
-struct device_node;
 static inline int of_platform_populate(struct device_node *root,
 					const struct of_device_id *matches,
 					const struct of_dev_auxdata *lookup,
-- 
1.7.10.4

