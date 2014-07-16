Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934189AbaGPNVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:21:51 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56479 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933182AbaGPNVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:21:02 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-watchdog@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <wim@iguana.be>, George Cherian <george.cherian@ti.com>
Subject: [RESEND PATCH 2/3] watchdog: lantiq_wdt: Remove the un-necessary check of resource after platform_get_resource()
Date: Wed, 16 Jul 2014 18:49:03 +0530
Message-ID: <1405516744-29333-2-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1405516744-29333-1-git-send-email-george.cherian@ti.com>
References: <1405516744-29333-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource() checks for valid resource.
Remove the un-necessary check after platform_get_resource().

Signed-off-by: George Cherian <george.cherian@ti.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/watchdog/lantiq_wdt.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/watchdog/lantiq_wdt.c b/drivers/watchdog/lantiq_wdt.c
index 3b3148c..021e84e 100644
--- a/drivers/watchdog/lantiq_wdt.c
+++ b/drivers/watchdog/lantiq_wdt.c
@@ -192,11 +192,6 @@ ltq_wdt_probe(struct platform_device *pdev)
 	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	struct clk *clk;
 
-	if (!res) {
-		dev_err(&pdev->dev, "cannot obtain I/O memory region");
-		return -ENOENT;
-	}
-
 	ltq_wdt_membase = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(ltq_wdt_membase))
 		return PTR_ERR(ltq_wdt_membase);
-- 
1.8.3.1

