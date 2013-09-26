Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750818Ab3IZNZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 09:25:44 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:16039 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab3IZNZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 09:25:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 26 Sep 2013 06:25:43 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <mturquette@linaro.org>
CC: <broonie@linaro.org>, <patches@opensource.wolfsonmicro.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] clk: wm831x: get rid of the implementation of remove function
Date: Thu, 26 Sep 2013 19:18:15 +0530
Message-ID: <1380203295-11030-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The remove function implemented for platform driver's remove callback
just return 0 as part of its implementation.

Remove this APIs and do not pass the valid .remove for platform driver.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
I was referring this driver for clock driver implementation for Palma and
realise that this remove function can be removed.
This is just outcome of code reading.

 drivers/clk/clk-wm831x.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/clk-wm831x.c b/drivers/clk/clk-wm831x.c
index 805b4c3..b131041 100644
--- a/drivers/clk/clk-wm831x.c
+++ b/drivers/clk/clk-wm831x.c
@@ -391,14 +391,8 @@ static int wm831x_clk_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int wm831x_clk_remove(struct platform_device *pdev)
-{
-	return 0;
-}
-
 static struct platform_driver wm831x_clk_driver = {
 	.probe = wm831x_clk_probe,
-	.remove = wm831x_clk_remove,
 	.driver		= {
 		.name	= "wm831x-clk",
 		.owner	= THIS_MODULE,
-- 
1.7.1.1

