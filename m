Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab3DYRea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:34:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59856 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932340Ab3DYR3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:29:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 16/21] OF: remove #ifdef from linux/of_platform.h
Date: Thu, 25 Apr 2013 19:28:59 +0200
Message-Id: <1366910944-3033663-17-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:wLGwz8tSoNJbPyio9sJ0R24FEOMEc+3vvB6r+yIbWNk
 GQZ5FBBXLugX4H0JLdMDSAEYna5ZG0dEFHr8Wjdr0F6rwCtJ7q
 Kc3qwJO2lnMnyZXmB0L/nLAtqwjglGeoIjg3D7WjzRvl5s1xqS
 Sg9xKScp+vezqeZs851ljTZNa90Uhw1FDXKRMbh9RmKp+mEl4j
 5Ku7rZpjABEtzApGwwLFxuJnh531JUg2i78QtJdMyNNuaDB0Mb
 WkIKMc85lMHp+Jdf93mhLdtR3JkV2C4qGWl/kHGHa4eAxHUj7y
 AKntl8sx/zXHnPO+X4IL4E+hSPg+FKbFSv/tIUETPC/5J9Zm07
 Vy9bv2/jRtzX+pedc0gjgR1rZw7HepFUW4VQh21JC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A lot of code uses the functions from of_platform.h when built for
devicetree-enabled platforms but can also be built without them.
In order to avoid using #ifdef everywhere in drivers, this
makes all the function declarations visible, which means we
can use "if (IS_ENABLED(CONFIG_OF))" in driver code and get build
coverage over the code but let the compiler drop the reference
in the object code.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
---
 include/linux/of_platform.h | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index 2a93b64..ff83462 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -14,7 +14,6 @@
 #include <linux/device.h>
 #include <linux/mod_devicetable.h>
 
-#ifdef CONFIG_OF_DEVICE
 #include <linux/pm.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
@@ -82,7 +81,6 @@ extern struct platform_device *of_device_alloc(struct device_node *np,
 					 struct device *parent);
 extern struct platform_device *of_find_device_by_node(struct device_node *np);
 
-#ifdef CONFIG_OF_ADDRESS /* device reg helpers depend on OF_ADDRESS */
 /* Platform devices and busses creation */
 extern struct platform_device *of_platform_device_create(struct device_node *np,
 						   const char *bus_id,
@@ -91,17 +89,12 @@ extern struct platform_device *of_platform_device_create(struct device_node *np,
 extern int of_platform_bus_probe(struct device_node *root,
 				 const struct of_device_id *matches,
 				 struct device *parent);
+#ifdef CONFIG_OF_ADDRESS
 extern int of_platform_populate(struct device_node *root,
 				const struct of_device_id *matches,
 				const struct of_dev_auxdata *lookup,
 				struct device *parent);
-#endif /* CONFIG_OF_ADDRESS */
-
-#endif /* CONFIG_OF_DEVICE */
-
-#if !defined(CONFIG_OF_ADDRESS)
-struct of_dev_auxdata;
-struct device_node;
+#else
 static inline int of_platform_populate(struct device_node *root,
 					const struct of_device_id *matches,
 					const struct of_dev_auxdata *lookup,
@@ -109,6 +102,6 @@ static inline int of_platform_populate(struct device_node *root,
 {
 	return -ENODEV;
 }
-#endif /* !CONFIG_OF_ADDRESS */
+#endif
 
 #endif	/* _LINUX_OF_PLATFORM_H */
-- 
1.8.1.2

