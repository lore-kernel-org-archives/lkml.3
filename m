Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaKFWsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:48:03 -0500
Received: from mail-ig0-f202.google.com ([209.85.213.202]:63002 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbaKFWr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:47:58 -0500
From: Andrew Bresticker <abrestic@chromium.org>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH] clk: tegra: SDMMC controllers are on APB
Date: Thu,  6 Nov 2014 14:47:55 -0800
Message-Id: <1415314075-14099-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the SDMMC controller registers are accessed via the APB,
the APB must be flushed before gating the SDMMC clocks to prevent
register accesses to the SDMMC controllers after their clocks are
gated.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/clk/tegra/clk-tegra-periph.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra-periph.c b/drivers/clk/tegra/clk-tegra-periph.c
index 37f32c4..fa20002 100644
--- a/drivers/clk/tegra/clk-tegra-periph.c
+++ b/drivers/clk/tegra/clk-tegra-periph.c
@@ -434,10 +434,10 @@ static struct tegra_periph_init_data periph_clks[] = {
 	MUX("hda", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_HDA, 125, TEGRA_PERIPH_ON_APB, tegra_clk_hda),
 	MUX("hda2codec_2x", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_HDA2CODEC_2X, 111, TEGRA_PERIPH_ON_APB, tegra_clk_hda2codec_2x),
 	MUX("vfir", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_VFIR, 7, TEGRA_PERIPH_ON_APB, tegra_clk_vfir),
-	MUX("sdmmc1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC1, 14, 0, tegra_clk_sdmmc1),
-	MUX("sdmmc2", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC2, 9, 0, tegra_clk_sdmmc2),
-	MUX("sdmmc3", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC3, 69, 0, tegra_clk_sdmmc3),
-	MUX("sdmmc4", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC4, 15, 0, tegra_clk_sdmmc4),
+	MUX("sdmmc1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC1, 14, TEGRA_PERIPH_ON_APB, tegra_clk_sdmmc1),
+	MUX("sdmmc2", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC2, 9, TEGRA_PERIPH_ON_APB, tegra_clk_sdmmc2),
+	MUX("sdmmc3", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC3, 69, TEGRA_PERIPH_ON_APB, tegra_clk_sdmmc3),
+	MUX("sdmmc4", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC4, 15, TEGRA_PERIPH_ON_APB, tegra_clk_sdmmc4),
 	MUX("la", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_LA, 76, TEGRA_PERIPH_ON_APB, tegra_clk_la),
 	MUX("trace", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_TRACE, 77, TEGRA_PERIPH_ON_APB, tegra_clk_trace),
 	MUX("owr", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_OWR, 71, TEGRA_PERIPH_ON_APB, tegra_clk_owr),
@@ -470,10 +470,10 @@ static struct tegra_periph_init_data periph_clks[] = {
 	MUX("adx1", mux_plla_pllc_pllp_clkm, CLK_SOURCE_ADX1, 180, TEGRA_PERIPH_ON_APB, tegra_clk_adx1),
 	MUX("amx1", mux_plla_pllc_pllp_clkm, CLK_SOURCE_AMX1, 185, TEGRA_PERIPH_ON_APB, tegra_clk_amx1),
 	MUX("vi_sensor2", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI_SENSOR2, 165, TEGRA_PERIPH_NO_RESET, tegra_clk_vi_sensor2),
-	MUX8("sdmmc1", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SDMMC1, 14, 0, tegra_clk_sdmmc1_8),
-	MUX8("sdmmc2", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SDMMC2, 9, 0, tegra_clk_sdmmc2_8),
-	MUX8("sdmmc3", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SDMMC3, 69, 0, tegra_clk_sdmmc3_8),
-	MUX8("sdmmc4", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SDMMC4, 15, 0, tegra_clk_sdmmc4_8),
+	MUX8("sdmmc1", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SDMMC1, 14, TEGRA_PERIPH_ON_APB, tegra_clk_sdmmc1_8),
+	MUX8("sdmmc2", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SDMMC2, 9, TEGRA_PERIPH_ON_APB, tegra_clk_sdmmc2_8),
+	MUX8("sdmmc3", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SDMMC3, 69, TEGRA_PERIPH_ON_APB, tegra_clk_sdmmc3_8),
+	MUX8("sdmmc4", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SDMMC4, 15, TEGRA_PERIPH_ON_APB, tegra_clk_sdmmc4_8),
 	MUX8("sbc1", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC1, 41, TEGRA_PERIPH_ON_APB, tegra_clk_sbc1_8),
 	MUX8("sbc2", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC2, 44, TEGRA_PERIPH_ON_APB, tegra_clk_sbc2_8),
 	MUX8("sbc3", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC3, 46, TEGRA_PERIPH_ON_APB, tegra_clk_sbc3_8),
-- 
2.1.0.rc2.206.gedb03e5

