Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab3JaLJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 07:09:48 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:43754 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab3JaLJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 07:09:45 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: patches@linaro.org, linux-watchdog@vger.kernel.org,
        Wim Van Sebroeck <wim@iguana.be>
Subject: [PATCH 4/5] watchdog: ralink: Use devm_ioremap_resource
Date: Thu, 31 Oct 2013 16:38:06 +0530
Message-Id: <1383217687-12037-5-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383217687-12037-1-git-send-email-tushar.behera@linaro.org>
References: <1383217687-12037-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
CC: linux-watchdog@vger.kernel.org
CC: Wim Van Sebroeck <wim@iguana.be>
---
 drivers/watchdog/rt2880_wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/rt2880_wdt.c b/drivers/watchdog/rt2880_wdt.c
index a9f8491..53d37fe 100644
--- a/drivers/watchdog/rt2880_wdt.c
+++ b/drivers/watchdog/rt2880_wdt.c
@@ -144,7 +144,7 @@ static int rt288x_wdt_probe(struct platform_device *pdev)
 	int ret;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	rt288x_wdt_base = devm_request_and_ioremap(&pdev->dev, res);
+	rt288x_wdt_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(rt288x_wdt_base))
 		return PTR_ERR(rt288x_wdt_base);
 
-- 
1.7.9.5

