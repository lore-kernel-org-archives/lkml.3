Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934822Ab3IDOV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:21:56 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:19859 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934731Ab3IDOVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:21:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 04 Sep 2013 07:21:53 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-tegra@vger.kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Joseph Lo <josephl@nvidia.com>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/4] clk: tegra: convert Tegra114 gate clocks to table
Date: Wed, 4 Sep 2013 17:20:09 +0300
Message-ID: <1378304438-7780-3-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1378304438-7780-1-git-send-email-pdeschrijver@nvidia.com>
References: <1378304438-7780-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the Tegra114 gate clock registration to be table driven
like the periph clocks. The same struct tegra_periph_init_data is used for the
table, but some fields are unused. This makes the code easier to read and also
paves the way to share clock data between Tegra SoCs.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-tegra114.c |  239 +++++++++++---------------------------
 drivers/clk/tegra/clk-tegra20.c  |    4 +-
 drivers/clk/tegra/clk-tegra30.c  |    4 +-
 drivers/clk/tegra/clk.h          |   20 +++-
 4 files changed, 88 insertions(+), 179 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index 451d0e2..dc74fd4 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -1892,6 +1892,37 @@ static struct tegra_periph_init_data tegra_periph_nodiv_clk_list[] = {
 	TEGRA_INIT_DATA_NODIV("disp2", NULL, "tegradc.1", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_DISP2, 29, 7, 26, 0, TEGRA114_CLK_DISP2),
 };
 
+static struct tegra_periph_init_data tegra_periph_gate_clk_list[] = {
+	TEGRA_INIT_DATA_GATE("rtc", NULL, "rtc-tegra", "clk_32k", 4, TEGRA_PERIPH_ON_APB | TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_RTC, 0),
+	TEGRA_INIT_DATA_GATE("timer", NULL, "timer", "clk_m", 5, 0, TEGRA114_CLK_TIMER, 0),
+	TEGRA_INIT_DATA_GATE("vcp", NULL, NULL, "clk_m", 29, 0, TEGRA114_CLK_HDA2HDMI, 0),
+	TEGRA_INIT_DATA_GATE("apbdma", NULL, NULL, "clk_m", 34, 0, TEGRA114_CLK_APBDMA, 0),
+	TEGRA_INIT_DATA_GATE("kbc", NULL, NULL, "clk_32k", 36, TEGRA_PERIPH_ON_APB | TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_KBC, 0),
+	TEGRA_INIT_DATA_GATE("fuse", NULL, NULL, "clk_m", 39, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_FUSE, 0),
+	TEGRA_INIT_DATA_GATE("fuse_burn", NULL, NULL, "clk_m", 39, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_FUSE_BURN, 0),
+	TEGRA_INIT_DATA_GATE("kfuse", NULL, NULL, "clk_m", 40, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_KFUSE, 0),
+	TEGRA_INIT_DATA_GATE("apbif", NULL, NULL, "clk_m", 107, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_APBIF, 0),
+	TEGRA_INIT_DATA_GATE("hda2hdmi", NULL, NULL, "clk_m", 128, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_HDA2HDMI, 0),
+	TEGRA_INIT_DATA_GATE("bsea", NULL, NULL, "clk_m", 62, 0, TEGRA114_CLK_HDA2HDMI, 0),
+	TEGRA_INIT_DATA_GATE("bsev", NULL, NULL, "clk_m", 63, 0, TEGRA114_CLK_BSEV, 0),
+	TEGRA_INIT_DATA_GATE("mipi-cal", NULL, NULL, "clk_m", 56, 0, TEGRA114_CLK_MIPI_CAL, 0),
+	TEGRA_INIT_DATA_GATE("usbd", NULL, NULL, "clk_m", 22, 0, TEGRA114_CLK_USBD, 0),
+	TEGRA_INIT_DATA_GATE("usb2", NULL, NULL, "clk_m", 58, 0, TEGRA114_CLK_USB2, 0),
+	TEGRA_INIT_DATA_GATE("usb3", NULL, NULL, "clk_m", 59, 0, TEGRA114_CLK_USB3, 0),
+	TEGRA_INIT_DATA_GATE("csi", NULL, NULL, "pll_p_out3", 52, 0, TEGRA114_CLK_CSI, 0),
+	TEGRA_INIT_DATA_GATE("isp", NULL, NULL, "clk_m", 23, 0, TEGRA114_CLK_ISP, 0),
+	TEGRA_INIT_DATA_GATE("csus", NULL, NULL, "clk_m", 92, TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_CSUS, 0),
+	TEGRA_INIT_DATA_GATE("dds", NULL, NULL, "clk_m", 150, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DDS, 0),
+	TEGRA_INIT_DATA_GATE("dp2", NULL, NULL, "clk_m", 152, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DP2, 0),
+	TEGRA_INIT_DATA_GATE("dtv", NULL, NULL, "clk_m", 79, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DTV, 0),
+	TEGRA_INIT_DATA_GATE("xusb_host", NULL, NULL, "xusb_host_src", 89, 0, TEGRA114_CLK_XUSB_HOST, 0),
+	TEGRA_INIT_DATA_GATE("xusb_ss", NULL, NULL, "xusb_ss_src", 156, 0, TEGRA114_CLK_XUSB_SS, 0),
+	TEGRA_INIT_DATA_GATE("xusb_dev", NULL, NULL," xusb_dev_src", 95, 0, TEGRA114_CLK_XUSB_DEV, 0),
+	TEGRA_INIT_DATA_GATE("dsia", NULL, NULL, "dsia_mux", 48, 0, TEGRA114_CLK_DSIA, 0),
+	TEGRA_INIT_DATA_GATE("dsib", NULL, NULL, "dsib_mux", 82, 0, TEGRA114_CLK_DSIB, 0),
+	TEGRA_INIT_DATA_GATE("emc", NULL, NULL, "emc_mux", 57, 0, TEGRA114_CLK_EMC, CLK_IGNORE_UNUSED),
+};
+
 static __init void tegra114_periph_clk_init(void __iomem *clk_base)
 {
 	struct tegra_periph_init_data *data;
@@ -1899,154 +1930,6 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base)
 	int i;
 	u32 val;
 
-	/* apbdma */
-	clk = tegra_clk_register_periph_gate("apbdma", "clk_m", 0, clk_base,
-				  0, 34, &periph_regs[h],
-				  periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_APBDMA] = clk;
-
-	/* rtc */
-	clk = tegra_clk_register_periph_gate("rtc", "clk_32k",
-				    TEGRA_PERIPH_ON_APB |
-				    TEGRA_PERIPH_NO_RESET, clk_base,
-				    0, 4, &periph_regs[l],
-				    periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "rtc-tegra");
-	clks[TEGRA114_CLK_RTC] = clk;
-
-	/* kbc */
-	clk = tegra_clk_register_periph_gate("kbc", "clk_32k",
-				    TEGRA_PERIPH_ON_APB |
-				    TEGRA_PERIPH_NO_RESET, clk_base,
-				    0, 36, &periph_regs[h],
-				    periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_KBC] = clk;
-
-	/* timer */
-	clk = tegra_clk_register_periph_gate("timer", "clk_m", 0, clk_base,
-				  0, 5, &periph_regs[l],
-				  periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "timer");
-	clks[TEGRA114_CLK_TIMER] = clk;
-
-	/* kfuse */
-	clk = tegra_clk_register_periph_gate("kfuse", "clk_m",
-				  TEGRA_PERIPH_ON_APB, clk_base,  0, 40,
-				  &periph_regs[h], periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_KFUSE] = clk;
-
-	/* fuse */
-	clk = tegra_clk_register_periph_gate("fuse", "clk_m",
-				  TEGRA_PERIPH_ON_APB, clk_base,  0, 39,
-				  &periph_regs[h], periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_FUSE] = clk;
-
-	/* fuse_burn */
-	clk = tegra_clk_register_periph_gate("fuse_burn", "clk_m",
-				  TEGRA_PERIPH_ON_APB, clk_base,  0, 39,
-				  &periph_regs[h], periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_FUSE_BURN] = clk;
-
-	/* apbif */
-	clk = tegra_clk_register_periph_gate("apbif", "clk_m",
-				  TEGRA_PERIPH_ON_APB, clk_base,  0, 107,
-				  &periph_regs[v], periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_APBIF] = clk;
-
-	/* hda2hdmi */
-	clk = tegra_clk_register_periph_gate("hda2hdmi", "clk_m",
-				    TEGRA_PERIPH_ON_APB, clk_base,  0, 128,
-				    &periph_regs[w], periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_HDA2HDMI] = clk;
-
-	/* vcp */
-	clk = tegra_clk_register_periph_gate("vcp", "clk_m", 0, clk_base,  0,
-				  29, &periph_regs[l],
-				  periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_VCP] = clk;
-
-	/* bsea */
-	clk = tegra_clk_register_periph_gate("bsea", "clk_m", 0, clk_base,
-				  0, 62, &periph_regs[h],
-				  periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_BSEA] = clk;
-
-	/* bsev */
-	clk = tegra_clk_register_periph_gate("bsev", "clk_m", 0, clk_base,
-				  0, 63, &periph_regs[h],
-				  periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_BSEV] = clk;
-
-	/* mipi-cal */
-	clk = tegra_clk_register_periph_gate("mipi-cal", "clk_m", 0, clk_base,
-				   0, 56, &periph_regs[h],
-				  periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_MIPI_CAL] = clk;
-
-	/* usbd */
-	clk = tegra_clk_register_periph_gate("usbd", "clk_m", 0, clk_base,
-				  0, 22, &periph_regs[l],
-				  periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_USBD] = clk;
-
-	/* usb2 */
-	clk = tegra_clk_register_periph_gate("usb2", "clk_m", 0, clk_base,
-				  0, 58, &periph_regs[h],
-				  periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_USB2] = clk;
-
-	/* usb3 */
-	clk = tegra_clk_register_periph_gate("usb3", "clk_m", 0, clk_base,
-				  0, 59, &periph_regs[h],
-				  periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_USB3] = clk;
-
-	/* csi */
-	clk = tegra_clk_register_periph_gate("csi", "pll_p_out3", 0, clk_base,
-				   0, 52, &periph_regs[h],
-				  periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_CSI] = clk;
-
-	/* isp */
-	clk = tegra_clk_register_periph_gate("isp", "clk_m", 0, clk_base, 0,
-				  23, &periph_regs[l],
-				  periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_ISP] = clk;
-
-	/* csus */
-	clk = tegra_clk_register_periph_gate("csus", "clk_m",
-				  TEGRA_PERIPH_NO_RESET, clk_base, 0, 92,
-				  &periph_regs[u], periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_CSUS] = clk;
-
-	/* dds */
-	clk = tegra_clk_register_periph_gate("dds", "clk_m",
-				  TEGRA_PERIPH_ON_APB, clk_base, 0, 150,
-				  &periph_regs[w], periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_DDS] = clk;
-
-	/* dp2 */
-	clk = tegra_clk_register_periph_gate("dp2", "clk_m",
-				  TEGRA_PERIPH_ON_APB, clk_base, 0, 152,
-				  &periph_regs[w], periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_DP2] = clk;
-
-	/* dtv */
-	clk = tegra_clk_register_periph_gate("dtv", "clk_m",
-				    TEGRA_PERIPH_ON_APB, clk_base, 0, 79,
-				    &periph_regs[u], periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_DTV] = clk;
-
-	/* dsia */
-	clk = clk_register_mux(NULL, "dsia_mux", mux_plld_out0_plld2_out0,
-			       ARRAY_SIZE(mux_plld_out0_plld2_out0), 0,
-			       clk_base + PLLD_BASE, 25, 1, 0, &pll_d_lock);
-	clks[TEGRA114_CLK_DSIA_MUX] = clk;
-	clk = tegra_clk_register_periph_gate("dsia", "dsia_mux", 0, clk_base,
-				    0, 48, &periph_regs[h],
-				    periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_DSIA] = clk;
-
 	/* xusb_hs_src */
 	val = readl(clk_base + CLK_SOURCE_XUSB_SS_SRC);
 	val |= BIT(25); /* always select PLLU_60M */
@@ -2056,33 +1939,23 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base)
 					1, 1);
 	clks[TEGRA114_CLK_XUSB_HS_SRC] = clk;
 
-	/* xusb_host */
-	clk = tegra_clk_register_periph_gate("xusb_host", "xusb_host_src", 0,
-				    clk_base, 0, 89, &periph_regs[u],
-				    periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_XUSB_HOST] = clk;
-
-	/* xusb_ss */
-	clk = tegra_clk_register_periph_gate("xusb_ss", "xusb_ss_src", 0,
-				    clk_base, 0, 156, &periph_regs[w],
-				    periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_XUSB_HOST] = clk;
-
-	/* xusb_dev */
-	clk = tegra_clk_register_periph_gate("xusb_dev", "xusb_dev_src", 0,
-				    clk_base, 0, 95, &periph_regs[u],
-				    periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_XUSB_DEV] = clk;
-
-	/* emc */
+	/* dsia mux */
+	clk = clk_register_mux(NULL, "dsia_mux", mux_plld_out0_plld2_out0,
+			       ARRAY_SIZE(mux_plld_out0_plld2_out0), 0,
+			       clk_base + PLLD_BASE, 25, 1, 0, &pll_d_lock);
+	clks[TEGRA114_CLK_DSIA_MUX] = clk;
+
+	/* dsib mux */
+	clk = clk_register_mux(NULL, "dsib_mux", mux_plld_out0_plld2_out0,
+			       ARRAY_SIZE(mux_plld_out0_plld2_out0), 0,
+			       clk_base + PLLD2_BASE, 25, 1, 0, &pll_d2_lock);
+	clks[TEGRA114_CLK_DSIB_MUX] = clk;
+
+	/* emc mux */
 	clk = clk_register_mux(NULL, "emc_mux", mux_pllmcp_clkm,
 			       ARRAY_SIZE(mux_pllmcp_clkm), 0,
 			       clk_base + CLK_SOURCE_EMC,
 			       29, 3, 0, NULL);
-	clk = tegra_clk_register_periph_gate("emc", "emc_mux", 0, clk_base,
-				CLK_IGNORE_UNUSED, 57, &periph_regs[h],
-				periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_EMC] = clk;
 
 	for (i = 0; i < ARRAY_SIZE(tegra_periph_clk_list); i++) {
 		int reg_bank;
@@ -2093,7 +1966,7 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base)
 		if (reg_bank >= 0) {
 			data->periph.gate.regs = &periph_regs[reg_bank];
 			clk = tegra_clk_register_periph(data->name,
-				data->parent_names, data->num_parents,
+				data->p.parent_names, data->num_parents,
 				&data->periph, clk_base, data->offset,
 				data->flags);
 			clks[data->clk_id] = clk;
@@ -2109,11 +1982,31 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base)
 		if (reg_bank >= 0) {
 			data->periph.gate.regs = &periph_regs[reg_bank];
 			clk = tegra_clk_register_periph_nodiv(data->name,
-				data->parent_names, data->num_parents,
+				data->p.parent_names, data->num_parents,
 				&data->periph, clk_base, data->offset);
 			clks[data->clk_id] = clk;
 		}
 	}
+
+	for (i = 0; i < ARRAY_SIZE(tegra_periph_gate_clk_list); i++) {
+		int reg_bank;
+
+		data = &tegra_periph_gate_clk_list[i];
+		reg_bank = get_reg_bank(data->periph.gate.clk_num);
+
+		if (reg_bank >= 0) {
+			clk = tegra_clk_register_periph_gate(data->name,
+					data->p.parent_name,
+					data->periph.gate.flags, clk_base,
+					data->flags, data->periph.gate.clk_num,
+					&periph_regs[reg_bank],
+					periph_clk_enb_refcnt);
+			clks[data->clk_id] = clk;
+			if (data->con_id || data->dev_id)
+				clk_register_clkdev(clk, data->con_id,
+						data->dev_id);
+		}
+	}
 }
 
 /* Tegra114 CPU clock and reset control functions */
diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index ebe94ce..fddce29 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -1025,7 +1025,7 @@ static void __init tegra20_periph_clk_init(void)
 
 	for (i = 0; i < ARRAY_SIZE(tegra_periph_clk_list); i++) {
 		data = &tegra_periph_clk_list[i];
-		clk = tegra_clk_register_periph(data->name, data->parent_names,
+		clk = tegra_clk_register_periph(data->name, data->p.parent_names,
 				data->num_parents, &data->periph,
 				clk_base, data->offset, data->flags);
 		clk_register_clkdev(clk, data->con_id, data->dev_id);
@@ -1035,7 +1035,7 @@ static void __init tegra20_periph_clk_init(void)
 	for (i = 0; i < ARRAY_SIZE(tegra_periph_nodiv_clk_list); i++) {
 		data = &tegra_periph_nodiv_clk_list[i];
 		clk = tegra_clk_register_periph_nodiv(data->name,
-					data->parent_names,
+					data->p.parent_names,
 					data->num_parents, &data->periph,
 					clk_base, data->offset);
 		clk_register_clkdev(clk, data->con_id, data->dev_id);
diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index ab35040..41e6d9b 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -1689,7 +1689,7 @@ static void __init tegra30_periph_clk_init(void)
 
 	for (i = 0; i < ARRAY_SIZE(tegra_periph_clk_list); i++) {
 		data = &tegra_periph_clk_list[i];
-		clk = tegra_clk_register_periph(data->name, data->parent_names,
+		clk = tegra_clk_register_periph(data->name, data->p.parent_names,
 				data->num_parents, &data->periph,
 				clk_base, data->offset, data->flags);
 		clk_register_clkdev(clk, data->con_id, data->dev_id);
@@ -1699,7 +1699,7 @@ static void __init tegra30_periph_clk_init(void)
 	for (i = 0; i < ARRAY_SIZE(tegra_periph_nodiv_clk_list); i++) {
 		data = &tegra_periph_nodiv_clk_list[i];
 		clk = tegra_clk_register_periph_nodiv(data->name,
-					data->parent_names,
+					data->p.parent_names,
 					data->num_parents, &data->periph,
 					clk_base, data->offset);
 		clk_register_clkdev(clk, data->con_id, data->dev_id);
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index 07cfacd..853cfe2 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -472,7 +472,10 @@ struct clk *tegra_clk_register_periph_nodiv(const char *name,
 struct tegra_periph_init_data {
 	const char *name;
 	int clk_id;
-	const char **parent_names;
+	union {
+		const char **parent_names;
+		const char *parent_name;
+	} p;
 	int num_parents;
 	struct tegra_clk_periph periph;
 	u32 offset;
@@ -489,7 +492,7 @@ struct tegra_periph_init_data {
 	{								\
 		.name = _name,						\
 		.clk_id = _clk_id,					\
-		.parent_names = _parent_names,				\
+		.p.parent_names = _parent_names,			\
 		.num_parents = ARRAY_SIZE(_parent_names),		\
 		.periph = TEGRA_CLK_PERIPH(_mux_shift, _mux_mask,	\
 					   _mux_flags, _div_shift,	\
@@ -513,6 +516,19 @@ struct tegra_periph_init_data {
 			_regs, _clk_num, _enb_refcnt, _gate_flags, _clk_id,\
 			NULL, 0)
 
+#define TEGRA_INIT_DATA_GATE(_name, _con_id, _dev_id, _parent_name,	\
+			     _clk_num, _gate_flags,  _clk_id, _flags)	\
+	{								\
+		.name = _name,						\
+		.clk_id = _clk_id,					\
+		.p.parent_name = _parent_name,				\
+		.periph = TEGRA_CLK_PERIPH(0, 0, 0, 0, 0, 0, 0, 	\
+				_clk_num, 0, 0, _gate_flags, 0),	\
+		.con_id = _con_id,					\
+		.dev_id = _dev_id,					\
+		.flags = _flags						\
+	}
+
 /**
  * struct clk_super_mux - super clock
  *
-- 
1.7.7.rc0.72.g4b5ea.dirty

