Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934400Ab3CZJf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 05:35:29 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:47271 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932951Ab3CZJf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 05:35:27 -0400
From: Fabio Porcedda <fabio.porcedda@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [PATCH 3/3] driver core: platform_device.h: fix checkpatch errors and warnings
Date: Tue, 26 Mar 2013 10:35:17 +0100
Message-Id: <1364290517-8094-4-git-send-email-fabio.porcedda@gmail.com>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1364290517-8094-1-git-send-email-fabio.porcedda@gmail.com>
References: <1364290517-8094-1-git-send-email-fabio.porcedda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/platform_device.h | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index c082c71..139e000 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -20,12 +20,12 @@
 struct mfd_cell;
 
 struct platform_device {
-	const char	* name;
+	const char	*name;
 	int		id;
 	bool		id_auto;
 	struct device	dev;
 	u32		num_resources;
-	struct resource	* resource;
+	struct resource	*resource;
 
 	const struct platform_device_id	*id_entry;
 
@@ -47,9 +47,11 @@ extern struct bus_type platform_bus_type;
 extern struct device platform_bus;
 
 extern void arch_setup_pdev_archdata(struct platform_device *);
-extern struct resource *platform_get_resource(struct platform_device *, unsigned int, unsigned int);
+extern struct resource *platform_get_resource(struct platform_device *,
+					      unsigned int, unsigned int);
 extern int platform_get_irq(struct platform_device *, unsigned int);
-extern struct resource *platform_get_resource_byname(struct platform_device *, unsigned int, const char *);
+extern struct resource *platform_get_resource_byname(
+	struct platform_device *, unsigned int, const char *);
 extern int platform_get_irq_byname(struct platform_device *, const char *);
 extern int platform_add_devices(struct platform_device **, int);
 
@@ -161,7 +163,8 @@ extern struct platform_device *platform_device_alloc(const char *name, int id);
 extern int platform_device_add_resources(struct platform_device *pdev,
 					 const struct resource *res,
 					 unsigned int num);
-extern int platform_device_add_data(struct platform_device *pdev, const void *data, size_t size);
+extern int platform_device_add_data(struct platform_device *pdev,
+				    const void *data, size_t size);
 extern int platform_device_add(struct platform_device *pdev);
 extern void platform_device_del(struct platform_device *pdev);
 extern void platform_device_put(struct platform_device *pdev);
@@ -190,7 +193,8 @@ static inline void *platform_get_drvdata(const struct platform_device *pdev)
 	return dev_get_drvdata(&pdev->dev);
 }
 
-static inline void platform_set_drvdata(struct platform_device *pdev, void *data)
+static inline void platform_set_drvdata(struct platform_device *pdev,
+					void *data)
 {
 	dev_set_drvdata(&pdev->dev, data);
 }
@@ -222,10 +226,10 @@ static void __exit __platform_driver##_exit(void) \
 } \
 module_exit(__platform_driver##_exit);
 
-extern struct platform_device *platform_create_bundle(struct platform_driver *driver,
-					int (*probe)(struct platform_device *),
-					struct resource *res, unsigned int n_res,
-					const void *data, size_t size);
+extern struct platform_device *platform_create_bundle(
+	struct platform_driver *driver, int (*probe)(struct platform_device *),
+	struct resource *res, unsigned int n_res,
+	const void *data, size_t size);
 
 /* early platform driver interface */
 struct early_platform_driver {
-- 
1.8.2

