Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbaA2Jdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:33:46 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16340 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbaA2JYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:24:13 -0500
X-AuditID: cbfee68e-b7f566d000002344-66-52e8c8bc9924
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 5/9 v5] clk: samsung exynos5250/5420: Add gate clock for SSS
 module
Date: Wed, 29 Jan 2014 14:54:06 +0530
Message-id: <1390987446-18784-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389354229-31936-1-git-send-email-ch.naveen@samsung.com>
References: <1389354229-31936-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWyRsSkWnfPiRdBBp0nNSxeHtK0mH/kHKtF
	9ysZi94FV9ks7t/7yWRxedccNosZ5/cxWSza9p/Z4uycQ0wOnB47Z91l99h2QNWjb8sqRo/P
	m+QCWKK4bFJSczLLUov07RK4Mm7Nv8BccE6i4t+T+WwNjBdEuhg5OSQETCR2ndvICmGLSVy4
	t56ti5GLQ0hgKaPEk+3fmWGK3n88wQqRmM4o8fxRN1hCSKCfSeLgPGUQm03ATOLgotXsILaI
	gLPE7+Y1YA3MAkcZJS7vPgSWEBYIlXjWAGGzCKhKnH17A2w1r4CrxNJpH4BsDqBtChJzJtmA
	hDkF3CRe/t4BtctV4sW0m2DXSQgsYpe40fGZCWKOgMS3yYdYIHplJTYdgDpaUuLgihssExiF
	FzAyrGIUTS1ILihOSi8y0itOzC0uzUvXS87P3cQIDPXT/5717WC8ecD6EGMy0LiJzFKiyfnA
	WMkriTc0NjOyMDUxNTYytzQjTVhJnHfRw6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYzT
	zE5cmH2EIfese0iDkmG/V55OSF3xy072c7prrPduknJL4Nmne4pHYPn32Zv2cT9Qv+Tl3HKv
	2DtRsvnBseYi6c2TXNeH5LYzbs9a8lDl9cmn1sfYSiI5Srz/fLbKvNvFfZCpaueVzobkeT5P
	A5bLP8m7oSx6qqu0rk98zpqZM09ubrzH5q7EUpyRaKjFXFScCAB34BlgiwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t9jQd09J14EGeyZoGjx8pCmxfwj51gt
	ul/JWPQuuMpmcf/eTyaLy7vmsFnMOL+PyWLRtv/MFmfnHGJy4PTYOesuu8e2A6oefVtWMXp8
	3iQXwBLVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZ
	A3SJkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHj1vwLzAXnJCr+PZnP
	1sB4QaSLkZNDQsBE4v3HE6wQtpjEhXvr2boYuTiEBKYzSjx/1M0MkhAS6GeSODhPGcRmEzCT
	OLhoNTuILSLgLPG7eQ0rSAOzwFFGicu7D4ElhAVCJZ41QNgsAqoSZ9/eANvAK+AqsXTaByCb
	A2ibgsScSTYgYU4BN4mXv3dA7XKVeDHtJtsERt4FjAyrGEVTC5ILipPScw31ihNzi0vz0vWS
	83M3MYIj6ZnUDsaVDRaHGAU4GJV4eFdcfB4kxJpYVlyZe4hRgoNZSYT3xKYXQUK8KYmVValF
	+fFFpTmpxYcYk4GOmsgsJZqcD4zyvJJ4Q2MTc1NjU0sTCxMzS9KElcR5D7RaBwoJpCeWpGan
	phakFsFsYeLglGpgrN231NhS2mSl9XKHWzoXb0WsuVGvEb71tpbVml8zt5Tsb3oyfdnKs1uc
	Taq3OWolzNeeZX9UtzhCOon9f9A51jeCe47MVj6sYV2jOettmO1bho5Hnl6NwrfvV0efXSrn
	o3BOWHLLWjtrg93hP1bJMBTnbrO79HrPk5768toHwbN1c5V4zjz9r8RSnJFoqMVcVJwIAJJf
	dSzoAgAA
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
Changes since v4:
Use register GATE_IP_G2D instead of GATE_BUS_G2D for Exynos5420
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
index ab4f2f7..c93d4d5 100644
--- a/drivers/clk/samsung/clk-exynos5420.c
+++ b/drivers/clk/samsung/clk-exynos5420.c
@@ -26,6 +26,7 @@
 #define DIV_CPU1		0x504
 #define GATE_BUS_CPU		0x700
 #define GATE_SCLK_CPU		0x800
+#define GATE_IP_G2D		0x8800
 #define CPLL_LOCK		0x10020
 #define DPLL_LOCK		0x10030
 #define EPLL_LOCK		0x10040
@@ -702,6 +703,9 @@ static struct samsung_gate_clock exynos5420_gate_clks[] __initdata = {
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

