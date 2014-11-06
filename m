Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbaKFStx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:49:53 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:39794 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaKFStw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:49:52 -0500
From: Dmitry Voytik <voytikd@gmail.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Dmitry Voytik <voytikd@gmail.com>
Subject: [PATCH] ARM: imx: simplify clk_pllv3_prepare()
Date: Thu,  6 Nov 2014 22:49:32 +0400
Message-Id: <1415299772-21079-1-git-send-email-voytikd@gmail.com>
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

