Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490Ab3DDJ5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 05:57:05 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:48458 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab3DDJ5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 05:57:03 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, sachin.kamat@linaro.org,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH 2/2] mfd: omap-usb-tll: Convert to devm_ioremap_resource()
Date: Thu,  4 Apr 2013 15:15:15 +0530
Message-Id: <1365068715-15868-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365068715-15868-1-git-send-email-sachin.kamat@linaro.org>
References: <1365068715-15868-1-git-send-email-sachin.kamat@linaro.org>
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
 drivers/mfd/omap-usb-tll.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
index 0aef1a7..f3b0365 100644
--- a/drivers/mfd/omap-usb-tll.c
+++ b/drivers/mfd/omap-usb-tll.c
@@ -235,12 +235,9 @@ static int usbtll_omap_probe(struct platform_device *pdev)
 	tll->pdata = pdata;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	base = devm_request_and_ioremap(dev, res);
-	if (!base) {
-		ret = -EADDRNOTAVAIL;
-		dev_err(dev, "Resource request/ioremap failed:%d\n", ret);
-		return ret;
-	}
+	base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
 
 	platform_set_drvdata(pdev, tll);
 	pm_runtime_enable(dev);
-- 
1.7.9.5

