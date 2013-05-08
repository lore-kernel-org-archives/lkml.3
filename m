Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab3EHNaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 09:30:11 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:47945 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab3EHNaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 09:30:08 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 3/9] clk: ux500: Provide device enumeration number suffix for SMSC911x
Date: Wed,  8 May 2013 14:29:03 +0100
Message-Id: <1368019749-19455-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368019749-19455-1-git-send-email-lee.jones@linaro.org>
References: <1368019749-19455-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First Ethernet device has a ".0" appended onto the device name. It
appears that we need this in order to obtain the correct clock.

Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/clk/ux500/u8500_clk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/ux500/u8500_clk.c b/drivers/clk/ux500/u8500_clk.c
index 0b4f35a..80069c3 100644
--- a/drivers/clk/ux500/u8500_clk.c
+++ b/drivers/clk/ux500/u8500_clk.c
@@ -325,7 +325,7 @@ void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 	clk = clk_reg_prcc_pclk("p3_pclk0", "per3clk", clkrst3_base,
 				BIT(0), 0);
 	clk_register_clkdev(clk, "fsmc", NULL);
-	clk_register_clkdev(clk, NULL, "smsc911x");
+	clk_register_clkdev(clk, NULL, "smsc911x.0");
 
 	clk = clk_reg_prcc_pclk("p3_pclk1", "per3clk", clkrst3_base,
 				BIT(1), 0);
-- 
1.7.10.4

