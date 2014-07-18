Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761887AbaGRQAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 12:00:22 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:65279 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbaGRQAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 12:00:21 -0400
X-AuditID: cbfee61b-f79f86d00000144c-06-53c94492c420
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH] ARM: dts: add CPU nodes for Exynos4 SoCs
Date: Fri, 18 Jul 2014 18:00:02 +0200
Message-id: <1863399.9O2S91ZvEO@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t9jAd3JLieDDVasYLLoXXCVzWLT42us
	Fpd3zWGzmHF+H5PFm98v2C3WHrnLbrF+xmsWB3aPNfPWMHpsXlLv0bdlFaPH501yASxRXDYp
	qTmZZalF+nYJXBn7Ol4zF7yWrOg/0c7YwHhFpIuRk0NCwETi7eFNzBC2mMSFe+vZQGwhgUWM
	EpMbtbsYuYDsFiaJS4d3MIEk2ASsJCa2r2IEsUUEVCU+ty1gByliFnjHKPF3+TV2kISwgKXE
	w5d3WEBsFqCipTNawDbwCmhKXN+5EmyQqICnxI7tK9kg4oISPybfA6tnFpCX2Ld/KiuErSWx
	fudxpgmMfLOQlM1CUjYLSdkCRuZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMGh+kx6B+Oq
	BotDjAIcjEo8vDu0TgYLsSaWFVfmHmKU4GBWEuGdoAEU4k1JrKxKLcqPLyrNSS0+xCjNwaIk
	znuw1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwJhjbSKuNXv6Lbm5U84mzqmafoZDr3j+pI1bdO+d
	3nwnf2Ja/NkV9wvz0yexrzvtJtL5XXX74Y3vGnaIqB7JKI67aTT7aXD7gtfHDOxb/IyrWZ4v
	ufb+opeLVn630o22KOHQdeEFilpfN6VYWn+9mWZwUO66/W32qLkN7BOXnHedrP6G4VSF028l
	luKMREMt5qLiRADdqLrRUQIAAA==
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
Based on next-20140717 branch of linux-next tree +
- [PATCH 2/6] ARM: EXYNOS: Fix core ID used by platsmp and hotplug code
  http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg32811.html
- [PATCH] irqchip: gic: Fix core ID calculation when topology is read from DT
  http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34277.html

 arch/arm/boot/dts/exynos4210.dtsi | 17 +++++++++++++++++
 arch/arm/boot/dts/exynos4212.dtsi | 17 +++++++++++++++++
 arch/arm/boot/dts/exynos4412.dtsi | 29 +++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index ee3001f..b99fc83 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -31,6 +31,23 @@
 		pinctrl2 = &pinctrl_2;
 	};
 
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0x900>;
+		};
+
+		cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0x901>;
+		};
+	};
+
 	sysram@02020000 {
 		compatible = "mmio-sram";
 		reg = <0x02020000 0x20000>;
diff --git a/arch/arm/boot/dts/exynos4212.dtsi b/arch/arm/boot/dts/exynos4212.dtsi
index 3c00e6e..484a2da 100644
--- a/arch/arm/boot/dts/exynos4212.dtsi
+++ b/arch/arm/boot/dts/exynos4212.dtsi
@@ -22,6 +22,23 @@
 / {
 	compatible = "samsung,exynos4212", "samsung,exynos4";
 
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0xA00>;
+		};
+
+		cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0xA01>;
+		};
+	};
+
 	combiner: interrupt-controller@10440000 {
 		samsung,combiner-nr = <18>;
 	};
diff --git a/arch/arm/boot/dts/exynos4412.dtsi b/arch/arm/boot/dts/exynos4412.dtsi
index c42a3e1..89f4743 100644
--- a/arch/arm/boot/dts/exynos4412.dtsi
+++ b/arch/arm/boot/dts/exynos4412.dtsi
@@ -22,6 +22,35 @@
 / {
 	compatible = "samsung,exynos4412", "samsung,exynos4";
 
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0xA00>;
+		};
+
+		cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0xA01>;
+		};
+
+		cpu@2 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0xA02>;
+		};
+
+		cpu@3 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0xA03>;
+		};
+	};
+
 	combiner: interrupt-controller@10440000 {
 		samsung,combiner-nr = <20>;
 	};
-- 
1.8.2.3


