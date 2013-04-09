Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937788Ab3DIK6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:58:36 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:43411 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759913Ab3DIK6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:58:35 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, rogerq@ti.com, sachin.kamat@linaro.org
Subject: [PATCH Resend 1/2] mfd: omap-usb-host: Convert to devm_ioremap_resource()
Date: Tue,  9 Apr 2013 16:16:36 +0530
Message-Id: <1365504397-29867-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly introduced devm_ioremap_resource() instead of
devm_request_and_ioremap() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages; so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Acked-by: Roger Quadros <rogerq@ti.com>
---
Rebased onto latest mfd-next tree.
---
 drivers/mfd/omap-usb-host.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index d3b6e94..759fae3 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -30,6 +30,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/err.h>
 
 #include "omap-usb.h"
 
@@ -608,11 +609,9 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
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

