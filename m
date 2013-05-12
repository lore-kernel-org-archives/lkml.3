Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab3ELSOl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 14:14:41 -0400
Received: from smtp-out-237.synserver.de ([212.40.185.237]:1037 "EHLO
	smtp-out-236.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754798Ab3ELSOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 14:14:40 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 23026
From: Lars-Peter Clausen <lars@metafoo.de>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] watchdog: jz4740: Pass device to clk_get
Date: Sun, 12 May 2013 20:04:03 +0200
Message-Id: <1368381843-3856-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation to switching the jz4740 clk driver to the common clk framework
make sure to pass the device to clk_get().

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/watchdog/jz4740_wdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/jz4740_wdt.c b/drivers/watchdog/jz4740_wdt.c
index 1cb25f6..d1afdf6 100644
--- a/drivers/watchdog/jz4740_wdt.c
+++ b/drivers/watchdog/jz4740_wdt.c
@@ -177,7 +177,7 @@ static int jz4740_wdt_probe(struct platform_device *pdev)
 		goto err_out;
 	}
 
-	drvdata->rtc_clk = clk_get(NULL, "rtc");
+	drvdata->rtc_clk = clk_get(&pdev->dev, "rtc");
 	if (IS_ERR(drvdata->rtc_clk)) {
 		dev_err(&pdev->dev, "cannot find RTC clock\n");
 		ret = PTR_ERR(drvdata->rtc_clk);
-- 
1.8.2.1

