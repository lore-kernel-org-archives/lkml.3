Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab3I0Q5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:57:17 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:33382 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004Ab3I0Q5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:57:11 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: linux-mmc@vger.kernel.org
Cc: cjb@laptop.org, grant.likely@linaro.org, rob.herring@calxeda.com,
        devicetree@vger.kernel.org, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v6 1/2] mmc: sdhci-msm: Initial SDHCI MSM driver documentation
Date: Fri, 27 Sep 2013 19:57:20 +0300
Message-Id: <1380301041-26405-2-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380301041-26405-1-git-send-email-gdjakov@mm-sol.com>
References: <1380301041-26405-1-git-send-email-gdjakov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds documentation for Qualcomm SDHCI MSM driver.
It contains the differences between the core properties in mmc.txt and
the properties used by the sdhci-msm driver.

Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---
 .../devicetree/bindings/mmc/sdhci-msm.txt          |   70 ++++++++++++++++++++
 1 file changed, 70 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mmc/sdhci-msm.txt

diff --git a/Documentation/devicetree/bindings/mmc/sdhci-msm.txt b/Documentation/devicetree/bindings/mmc/sdhci-msm.txt
new file mode 100644
index 0000000..81dd221
--- /dev/null
+++ b/Documentation/devicetree/bindings/mmc/sdhci-msm.txt
@@ -0,0 +1,70 @@
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
+	The supported bus speed modes are :
+	"HS200_1p8v" - indicates that host can support HS200 at 1.8v
+	"HS200_1p2v" - indicates that host can support HS200 at 1.2v
+	"DDR_1p8v" - indicates that host can support DDR mode at 1.8v
+	"DDR_1p2v" - indicates that host can support DDR mode at 1.2v
+
+- qcom,{vdd,vddio}-always-on - specifies whether the supply should be kept "on" always.
+- qcom,{vdd,vddio}-lpm-sup - specifies whether the supply can be kept in low power mode.
+- qcom,{vdd,vddio}-voltage-level - specifies voltage levels for the supply.
+	Should be specified in pairs (min, max), units uV.
+- qcom,{vdd,vddio}-current-level - specifies load levels for the supply in lpm
+	or high power mode (hpm). Should be specified in pairs (lpm, hpm), units uA.
+
+Example:
+
+	aliases {
+		sdhc1 = &sdhc_1;
+	};
+
+	sdhc_1: qcom,sdhc@f9824900 {
+		compatible = "qcom,sdhci-msm";
+		reg = <0xf9824900 0x11c>, <0xf9824000 0x800>;
+		reg-names = "hc_mem", "core_mem";
+		interrupts = <0 123 0>, <0 138 0>;
+		interrupt-names = "hc_irq", "pwr_irq";
+		bus-width = <4>;
+		non-removable;
+
+		vdd-supply = <&pm8941_l21>;
+		vddio-supply = <&pm8941_l13>;
+		qcom,vdd-voltage-level = <2950000 2950000>;
+		qcom,vdd-current-level = <9000 800000>;
+		qcom,vddio-always-on;
+		qcom,vddio-lpm-sup;
+		qcom,vddio-voltage-level = <1800000 2950000>;
+		qcom,vddio-current-level = <6 22000>;
+		qcom,bus-speed-mode = "HS200_1p8v", "DDR_1p8v";
+
+		pinctrl-names = "default"
+		pinctrl-0 = <&sdc1_clk &sdc1_cmd &sdc1_data>;
+
+		clocks = <&iface>, <&core>, <&bus>;
+		clock-names = "iface", "core", "bus";
+
+	};
-- 
1.7.9.5

