Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbaBTNzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 08:55:00 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13771 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215AbaBTNy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 08:54:58 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 20 Feb 2014 05:51:46 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] clk: tegra: Fix vic03 mux index
Date: Thu, 20 Feb 2014 15:54:52 +0200
Message-ID: <1392904492-11979-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vic03 mux uses a linear mapping.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-tegra-periph.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra-periph.c b/drivers/clk/tegra/clk-tegra-periph.c
index f5376a3..1fa5c3f 100644
--- a/drivers/clk/tegra/clk-tegra-periph.c
+++ b/drivers/clk/tegra/clk-tegra-periph.c
@@ -371,9 +371,7 @@ static const char *mux_pllp3_pllc_clkm[] = {
 static const char *mux_pllm_pllc_pllp_plla_pllc2_c3_clkm[] = {
 	"pll_m", "pll_c", "pll_p", "pll_a", "pll_c2", "pll_c3", "clk_m"
 };
-static u32 mux_pllm_pllc_pllp_plla_pllc2_c3_clkm_idx[] = {
-	[0] = 0, [1] = 1, [2] = 2, [3] = 3, [4] = 4, [5] = 6,
-};
+#define mux_pllm_pllc_pllp_plla_pllc2_c3_clkm_idx NULL
 
 static const char *mux_pllm_pllc2_c_c3_pllp_plla_pllc4[] = {
 	"pll_m", "pll_c2", "pll_c", "pll_c3", "pll_p", "pll_a_out0", "pll_c4",
-- 
1.7.7.rc0.72.g4b5ea.dirty

