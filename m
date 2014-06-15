Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbaFOPbp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 11:31:45 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:53350 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaFOPbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 11:31:42 -0400
Message-ID: <1402846298.6673.2.camel@phoenix>
Subject: [PATCH RESEND] clk: twl6040: Convert to use devm_clk_register
From: Axel Lin <axel.lin@ingics.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-kernel@vger.kernel.org
Date: Sun, 15 Jun 2014 23:31:38 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_clk_register() to simplify the code by removing twl6040_clk_remove().

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
This patch was sent on https://lkml.org/lkml/2014/5/18/75 with Peter's Ack.
 drivers/clk/clk-twl6040.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/clk/clk-twl6040.c b/drivers/clk/clk-twl6040.c
index 1ada79a..9e996b4 100644
--- a/drivers/clk/clk-twl6040.c
+++ b/drivers/clk/clk-twl6040.c
@@ -91,7 +91,7 @@ static int twl6040_clk_probe(struct platform_device *pdev)
 	clkdata->twl6040 = twl6040;
 
 	clkdata->mcpdm_fclk.init = &wm831x_clkout_init;
-	clkdata->clk = clk_register(&pdev->dev, &clkdata->mcpdm_fclk);
+	clkdata->clk = devm_clk_register(&pdev->dev, &clkdata->mcpdm_fclk);
 	if (IS_ERR(clkdata->clk))
 		return PTR_ERR(clkdata->clk);
 
@@ -100,22 +100,12 @@ static int twl6040_clk_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int twl6040_clk_remove(struct platform_device *pdev)
-{
-	struct twl6040_clk *clkdata = platform_get_drvdata(pdev);
-
-	clk_unregister(clkdata->clk);
-
-	return 0;
-}
-
 static struct platform_driver twl6040_clk_driver = {
 	.driver = {
 		.name = "twl6040-clk",
 		.owner = THIS_MODULE,
 	},
 	.probe = twl6040_clk_probe,
-	.remove = twl6040_clk_remove,
 };
 
 module_platform_driver(twl6040_clk_driver);
-- 
1.8.3.2



