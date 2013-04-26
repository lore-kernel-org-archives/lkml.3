Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529Ab3DZIPM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 04:15:12 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:58453 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab3DZIPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 04:15:08 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH] clk: ux500: abx500-clk: rename ux500 audio codec aliases
Date: Fri, 26 Apr 2013 10:14:52 +0200
Message-Id: <1366964092-7672-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change soc-audio related clk_register_clkdev() device names to reflect
the ones actually used in current snd-soc-mop500 and ab8500-codec
drivers.

Cc: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/clk/ux500/abx500-clk.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/ux500/abx500-clk.c b/drivers/clk/ux500/abx500-clk.c
index a0fca00..e7bd62c 100644
--- a/drivers/clk/ux500/abx500-clk.c
+++ b/drivers/clk/ux500/abx500-clk.c
@@ -45,7 +45,7 @@ static int ab8500_reg_clks(struct device *dev)
 				CLK_IS_ROOT);
 	clk_register_clkdev(clk, "sysclk", "ab8500-usb.0");
 	clk_register_clkdev(clk, "sysclk", "ab-iddet.0");
-	clk_register_clkdev(clk, "sysclk", "ab85xx-codec.0");
+	clk_register_clkdev(clk, "sysclk", "snd-soc-mop500.0");
 	clk_register_clkdev(clk, "sysclk", "shrm_bus");
 
 	/* ab8500_sysclk2 */
@@ -70,19 +70,19 @@ static int ab8500_reg_clks(struct device *dev)
 		AB8500_SYSULPCLKCTRL1, AB8500_SYSULPCLKCTRL1_ULPCLKREQ,
 		AB8500_SYSULPCLKCTRL1_ULPCLKREQ,
 		38400000, 9000, CLK_IS_ROOT);
-	clk_register_clkdev(clk, "ulpclk", "ab85xx-codec.0");
+	clk_register_clkdev(clk, "ulpclk", "snd-soc-mop500.0");
 
 	/* ab8500_intclk */
 	clk = clk_reg_sysctrl_set_parent(dev , "intclk", intclk_parents, 2,
 		intclk_reg_sel, intclk_reg_mask, intclk_reg_bits, 0);
-	clk_register_clkdev(clk, "intclk", "ab85xx-codec.0");
+	clk_register_clkdev(clk, "intclk", "snd-soc-mop500.0");
 	clk_register_clkdev(clk, NULL, "ab8500-pwm.1");
 
 	/* ab8500_audioclk */
 	clk = clk_reg_sysctrl_gate(dev , "audioclk", "intclk",
 		AB8500_SYSULPCLKCTRL1, AB8500_SYSULPCLKCTRL1_AUDIOCLKENA,
 		AB8500_SYSULPCLKCTRL1_AUDIOCLKENA, 0, 0);
-	clk_register_clkdev(clk, "audioclk", "ab85xx-codec.0");
+	clk_register_clkdev(clk, "audioclk", "ab8500-codec.0");
 
 	return 0;
 }
-- 
1.8.1.3

