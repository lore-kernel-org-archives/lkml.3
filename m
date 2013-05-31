Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800Ab3EaWYp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 18:24:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60239 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757475Ab3EaWXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 18:23:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: patches@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 15/15] OF: remove #ifdef from linux/of_platform.h
Date: Sat,  1 Jun 2013 00:22:52 +0200
Message-Id: <1370038972-2318779-16-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:BMgRbDgHvZyWEy8kwmZPY5uQ16bc9h5haAe1BmBYM0s
 A5RD7EtxNKqn/yM/gdnWCG9V3PI16jjgiwoP28iaE+giG2LfKP
 X/P8cVRk6ITTJaUqnCaYIhUijAREFki3whHvnrx4+H6QGL/hcQ
 182uczeBinzZl1IH5fkvcdpIyvJykLUtsJf+RXlTU/Xj6clrUH
 2c8seBpwWZ4JlJnEoWXYeYDNgHypKDf44sMWLxrse4uCBJEuRy
 vR8kHTlaXUMDYJIk7HkDySy8h+bOOElV2wVofeZINkAghO3Z1S
 FlT5hHy3feQOLGm5DEPxfmkY3H2aYbjniRGG6tGkRfUC7nxrBG
 XIAW5Wh7CTahBRVniHPgk2fcjft3uPzaNabFc0kdz
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
 include/linux/of_platform.h | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index 2a93b64..7747ad0 100644
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
@@ -82,7 +80,6 @@ extern struct platform_device *of_device_alloc(struct device_node *np,
 					 struct device *parent);
 extern struct platform_device *of_find_device_by_node(struct device_node *np);
 
-#ifdef CONFIG_OF_ADDRESS /* device reg helpers depend on OF_ADDRESS */
 /* Platform devices and busses creation */
 extern struct platform_device *of_platform_device_create(struct device_node *np,
 						   const char *bus_id,
@@ -91,17 +88,12 @@ extern struct platform_device *of_platform_device_create(struct device_node *np,
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
@@ -109,6 +101,6 @@ static inline int of_platform_populate(struct device_node *root,
 {
 	return -ENODEV;
 }
-#endif /* !CONFIG_OF_ADDRESS */
+#endif
 
 #endif	/* _LINUX_OF_PLATFORM_H */
-- 
1.8.1.2

