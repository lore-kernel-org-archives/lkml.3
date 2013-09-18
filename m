Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab3IRMUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:20:51 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60957 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab3IRMPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:15:09 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 21/41] clk: ux500: Remove BML8580 clock
Date: Wed, 18 Sep 2013 13:14:18 +0100
Message-Id: <1379506478-16625-22-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no mention of the PRCMU_BML8580CLK in any of the Design
Specifications for the chips supported in Mainline. In fact, where it
is incorrectly used in the u8540 clock definition driver it would
have the side effect of using the incorrect clock management address
([PRCM_BML8580CLK_MGT] 0x108 instead of the correct value 0x04C).

Acked-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/clk/ux500/u8540_clk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/ux500/u8540_clk.c b/drivers/clk/ux500/u8540_clk.c
index f262588..20c8add 100644
--- a/drivers/clk/ux500/u8540_clk.c
+++ b/drivers/clk/ux500/u8540_clk.c
@@ -83,7 +83,7 @@ void u8540_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 	clk_register_clkdev(clk, NULL, "lcd");
 	clk_register_clkdev(clk, "lcd", "mcde");
 
-	clk = clk_reg_prcmu_opp_gate("bmlclk", NULL, PRCMU_BML8580CLK,
+	clk = clk_reg_prcmu_opp_gate("bmlclk", NULL, PRCMU_BMLCLK,
 				CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "bml");
 
-- 
1.8.1.2

