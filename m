Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab3BFLYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:24:42 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:40070 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab3BFLYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 06:24:41 -0500
From: Mrugesh Katepallewar <mrugesh.mk@ti.com>
To: <linux-watchdog@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <wim@iguana.be>, <nsekhar@ti.com>
Subject: [PATCH] watchdog: davinci_wdt: use devm managed clk get
Date: Wed, 6 Feb 2013 16:56:01 +0530
Message-ID: <1360149961-3546-1-git-send-email-mrugesh.mk@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get the clock using devm_clk_get().

Signed-off-by: Mrugesh Katepallewar <mrugesh.mk@ti.com>
---
Apply on top of v3.8-rc6 of linus tree.

:100644 100644 e8e8724... c3c2f820.. M	drivers/watchdog/davinci_wdt.c
 drivers/watchdog/davinci_wdt.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index e8e8724..c3c2f820 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -204,7 +204,7 @@ static int davinci_wdt_probe(struct platform_device *pdev)
 	int ret = 0, size;
 	struct device *dev = &pdev->dev;
 
-	wdt_clk = clk_get(dev, NULL);
+	wdt_clk = devm_clk_get(dev, NULL);
 	if (WARN_ON(IS_ERR(wdt_clk)))
 		return PTR_ERR(wdt_clk);
 
@@ -257,7 +257,6 @@ static int davinci_wdt_remove(struct platform_device *pdev)
 	}
 
 	clk_disable_unprepare(wdt_clk);
-	clk_put(wdt_clk);
 
 	return 0;
 }
-- 
1.7.9.5

