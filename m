Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbaIXNJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:09:28 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:15629 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbaIXNJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:09:27 -0400
X-AuditID: cbfee61a-f79c06d000004e71-bc-5422c28469f2
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Thomas Abraham <ta.omasab@gmail.com>
Subject: [PATCH v3] ARM: dts: add CPU nodes for Exynos4 SoCs
Date: Wed, 24 Sep 2014 15:09:19 +0200
Message-id: <5230569.XLlNbB5NvF@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jQd2WQ0ohBvP3aFv0LrjKZrHp8TVW
	i8u75rBZzDi/j8nize8X7BZrj9xlt1h6/SKTxeYJG9ksVu36w+jA6bFm3hpGj52z7rJ7bF5S
	79G3ZRWjx+dNcgGsUVw2Kak5mWWpRfp2CVwZ/X0P2Qo2SlWcXf+QtYFxvmgXIweHhICJxK/n
	cl2MnECmmMSFe+vZuhi5OIQEpjNKPO5+A+W0MEn03z/CCFLFJmAlMbF9FZgtIqAq8bltATtI
	EbPAASaJD0+eM4EkhAVsJN5t7wKzWYCK1l5qBrN5BTQlZi07yAJiiwp4SuzYvpINIi4o8WPy
	PbA4s4C8xL79U1khbC2J9TuPM01g5JuFpGwWkrJZSMoWMDKvYhRNLUguKE5KzzXUK07MLS7N
	S9dLzs/dxAgO5GdSOxhXNlgcYhTgYFTi4XXcpBQixJpYVlyZe4hRgoNZSYRXbT9QiDclsbIq
	tSg/vqg0J7X4EKM0B4uSOO+BVutAIYH0xJLU7NTUgtQimCwTB6dUA6M2y65gu+zQF6u2P+B7
	+/5QeVpRxGq1CSWdqg287w5NaGnMEe5mUJo0Y93nc/wdR7J+VBVnmwkddGBxl71ftVH29Fcp
	bcsvOf8mTWCd9y5z25mMc8tTjKYsLp954X/42uUpeyY9KFuXppCn26PGpGbNcc/x6TH1CFbe
	KrGr1V5KN76HXpbkbFZiKc5INNRiLipOBACeCCMMYAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent patch by Tomasz Figa ("irqchip: gic: Fix core ID calculation
when topology is read from DT") fixed GIC driver to filter cluster ID
from values returned by cpu_logical_map() for SoCs having registers
mapped without per-CPU banking making it is possible to add CPU nodes
for Exynos4 SoCs.  In case of Exynos SoCs these CPU nodes are also
required by future changes adding initialization of cpuidle states in
Exynos cpuidle driver through DT.

Tested on Origen board (Exynos4210 SoC) and Trats2 (Exynos4412 SoC).

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
Based on for-next branch of linux-samsung.git tree.

v3:
- refreshed on top of Kukjin's tree

v2:
- match the unit-address with the reg

 arch/arm/boot/dts/exynos4210.dtsi |   17 +++++++++++++++++
 arch/arm/boot/dts/exynos4212.dtsi |   17 +++++++++++++++++
 arch/arm/boot/dts/exynos4412.dtsi |   29 +++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+)

Index: b/arch/arm/boot/dts/exynos4210.dtsi
===================================================================
--- a/arch/arm/boot/dts/exynos4210.dtsi	2014-09-24 14:38:18.958571829 +0200
+++ b/arch/arm/boot/dts/exynos4210.dtsi	2014-09-24 15:08:14.062510517 +0200
@@ -31,6 +31,23 @@
 		pinctrl2 = &pinctrl_2;
 	};
 
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@900 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0x900>;
+		};
+
+		cpu@901 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0x901>;
+		};
+	};
+
 	pmu_system_controller: system-controller@10020000 {
 		clock-names = "clkout0", "clkout1", "clkout2", "clkout3",
 				"clkout4", "clkout8", "clkout9";
Index: b/arch/arm/boot/dts/exynos4212.dtsi
===================================================================
--- a/arch/arm/boot/dts/exynos4212.dtsi	2014-09-24 14:38:18.954571828 +0200
+++ b/arch/arm/boot/dts/exynos4212.dtsi	2014-09-24 14:43:02.198562156 +0200
@@ -22,6 +22,23 @@
 / {
 	compatible = "samsung,exynos4212", "samsung,exynos4";
 
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@A00 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0xA00>;
+		};
+
+		cpu@A01 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0xA01>;
+		};
+	};
+
 	combiner: interrupt-controller@10440000 {
 		samsung,combiner-nr = <18>;
 	};
Index: b/arch/arm/boot/dts/exynos4412.dtsi
===================================================================
--- a/arch/arm/boot/dts/exynos4412.dtsi	2014-09-24 14:38:18.966571830 +0200
+++ b/arch/arm/boot/dts/exynos4412.dtsi	2014-09-24 14:43:02.198562156 +0200
@@ -22,6 +22,35 @@
 / {
 	compatible = "samsung,exynos4412", "samsung,exynos4";
 
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@A00 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0xA00>;
+		};
+
+		cpu@A01 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0xA01>;
+		};
+
+		cpu@A02 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0xA02>;
+		};
+
+		cpu@A03 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0xA03>;
+		};
+	};
+
 	combiner: interrupt-controller@10440000 {
 		samsung,combiner-nr = <20>;
 	};

