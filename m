Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbaCDQmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:42:47 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:43025 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369AbaCDQmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:42:42 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-i2c@vger.kernel.org, Harini Katakam <harinik@xilinx.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v2 2/2] ARM: zynq: dt: Add I2C nodes to Zynq device tree
Date: Tue,  4 Mar 2014 08:42:29 -0800
Message-Id: <1393951349-24548-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.0.1.g4196000
In-Reply-To: <1393951349-24548-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1393951349-24548-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
v2:
 - replace 'pmbus' with 'ti' in compatibility strings of UCD devices
---
 arch/arm/boot/dts/zynq-7000.dtsi | 22 ++++++++++++
 arch/arm/boot/dts/zynq-zc702.dts | 76 ++++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/zynq-zc706.dts | 68 +++++++++++++++++++++++++++++++++++
 3 files changed, 166 insertions(+)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index 8b67b19392ec..fb1e1e7cae8f 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -48,6 +48,28 @@
 		interrupt-parent = <&intc>;
 		ranges;
 
+		i2c0: zynq-i2c@e0004000 {
+			compatible = "cdns,i2c-r1p10";
+			status = "disabled";
+			clocks = <&clkc 38>;
+			interrupt-parent = <&intc>;
+			interrupts = <0 25 4>;
+			reg = <0xE0004000 0x1000>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		i2c1: zynq-i2c@e0005000 {
+			compatible = "cdns,i2c-r1p10";
+			status = "disabled";
+			clocks = <&clkc 39>;
+			interrupt-parent = <&intc>;
+			interrupts = <0 48 4>;
+			reg = <0xE0005000 0x1000>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
 		intc: interrupt-controller@f8f01000 {
 			compatible = "arm,cortex-a9-gic";
 			#interrupt-cells = <3>;
diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-zc702.dts
index c913f77a21eb..5e09cee33d42 100644
--- a/arch/arm/boot/dts/zynq-zc702.dts
+++ b/arch/arm/boot/dts/zynq-zc702.dts
@@ -34,6 +34,82 @@
 	phy-mode = "rgmii";
 };
 
+&i2c0 {
+	status = "okay";
+	clock-frequency = <400000>;
+
+	i2cswitch@74 {
+		compatible = "nxp,pca9548";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		reg = <0x74>;
+
+		i2c@0 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0>;
+			si570: clock-generator@5d {
+				#clock-cells = <0>;
+				compatible = "silabs,si570";
+				temperature-stability = <50>;
+				reg = <0x5d>;
+				factory-fout = <156250000>;
+				clock-frequency = <148500000>;
+			};
+		};
+
+		i2c@2 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <2>;
+			eeprom@54 {
+				compatible = "at,24c08";
+				reg = <0x54>;
+			};
+		};
+
+		i2c@3 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <3>;
+			gpio@21 {
+				compatible = "ti,tca6416";
+				reg = <0x21>;
+				gpio-controller;
+				#gpio-cells = <2>;
+			};
+		};
+
+		i2c@4 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <4>;
+			rtc@51 {
+				compatible = "nxp,pcf8563";
+				reg = <0x51>;
+			};
+		};
+
+		i2c@7 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <7>;
+			hwmon@52 {
+				compatible = "ti,ucd9248";
+				reg = <52>;
+			};
+			hwmon@53 {
+				compatible = "ti,ucd9248";
+				reg = <53>;
+			};
+			hwmon@54 {
+				compatible = "ti,ucd9248";
+				reg = <54>;
+			};
+		};
+	};
+};
+
 &sdhci0 {
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/zynq-zc706.dts b/arch/arm/boot/dts/zynq-zc706.dts
index 88f62c50382e..4cc9913078cd 100644
--- a/arch/arm/boot/dts/zynq-zc706.dts
+++ b/arch/arm/boot/dts/zynq-zc706.dts
@@ -35,6 +35,74 @@
 	phy-mode = "rgmii";
 };
 
+&i2c0 {
+	status = "okay";
+	clock-frequency = <400000>;
+
+	i2cswitch@74 {
+		compatible = "nxp,pca9548";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		reg = <0x74>;
+
+		i2c@0 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0>;
+			si570: clock-generator@5d {
+				#clock-cells = <0>;
+				compatible = "silabs,si570";
+				temperature-stability = <50>;
+				reg = <0x5d>;
+				factory-fout = <156250000>;
+				clock-frequency = <148500000>;
+			};
+		};
+
+		i2c@2 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <2>;
+			eeprom@54 {
+				compatible = "at,24c08";
+				reg = <0x54>;
+			};
+		};
+
+		i2c@3 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <3>;
+			gpio@21 {
+				compatible = "ti,tca6416";
+				reg = <0x21>;
+				gpio-controller;
+				#gpio-cells = <2>;
+			};
+		};
+
+		i2c@4 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <4>;
+			rtc@51 {
+				compatible = "nxp,pcf8563";
+				reg = <0x51>;
+			};
+		};
+
+		i2c@7 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <7>;
+			ucd90120@65 {
+				compatible = "ti,ucd90120";
+				reg = <0x65>;
+			};
+		};
+	};
+};
+
 &sdhci0 {
 	status = "okay";
 };
-- 
1.9.0.1.g4196000

