Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724AbaCDT2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:28:10 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:60287 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755605AbaCDT2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:28:07 -0500
From: Georgi Djakov <gdjakov@mm-sol.com>
To: linux-mmc@vger.kernel.org, cjb@laptop.org, ulf.hansson@linaro.org,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v10 1/3] mmc: sdhci-msm: Qualcomm SDHCI binding documentation
Date: Tue,  4 Mar 2014 21:27:04 +0200
Message-Id: <1393961226-25618-2-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393961226-25618-1-git-send-email-gdjakov@mm-sol.com>
References: <1393961226-25618-1-git-send-email-gdjakov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the device-tree binding documentation for
Qualcomm SDHCI driver. It contains the differences between
the core properties in mmc.txt and the properties used by
the sdhci-msm driver.

Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---
 .../devicetree/bindings/mmc/sdhci-msm.txt          |   63 ++++++++++++++++++++
 1 file changed, 63 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mmc/sdhci-msm.txt

diff --git a/Documentation/devicetree/bindings/mmc/sdhci-msm.txt b/Documentation/devicetree/bindings/mmc/sdhci-msm.txt
new file mode 100644
index 0000000..c635c53
--- /dev/null
+++ b/Documentation/devicetree/bindings/mmc/sdhci-msm.txt
@@ -0,0 +1,63 @@
+* Qualcomm SDHCI controller (sdhci-msm)
+
+This file documents differences between the core properties in mmc.txt
+and the properties used by the sdhci-msm driver.
+
+Required properties:
+- compatible: Should contain "qcom,sdhci-msm-v4".
+- reg: Base address and length of the register set listed in reg-names.
+- reg-names: Should contain the following:
+	"hc_mem"   - Host controller register map
+	"core_mem" - SD Core register map
+- interrupts: Should contain an interrupt-specifiers for the interrupts listed in interrupt-names.
+- interrupt-names: Should contain the following:
+	"hc_irq"     - Host controller interrupt
+	"pwr_irq"    - PMIC interrupt
+- vdd-supply: Phandle to the regulator for the vdd (core voltage) supply.
+- vdd-io-supply: Phandle to the regulator for the vdd-io (i/o voltage) supply.
+- pinctrl-names: Should contain only one value - "default".
+- pinctrl-0: Should specify pin control groups used for this controller.
+- clocks: A list of phandle + clock-specifier pairs for the clocks listed in clock-names.
+- clock-names: Should contain the following:
+	"iface" - Main peripheral bus clock (PCLK/HCLK - AHB Bus clock) (required)
+	"core"	- SDC MMC clock (MCLK) (required)
+	"bus"	- SDCC bus voter clock (optional)
+
+Example:
+
+	sdhc_1: sdhci@f9824900 {
+		compatible = "qcom,sdhci-msm-v4";
+		reg = <0xf9824900 0x11c>, <0xf9824000 0x800>;
+		reg-names = "hc_mem", "core_mem";
+		interrupts = <0 123 0>, <0 138 0>;
+		interrupt-names = "hc_irq", "pwr_irq";
+		bus-width = <8>;
+		non-removable;
+
+		vdd-supply = <&pm8941_l20>;
+		vdd-io-supply = <&pm8941_s3>;
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&sdc1_clk &sdc1_cmd &sdc1_data>;
+
+		clocks = <&gcc GCC_SDCC1_APPS_CLK>, <&gcc GCC_SDCC1_AHB_CLK>;
+		clock-names = "core", "iface";
+	};
+
+	sdhc_2: sdhci@f98a4900 {
+		compatible = "qcom,sdhci-msm-v4";
+		reg = <0xf98a4900 0x11c>, <0xf98a4000 0x800>;
+		reg-names = "hc_mem", "core_mem";
+		interrupts = <0 125 0>, <0 221 0>;
+		interrupt-names = "hc_irq", "pwr_irq";
+		bus-width = <4>;
+
+		vdd-supply = <&pm8941_l21>;
+		vdd-io-supply = <&pm8941_l13>;
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&sdc2_clk &sdc2_cmd &sdc2_data>;
+
+		clocks = <&gcc GCC_SDCC2_APPS_CLK>, <&gcc GCC_SDCC2_AHB_CLK>;
+		clock-names = "core", "iface";
+	};
-- 
1.7.9.5

