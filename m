Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbaFJEl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 00:41:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53902 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbaFJElz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 00:41:55 -0400
From: George Cherian <george.cherian@ti.com>
To: <wim@iguana.be>
CC: <linux-watchdog@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 2/3] watchdog: lantiq_wdt: Remove the un-necessary check of resource after platform_get_resource()
Date: Tue, 10 Jun 2014 10:10:07 +0530
Message-ID: <1402375208-18445-2-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1402375208-18445-1-git-send-email-george.cherian@ti.com>
References: <1402375208-18445-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource() checks for valid resource.
Remove the un-necessary check after platform_get_resource().

Signed-off-by: George Cherian <george.cherian@ti.com>
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

