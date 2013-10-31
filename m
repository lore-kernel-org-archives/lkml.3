Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab3JaLKD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 07:10:03 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:59006 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842Ab3JaLJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 07:09:48 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: patches@linaro.org, linux-doc@vger.kernel.org,
        Rob Landley <rob@landley.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5/5] lib: devres: Remove deprecated devm_request_and_ioremap
Date: Thu, 31 Oct 2013 16:38:07 +0530
Message-Id: <1383217687-12037-6-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383217687-12037-1-git-send-email-tushar.behera@linaro.org>
References: <1383217687-12037-1-git-send-email-tushar.behera@linaro.org>
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
index 5bdc8cb..7de1a54 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -273,7 +273,6 @@ IOMAP
   devm_ioremap_nocache()
   devm_iounmap()
   devm_ioremap_resource() : checks resource, requests memory region, ioremaps
-  devm_request_and_ioremap() : obsoleted by devm_ioremap_resource()
   pcim_iomap()
   pcim_iounmap()
   pcim_iomap_table()	: array of mapped addresses indexed by BAR
diff --git a/include/linux/device.h b/include/linux/device.h
index 5e44cff..54d74cf 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -628,8 +628,6 @@ static inline void *devm_kcalloc(struct device *dev,
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

