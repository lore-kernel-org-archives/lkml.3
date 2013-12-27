Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab3L0AxC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 19:53:02 -0500
Received: from mail-yh0-f73.google.com ([209.85.213.73]:45799 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab3L0AxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 19:53:00 -0500
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Dec 2013 19:53:00 EST
From: Andrew Bresticker <abrestic@chromium.org>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH 6/7] clk: tegra: cclk_lp has a pllx/2 divider
Date: Thu, 26 Dec 2013 16:44:26 -0800
Message-Id: <1388105067-24438-7-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1388105067-24438-1-git-send-email-abrestic@chromium.org>
References: <1388105067-24438-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When pll_x is the parent of cclk_lp, PLLX_DIV2_BYPASS_LP determines
whether cclk_lp output is divided by 2.  Set TEGRA_DIVIDER_2 so that
the clk_super driver is aware of this.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/clk/tegra/clk-tegra-super-gen4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/tegra/clk-tegra-super-gen4.c b/drivers/clk/tegra/clk-tegra-super-gen4.c
index 05dce4a..feb3201 100644
--- a/drivers/clk/tegra/clk-tegra-super-gen4.c
+++ b/drivers/clk/tegra/clk-tegra-super-gen4.c
@@ -120,7 +120,7 @@ void __init tegra_super_clk_gen4_init(void __iomem *clk_base,
 					ARRAY_SIZE(cclk_lp_parents),
 					CLK_SET_RATE_PARENT,
 					clk_base + CCLKLP_BURST_POLICY,
-					0, 4, 8, 9, NULL);
+					TEGRA_DIVIDER_2, 4, 8, 9, NULL);
 		*dt_clk = clk;
 	}
 
-- 
1.8.5.1

