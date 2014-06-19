Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934323AbaFSSte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 14:49:34 -0400
Received: from sauhun.de ([89.238.76.85]:37042 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934259AbaFSStb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 14:49:31 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Tushar Behera <tushar.behera@linaro.org>, Wolfram Sang <wsa@the-dreams.de>,
        Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org
Subject: [PATCH 3/3] lib: devres: Remove deprecated devm_request_and_ioremap
Date: Thu, 19 Jun 2014 20:49:01 +0200
Message-Id: <1403203741-5113-4-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403203741-5113-1-git-send-email-wsa@the-dreams.de>
References: <1403203741-5113-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tushar Behera <tushar.behera@linaro.org>

Now that all the users of devm_request_and_ioremap have been converted
to use devm_ioremap_resource, remove it. Also remove the entries from
Documentation.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 Documentation/driver-model/devres.txt |  1 -
 include/linux/device.h                |  2 --
 lib/devres.c                          | 28 ----------------------------
 3 files changed, 31 deletions(-)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index 1525e30483fd..de6bc8c325e9 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -278,7 +278,6 @@ IOMAP
   devm_ioremap_nocache()
   devm_iounmap()
   devm_ioremap_resource() : checks resource, requests memory region, ioremaps
-  devm_request_and_ioremap() : obsoleted by devm_ioremap_resource()
   pcim_iomap()
   pcim_iounmap()
   pcim_iomap_table()	: array of mapped addresses indexed by BAR
diff --git a/include/linux/device.h b/include/linux/device.h
index af424acd393d..921fa0a74df6 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -631,8 +631,6 @@ extern unsigned long devm_get_free_pages(struct device *dev,
 extern void devm_free_pages(struct device *dev, unsigned long addr);
 
 void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res);
-void __iomem *devm_request_and_ioremap(struct device *dev,
-			struct resource *res);
 
 /* allows to add/remove a custom action to devres stack */
 int devm_add_action(struct device *dev, void (*action)(void *), void *data);
diff --git a/lib/devres.c b/lib/devres.c
index f562bf6ff71d..6a4aee8a3a7e 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -142,34 +142,6 @@ void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res)
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
-void __iomem *devm_request_and_ioremap(struct device *dev,
-				       struct resource *res)
-{
-	void __iomem *dest_ptr;
-
-	dest_ptr = devm_ioremap_resource(dev, res);
-	if (IS_ERR(dest_ptr))
-		return NULL;
-
-	return dest_ptr;
-}
-EXPORT_SYMBOL(devm_request_and_ioremap);
-
 #ifdef CONFIG_HAS_IOPORT_MAP
 /*
  * Generic iomap devres
-- 
2.0.0

