Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbaK0Hjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 02:39:31 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:20556 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbaK0Hf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 02:35:26 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-34-5476d437f44b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net,
        catalin.marinas@arm.com, will.deacon@arm.com, s.nawrocki@samsung.com,
        tomasz.figa@gmail.com, thomas.abraham@linaro.org,
        linus.walleij@linaro.org, kyungmin.park@samsung.com,
        inki.dae@samsung.com, chanho61.park@samsung.com,
        geunsik.lim@samsung.com, sw0312.kim@samsung.com,
        jh80.chung@samsung.com, cw00.choi@samsung.com, a.kesavan@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 11/19] clk: samsung: exynos5433: Add clocks for CMU_BUS{0|1|2}
 domains
Date: Thu, 27 Nov 2014 16:35:08 +0900
Message-id: <1417073716-22997-12-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsWyRsSkRNfiSlmIwfPv7BaP1yxmsvg76Ri7
	xftlPYwWl/drW1z/8pzVYv6Rc6wWfya0sllMuj+BxeLGrzZWi94FV9kszja9YbeY8mc5k8Wm
	x9dYLS7vmsNmMeP8PiaLpdcvMlmcuv6ZzeLwm3ZWixmTX7JZHJuxhNFi1a4/jBYvP55gcRDz
	WDNvDaPH71+TGD12zrrL7nHn2h42j81L6j2unGhi9ejbsorR4/MmuQCOKC6blNSczLLUIn27
	BK6Ms82uBVtyKl5MOcrWwHgruouRk0NCwETix9RNLBC2mMSFe+vZuhi5OIQEljJKbJz3gwWm
	6Piky6wgtpDAdEaJ3t/lEEVNTBK3Vj5gB0mwCWhJ7H9xgw3EFhFwlmiY2sgEUsQs8JFZomHa
	RbBuYYEIiQ2/7wJN5eBgEVCVWLmeGyTMK+Am8fvcdahlChLLls8EK+cEiu//ehBqsavEom9X
	wGZKCMzkkGg42AmWYBEQkPg2+RDYTAkBWYlNB5gh5khKHFxxg2UCo/ACRoZVjKKpBckFxUnp
	RSZ6xYm5xaV56XrJ+bmbGIFRefrfswk7GO8dsD7EKMDBqMTDa3GgLESINbGsuDL3EKMp0IaJ
	zFKiyfnA2M8riTc0NjOyMDUxNTYytzRTEud9LfUzWEggPbEkNTs1tSC1KL6oNCe1+BAjEwen
	VAOj8rYtfIVd3j/UZkx19+/Udxd5JVVi0Hz1vzmjZK/ga8VDdj+Pr0/cwXGUddnEugT9XTEN
	9w9eVnVt/Sfxq2F7dLRWwKfT7BLfXWwSp75iumdw1vezx8X7JqcPVHS1MB9ap1SYueDs1e+b
	FnxQ9O9t/MR5XztHWOCg1uaCR7oBiTfeOc3NE9+pxFKckWioxVxUnAgAYv8facUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jQV3zK2UhBr1tVhaP1yxmsvg76Ri7
	xftlPYwWl/drW1z/8pzVYv6Rc6wWfya0sllMuj+BxeLGrzZWi94FV9kszja9YbeY8mc5k8Wm
	x9dYLS7vmsNmMeP8PiaLpdcvMlmcuv6ZzeLwm3ZWixmTX7JZHJuxhNFi1a4/jBYvP55gcRDz
	WDNvDaPH71+TGD12zrrL7nHn2h42j81L6j2unGhi9ejbsorR4/MmuQCOqAZGm4zUxJTUIoXU
	vOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg/5QUyhJzSoFCAYnFxUr6
	dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGWebXQu25FS8mHKUrYHxVnQXIyeHhICJxPFJl1kh
	bDGJC/fWs4HYQgLTGSV6f5d3MXIB2U1MErdWPmAHSbAJaEnsf3EDrEhEwFmiYWojE0gRs8BH
	ZomGaRfBJgkLREhs+H2XpYuRg4NFQFVi5XpukDCvgJvE73PXWSCWKUgsWz4TrJwTKL7/60FW
	iMWuEou+XWGawMi7gJFhFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwzD+T3sG4qsHiEKMA
	B6MSD6/FgbIQIdbEsuLK3EOMEhzMSiK8UouAQrwpiZVVqUX58UWlOanFhxhNgY6ayCwlmpwP
	TEd5JfGGxiZmRpZG5oYWRsbmSuK8N27mhggJpCeWpGanphakFsH0MXFwSjUwFq+I23T/5P7m
	jPdLZ03ddnynRNCB3g/TBMVkug7EJwoVefdZFCjZzgy3TNxqquoy91+13FqxI4qK64/cqFz2
	KsVRbp/opOuWjkaL7bcKX3J/VNncttaOu8iJMcl9+Sa3qrX/RTdkcVjwWWcqT5sUnyleHtuY
	7n/tXf+la1wiG36eOWfVveavEktxRqKhFnNRcSIAz5AvyQ8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the mux/divider/gate clocks for CMU_BUS{0|1|2} domains
which contain global data buses clocked at up the 400MHz. These blocks
transfer data between DRAM and various sub-blocks. These clock domains
also contain global peripheral buses clocked at 67/111/200/222/266/333/400
MHz and used for regiser accesses.

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
---
 .../devicetree/bindings/clock/exynos5433-clock.txt |  21 ++
 drivers/clk/samsung/clk-exynos5433.c               | 225 ++++++++++++++++++++-
 include/dt-bindings/clock/exynos5433.h             |  52 ++++-
 3 files changed, 295 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/exynos5433-clock.txt b/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
index 9a6ae75..03ae40a 100644
--- a/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
+++ b/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
@@ -25,6 +25,9 @@ Required Properties:
     which generates clocks for Display (DECON/HDMI/DSIM/MIXER) IPs.
   - "samsung,exynos5433-cmu-aud"   - clock controller compatible for CMU_AUD
     which generates clocks for Cortex-A5/BUS/AUDIO clocks.
+  - "samsung,exynos5433-cmu-bus0", "samsung,exynos5433-cmu-bus1"
+    and "samsung,exynos5433-cmu-bus2" - clock controller compatible for CMU_BUS
+    which generates global data buses clock and global peripheral buses clock.
 
 - reg: physical base address of the controller and length of memory mapped
   region.
@@ -94,6 +97,24 @@ Example 1: Examples of clock controller nodes are listed below.
 		#clock-cells = <1>;
 	};
 
+	cmu_bus0: clock-controller@0x13600000 {
+		compatible = "samsung,exynos5433-cmu-bus0";
+		reg = <0x13600000 0x0b04>;
+		#clock-cells = <1>;
+	};
+
+	cmu_bus1: clock-controller@0x14800000 {
+		compatible = "samsung,exynos5433-cmu-bus1";
+		reg = <0x14800000 0x0b04>;
+		#clock-cells = <1>;
+	};
+
+	cmu_bus2: clock-controller@0x13400000 {
+		compatible = "samsung,exynos5433-cmu-bus2";
+		reg = <0x13400000 0x0b04>;
+		#clock-cells = <1>;
+	};
+
 Example 2: UART controller node that consumes the clock generated by the clock
 	   controller.
 
diff --git a/drivers/clk/samsung/clk-exynos5433.c b/drivers/clk/samsung/clk-exynos5433.c
index 9f28672..f0975e1 100644
--- a/drivers/clk/samsung/clk-exynos5433.c
+++ b/drivers/clk/samsung/clk-exynos5433.c
@@ -428,7 +428,7 @@ static struct samsung_div_clock top_div_clks[] __initdata = {
 			DIV_TOP2, 0, 3),
 
 	/* DIV_TOP3 */
-	DIV(CLK_DIV_ACLK_IMEM_SSSX, "div_aclk_imem_sssx",
+	DIV(CLK_DIV_ACLK_IMEM_SSSX_266, "div_aclk_imem_sssx_266",
 			"mout_bus_pll_user", DIV_TOP3, 24, 3),
 	DIV(CLK_DIV_ACLK_IMEM_200, "div_aclk_imem_200",
 			"mout_bus_pll_user", DIV_TOP3, 20, 3),
@@ -443,6 +443,14 @@ static struct samsung_div_clock top_div_clks[] __initdata = {
 	DIV(CLK_DIV_ACLK_PERIS_66_A, "div_aclk_peris_66_a",
 			"mout_bus_pll_user", DIV_TOP3, 0, 3),
 
+	/* DIV_TOP4 */
+	DIV(CLK_DIV_ACLK_G3D_400, "div_aclk_g3d_400", "mout_bus_pll_user",
+			DIV_TOP4, 8, 3),
+	DIV(CLK_DIV_ACLK_BUS0_400, "div_aclk_bus0_400", "mout_aclk_bus0_400",
+			DIV_TOP4, 4, 3),
+	DIV(CLK_DIV_ACLK_BUS1_400, "div_aclk_bus1_400", "mout_bus_pll_user",
+			DIV_TOP4, 0, 3),
+
 	/* DIV_TOP_FSYS0 */
 	DIV(CLK_DIV_SCLK_MMC1_B, "div_sclk_mmc1_b", "div_sclk_mmc1_a",
 			DIV_TOP_FSYS0, 16, 8),
@@ -506,6 +514,19 @@ static struct samsung_div_clock top_div_clks[] __initdata = {
 
 static struct samsung_gate_clock top_gate_clks[] __initdata = {
 	/* ENABLE_ACLK_TOP */
+	GATE(CLK_ACLK_G3D_400, "aclk_g3d_400", "div_aclk_g3d_400",
+			ENABLE_ACLK_TOP, 30, 0, 0),
+	GATE(CLK_ACLK_IMEM_SSX_266, "aclk_imem_ssx_266",
+			"div_aclk_imem_sssx_266", ENABLE_ACLK_TOP,
+			29, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_BUS0_400, "aclk_bus0_400", "div_aclk_bus0_400",
+			ENABLE_ACLK_TOP, 26, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_BUS1_400, "aclk_bus1_400", "div_aclk_bus1_400",
+			ENABLE_ACLK_TOP, 25, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_IMEM_200, "aclk_imem_200", "div_aclk_imem_266",
+			ENABLE_ACLK_TOP, 24, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_IMEM_266, "aclk_imem_266", "div_aclk_imem_200",
+			ENABLE_ACLK_TOP, 23, CLK_IGNORE_UNUSED, 0),
 	GATE(CLK_ACLK_PERIC_66, "aclk_peric_66", "div_aclk_peric_66_b",
 			ENABLE_ACLK_TOP, 22, CLK_IGNORE_UNUSED, 0),
 	GATE(CLK_ACLK_PERIS_66, "aclk_peris_66", "div_aclk_peris_66_b",
@@ -2629,3 +2650,205 @@ static void __init exynos5433_cmu_aud_init(struct device_node *np)
 }
 CLK_OF_DECLARE(exynos5433_cmu_aud, "samsung,exynos5433-cmu-aud",
 		exynos5433_cmu_aud_init);
+
+
+/*
+ * Register offset definitions for CMU_BUS0
+ */
+#define DIV_BUS0			0x0600
+#define DIV_STAT_BUS0			0x0700
+#define ENABLE_ACLK_BUS0		0x0800
+#define ENABLE_PCLK_BUS0		0x0900
+#define ENABLE_IP_BUS0			0x0b00
+#define ENABLE_IP_BUS1			0x0b04
+
+static unsigned long bus0_clk_regs[] __initdata = {
+	DIV_BUS0,
+	DIV_STAT_BUS0,
+	ENABLE_ACLK_BUS0,
+	ENABLE_PCLK_BUS0,
+	ENABLE_IP_BUS0,
+	ENABLE_IP_BUS1,
+};
+
+static struct samsung_div_clock bus0_div_clks[] __initdata = {
+	/* DIV_BUS0 */
+	DIV(CLK_DIV_PCLK_BUS0_133, "div_pclk_bus0_133", "aclk_bus0_400",
+			DIV_BUS0, 0, 3),
+};
+
+static struct samsung_gate_clock bus0_gate_clks[] __initdata = {
+	/* ENABLE_ACLK_BUS0 */
+	GATE(CLK_ACLK_AHB2APB_BUS0P, "aclk_ahb2apb_bus0p", "div_pclk_bus0_133",
+			ENABLE_ACLK_BUS0, 4, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_BUS0NP_133, "aclk_bus0np_133", "div_pclk_bus0_133",
+			ENABLE_ACLK_BUS0, 2, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_BUS0ND_400, "aclk_bus0nd_400", "aclk_bus0_400",
+			ENABLE_ACLK_BUS0, 0, CLK_IGNORE_UNUSED, 0),
+
+	/* ENABLE_PCLK_BUS0 */
+	GATE(CLK_PCLK_BUS0SRVND_133, "pclk_bus0srvnd_133", "div_pclk_bus0_133",
+			ENABLE_PCLK_BUS0, 2, 0, 0),
+	GATE(CLK_PCLK_PMU_BUS0, "pclk_pmu_bus0", "div_pclk_bus0_133",
+			ENABLE_PCLK_BUS0, 1, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_SYSREG_BUS0, "pclk_sysreg_bus0", "div_pclk_bus0_133",
+			ENABLE_PCLK_BUS0, 0, 0, 0),
+};
+
+static struct samsung_cmu_info bus0_cmu_info __initdata = {
+	.div_clks		= bus0_div_clks,
+	.nr_div_clks		= ARRAY_SIZE(bus0_div_clks),
+	.gate_clks		= bus0_gate_clks,
+	.nr_gate_clks		= ARRAY_SIZE(bus0_gate_clks),
+	.nr_clk_ids		= BUS0_NR_CLK,
+	.clk_regs		= bus0_clk_regs,
+	.nr_clk_regs		= ARRAY_SIZE(bus0_clk_regs),
+};
+
+static void __init exynos5433_cmu_bus0_init(struct device_node *np)
+{
+	samsung_cmu_register_one(np, &bus0_cmu_info);
+}
+CLK_OF_DECLARE(exynos5433_cmu_bus0, "samsung,exynos5433-cmu-bus0",
+		exynos5433_cmu_bus0_init);
+
+/*
+ * Register offset definitions for CMU_BUS1
+ */
+#define DIV_BUS1			0x0600
+#define DIV_STAT_BUS1			0x0700
+#define ENABLE_ACLK_BUS1		0x0800
+#define ENABLE_PCLK_BUS1		0x0900
+#define ENABLE_IP_BUS10			0x0b00
+#define ENABLE_IP_BUS11			0x0b04
+
+static unsigned long bus1_clk_regs[] __initdata = {
+	DIV_BUS1,
+	DIV_STAT_BUS1,
+	ENABLE_ACLK_BUS1,
+	ENABLE_PCLK_BUS1,
+	ENABLE_IP_BUS10,
+	ENABLE_IP_BUS11,
+};
+
+static struct samsung_div_clock bus1_div_clks[] __initdata = {
+	/* DIV_BUS1 */
+	DIV(CLK_DIV_PCLK_BUS1_133, "div_pclk_bus1_133", "aclk_bus1_400",
+			DIV_BUS1, 0, 3),
+};
+
+static struct samsung_gate_clock bus1_gate_clks[] __initdata = {
+	/* ENABLE_ACLK_BUS1 */
+	GATE(CLK_ACLK_AHB2APB_BUS1P, "aclk_ahb2apb_bus1p", "div_pclk_bus1_133",
+			ENABLE_ACLK_BUS1, 4, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_BUS1NP_133, "aclk_bus1np_133", "div_pclk_bus1_133",
+			ENABLE_ACLK_BUS1, 2, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_BUS1ND_400, "aclk_bus1nd_400", "aclk_bus1_400",
+			ENABLE_ACLK_BUS1, 0, CLK_IGNORE_UNUSED, 0),
+
+	/* ENABLE_PCLK_BUS1 */
+	GATE(CLK_PCLK_BUS1SRVND_133, "pclk_bus1srvnd_133", "div_pclk_bus1_133",
+			ENABLE_PCLK_BUS1, 2, 0, 0),
+	GATE(CLK_PCLK_PMU_BUS1, "pclk_pmu_bus1", "div_pclk_bus1_133",
+			ENABLE_PCLK_BUS1, 1, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_SYSREG_BUS1, "pclk_sysreg_bus1", "div_pclk_bus1_133",
+			ENABLE_PCLK_BUS1, 0, 0, 0),
+};
+
+static struct samsung_cmu_info bus1_cmu_info __initdata = {
+	.div_clks		= bus1_div_clks,
+	.nr_div_clks		= ARRAY_SIZE(bus1_div_clks),
+	.gate_clks		= bus1_gate_clks,
+	.nr_gate_clks		= ARRAY_SIZE(bus1_gate_clks),
+	.nr_clk_ids		= BUS1_NR_CLK,
+	.clk_regs		= bus1_clk_regs,
+	.nr_clk_regs		= ARRAY_SIZE(bus1_clk_regs),
+};
+
+static void __init exynos5433_cmu_bus1_init(struct device_node *np)
+{
+	samsung_cmu_register_one(np, &bus1_cmu_info);
+}
+CLK_OF_DECLARE(exynos5433_cmu_bus1, "samsung,exynos5433-cmu-bus1",
+		exynos5433_cmu_bus1_init);
+
+/*
+ * Register offset definitions for CMU_BUS2
+ */
+#define MUX_SEL_BUS2			0x0200
+#define MUX_ENABLE_BUS2			0x0300
+#define MUX_STAT_BUS2			0x0400
+#define DIV_BUS2			0x0600
+#define DIV_STAT_BUS2			0x0700
+#define ENABLE_ACLK_BUS2		0x0800
+#define ENABLE_PCLK_BUS2		0x0900
+#define ENABLE_IP_BUS20			0x0b00
+#define ENABLE_IP_BUS21			0x0b04
+
+static unsigned long bus2_clk_regs[] __initdata = {
+	MUX_SEL_BUS2,
+	MUX_ENABLE_BUS2,
+	MUX_STAT_BUS2,
+	DIV_BUS2,
+	DIV_STAT_BUS2,
+	ENABLE_ACLK_BUS2,
+	ENABLE_PCLK_BUS2,
+	ENABLE_IP_BUS20,
+	ENABLE_IP_BUS21,
+};
+
+/* list of all parent clock list */
+PNAME(mout_aclk_bus2_400_p)	= { "fin_pll", "aclk_bus2_400", };
+
+static struct samsung_mux_clock bus2_mux_clks[] __initdata = {
+	/* MUX_SEL_BUS2 */
+	MUX(CLK_MOUT_ACLK_BUS2_400_USER, "mout_aclk_bus2_400_user",
+			mout_aclk_bus2_400_p, MUX_SEL_BUS2, 0, 1),
+};
+
+static struct samsung_div_clock bus2_div_clks[] __initdata = {
+	/* DIV_BUS2 */
+	DIV(CLK_DIV_PCLK_BUS2_133, "div_pclk_bus2_133",
+			"mout_aclk_bus2_400_user", DIV_BUS2, 0, 3),
+};
+
+static struct samsung_gate_clock bus2_gate_clks[] __initdata = {
+	/* ENABLE_ACLK_BUS2 */
+	GATE(CLK_ACLK_AHB2APB_BUS2P, "aclk_ahb2apb_bus2p", "div_pclk_bus2_133",
+			ENABLE_ACLK_BUS2, 3, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_BUS2NP_133, "aclk_bus2np_133", "div_pclk_bus2_133",
+			ENABLE_ACLK_BUS2, 2, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_BUS2BEND_400, "aclk_bus2bend_400",
+			"mout_aclk_bus2_400_user", ENABLE_ACLK_BUS2,
+			1, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_BUS2RTND_400, "aclk_bus2rtnd_400",
+			"mout_aclk_bus2_400_user", ENABLE_ACLK_BUS2,
+			0, CLK_IGNORE_UNUSED, 0),
+
+	/* ENABLE_PCLK_BUS2 */
+	GATE(CLK_PCLK_BUS2SRVND_133, "pclk_bus2srvnd_133", "div_pclk_bus2_133",
+			ENABLE_PCLK_BUS2, 2, 0, 0),
+	GATE(CLK_PCLK_PMU_BUS2, "pclk_pmu_bus2", "div_pclk_bus2_133",
+			ENABLE_PCLK_BUS2, 1, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_SYSREG_BUS2, "pclk_sysreg_bus2", "div_pclk_bus2_133",
+			ENABLE_PCLK_BUS2, 0, 0, 0),
+};
+
+static struct samsung_cmu_info bus2_cmu_info __initdata = {
+	.mux_clks		= bus2_mux_clks,
+	.nr_mux_clks		= ARRAY_SIZE(bus2_mux_clks),
+	.div_clks		= bus2_div_clks,
+	.nr_div_clks		= ARRAY_SIZE(bus2_div_clks),
+	.gate_clks		= bus2_gate_clks,
+	.nr_gate_clks		= ARRAY_SIZE(bus2_gate_clks),
+	.nr_clk_ids		= BUS2_NR_CLK,
+	.clk_regs		= bus2_clk_regs,
+	.nr_clk_regs		= ARRAY_SIZE(bus2_clk_regs),
+};
+
+static void __init exynos5433_cmu_bus2_init(struct device_node *np)
+{
+	samsung_cmu_register_one(np, &bus2_cmu_info);
+}
+CLK_OF_DECLARE(exynos5433_cmu_bus2, "samsung,exynos5433-cmu-bus2",
+		exynos5433_cmu_bus2_init);
diff --git a/include/dt-bindings/clock/exynos5433.h b/include/dt-bindings/clock/exynos5433.h
index e1c848a..56eb8c8 100644
--- a/include/dt-bindings/clock/exynos5433.h
+++ b/include/dt-bindings/clock/exynos5433.h
@@ -72,7 +72,7 @@
 #define CLK_MOUT_SCLK_HDMI_SPDIF	64
 
 #define CLK_DIV_ACLK_FSYS_200		100
-#define CLK_DIV_ACLK_IMEM_SSSX		101
+#define CLK_DIV_ACLK_IMEM_SSSX_266	101
 #define CLK_DIV_ACLK_IMEM_200		102
 #define CLK_DIV_ACLK_IMEM_266		103
 #define CLK_DIV_ACLK_PERIC_66_B		104
@@ -108,6 +108,9 @@
 #define CLK_DIV_ACLK_MFC_400		134
 #define CLK_DIV_ACLK_G2D_266		135
 #define CLK_DIV_ACLK_G2D_400		136
+#define CLK_DIV_ACLK_G3D_400		137
+#define CLK_DIV_ACLK_BUS0_400		138
+#define CLK_DIV_ACLK_BUS1_400		139
 
 #define CLK_ACLK_PERIC_66		200
 #define CLK_ACLK_PERIS_66		201
@@ -131,8 +134,14 @@
 #define CLK_SCLK_AUDIO0			219
 #define CLK_ACLK_G2D_266		220
 #define CLK_ACLK_G2D_400		221
+#define CLK_ACLK_G3D_400		222
+#define CLK_ACLK_IMEM_SSX_266		223
+#define CLK_ACLK_BUS0_400		224
+#define CLK_ACLK_BUS1_400		225
+#define CLK_ACLK_IMEM_200		226
+#define CLK_ACLK_IMEM_266		227
 
-#define TOP_NR_CLK			222
+#define TOP_NR_CLK			228
 
 /* CMU_CPIF */
 #define CLK_FOUT_MPHY_PLL		1
@@ -680,4 +689,43 @@
 
 #define AUD_NR_CLK					48
 
+/* CMU_BUS0 */
+#define CLK_DIV_PCLK_BUS0_133				1
+
+#define CLK_ACLK_AHB2APB_BUS0P				2
+#define CLK_ACLK_BUS0NP_133				3
+#define CLK_ACLK_BUS0ND_400				4
+#define CLK_PCLK_BUS0SRVND_133				5
+#define CLK_PCLK_PMU_BUS0				6
+#define CLK_PCLK_SYSREG_BUS0				7
+
+#define BUS0_NR_CLK					8
+
+/* CMU_BUS1 */
+#define CLK_DIV_PCLK_BUS1_133				1
+
+#define CLK_ACLK_AHB2APB_BUS1P				2
+#define CLK_ACLK_BUS1NP_133				3
+#define CLK_ACLK_BUS1ND_400				4
+#define CLK_PCLK_BUS1SRVND_133				5
+#define CLK_PCLK_PMU_BUS1				6
+#define CLK_PCLK_SYSREG_BUS1				7
+
+#define BUS1_NR_CLK					8
+
+/* CMU_BUS2 */
+#define CLK_MOUT_ACLK_BUS2_400_USER			1
+
+#define CLK_DIV_PCLK_BUS2_133				2
+
+#define CLK_ACLK_AHB2APB_BUS2P				3
+#define CLK_ACLK_BUS2NP_133				4
+#define CLK_ACLK_BUS2BEND_400				5
+#define CLK_ACLK_BUS2RTND_400				6
+#define CLK_PCLK_BUS2SRVND_133				7
+#define CLK_PCLK_PMU_BUS2				8
+#define CLK_PCLK_SYSREG_BUS2				9
+
+#define BUS2_NR_CLK					10
+
 #endif /* _DT_BINDINGS_CLOCK_EXYNOS5433_H */
-- 
1.8.5.5

