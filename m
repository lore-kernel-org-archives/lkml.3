Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab3LBDNV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 22:13:21 -0500
Received: from mail-qe0-f51.google.com ([209.85.128.51]:51498 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab3LBDNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 22:13:17 -0500
From: Fabio Estevam <festevam@gmail.com>
To: akpm@linux-foundation.org
Cc: a.zummo@towertech.it, s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 1/2] rtc: rtc-mxc: Remove unneeded label
Date: Mon,  2 Dec 2013 01:13:00 -0200
Message-Id: <1385953981-23630-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

There is no need to jump to the 'exit_free_pdata' label when devm_clk_get()
fails, as we can directly return the error and simplify the code a bit.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/rtc/rtc-mxc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-mxc.c b/drivers/rtc/rtc-mxc.c
index 50c5726..a3ed1cf 100644
--- a/drivers/rtc/rtc-mxc.c
+++ b/drivers/rtc/rtc-mxc.c
@@ -391,8 +391,7 @@ static int mxc_rtc_probe(struct platform_device *pdev)
 	pdata->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(pdata->clk)) {
 		dev_err(&pdev->dev, "unable to get clock!\n");
-		ret = PTR_ERR(pdata->clk);
-		goto exit_free_pdata;
+		return PTR_ERR(pdata->clk);
 	}
 
 	clk_prepare_enable(pdata->clk);
@@ -447,8 +446,6 @@ static int mxc_rtc_probe(struct platform_device *pdev)
 exit_put_clk:
 	clk_disable_unprepare(pdata->clk);
 
-exit_free_pdata:
-
 	return ret;
 }
 
-- 
1.8.1.2

