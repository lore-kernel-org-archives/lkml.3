Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab3EQGJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 02:09:29 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:59339 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab3EQGJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 02:09:25 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, mturquette@linaro.org, thomas.abraham@linaro.org,
        patches@linaro.org
Subject: [PATCH 1/2] clk: exynos5250: Update cpufreq related clocks for EXYNOS5250
Date: Fri, 17 May 2013 11:25:52 +0530
Message-Id: <1368770153-29041-2-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1368770153-29041-1-git-send-email-tushar.behera@linaro.org>
References: <1368770153-29041-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpufreq driver for EXYNOS5250 is not a platform driver, hence we cannot
currently pass the clock names through a device tree node. Instead, we
need to make them available through a global alias.

cpufreq driver for EXYNOS5250 requires four clocks - 'armclk',
'mout_cpu', 'mout_mpll' and 'mout_apll'.

'armclk' has already been defined with an alias, 'mout_cpu', 'mout_mpll'
and 'mout_apll' are now defined with an alias.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/clk/samsung/clk-exynos5250.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos5250.c b/drivers/clk/samsung/clk-exynos5250.c
index 5c97e75..05d099d 100644
--- a/drivers/clk/samsung/clk-exynos5250.c
+++ b/drivers/clk/samsung/clk-exynos5250.c
@@ -208,10 +208,10 @@ struct samsung_fixed_factor_clock exynos5250_fixed_factor_clks[] __initdata = {
 };
 
 struct samsung_mux_clock exynos5250_mux_clks[] __initdata = {
-	MUX(none, "mout_apll", mout_apll_p, SRC_CPU, 0, 1),
-	MUX(none, "mout_cpu", mout_cpu_p, SRC_CPU, 16, 1),
+	MUX_A(none, "mout_apll", mout_apll_p, SRC_CPU, 0, 1, "mout_apll"),
+	MUX_A(none, "mout_cpu", mout_cpu_p, SRC_CPU, 16, 1, "mout_cpu"),
 	MUX(none, "mout_mpll_fout", mout_mpll_fout_p, PLL_DIV2_SEL, 4, 1),
-	MUX(none, "sclk_mpll", mout_mpll_p, SRC_CORE1, 8, 1),
+	MUX_A(none, "sclk_mpll", mout_mpll_p, SRC_CORE1, 8, 1, "mout_mpll"),
 	MUX(none, "mout_bpll_fout", mout_bpll_fout_p, PLL_DIV2_SEL, 0, 1),
 	MUX(none, "sclk_bpll", mout_bpll_p, SRC_CDREX, 0, 1),
 	MUX(none, "mout_vpllsrc", mout_vpllsrc_p, SRC_TOP2, 0, 1),
-- 
1.7.9.5

