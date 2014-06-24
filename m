Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030229AbaFXQJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:09:56 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:17343 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965173AbaFXQJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 12:09:38 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-95-53a9a2be4759
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Daniel Drake <drake@endlessm.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v2 4/4] ARM: dts: exynos: Update PMU node with CLKOUT related
 data
Date: Tue, 24 Jun 2014 18:08:27 +0200
Message-id: <1403626107-12073-5-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1403626107-12073-1-git-send-email-t.figa@samsung.com>
References: <1403626107-12073-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsVy+t/xK7r7Fq0MNrh/jMNi6sMnbBaP5j9m
	tuhdcJXNYtPja6wWl3fNYbOYcX4fk8XaI3fZLZZev8hk8XTCRTaLRVu/sFtMWXSY1aJ17xF2
	i8Nv2lkt1s94zWKxatcfRgd+jzXz1jB6LPqe5bFz1l12j02rOtk87lzbw+axeUm9R9+WVYwe
	nzfJBXBEcdmkpOZklqUW6dslcGXc3b2WvWC6WMWcM/PZGhivC3UxcnBICJhIPP1e3cXICWSK
	SVy4t56ti5GLQ0hgKaPExMV7GSGcPiaJxwvXsYNUsQmoSXxueMQGYosIqEp8blvADlLELLCA
	RWLjq5lgRcICIRK32vaC2SxARS+evgJr4BVwkriyfg0rxDo5id5tb5hBbE4BZ4lJxw6B1QgB
	1SzfO59xAiPvAkaGVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxghAfx1B+PSY1aHGAU4GJV4
	eCt2rAgWYk0sK67MPcQowcGsJMJr2r0yWIg3JbGyKrUoP76oNCe1+BAjEwenVAMjs8Dp/Yq1
	zGeWpsuV6s6/8tvoqX3c2n8PGV0i3FanT9z0MeO1QaxBqLvVPsE309NtnkYsva6W6VjZKr/u
	/MydjycKZFn1CX/a/6e7quDST0arT18WcCa67P+2UrWl/6Ww83aZg6b/uBvav7wKP8Ld97tH
	SsXsROGC5pjpt/lYg5SYUu61X/+gxFKckWioxVxUnAgAqkK+6z4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends nodes of PMU system controller on Exynos4210, 4x12,
5250 and 5420 SoCs with newly defined properties used by Exynos CLKOUT
driver.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/boot/dts/exynos4210.dtsi | 10 ++++++++++
 arch/arm/boot/dts/exynos4x12.dtsi |  7 +++++++
 arch/arm/boot/dts/exynos5250.dtsi |  3 +++
 arch/arm/boot/dts/exynos5420.dtsi |  3 +++
 4 files changed, 23 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index ee3001f..97ea7a9 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -31,6 +31,16 @@
 		pinctrl2 = &pinctrl_2;
 	};
 
+	pmu_system_controller: system-controller@10020000 {
+		clock-names = "clkout0", "clkout1", "clkout2", "clkout3",
+				"clkout4", "clkout8", "clkout9";
+		clocks = <&clock CLK_OUT_DMC>, <&clock CLK_OUT_TOP>,
+			<&clock CLK_OUT_LEFTBUS>, <&clock CLK_OUT_RIGHTBUS>,
+			<&clock CLK_OUT_CPU>, <&clock CLK_XXTI>,
+			<&clock CLK_XUSBXTI>;
+		#clock-cells = <1>;
+	};
+
 	sysram@02020000 {
 		compatible = "mmio-sram";
 		reg = <0x02020000 0x20000>;
diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index c5a943d..de1f9c7 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -139,6 +139,13 @@
 
 	pmu_system_controller: system-controller@10020000 {
 		compatible = "samsung,exynos4212-pmu", "syscon";
+		clock-names = "clkout0", "clkout1", "clkout2", "clkout3",
+				"clkout4", "clkout8", "clkout9";
+		clocks = <&clock CLK_OUT_DMC>, <&clock CLK_OUT_TOP>,
+			<&clock CLK_OUT_LEFTBUS>, <&clock CLK_OUT_RIGHTBUS>,
+			<&clock CLK_OUT_CPU>, <&clock CLK_XXTI>,
+			<&clock CLK_XUSBXTI>;
+		#clock-cells = <1>;
 	};
 
 	g2d@10800000 {
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 834fb5a..492e1ef 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -191,6 +191,9 @@
 	pmu_system_controller: system-controller@10040000 {
 		compatible = "samsung,exynos5250-pmu", "syscon";
 		reg = <0x10040000 0x5000>;
+		clock-names = "clkout16";
+		clocks = <&clock CLK_FIN_PLL>;
+		#clock-cells = <1>;
 	};
 
 	sysreg_system_controller: syscon@10050000 {
diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index e385322..481beec 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -724,6 +724,9 @@
 	pmu_system_controller: system-controller@10040000 {
 		compatible = "samsung,exynos5420-pmu", "syscon";
 		reg = <0x10040000 0x5000>;
+		clock-names = "clkout16";
+		clocks = <&clock CLK_FIN_PLL>;
+		#clock-cells = <1>;
 	};
 
 	sysreg_system_controller: syscon@10050000 {
-- 
1.9.3

