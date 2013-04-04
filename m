Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab3DDJ5C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 05:57:02 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:35132 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab3DDJ5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 05:57:00 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, sachin.kamat@linaro.org,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH 1/2] mfd: omap-usb-host: Convert to devm_ioremap_resource()
Date: Thu,  4 Apr 2013 15:15:14 +0530
Message-Id: <1365068715-15868-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly introduced devm_ioremap_resource() instead of
devm_request_and_ioremap() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages; so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Roger Quadros <rogerq@ti.com>
---
 drivers/mfd/omap-usb-host.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 4febc5c..1b49b21 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -27,6 +27,7 @@
 #include <linux/platform_device.h>
 #include <linux/platform_data/usb-omap.h>
 #include <linux/pm_runtime.h>
+#include <linux/err.h>
 
 #include "omap-usb.h"
 
@@ -534,11 +535,9 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 	}
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "uhh");
-	omap->uhh_base = devm_request_and_ioremap(dev, res);
-	if (!omap->uhh_base) {
-		dev_err(dev, "Resource request/ioremap failed\n");
-		return -EADDRNOTAVAIL;
-	}
+	omap->uhh_base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(omap->uhh_base))
+		return PTR_ERR(omap->uhh_base);
 
 	omap->pdata = pdata;
 
-- 
1.7.9.5

