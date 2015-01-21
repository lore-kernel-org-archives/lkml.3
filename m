Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbbAUG1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:27:45 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:62694 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbbAUG1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:27:10 -0500
X-AuditID: cbfee691-f79b86d000004a5a-e6-54bf46b472b5
From: Chanwoo Choi <cw00.choi@samsung.com>
To: s.nawrocki@samsung.com, tomasz.figa@gmail.com
Cc: mturquette@linaro.org, kgene@kernel.org, pankaj.dubey@samsung.com,
        inki.dae@samsung.com, chanho61.park@samsung.com,
        sw0312.kim@samsung.com, cw00.choi@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 09/12] clk: samsung: exynos5433: Add clocks for
 CMU_BUS{0|1|2} domains
Date: Wed, 21 Jan 2015 15:26:58 +0900
Message-id: <1421821618-8627-10-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1421821618-8627-1-git-send-email-cw00.choi@samsung.com>
References: <1421821618-8627-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsWyRsSkRHeL2/4QgwNX5Cz+TjrGbnF5v7bF
	9S/PWS0m3Z/AYtH/+DWzxeVdc9gsZpzfx2TxdMJFNotFW7+wWxx+085qMWPySzaLVbv+MDrw
	ePz+NYnRY+esu+wem1Z1snncubaHzaNvyypGj8+b5ALYorhsUlJzMstSi/TtErgyJp2ayV7w
	Ibri4+2cBsbzvl2MnBwSAiYSvWv2sEHYYhIX7q0Hsrk4hASWMkpM3biTGabo6uJZLBCJRYwS
	b2Y/ZIJwmpgkWs62sYBUsQloSex/cQOonYNDRMBQ4uYhJZAaZoFuJok/C76CrRAWiJY4smIW
	2FQWAVWJGWuvsoPYvAKuEj9vLoI6Q0Fi2fKZrCBzOIHi7beZQEwhAReJc1tKICqOsUssWWsA
	MUVA4tvkQywgJRICshKbDkCdLClxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXmeoVJ+YWl+al6yXn
	525iBMbG6X/PJu5gvH/A+hCjAAejEg/vC8X9IUKsiWXFlbmHGE2BNkxklhJNzgdGYF5JvKGx
	mZGFqYmpsZG5pZmSOK+O9M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYzz76h0q9SxZlW3
	JBZMrHJOCTL9/EM2znaey6yG3l3y09bnb4jfsWm1Y/F/3Qt3IzyCQx+fuvHAc9qzfAVxbYt1
	a9jOP7DS2SzYNiNJ9uWexXu//z31+X266rzWK64P+vkm/Lv3dd7xfquNi69wNVnHa6zSyVyv
	tERB+UCV9q69rUV9tTOnnD+sxFKckWioxVxUnAgASOvp1ogCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t9jAd0tbvtDDBr7RCz+TjrGbnF5v7bF
	9S/PWS0m3Z/AYtH/+DWzxeVdc9gsZpzfx2TxdMJFNotFW7+wWxx+085qMWPySzaLVbv+MDrw
	ePz+NYnRY+esu+wem1Z1snncubaHzaNvyypGj8+b5ALYohoYbTJSE1NSixRS85LzUzLz0m2V
	vIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAjlRSKEvMKQUKBSQWFyvp22GaEBripmsB
	0xih6xsSBNdjZIAGEtYwZkw6NZO94EN0xcfbOQ2M5327GDk5JARMJK4unsUCYYtJXLi3nq2L
	kYtDSGARo8Sb2Q+ZIJwmJomWs21gVWwCWhL7X9wAquLgEBEwlLh5SAmkhlmgm0niz4KvbCA1
	wgLREkdWzGIGsVkEVCVmrL3KDmLzCrhK/Ly5iA1im4LEsuUzWUHmcALF228zgZhCAi4S57aU
	TGDkXcDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOPaeSe1gXNlgcYhRgINRiYf3heL+
	ECHWxLLiytxDjBIczEoivIoSQCHelMTKqtSi/Pii0pzU4kOMpkA3TWSWEk3OB6aFvJJ4Q2MT
	MyNLI3NDCyNjcyVxXiX7thAhgfTEktTs1NSC1CKYPiYOTqkGxqAEGdHYr7E1z6MEDNbdZp7C
	ejOg40rWb9Etjhv0Uh6ZznjJF+eu15hSeHdGZPoqZm45q6pJZ/qX5s06Ivd09/Gvn1ZHzzwt
	siXyZG3mXG3z1y8Xhk6Yfln26GrlTNMpETqP3nQ1bHW+f4bldO72CWuFbvdXHLOfxaISYLRh
	9u0TAu2LFz7jXqfEUpyRaKjFXFScCADOslTE0wIAAA==
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
MHz and used for register accesses.

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 .../devicetree/bindings/clock/exynos5433-clock.txt |  21 +++
 drivers/clk/samsung/clk-exynos5433.c               | 187 +++++++++++++++++++++
 include/dt-bindings/clock/exynos5433.h             |  27 ++-
 3 files changed, 234 insertions(+), 1 deletion(-)

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
index a33ef2e..e79edd7 100644
--- a/drivers/clk/samsung/clk-exynos5433.c
+++ b/drivers/clk/samsung/clk-exynos5433.c
@@ -438,6 +438,14 @@ static struct samsung_div_clock top_div_clks[] __initdata = {
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
@@ -501,6 +509,23 @@ static struct samsung_div_clock top_div_clks[] __initdata = {
 
 static struct samsung_gate_clock top_gate_clks[] __initdata = {
 	/* ENABLE_ACLK_TOP */
+	GATE(CLK_ACLK_G3D_400, "aclk_g3d_400", "div_aclk_g3d_400",
+			ENABLE_ACLK_TOP, 30, 0, 0),
+	GATE(CLK_ACLK_IMEM_SSX_266, "aclk_imem_ssx_266",
+			"div_aclk_imem_sssx_266", ENABLE_ACLK_TOP,
+			29, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_BUS0_400, "aclk_bus0_400", "div_aclk_bus0_400",
+			ENABLE_ACLK_TOP, 26,
+			CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_ACLK_BUS1_400, "aclk_bus1_400", "div_aclk_bus1_400",
+			ENABLE_ACLK_TOP, 25,
+			CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_ACLK_IMEM_200, "aclk_imem_200", "div_aclk_imem_266",
+			ENABLE_ACLK_TOP, 24,
+			CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_ACLK_IMEM_266, "aclk_imem_266", "div_aclk_imem_200",
+			ENABLE_ACLK_TOP, 23,
+			CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0),
 	GATE(CLK_ACLK_PERIC_66, "aclk_peric_66", "div_aclk_peric_66_b",
 			ENABLE_ACLK_TOP, 22,
 			CLK_SET_RATE_PARENT | CLK_IGNORE_UNUSED, 0),
@@ -2631,3 +2656,165 @@ static void __init exynos5433_cmu_aud_init(struct device_node *np)
 }
 CLK_OF_DECLARE(exynos5433_cmu_aud, "samsung,exynos5433-cmu-aud",
 		exynos5433_cmu_aud_init);
+
+
+/*
+ * Register offset definitions for CMU_BUS{0|1|2}
+ */
+#define DIV_BUS				0x0600
+#define DIV_STAT_BUS			0x0700
+#define ENABLE_ACLK_BUS			0x0800
+#define ENABLE_PCLK_BUS			0x0900
+#define ENABLE_IP_BUS0			0x0b00
+#define ENABLE_IP_BUS1			0x0b04
+
+#define MUX_SEL_BUS2			0x0200	/* Only for CMU_BUS2 */
+#define MUX_ENABLE_BUS2			0x0300	/* Only for CMU_BUS2 */
+#define MUX_STAT_BUS2			0x0400	/* Only for CMU_BUS2 */
+
+/* list of all parent clock list */
+PNAME(mout_aclk_bus2_400_p)	= { "fin_pll", "aclk_bus2_400", };
+
+#define CMU_BUS_COMMON_CLK_REGS	\
+	DIV_BUS,		\
+	DIV_STAT_BUS,		\
+	ENABLE_ACLK_BUS,	\
+	ENABLE_PCLK_BUS,	\
+	ENABLE_IP_BUS0,		\
+	ENABLE_IP_BUS1
+
+static unsigned long bus01_clk_regs[] __initdata = {
+	CMU_BUS_COMMON_CLK_REGS,
+};
+
+static unsigned long bus2_clk_regs[] __initdata = {
+	MUX_SEL_BUS2,
+	MUX_ENABLE_BUS2,
+	MUX_STAT_BUS2,
+	CMU_BUS_COMMON_CLK_REGS,
+};
+
+static struct samsung_div_clock bus0_div_clks[] __initdata = {
+	/* DIV_BUS0 */
+	DIV(CLK_DIV_PCLK_BUS_133, "div_pclk_bus0_133", "aclk_bus0_400",
+			DIV_BUS, 0, 3),
+};
+
+/* CMU_BUS0 clocks */
+static struct samsung_gate_clock bus0_gate_clks[] __initdata = {
+	/* ENABLE_ACLK_BUS0 */
+	GATE(CLK_ACLK_AHB2APB_BUSP, "aclk_ahb2apb_bus0p", "div_pclk_bus0_133",
+			ENABLE_ACLK_BUS, 4, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_BUSNP_133, "aclk_bus0np_133", "div_pclk_bus0_133",
+			ENABLE_ACLK_BUS, 2, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_BUSND_400, "aclk_bus0nd_400", "aclk_bus0_400",
+			ENABLE_ACLK_BUS, 0, CLK_IGNORE_UNUSED, 0),
+
+	/* ENABLE_PCLK_BUS0 */
+	GATE(CLK_PCLK_BUSSRVND_133, "pclk_bus0srvnd_133", "div_pclk_bus0_133",
+			ENABLE_PCLK_BUS, 2, 0, 0),
+	GATE(CLK_PCLK_PMU_BUS, "pclk_pmu_bus0", "div_pclk_bus0_133",
+			ENABLE_PCLK_BUS, 1, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_SYSREG_BUS, "pclk_sysreg_bus0", "div_pclk_bus0_133",
+			ENABLE_PCLK_BUS, 0, CLK_IGNORE_UNUSED, 0),
+};
+
+/* CMU_BUS1 clocks */
+static struct samsung_div_clock bus1_div_clks[] __initdata = {
+	/* DIV_BUS1 */
+	DIV(CLK_DIV_PCLK_BUS_133, "div_pclk_bus1_133", "aclk_bus1_400",
+			DIV_BUS, 0, 3),
+};
+
+static struct samsung_gate_clock bus1_gate_clks[] __initdata = {
+	/* ENABLE_ACLK_BUS1 */
+	GATE(CLK_ACLK_AHB2APB_BUSP, "aclk_ahb2apb_bus1p", "div_pclk_bus1_133",
+			ENABLE_ACLK_BUS, 4, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_BUSNP_133, "aclk_bus1np_133", "div_pclk_bus1_133",
+			ENABLE_ACLK_BUS, 2, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_BUSND_400, "aclk_bus1nd_400", "aclk_bus1_400",
+			ENABLE_ACLK_BUS, 0, CLK_IGNORE_UNUSED, 0),
+
+	/* ENABLE_PCLK_BUS1 */
+	GATE(CLK_PCLK_BUSSRVND_133, "pclk_bus1srvnd_133", "div_pclk_bus1_133",
+			ENABLE_PCLK_BUS, 2, 0, 0),
+	GATE(CLK_PCLK_PMU_BUS, "pclk_pmu_bus1", "div_pclk_bus1_133",
+			ENABLE_PCLK_BUS, 1, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_SYSREG_BUS, "pclk_sysreg_bus1", "div_pclk_bus1_133",
+			ENABLE_PCLK_BUS, 0, CLK_IGNORE_UNUSED, 0),
+};
+
+/* CMU_BUS2 clocks */
+static struct samsung_mux_clock bus2_mux_clks[] __initdata = {
+	/* MUX_SEL_BUS2 */
+	MUX(CLK_MOUT_ACLK_BUS2_400_USER, "mout_aclk_bus2_400_user",
+			mout_aclk_bus2_400_p, MUX_SEL_BUS2, 0, 1),
+};
+
+static struct samsung_div_clock bus2_div_clks[] __initdata = {
+	/* DIV_BUS2 */
+	DIV(CLK_DIV_PCLK_BUS_133, "div_pclk_bus2_133",
+			"mout_aclk_bus2_400_user", DIV_BUS, 0, 3),
+};
+
+static struct samsung_gate_clock bus2_gate_clks[] __initdata = {
+	/* ENABLE_ACLK_BUS2 */
+	GATE(CLK_ACLK_AHB2APB_BUSP, "aclk_ahb2apb_bus2p", "div_pclk_bus2_133",
+			ENABLE_ACLK_BUS, 3, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_BUSNP_133, "aclk_bus2np_133", "div_pclk_bus2_133",
+			ENABLE_ACLK_BUS, 2, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_BUS2BEND_400, "aclk_bus2bend_400",
+			"mout_aclk_bus2_400_user", ENABLE_ACLK_BUS,
+			1, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_ACLK_BUS2RTND_400, "aclk_bus2rtnd_400",
+			"mout_aclk_bus2_400_user", ENABLE_ACLK_BUS,
+			0, CLK_IGNORE_UNUSED, 0),
+
+	/* ENABLE_PCLK_BUS2 */
+	GATE(CLK_PCLK_BUSSRVND_133, "pclk_bus2srvnd_133", "div_pclk_bus2_133",
+			ENABLE_PCLK_BUS, 2, 0, 0),
+	GATE(CLK_PCLK_PMU_BUS, "pclk_pmu_bus2", "div_pclk_bus2_133",
+			ENABLE_PCLK_BUS, 1, CLK_IGNORE_UNUSED, 0),
+	GATE(CLK_PCLK_SYSREG_BUS, "pclk_sysreg_bus2", "div_pclk_bus2_133",
+			ENABLE_PCLK_BUS, 0, CLK_IGNORE_UNUSED, 0),
+};
+
+#define CMU_BUS_INFO_CLKS(id)						\
+	.div_clks		= bus##id##_div_clks,			\
+	.nr_div_clks		= ARRAY_SIZE(bus##id##_div_clks),	\
+	.gate_clks		= bus##id##_gate_clks,			\
+	.nr_gate_clks		= ARRAY_SIZE(bus##id##_gate_clks),	\
+	.nr_clk_ids		= BUSx_NR_CLK
+
+static struct samsung_cmu_info bus0_cmu_info __initdata = {
+	CMU_BUS_INFO_CLKS(0),
+	.clk_regs		= bus01_clk_regs,
+	.nr_clk_regs		= ARRAY_SIZE(bus01_clk_regs),
+};
+
+static struct samsung_cmu_info bus1_cmu_info __initdata = {
+	CMU_BUS_INFO_CLKS(1),
+	.clk_regs		= bus01_clk_regs,
+	.nr_clk_regs		= ARRAY_SIZE(bus01_clk_regs),
+};
+
+static struct samsung_cmu_info bus2_cmu_info __initdata = {
+	CMU_BUS_INFO_CLKS(2),
+	.mux_clks		= bus2_mux_clks,
+	.nr_mux_clks		= ARRAY_SIZE(bus2_mux_clks),
+	.clk_regs		= bus2_clk_regs,
+	.nr_clk_regs		= ARRAY_SIZE(bus2_clk_regs),
+};
+
+#define exynos5433_cmu_bus_init(id)					\
+static void __init exynos5433_cmu_bus##id##_init(struct device_node *np)\
+{									\
+	samsung_cmu_register_one(np, &bus##id##_cmu_info);		\
+}									\
+CLK_OF_DECLARE(exynos5433_cmu_bus##id,					\
+		"samsung,exynos5433-cmu-bus"#id,			\
+		exynos5433_cmu_bus##id##_init)
+
+exynos5433_cmu_bus_init(0);
+exynos5433_cmu_bus_init(1);
+exynos5433_cmu_bus_init(2);
diff --git a/include/dt-bindings/clock/exynos5433.h b/include/dt-bindings/clock/exynos5433.h
index 4828e02..6bc7f51 100644
--- a/include/dt-bindings/clock/exynos5433.h
+++ b/include/dt-bindings/clock/exynos5433.h
@@ -107,6 +107,9 @@
 #define CLK_DIV_ACLK_MFC_400		134
 #define CLK_DIV_ACLK_G2D_266		135
 #define CLK_DIV_ACLK_G2D_400		136
+#define CLK_DIV_ACLK_G3D_400		137
+#define CLK_DIV_ACLK_BUS0_400		138
+#define CLK_DIV_ACLK_BUS1_400		139
 
 #define CLK_ACLK_PERIC_66		200
 #define CLK_ACLK_PERIS_66		201
@@ -130,8 +133,14 @@
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
@@ -679,4 +688,20 @@
 
 #define AUD_NR_CLK					48
 
+/* CMU_BUS{0|1|2} */
+#define CLK_DIV_PCLK_BUS_133				1
+
+#define CLK_ACLK_AHB2APB_BUSP				2
+#define CLK_ACLK_BUSNP_133				3
+#define CLK_ACLK_BUSND_400				4
+#define CLK_PCLK_BUSSRVND_133				5
+#define CLK_PCLK_PMU_BUS				6
+#define CLK_PCLK_SYSREG_BUS				7
+
+#define CLK_MOUT_ACLK_BUS2_400_USER			8  /* Only CMU_BUS2 */
+#define CLK_ACLK_BUS2BEND_400				9  /* Only CMU_BUS2 */
+#define CLK_ACLK_BUS2RTND_400				10 /* Only CMU_BUS2 */
+
+#define BUSx_NR_CLK					11
+
 #endif /* _DT_BINDINGS_CLOCK_EXYNOS5433_H */
-- 
1.8.5.5

