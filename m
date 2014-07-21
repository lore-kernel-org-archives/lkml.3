Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445AbaGUN53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 09:57:29 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:63100 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916AbaGUN51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 09:57:27 -0400
X-AuditID: cbfee61a-f79e46d00000134f-8e-53cd1c44838c
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Tomasz Figa <t.figa@samsung.com>, Mark Rutland <mark.rutland@arm.com>,
        Thomas Abraham <ta.omasab@gmail.com>
Subject: [PATCH v2] ARM: dts: add CPU nodes for Exynos4 SoCs
Date: Mon, 21 Jul 2014 15:57:04 +0200
Message-id: <1444042.RbiCcg7JnP@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jQV1XmbPBBts3s1n0LrjKZrHp8TVW
	i8u75rBZzDi/j8nize8X7BZrj9xlt1h6/SKTxfoZr1ksNk/YyObA6bFm3hpGj52z7rJ7bF5S
	79G3ZRWjx+dNcgGsUVw2Kak5mWWpRfp2CVwZR2Z9YipYKVVx9+ZL5gbGNtEuRk4OCQETiecn
	d7FB2GISF+6tB7K5OIQEpjNKfD+5jxkkISTQwiSx/UsAiM0mYCUxsX0VI4gtIqAq8bltATtI
	A7PAXiaJXV82gk0SFrCROHpmI1MXIwcHC1DR+4NVIGFeAU2JNauOgZWICnhK7Ni+kg0iLijx
	Y/I9FhCbWUBeYt/+qawQtpbE+p3HmSYw8s1CUjYLSdksJGULGJlXMYqmFiQXFCel5xrqFSfm
	Fpfmpesl5+duYgSH8TOpHYwrGywOMQpwMCrx8HowngkWYk0sK67MPcQowcGsJMJby3g2WIg3
	JbGyKrUoP76oNCe1+BCjNAeLkjjvgVbrQCGB9MSS1OzU1ILUIpgsEwenVAMjk7HNOiM5xcUS
	9Y1Bl5MM9DjdZq1RUZ/2y6VTfalSN4dVyvkiL9b3/7apJzcvuLUycgEnS02FahdjhkfzjWvl
	f+awxITMt1iTy9cic1XH4LX96j87Djw7sf6oHMuMj7nXuxqfy1Revnr3tEf8JVape6/LlsZO
	1uk8+Wkuz0GmeDnphhTV/DVKLMUZiYZazEXFiQCbIEfBXwIAAA==
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

v2:
- match the unit-address with the reg

 arch/arm/boot/dts/exynos4210.dtsi | 17 +++++++++++++++++
 arch/arm/boot/dts/exynos4212.dtsi | 17 +++++++++++++++++
 arch/arm/boot/dts/exynos4412.dtsi | 29 +++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index ee3001f..bc2b444 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
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
 	sysram@02020000 {
 		compatible = "mmio-sram";
 		reg = <0x02020000 0x20000>;
diff --git a/arch/arm/boot/dts/exynos4212.dtsi b/arch/arm/boot/dts/exynos4212.dtsi
index 3c00e6e..dd0a43e 100644
--- a/arch/arm/boot/dts/exynos4212.dtsi
+++ b/arch/arm/boot/dts/exynos4212.dtsi
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
diff --git a/arch/arm/boot/dts/exynos4412.dtsi b/arch/arm/boot/dts/exynos4412.dtsi
index c42a3e1..435a722 100644
--- a/arch/arm/boot/dts/exynos4412.dtsi
+++ b/arch/arm/boot/dts/exynos4412.dtsi
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
-- 
1.8.2.3


