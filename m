Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbaBQJpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:45:41 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:29241 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbaBQJpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:45:25 -0500
X-AuditID: cbfee68f-b7f156d00000276c-1b-5301da2a68ed
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, davem@davemloft.net,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 5/9 v7] clk: samsung exynos5250/5420: Add gate clock for SSS
 module
Date: Mon, 17 Feb 2014 15:14:31 +0530
Message-id: <1392630275-8667-6-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392630275-8667-1-git-send-email-ch.naveen@samsung.com>
References: <1392630275-8667-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkWlfrFmOwwcSDChYvD2lazDnfwmLR
	/UrGonfBVTaL+/d+Mllc3jWHzWLG+X1MFou2/We2ODvnEJMDp8eWlTeZPHbOusvuse2Aqkff
	llWMHp83yQWwRnHZpKTmZJalFunbJXBlPPuwhq3gkHjF6u+yDYzXhbsYOTkkBEwk3p7azgph
	i0lcuLeerYuRi0NIYCmjxLn5e9hgin49P80IkVjEKNH/byc7hNPPJLFz23SwdjYBM4mDi1az
	g9giAs4Sv5vXsIIUMQvsY5S41nscLCEsECqx5HgL2FgWAVWJAx/+M4HYvAIuEnd3vGHuYuQA
	WqcgMWeSDUiYU8BVovPOdhYQWwioZF3nJRaQmRICq9gl9uzayg4xR0Di2+RDLBC9shKbDjBD
	XC0pcXDFDZYJjMILGBlWMYqmFiQXFCelFxnrFSfmFpfmpesl5+duYgQG/el/z/p3MN49YH2I
	MRlo3ERmKdHkfGDU5JXEGxqbGVmYmpgaG5lbmpEmrCTOe/9hUpCQQHpiSWp2ampBalF8UWlO
	avEhRiYOTqkGRqeVMXNPT3GUtdEM5P7PpXHovvPpWIb1ShPv9LJy72b4zXT/0/zAG5z91uX5
	r+6rHZFa1nPpz30+0Utf6x6q3q56e1LxmSfr3rxNz9ttWu4fz/136/J94xMnS46wex3ynf1E
	cjOrSWBv/jMXFw9j26xb5+QvuuZmm8Q0X+aIOHfoRrulodSML0osxRmJhlrMRcWJAMLFgm2Q	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jAV2tW4zBBlM+Sli8PKRpMed8C4tF
	9ysZi94FV9ks7t/7yWRxedccNosZ5/cxWSza9p/Z4uycQ0wOnB5bVt5k8tg56y67x7YDqh59
	W1YxenzeJBfAGtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+Ti
	E6DrlpkDdI6SQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMePZhzVsBYfE
	K1Z/l21gvC7cxcjJISFgIvHr+WlGCFtM4sK99WxdjFwcQgKLGCX6/+1kh3D6mSR2bpvOClLF
	JmAmcXDRanYQW0TAWeJ38xpWkCJmgX2MEtd6j4MlhAVCJZYcb2EDsVkEVCUOfPjPBGLzCrhI
	3N3xhrmLkQNonYLEnEk2IGFOAVeJzjvbWUBsIaCSdZ2XWCYw8i5gZFjFKJpakFxQnJSea6hX
	nJhbXJqXrpecn7uJERxTz6R2MK5ssDjEKMDBqMTDa1DNGCzEmlhWXJl7iFGCg1lJhNd2HVCI
	NyWxsiq1KD++qDQntfgQYzLQUROZpUST84HxnlcSb2hsYm5qbGppYmFiZkmasJI474FW60Ah
	gfTEktTs1NSC1CKYLUwcnFINjH6dOxh2vJq+7pr05yn3b5sw7TDkT+1IvmVwSv72/WnKXi7l
	vQcWHC89/8fsbHFNLsuG20c1TianW7W7HJyjdXH1nF3urKVnRDIfLY7K2zNFnaMpOLU+44z3
	yYOJYn99BXiL6qZJN+xYk9pl+MnNr+vet53ObprXV+YuVWTSNVyhcOzKrcClwUosxRmJhlrM
	RcWJAHeTexvtAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds gating clock for SSS(Security SubSystem)
module on Exynos5250/5420.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
TO: <linux-samsung-soc@vger.kernel.org>
TO: Tomasz Figa <t.figa@samsung.com>
CC: David S. Miller <davem@davemloft.net>
CC: Kukjin Kim <kgene.kim@samsung.com>
CC: <linux-crypto@vger.kernel.org>
---
changes since v6:
None
changes since v5:
1. Added Reviewed-by: Tomasz Figa <t.figa@samsung.com>

 .../devicetree/bindings/clock/exynos5250-clock.txt |    1 +
 drivers/clk/samsung/clk-exynos5250.c               |    1 +
 drivers/clk/samsung/clk-exynos5420.c               |    4 ++++
 include/dt-bindings/clock/exynos5250.h             |    1 +
 4 files changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/clock/exynos5250-clock.txt b/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
index 72ce617..87f1539 100644
--- a/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
+++ b/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
@@ -162,6 +162,7 @@ clock which they consume.
   g2d			345
   mdma0			346
   smmu_mdma0		347
+  sss			348
 
 
    [Clock Muxes]
diff --git a/drivers/clk/samsung/clk-exynos5250.c b/drivers/clk/samsung/clk-exynos5250.c
index e7ee442..d1d16cf 100644
--- a/drivers/clk/samsung/clk-exynos5250.c
+++ b/drivers/clk/samsung/clk-exynos5250.c
@@ -428,6 +428,7 @@ static struct samsung_gate_clock exynos5250_gate_clks[] __initdata = {
 	 * CMU_ACP
 	 */
 	GATE(CLK_MDMA0, "mdma0", "div_aclk266", GATE_IP_ACP, 1, 0, 0),
+	GATE(CLK_SSS, "sss", "div_aclk266", GATE_IP_ACP, 2, 0, 0),
 	GATE(CLK_G2D, "g2d", "div_aclk200", GATE_IP_ACP, 3, 0, 0),
 	GATE(CLK_SMMU_MDMA0, "smmu_mdma0", "div_aclk266", GATE_IP_ACP, 5, 0, 0),
 
diff --git a/drivers/clk/samsung/clk-exynos5420.c b/drivers/clk/samsung/clk-exynos5420.c
index 60b2681..35311e1 100644
--- a/drivers/clk/samsung/clk-exynos5420.c
+++ b/drivers/clk/samsung/clk-exynos5420.c
@@ -27,6 +27,7 @@
 #define DIV_CPU1		0x504
 #define GATE_BUS_CPU		0x700
 #define GATE_SCLK_CPU		0x800
+#define GATE_IP_G2D		0x8800
 #define CPLL_LOCK		0x10020
 #define DPLL_LOCK		0x10030
 #define EPLL_LOCK		0x10040
@@ -743,6 +744,9 @@ static struct samsung_gate_clock exynos5420_gate_clks[] __initdata = {
 		0),
 	GATE(CLK_SMMU_MIXER, "smmu_mixer", "aclk200_disp1", GATE_IP_DISP1, 9, 0,
 		0),
+
+	/* SSS */
+	GATE(CLK_SSS, "sss", "aclk266_g2d", GATE_IP_G2D, 2, 0, 0),
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

