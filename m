Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab3GQLAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 07:00:19 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50993 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab3GQLAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 07:00:14 -0400
From: Mark Brown <broonie@kernel.org>
To: Mike Turquette <mturquette@linaro.org>, Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Wed, 17 Jul 2013 11:59:46 +0100
Message-Id: <1374058786-16603-2-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374058786-16603-1-git-send-email-broonie@kernel.org>
References: <1374058786-16603-1-git-send-email-broonie@kernel.org>
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 2/2] clk: exynos4: Remove unused external clock registration function
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

As the comment says exynos4_clk_register_fixed_ext() was only used by
non-DT platforms. Since Exynos is now DT only it is no longer referenced
and can be removed.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/clk/samsung/clk-exynos4.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
index 0a91ff4..75635eb 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -969,20 +969,6 @@ static void __init exynos4_clk_register_finpll(unsigned long xom)
 
 }
 
-/*
- * This function allows non-dt platforms to specify the clock speed of the
- * xxti and xusbxti clocks. These clocks are then registered with the specified
- * clock speed.
- */
-static void __init exynos4_clk_register_fixed_ext(unsigned long xxti_f,
-						unsigned long xusbxti_f)
-{
-	exynos4_fixed_rate_ext_clks[0].fixed_rate = xxti_f;
-	exynos4_fixed_rate_ext_clks[1].fixed_rate = xusbxti_f;
-	samsung_clk_register_fixed_rate(exynos4_fixed_rate_ext_clks,
-			ARRAY_SIZE(exynos4_fixed_rate_ext_clks));
-}
-
 static __initdata struct of_device_id ext_clk_match[] = {
 	{ .compatible = "samsung,clock-xxti", .data = (void *)0, },
 	{ .compatible = "samsung,clock-xusbxti", .data = (void *)1, },
-- 
1.8.3.2

