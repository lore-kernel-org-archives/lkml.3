Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbaFYQKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 12:10:18 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6791 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757233AbaFYQKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 12:10:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 25 Jun 2014 09:00:24 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] clk: tegra: fix vi_sensor clocks on Tegra124
Date: Wed, 25 Jun 2014 19:10:09 +0300
Message-ID: <1403712609-13624-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vi_sensor and vi_sensor2 have a wrong hw clkid on Tegra124. Fix this by
correcting the hw clkid for Tegra124 and creating the Tegra114 vi_sensor clock
from its own data. Tegra124 was also using the wrong internal clock id.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-tegra-periph.c |    4 ++--
 drivers/clk/tegra/clk-tegra114.c     |   31 ++++++++++++++++++++++++++++++-
 drivers/clk/tegra/clk-tegra124.c     |    2 +-
 3 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra-periph.c b/drivers/clk/tegra/clk-tegra-periph.c
index adf6b81..37f32c4 100644
--- a/drivers/clk/tegra/clk-tegra-periph.c
+++ b/drivers/clk/tegra/clk-tegra-periph.c
@@ -469,7 +469,7 @@ static struct tegra_periph_init_data periph_clks[] = {
 	MUX("sata", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SATA, 124, TEGRA_PERIPH_ON_APB, tegra_clk_sata),
 	MUX("adx1", mux_plla_pllc_pllp_clkm, CLK_SOURCE_ADX1, 180, TEGRA_PERIPH_ON_APB, tegra_clk_adx1),
 	MUX("amx1", mux_plla_pllc_pllp_clkm, CLK_SOURCE_AMX1, 185, TEGRA_PERIPH_ON_APB, tegra_clk_amx1),
-	MUX("vi_sensor2", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI_SENSOR2, 20, TEGRA_PERIPH_NO_RESET, tegra_clk_vi_sensor2),
+	MUX("vi_sensor2", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI_SENSOR2, 165, TEGRA_PERIPH_NO_RESET, tegra_clk_vi_sensor2),
 	MUX8("sdmmc1", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SDMMC1, 14, 0, tegra_clk_sdmmc1_8),
 	MUX8("sdmmc2", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SDMMC2, 9, 0, tegra_clk_sdmmc2_8),
 	MUX8("sdmmc3", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SDMMC3, 69, 0, tegra_clk_sdmmc3_8),
@@ -487,7 +487,7 @@ static struct tegra_periph_init_data periph_clks[] = {
 	MUX8("extern2", mux_plla_clk32_pllp_clkm_plle, CLK_SOURCE_EXTERN2, 121, 0, tegra_clk_extern2),
 	MUX8("extern3", mux_plla_clk32_pllp_clkm_plle, CLK_SOURCE_EXTERN3, 122, 0, tegra_clk_extern3),
 	MUX8("soc_therm", mux_pllm_pllc_pllp_plla, CLK_SOURCE_SOC_THERM, 78, TEGRA_PERIPH_ON_APB, tegra_clk_soc_therm),
-	MUX8("vi_sensor", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI_SENSOR, 20, TEGRA_PERIPH_NO_RESET, tegra_clk_vi_sensor_8),
+	MUX8("vi_sensor", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI_SENSOR, 164, TEGRA_PERIPH_NO_RESET, tegra_clk_vi_sensor_8),
 	MUX8("isp", mux_pllm_pllc_pllp_plla_clkm_pllc4, CLK_SOURCE_ISP, 23, TEGRA_PERIPH_ON_APB, tegra_clk_isp_8),
 	MUX8("entropy", mux_pllp_clkm1, CLK_SOURCE_ENTROPY, 149,  0, tegra_clk_entropy),
 	MUX8("hdmi_audio", mux_pllp3_pllc_clkm, CLK_SOURCE_HDMI_AUDIO, 176, TEGRA_PERIPH_NO_RESET, tegra_clk_hdmi_audio),
diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index b9c8ba2..f760f31 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -151,6 +151,13 @@
 /* Tegra CPU clock and reset control regs */
 #define CLK_RST_CONTROLLER_CPU_CMPLX_STATUS	0x470
 
+#define MUX8(_name, _parents, _offset, \
+			     _clk_num, _gate_flags, _clk_id)	\
+	TEGRA_INIT_DATA_TABLE(_name, NULL, NULL, _parents, _offset,\
+			29, MASK(3), 0, 0, 8, 1, TEGRA_DIVIDER_ROUND_UP,\
+			_clk_num, _gate_flags, _clk_id, _parents##_idx, 0,\
+			NULL)
+
 #ifdef CONFIG_PM_SLEEP
 static struct cpu_clk_suspend_context {
 	u32 clk_csite_src;
@@ -777,7 +784,6 @@ static struct tegra_clk tegra114_clks[tegra_clk_max] __initdata = {
 	[tegra_clk_spdif_in] = { .dt_id = TEGRA114_CLK_SPDIF_IN, .present = true },
 	[tegra_clk_spdif_out] = { .dt_id = TEGRA114_CLK_SPDIF_OUT, .present = true },
 	[tegra_clk_vi_8] = { .dt_id = TEGRA114_CLK_VI, .present = true },
-	[tegra_clk_vi_sensor_8] = { .dt_id = TEGRA114_CLK_VI_SENSOR, .present = true },
 	[tegra_clk_fuse] = { .dt_id = TEGRA114_CLK_FUSE, .present = true },
 	[tegra_clk_fuse_burn] = { .dt_id = TEGRA114_CLK_FUSE_BURN, .present = true },
 	[tegra_clk_clk_32k] = { .dt_id = TEGRA114_CLK_CLK_32K, .present = true },
@@ -923,6 +929,13 @@ static struct tegra_devclk devclks[] __initdata = {
 	{ .dev_id = "timer", .dt_id = TEGRA114_CLK_TIMER },
 };
 
+static const char *mux_pllm_pllc2_c_c3_pllp_plla[] = {
+	"pll_m", "pll_c2", "pll_c", "pll_c3", "pll_p", "pll_a_out0"
+};
+static u32 mux_pllm_pllc2_c_c3_pllp_plla_idx[] = {
+	[0] = 0, [1] = 1, [2] = 2, [3] = 3, [4] = 4, [5] = 6,
+};
+
 static struct clk **clks;
 
 static unsigned long osc_freq;
@@ -1178,10 +1191,18 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 	clks[TEGRA114_CLK_PLL_E_OUT0] = clk;
 }
 
+#define CLK_SOURCE_VI_SENSOR 0x1a8
+
+static struct tegra_periph_init_data tegra_periph_clk_list[] = {
+	MUX8("vi_sensor", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI_SENSOR, 20, TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_VI_SENSOR),
+};
+
 static __init void tegra114_periph_clk_init(void __iomem *clk_base,
 					    void __iomem *pmc_base)
 {
 	struct clk *clk;
+	struct tegra_periph_init_data *data;
+	int i;
 
 	/* xusb_ss_div2 */
 	clk = clk_register_fixed_factor(NULL, "xusb_ss_div2", "xusb_ss_src", 0,
@@ -1209,6 +1230,14 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base,
 			       clk_base + CLK_SOURCE_EMC,
 			       29, 3, 0, NULL);
 
+	for (i = 0; i < ARRAY_SIZE(tegra_periph_clk_list); i++) {
+		data = &tegra_periph_clk_list[i];
+		clk = tegra_clk_register_periph(data->name,
+			data->p.parent_names, data->num_parents,
+			&data->periph, clk_base, data->offset, data->flags);
+		clks[data->clk_id] = clk;
+	}
+
 	tegra_periph_clk_init(clk_base, pmc_base, tegra114_clks,
 				&pll_p_params);
 }
diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
index 80efe51..d78bcb7 100644
--- a/drivers/clk/tegra/clk-tegra124.c
+++ b/drivers/clk/tegra/clk-tegra124.c
@@ -869,7 +869,7 @@ static struct tegra_clk tegra124_clks[tegra_clk_max] __initdata = {
 	[tegra_clk_spdif_in] = { .dt_id = TEGRA124_CLK_SPDIF_IN, .present = true },
 	[tegra_clk_spdif_out] = { .dt_id = TEGRA124_CLK_SPDIF_OUT, .present = true },
 	[tegra_clk_vi_9] = { .dt_id = TEGRA124_CLK_VI, .present = true },
-	[tegra_clk_vi_sensor] = { .dt_id = TEGRA124_CLK_VI_SENSOR, .present = true },
+	[tegra_clk_vi_sensor_8] = { .dt_id = TEGRA124_CLK_VI_SENSOR, .present = true },
 	[tegra_clk_fuse] = { .dt_id = TEGRA124_CLK_FUSE, .present = true },
 	[tegra_clk_fuse_burn] = { .dt_id = TEGRA124_CLK_FUSE_BURN, .present = true },
 	[tegra_clk_clk_32k] = { .dt_id = TEGRA124_CLK_CLK_32K, .present = true },
-- 
1.7.7.rc0.72.g4b5ea.dirty

