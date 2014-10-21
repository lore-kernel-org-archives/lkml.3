Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869AbaJUN7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:59:01 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:61300 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932609AbaJUN67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:58:59 -0400
From: Dmitry Voytik <voytikd@gmail.com>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Sascha Hauer <kernel@pengutronix.de>, linux-kernel@vger.kernel.org,
        Dmitry Voytik <voytikd@gmail.com>
Subject: [PATCH] ARM: imx: simplify clk_pllv3_prepare()
Date: Tue, 21 Oct 2014 17:58:54 +0400
Message-Id: <1413899934-16227-1-git-send-email-voytikd@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ret variable is redundant. Call clk_pllv3_wait_lock() in the end
return.

Signed-off-by: Dmitry Voytik <voytikd@gmail.com>
---
 arch/arm/mach-imx/clk-pllv3.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/arm/mach-imx/clk-pllv3.c b/arch/arm/mach-imx/clk-pllv3.c
index 57de74d..0ad6e54 100644
--- a/arch/arm/mach-imx/clk-pllv3.c
+++ b/arch/arm/mach-imx/clk-pllv3.c
@@ -69,7 +69,6 @@ static int clk_pllv3_prepare(struct clk_hw *hw)
 {
 	struct clk_pllv3 *pll = to_clk_pllv3(hw);
 	u32 val;
-	int ret;
 
 	val = readl_relaxed(pll->base);
 	if (pll->powerup_set)
@@ -78,11 +77,7 @@ static int clk_pllv3_prepare(struct clk_hw *hw)
 		val &= ~BM_PLL_POWER;
 	writel_relaxed(val, pll->base);
 
-	ret = clk_pllv3_wait_lock(pll);
-	if (ret)
-		return ret;
-
-	return 0;
+	return clk_pllv3_wait_lock(pll);
 }
 
 static void clk_pllv3_unprepare(struct clk_hw *hw)
-- 
1.9.1

