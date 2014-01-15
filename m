Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaAOJQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 04:16:28 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:23080 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbaAOJPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 04:15:54 -0500
X-AuditID: cbfee690-b7f266d00000287c-9b-52d651c9d47b
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 5/8 v4] clk: samsung: exynos5250/5420: Add gate clock for SSS
 module
Date: Wed, 15 Jan 2014 14:46:06 +0530
Message-id: <1389777366-15147-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389354229-31936-1-git-send-email-ch.naveen@samsung.com>
References: <1389354229-31936-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsWyRsSkTvdk4LUgg8VrTS1eHtK06H4lY9G7
	4Cqbxf17P5ksLu+aw2Yx4/w+JotF2/4zW6za9YfR4uycQ0wOnB47Z91l99h2QNWjb8sqRo/P
	m+QCWKK4bFJSczLLUov07RK4MlZP7GUs+Cde0fjkBlsDY7dIFyMnh4SAicSC/oOsELaYxIV7
	69lAbCGBpYwSm755wtSs+bCIvYuRCyi+iFGiofc/lNPPJPFuxywWkCo2ATOJg4tWs4PYIgLO
	Er+b17CCFDELHGCUWDf9FNBYDg5hgTCJ49vDQWpYBFQlHk89ALaNV8BV4tnSQ8wgJRICChJz
	JtmAhDkF3CRe/t7BDHGQq8SLaTfZIA5axi4x6VwkxBgBiW+TD7FAtMpKbDrADFEiKXFwxQ2W
	CYzCCxgZVjGKphYkFxQnpReZ6BUn5haX5qXrJefnbmIEhvnpf88m7GC8d8D6EGMy0LiJzFKi
	yfnAOMkriTc0NjOyMDUxNTYytzQjTVhJnFftUVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6p
	BsZ5znMfVu75v2F32iP9FRdP9mzQtjEuV1f2d3NZwTL3k8PvN3sbdWaEzVRTvmRkd9nbvvZ6
	As/5V+3cd1VX8fwyY+oX4XCNW3f96cY8ldt/TQ/79C79/3h5f0pgt6B8w8zv380SN6gWFL2f
	yMsXeEjtMlNt0tWcgzqL3N61bNuiEcu7/MH6XZJKLMUZiYZazEXFiQC7A/mDiQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t9jAd2TgdeCDHbO1LV4eUjTovuVjEXv
	gqtsFvfv/WSyuLxrDpvFjPP7mCwWbfvPbLFq1x9Gi7NzDjE5cHrsnHWX3WPbAVWPvi2rGD0+
	b5ILYIlqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvM
	AbpESaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5ixemIvY8E/8YrGJzfY
	Ghi7RboYOTkkBEwk1nxYxA5hi0lcuLeerYuRi0NIYBGjREPvf3YIp59J4t2OWSwgVWwCZhIH
	F60G6xARcJb43byGFaSIWeAAo8S66aeA2jk4hAXCJI5vDwepYRFQlXg89QAbiM0r4CrxbOkh
	ZpASCQEFiTmTbEDCnAJuEi9/72AGsYWASl5Mu8k2gZF3ASPDKkbR1ILkguKk9FwjveLE3OLS
	vHS95PzcTYzgSHomvYNxVYPFIUYBDkYlHt4f4VeDhFgTy4orcw8xSnAwK4nwSvlcCxLiTUms
	rEotyo8vKs1JLT7EmAx01ERmKdHkfGCU55XEGxqbmJsam1qaWJiYWZImrCTOe7DVOlBIID2x
	JDU7NbUgtQhmCxMHp1QDY38Nh6HXM7dFH/jT373u9Hx5tbq14+/r3kc+v87VOTj3GsuLeawN
	c9eZtq3qn9K1RT3ix1rqr88zNI/7561lfEiTVX6RSJhY4U9eVibDxWscSg/OVZSalXHdqbVi
	1o+3JrxH7nz1v8GqWWf21uaRS3Tdi+R+rVWzctY9vyM9R/OUw6UtYVufKbEUZyQaajEXFScC
	AN+RAXLoAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds gating clock for SSS(Security SubSystem)
module on Exynos5250/5420.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
TO: <linux-samsung-soc@vger.kernel.org>
TO: Tomasz Figa <t.figa@samsung.com>
CC: Kukjin Kim <kgene.kim@samsung.com>
CC: <linux-crypto@vger.kernel.org>
---
Changes since v3:
1. Rebased on to https://git.kernel.org/pub/scm/linux/kernel/git/tfiga/samsung-clk.git
2. Added new ID for SSS clock on Exynos5250, with Documentation and 
3. Added gate clocks definitions for SSS on Exynos5420 and Exynos5250

 .../devicetree/bindings/clock/exynos5250-clock.txt |    1 +
 drivers/clk/samsung/clk-exynos5250.c               |    1 +
 drivers/clk/samsung/clk-exynos5420.c               |    4 ++++
 include/dt-bindings/clock/exynos5250.h             |    1 +
 4 files changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/clock/exynos5250-clock.txt b/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
index 492ed09..a845fc6 100644
--- a/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
+++ b/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
@@ -162,6 +162,7 @@ clock which they consume.
   g2d			345
   mdma0			346
   smmu_mdma0		347
+  sss			348
 
 
    [Clock Muxes]
diff --git a/drivers/clk/samsung/clk-exynos5250.c b/drivers/clk/samsung/clk-exynos5250.c
index ff4beeb..2c52fe1 100644
--- a/drivers/clk/samsung/clk-exynos5250.c
+++ b/drivers/clk/samsung/clk-exynos5250.c
@@ -387,6 +387,7 @@ static struct samsung_gate_clock exynos5250_gate_clks[] __initdata = {
 	 * CMU_ACP
 	 */
 	GATE(CLK_MDMA0, "mdma0", "div_aclk266", GATE_IP_ACP, 1, 0, 0),
+	GATE(CLK_SSS, "sss", "div_aclk266", GATE_IP_ACP, 2, 0, 0),
 	GATE(CLK_G2D, "g2d", "div_aclk200", GATE_IP_ACP, 3, 0, 0),
 	GATE(CLK_SMMU_MDMA0, "smmu_mdma0", "div_aclk266", GATE_IP_ACP, 5, 0, 0),
 
diff --git a/drivers/clk/samsung/clk-exynos5420.c b/drivers/clk/samsung/clk-exynos5420.c
index ab4f2f7..94915bb 100644
--- a/drivers/clk/samsung/clk-exynos5420.c
+++ b/drivers/clk/samsung/clk-exynos5420.c
@@ -26,6 +26,7 @@
 #define DIV_CPU1		0x504
 #define GATE_BUS_CPU		0x700
 #define GATE_SCLK_CPU		0x800
+#define GATE_BUS_G2D		0x8700
 #define CPLL_LOCK		0x10020
 #define DPLL_LOCK		0x10030
 #define EPLL_LOCK		0x10040
@@ -702,6 +703,9 @@ static struct samsung_gate_clock exynos5420_gate_clks[] __initdata = {
 		0),
 	GATE(CLK_SMMU_MIXER, "smmu_mixer", "aclk200_disp1", GATE_IP_DISP1, 9, 0,
 		0),
+
+	/* SSS */
+	GATE(CLK_SSS, "sss", "aclk266_g2d", GATE_BUS_G2D, 2, 0, 0),
 };
 
 static struct samsung_pll_clock exynos5420_plls[nr_plls] __initdata = {
diff --git a/include/dt-bindings/clock/exynos5250.h b/include/dt-bindings/clock/exynos5250.h
index 922f2dc..f9b452b 100644
--- a/include/dt-bindings/clock/exynos5250.h
+++ b/include/dt-bindings/clock/exynos5250.h
@@ -150,6 +150,7 @@
 #define CLK_G2D			345
 #define CLK_MDMA0		346
 #define CLK_SMMU_MDMA0		347
+#define CLK_SSS			348
 
 /* mux clocks */
 #define CLK_MOUT_HDMI		1024
-- 
1.7.9.5

