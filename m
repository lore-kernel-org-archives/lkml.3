Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab3KFQDN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 11:03:13 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:47231 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754982Ab3KFQDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 11:03:09 -0500
From: Georgi Djakov <gdjakov@mm-sol.com>
To: linux-mmc@vger.kernel.org, cjb@laptop.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, subhashj@codeaurora.org,
        Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v7 1/2] mmc: sdhci-msm: Initial SDHCI MSM driver documentation
Date: Wed,  6 Nov 2013 17:56:44 +0200
Message-Id: <1383753405-23631-2-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383753405-23631-1-git-send-email-gdjakov@mm-sol.com>
References: <1383753405-23631-1-git-send-email-gdjakov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds documentation for Qualcomm SDHCI MSM driver.
It contains the differences between the core properties in mmc.txt
and the properties used by the sdhci-msm driver.

Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---
 .../devicetree/bindings/mmc/sdhci-msm.txt          |   92 ++++++++++++++++++++
 1 file changed, 92 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mmc/sdhci-msm.txt

diff --git a/Documentation/devicetree/bindings/mmc/sdhci-msm.txt b/Documentation/devicetree/bindings/mmc/sdhci-msm.txt
new file mode 100644
index 0000000..8f1a52d
--- /dev/null
+++ b/Documentation/devicetree/bindings/mmc/sdhci-msm.txt
@@ -0,0 +1,92 @@
+* Qualcomm SDHCI controller (sdhci-msm)
+
+This file documents differences between the core properties in mmc.txt
+and the properties used by the sdhci-msm driver.
+
+Required properties:
+- compatible: should contain "qcom,sdhci-msm"
+- reg: should contain SDHC, SD Core register map
+- reg-names: indicates various resources passed to driver (via reg proptery) by name
+	"reg-names" examples are "hc_mem" and "core_mem"
+- interrupts: should contain SDHC interrupts
+- interrupt-names: indicates interrupts passed to driver (via interrupts property) by name
+	"interrupt-names" examples are "hc_irq" and "pwr_irq"
+- vdd-supply: phandle to the regulator for the vdd (flash core voltage) supply.
+- vddio-supply: phandle to the regulator for the vdd-io (i/o voltage) supply.
+- pinctrl-names: Should contain only one value - "default".
+- pinctrl-0: Should specify pin control groups used for this controller.
+- clocks: A list of phandle + clock-specifier pairs for the clocks listed in clock-names
+- clock-names: Should contain the following:
+	"iface" - Main peripheral bus clock (PCLK/HCLK - AHB Bus clock) (required)
+	"core"	- SDC MMC clock (MCLK) (required)
+	"bus"	- SDCC bus voter clock (optional)
+
+Optional properties:
+- qcom,bus-speed-mode: specifies the supported bus speed modes by host
+	The supported bus speed modes are:
+	"HS200_1p8v" - indicates that host can support HS200 at 1.8v
+	"HS200_1p2v" - indicates that host can support HS200 at 1.2v
+	"DDR_1p8v" - indicates that host can support DDR mode at 1.8v
+	"DDR_1p2v" - indicates that host can support DDR mode at 1.2v
+
+- qcom,{vdd,vdd-io}-lpm-sup - specifies whether the supply can be kept in low power mode.
+- qcom,{vdd,vdd-io}-voltage-level - specifies voltage levels for the supply.
+	Should be specified in pairs (min, max), units uV.
+- qcom,{vdd,vdd-io}-current-level - specifies load levels for the supply in lpm
+	or high power mode (hpm). Should be specified in pairs (lpm, hpm), units uA.
+
+Example:
+
+	aliases {
+		sdhc1 = &sdhc_1;
+		sdhc2 = &sdhc_2;
+	};
+
+	sdhc_1: qcom,sdhc@f9824900 {
+		compatible = "qcom,sdhci-msm";
+		reg = <0xf9824900 0x11c>, <0xf9824000 0x800>;
+		reg-names = "hc_mem", "core_mem";
+		interrupts = <0 123 0>, <0 138 0>;
+		interrupt-names = "hc_irq", "pwr_irq";
+		bus-width = <8>;
+		non-removable;
+
+		vdd-supply = <&pm8941_l20>;
+		qcom,vdd-io-lpm-sup;
+		qcom,vdd-voltage-level = <2950000 2950000>;
+		qcom,vdd-current-level = <800 500000>;
+
+		vdd-io-supply = <&pm8941_s3>;
+		qcom,vdd-io-voltage-level = <1800000 1800000>;
+		qcom,vdd-io-current-level = <250 154000>;
+		qcom,bus-speed-mode = "HS200_1p8v", "DDR_1p8v";
+
+		pinctrl-names = "default"
+		pinctrl-0 = <&sdc1_clk &sdc1_cmd &sdc1_data>;
+
+		clocks = <&gcc GCC_SDCC1_APPS_CLK>, <&gcc GCC_SDCC1_AHB_CLK>;
+		clock-names = "iface", "core";
+	};
+
+	sdhc_2: sdhci@f98a4900 {
+		compatible = "qcom,sdhci-msm";
+		reg = <0xf98a4900 0x11c>, <0xf98a4000 0x800>;
+		reg-names = "hc_mem", "core_mem";
+		interrupts = <0 125 0>, <0 221 0>;
+		interrupt-names = "hc_irq", "pwr_irq";
+		bus-width = <4>;
+
+		vdd-supply = <&pm8941_l21>;
+		qcom,vdd-voltage-level = <2950000 2950000>;
+		qcom,vdd-current-level = <9000 800000>;
+
+		vdd-io-supply = <&pm8941_l13>;
+		qcom,vdd-io-voltage-level = <1800000 2950000>;
+		qcom,vdd-io-current-level = <6 22000>;
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&sdc2_clk &sdc2_cmd &sdc2_data>;
+
+		clocks = <&gcc GCC_SDCC2_APPS_CLK>, <&gcc GCC_SDCC2_AHB_CLK>;
+		clock-names = "core", "iface";
+	};
-- 
1.7.9.5

