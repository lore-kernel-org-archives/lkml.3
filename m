Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab3FJLu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 07:50:57 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:42562 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab3FJLux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 07:50:53 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: thierry.reding@gmail.com, patches@linaro.org, linux-doc@vger.kernel.org,
        Rob Landley <rob@landley.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 15/15] lib: devres: Remove deprecated devm_request_and_ioremap
Date: Mon, 10 Jun 2013 17:05:13 +0530
Message-Id: <1370864113-17895-16-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all the users of devm_request_and_ioremap have been converted
to use devm_ioremap_resource, remove the definition.

Also remove the entries from Documentation.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
CC: linux-doc@vger.kernel.org
CC: Rob Landley <rob@landley.net>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/driver-model/devres.txt |    1 -
 include/linux/device.h                |    2 --
 lib/devres.c                          |   28 ----------------------------
 3 files changed, 31 deletions(-)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index b467145..c085bbb 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -267,7 +267,6 @@ IOMAP
   devm_ioremap_nocache()
   devm_iounmap()
   devm_ioremap_resource() : checks resource, requests memory region, ioremaps
-  devm_request_and_ioremap() : obsoleted by devm_ioremap_resource()
   pcim_iomap()
   pcim_iounmap()
   pcim_iomap_table()	: array of mapped addresses indexed by BAR
diff --git a/include/linux/device.h b/include/linux/device.h
index eeb3331..ba99ee2 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -580,8 +580,6 @@ extern void *devm_kzalloc(struct device *dev, size_t size, gfp_t gfp);
 extern void devm_kfree(struct device *dev, void *p);
 
 void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res);
-void __iomem *devm_request_and_ioremap(struct device *dev,
-			struct resource *res);
 
 /* allows to add/remove a custom action to devres stack */
 int devm_add_action(struct device *dev, void (*action)(void *), void *data);
diff --git a/lib/devres.c b/lib/devres.c
index 8235331..3ddb56d 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -140,34 +140,6 @@ void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res)
 }
 EXPORT_SYMBOL(devm_ioremap_resource);
 
-/**
- * devm_request_and_ioremap() - Check, request region, and ioremap resource
- * @dev: Generic device to handle the resource for
- * @res: resource to be handled
- *
- * Takes all necessary steps to ioremap a mem resource. Uses managed device, so
- * everything is undone on driver detach. Checks arguments, so you can feed
- * it the result from e.g. platform_get_resource() directly. Returns the
- * remapped pointer or NULL on error. Usage example:
- *
- *	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
- *	base = devm_request_and_ioremap(&pdev->dev, res);
- *	if (!base)
- *		return -EADDRNOTAVAIL;
- */
-void __iomem *devm_request_and_ioremap(struct device *device,
-				       struct resource *res)
-{
-	void __iomem *dest_ptr;
-
-	dest_ptr = devm_ioremap_resource(device, res);
-	if (IS_ERR(dest_ptr))
-		return NULL;
-
-	return dest_ptr;
-}
-EXPORT_SYMBOL(devm_request_and_ioremap);
-
 #ifdef CONFIG_HAS_IOPORT
 /*
  * Generic iomap devres
-- 
1.7.9.5

