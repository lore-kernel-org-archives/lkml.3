Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075AbaEORdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:33:00 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:8236 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830AbaEORcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:32:54 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-30-5374fa43f7cf
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Mark Brown <broonie@kernel.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH RFC 4/4] ARM: dts: exynos: Update PMU node with CLKOUT related
 data
Date: Thu, 15 May 2014 19:32:31 +0200
Message-id: <1400175151-27779-5-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1400175151-27779-1-git-send-email-t.figa@samsung.com>
References: <1400175151-27779-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKLMWRmVeSWpSXmKPExsVy+t/xq7rOv0qCDRbd0bCY+vAJm8X8I+dY
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZLH2yF12i6XXLzJZPJ1wkc1i0dYv7BZTFh1mtWjde4Td
	Yv2M1ywWq3b9YbRo/7uXzYHfY828NYweO2fdZffYtKqTzePOtT1sHpuX1Hv0bVnF6PF5k1wA
	exSXTUpqTmZZapG+XQJXxoF7pQX9YhWHZ39lbmA8K9TFyMkhIWAi8e/2HkYIW0ziwr31bF2M
	XBxCAksZJR69+sMOkhAS6GOSeD1XGsRmE1CT+NzwiA3EFhFQlfjctoAdpIFZYBqLxKpl7WAN
	wgKhEkc7frCC2CxARecuXgfawMHBK+Ak8fC+L8QyOYn/L1cwgdicAs4SH5dMYYPY5SRxd28H
	2wRG3gWMDKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQoL2yw7GxcesDjEKcDAq8fB27C8O
	FmJNLCuuzD3EKMHBrCTCa/68JFiINyWxsiq1KD++qDQntfgQIxMHp1QDo/26v51BvD+/Wtxt
	OtTv5slYc9ugKva+4vGPvpcr2M3TJ4ou47Bw/+ad/vL/z9dv5xkcOxEnJF8eUzHn6qNLyufq
	nrw+IrLpsVF9e1nZ7+4+2UaLvFPH1YVO+DO5f4zjyOoyKVew1XWWSRFWqI25Gy/wYVuhjNkP
	xZ75JirHWVRPJSj+WrdZiaU4I9FQi7moOBEAPugZ+jgCAAA=
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
index c4e3df9..a9d9b8c 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -31,6 +31,16 @@
 		pinctrl2 = &pinctrl_2;
 	};
 
+	pmu_system_controller: system-controller@10020000 {
+		#clock-cells = <0>;
+		clock-names = "clkout0", "clkout1", "clkout2", "clkout3",
+				"clkout4", "clkout8", "clkout9";
+		clocks = <&clock CLK_OUT_DMC>, <&clock CLK_OUT_TOP>,
+			<&clock CLK_OUT_LEFTBUS>, <&clock CLK_OUT_RIGHTBUS>,
+			<&clock CLK_OUT_CPU>, <&clock CLK_XXTI>,
+			<&clock CLK_XUSBXTI>;
+	};
+
 	sysram@02020000 {
 		compatible = "mmio-sysram";
 		reg = <0x02020000 0x20000>;
diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index a2889b5..494d296 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -139,6 +139,13 @@
 
 	pmu_system_controller: system-controller@10020000 {
 		compatible = "samsung,exynos4x12-pmu", "syscon";
+		#clock-cells = <0>;
+		clock-names = "clkout0", "clkout1", "clkout2", "clkout3",
+				"clkout4", "clkout5", "clkout8", "clkout9";
+		clocks = <&clock CLK_OUT_DMC>, <&clock CLK_OUT_TOP>,
+			<&clock CLK_OUT_LEFTBUS>, <&clock CLK_OUT_RIGHTBUS>,
+			<&clock CLK_OUT_CPU>, <&clock CLK_OUT_ISP>,
+			<&clock CLK_XXTI>, <&clock CLK_XUSBXTI>;
 	};
 
 	g2d@10800000 {
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index e910253..d0a899c 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -191,6 +191,9 @@
 	pmu_system_controller: system-controller@10040000 {
 		compatible = "samsung,exynos5250-pmu", "syscon";
 		reg = <0x10040000 0x5000>;
+		#clock-cells = <0>;
+		clock-names = "clkout16";
+		clocks = <&clock CLK_FIN_PLL>;
 	};
 
 	watchdog@101D0000 {
diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 0cd65a7..20ee104 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -698,6 +698,9 @@
 	pmu_system_controller: system-controller@10040000 {
 		compatible = "samsung,exynos5420-pmu", "syscon";
 		reg = <0x10040000 0x5000>;
+		#clock-cells = <0>;
+		clock-names = "clkout16";
+		clocks = <&clock CLK_FIN_PLL>;
 	};
 
 	tmu_cpu0: tmu@10060000 {
-- 
1.9.2

