Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418AbaICQuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 12:50:55 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:33511 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756292AbaICQux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 12:50:53 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: galak@codeaurora.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        iivanov@mm-sol.com, Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v3] ARM: dts: qcom: Add initial IFC6540 board device tree
Date: Wed,  3 Sep 2014 19:50:31 +0300
Message-Id: <1409763031-16873-1-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add basic support for the IFC6540 single-board computer boards, that are
based on the APQ8084 SoC. This patch adds the initial device tree and the
neccessary nodes required for enabling the serial port and eMMC.

Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---
Changes since v2:
 - Squashed all patches into one. (suggested by Kumar Gala)

Changes since v1:
 - This time add linux-arm-msm list to the CC.
 - Include a third patch for enabling the eMMC.

 arch/arm/boot/dts/Makefile                 |    1 +
 arch/arm/boot/dts/qcom-apq8084-ifc6540.dts |   23 +++++++++++++++++++++++
 arch/arm/boot/dts/qcom-apq8084.dtsi        |   23 +++++++++++++++++++++++
 3 files changed, 47 insertions(+)
 create mode 100644 arch/arm/boot/dts/qcom-apq8084-ifc6540.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index b022972..df8453a 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -345,6 +345,7 @@ dtb-$(CONFIG_ARCH_PRIMA2) += prima2-evb.dtb
 dtb-$(CONFIG_ARCH_QCOM) += \
 	qcom-apq8064-ifc6410.dtb \
 	qcom-apq8074-dragonboard.dtb \
+	qcom-apq8084-ifc6540.dtb \
 	qcom-apq8084-mtp.dtb \
 	qcom-msm8660-surf.dtb \
 	qcom-msm8960-cdp.dtb
diff --git a/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts b/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts
new file mode 100644
index 0000000..c9ff108
--- /dev/null
+++ b/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts
@@ -0,0 +1,23 @@
+#include "qcom-apq8084.dtsi"
+
+/ {
+	model = "Qualcomm APQ8084/IFC6540";
+	compatible = "qcom,apq8084-ifc6540", "qcom,apq8084";
+
+	soc {
+		serial@f995e000 {
+			status = "okay";
+		};
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
+	};
+};
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

