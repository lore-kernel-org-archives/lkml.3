Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab3H1PS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:18:59 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:3663 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab3H1PS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 11:18:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 28 Aug 2013 08:16:25 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <mturquette@linaro.org>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <linux-usb@vger.kernel.org>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH 2nd RESEND] clk: tegra30: Don't wait for PLL_U lock bit
Date: Wed, 28 Aug 2013 18:18:47 +0300
Message-ID: <1377703127-7020-2-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1377703127-7020-1-git-send-email-ttynkkynen@nvidia.com>
References: <1377703127-7020-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lock bit on PLL_U does not seem to be working correctly and
sometimes never gets set when waiting for the PLL to come up.
Remove the TEGRA_PLL_USE_LOCK flag to use a constant delay.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>

---
 drivers/clk/tegra/clk-tegra30.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index e2c6ca0..9103fc8 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -971,7 +971,7 @@ static void __init tegra30_pll_init(void)
 	/* PLLU */
 	clk = tegra_clk_register_pll("pll_u", "pll_ref", clk_base, pmc_base, 0,
 			    0, &pll_u_params, TEGRA_PLLU | TEGRA_PLL_HAS_CPCON |
-			    TEGRA_PLL_SET_LFCON | TEGRA_PLL_USE_LOCK,
+			    TEGRA_PLL_SET_LFCON,
 			    pll_u_freq_table,
 			    NULL);
 	clk_register_clkdev(clk, "pll_u", NULL);
-- 
1.8.1.5

