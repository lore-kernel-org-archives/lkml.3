Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab3FXKxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:53:08 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:39361 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab3FXKxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:53:03 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.kachhap@gmail.com, Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH V7 27/30] ARM: dts: thermal: exynos: Add documentation for Exynos SoC thermal bindings
Date: Mon, 24 Jun 2013 16:20:48 +0530
Message-Id: <1372071051-3167-28-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1372071051-3167-1-git-send-email-amit.daniel@samsung.com>
References: <1372071051-3167-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Proper description for Exynos4 bindings added to Documentation/devicetree/
bindings. It adds description to use multiple TMU instances, optional voltage
supply node and optional shared register across multiple TMU's.

Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 .../devicetree/bindings/thermal/exynos-thermal.txt |   55 ++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/thermal/exynos-thermal.txt

diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
new file mode 100644
index 0000000..284f530
--- /dev/null
+++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
@@ -0,0 +1,55 @@
+* Exynos Thermal Management Unit (TMU)
+
+** Required properties:
+
+- compatible : One of the following:
+	       "samsung,exynos4412-tmu"
+	       "samsung,exynos4210-tmu"
+	       "samsung,exynos5250-tmu"
+	       "samsung,exynos5440-tmu"
+- interrupt-parent : The phandle for the interrupt controller
+- reg : Address range of the thermal registers. For soc's which has multiple
+	instances of TMU and some registers are shared across all TMU's like
+	interrupt related then 2 set of register has to supplied. First set
+	belongs	to each instance of TMU and second set belongs to common TMU
+	registers.
+- interrupts : Should contain interrupt for thermal system
+- clocks : The main clock for TMU device
+- clock-names : Thermal system clock name
+- vtmu-supply: This entry is optional and provides the regulator node supplying
+		voltage to TMU. If needed this entry can be placed inside
+		board/platform specific dts file.
+
+Example 1):
+
+	tmu@100C0000 {
+		compatible = "samsung,exynos4412-tmu";
+		interrupt-parent = <&combiner>;
+		reg = <0x100C0000 0x100>;
+		interrupts = <2 4>;
+		clocks = <&clock 383>;
+		clock-names = "tmu_apbif";
+		status = "disabled";
+		vtmu-supply = <&tmu_regulator_node>;
+	};
+
+Example 2):
+
+	tmuctrl_0: tmuctrl@160118 {
+		compatible = "samsung,exynos5440-tmu";
+		reg = <0x160118 0x230>, <0x160368 0x10>;
+		interrupts = <0 58 0>;
+		clocks = <&clock 21>;
+		clock-names = "tmu_apbif";
+	};
+
+Note: For multi-instance tmu each instance should have an alias correctly
+numbered in "aliases" node.
+
+Example:
+
+aliases {
+	tmuctrl0 = &tmuctrl_0;
+	tmuctrl1 = &tmuctrl_1;
+	tmuctrl2 = &tmuctrl_2;
+};
-- 
1.7.1

