Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937803Ab3DIK6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:58:41 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:40483 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937791Ab3DIK6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:58:38 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, rogerq@ti.com, sachin.kamat@linaro.org
Subject: [PATCH Resend 2/2] mfd: omap-usb-tll: Convert to devm_ioremap_resource()
Date: Tue,  9 Apr 2013 16:16:37 +0530
Message-Id: <1365504397-29867-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365504397-29867-1-git-send-email-sachin.kamat@linaro.org>
References: <1365504397-29867-1-git-send-email-sachin.kamat@linaro.org>
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
 drivers/mfd/omap-usb-tll.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
index 8f4d5a1..e59ac4c 100644
--- a/drivers/mfd/omap-usb-tll.c
+++ b/drivers/mfd/omap-usb-tll.c
@@ -226,12 +226,9 @@ static int usbtll_omap_probe(struct platform_device *pdev)
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	tll->base = devm_request_and_ioremap(dev, res);
-	if (!tll->base) {
-		ret = -EADDRNOTAVAIL;
-		dev_err(dev, "Resource request/ioremap failed:%d\n", ret);
-		return ret;
-	}
+	tll->base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(tll->base))
+		return PTR_ERR(tll->base);
 
 	platform_set_drvdata(pdev, tll);
 	pm_runtime_enable(dev);
-- 
1.7.9.5

