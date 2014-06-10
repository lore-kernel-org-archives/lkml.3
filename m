Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbaFJEly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 00:41:54 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51912 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbaFJElx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 00:41:53 -0400
From: George Cherian <george.cherian@ti.com>
To: <wim@iguana.be>
CC: <linux-watchdog@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 1/3] watchdog: dw_wdt: Remove the un-necessary check after platform_get_resource()
Date: Tue, 10 Jun 2014 10:10:06 +0530
Message-ID: <1402375208-18445-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource() checks for valid resource.
Remove the un-necessary check after platform_get_resource().

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/watchdog/dw_wdt.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/watchdog/dw_wdt.c b/drivers/watchdog/dw_wdt.c
index ee4f86b..9f21029 100644
--- a/drivers/watchdog/dw_wdt.c
+++ b/drivers/watchdog/dw_wdt.c
@@ -296,9 +296,6 @@ static int dw_wdt_drv_probe(struct platform_device *pdev)
 	int ret;
 	struct resource *mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	if (!mem)
-		return -EINVAL;
-
 	dw_wdt.regs = devm_ioremap_resource(&pdev->dev, mem);
 	if (IS_ERR(dw_wdt.regs))
 		return PTR_ERR(dw_wdt.regs);
-- 
1.8.3.1

