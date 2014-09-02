Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbaIBPnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:43:13 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:39228 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628AbaIBPnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:43:09 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: galak@codeaurora.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        iivanov@mm-sol.com, Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v2 3/3] ARM: dts: qcom: Add SDHC nodes for APQ8084 platform
Date: Tue,  2 Sep 2014 18:40:43 +0300
Message-Id: <1409672443-4289-4-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409672443-4289-1-git-send-email-gdjakov@mm-sol.com>
References: <1409672443-4289-1-git-send-email-gdjakov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable support for the two SD host controllers on the APQ8084 platform
by adding the required nodes to the DT files.
On the IFC6540 board, the first controller is connected to the onboard
eMMC and the second is connected to a micro-SD card slot.

Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---
 arch/arm/boot/dts/qcom-apq8084-ifc6540.dts |   11 +++++++++++
 arch/arm/boot/dts/qcom-apq8084.dtsi        |   23 +++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts b/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts
index e41cb8a..c9ff108 100644
--- a/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts
+++ b/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts
@@ -8,5 +8,16 @@
 		serial@f995e000 {
 			status = "okay";
 		};
+
+		sdhci@f9824900 {
+			bus-width = <8>;
+			non-removable;
+			status = "okay";
+		};
+
+		sdhci@f98a4900 {
+			cd-gpios = <&tlmm 122 GPIO_ACTIVE_LOW>;
+			bus-width = <4>;
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/qcom-apq8084.dtsi b/arch/arm/boot/dts/qcom-apq8084.dtsi
index 21d01e5..1f130bc 100644
--- a/arch/arm/boot/dts/qcom-apq8084.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8084.dtsi
@@ -3,6 +3,7 @@
 #include "skeleton.dtsi"
 
 #include <dt-bindings/clock/qcom,gcc-apq8084.h>
+#include <dt-bindings/gpio/gpio.h>
 
 / {
 	model = "Qualcomm APQ 8084";
@@ -203,5 +204,27 @@
 			clock-names = "core", "iface";
 			status = "disabled";
 		};
+
+		sdhci@f9824900 {
+			compatible = "qcom,sdhci-msm-v4";
+			reg = <0xf9824900 0x11c>, <0xf9824000 0x800>;
+			reg-names = "hc_mem", "core_mem";
+			interrupts = <0 123 0>, <0 138 0>;
+			interrupt-names = "hc_irq", "pwr_irq";
+			clocks = <&gcc GCC_SDCC1_APPS_CLK>, <&gcc GCC_SDCC1_AHB_CLK>;
+			clock-names = "core", "iface";
+			status = "disabled";
+		};
+
+		sdhci@f98a4900 {
+			compatible = "qcom,sdhci-msm-v4";
+			reg = <0xf98a4900 0x11c>, <0xf98a4000 0x800>;
+			reg-names = "hc_mem", "core_mem";
+			interrupts = <0 125 0>, <0 221 0>;
+			interrupt-names = "hc_irq", "pwr_irq";
+			clocks = <&gcc GCC_SDCC2_APPS_CLK>, <&gcc GCC_SDCC2_AHB_CLK>;
+			clock-names = "core", "iface";
+			status = "disabled";
+		};
 	};
 };
-- 
1.7.9.5

