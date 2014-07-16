Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934085AbaGPNVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:21:12 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50537 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932591AbaGPNVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:21:07 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-watchdog@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <wim@iguana.be>, George Cherian <george.cherian@ti.com>
Subject: [RESEND PATCH 3/3] watchdog: shwdt: Remove the unnecessary check of resource after platform_get_resource()
Date: Wed, 16 Jul 2014 18:49:04 +0530
Message-ID: <1405516744-29333-3-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1405516744-29333-1-git-send-email-george.cherian@ti.com>
References: <1405516744-29333-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource check for a valid resource. Remove the unnecessary check.
Also group platform_get_resource and devm_ioremap_resource together for better
readability.

Signed-off-by: George Cherian <george.cherian@ti.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/watchdog/shwdt.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/watchdog/shwdt.c b/drivers/watchdog/shwdt.c
index 061756e..fa89bb3 100644
--- a/drivers/watchdog/shwdt.c
+++ b/drivers/watchdog/shwdt.c
@@ -230,10 +230,6 @@ static int sh_wdt_probe(struct platform_device *pdev)
 	if (pdev->id != -1)
 		return -EINVAL;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (unlikely(!res))
-		return -EINVAL;
-
 	wdt = devm_kzalloc(&pdev->dev, sizeof(struct sh_wdt), GFP_KERNEL);
 	if (unlikely(!wdt))
 		return -ENOMEM;
@@ -249,6 +245,7 @@ static int sh_wdt_probe(struct platform_device *pdev)
 		wdt->clk = NULL;
 	}
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	wdt->base = devm_ioremap_resource(wdt->dev, res);
 	if (IS_ERR(wdt->base))
 		return PTR_ERR(wdt->base);
-- 
1.8.3.1

