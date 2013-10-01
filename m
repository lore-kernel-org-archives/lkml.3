Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab3JAKkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 06:40:46 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:46381 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752610Ab3JAKj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 06:39:58 -0400
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Wolfram Sang <wsa@the-dreams.de>, srinivas.kandagatla@st.com,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Cc: stephen.gallimore@st.com, stuart.menefy@st.com,
        Lee Jones <lee.jones@linaro.org>, gabriel.fernandez@st.com,
        kernel@stlinux.com, Maxime Coquelin <maxime.coquelin@st.com>
Subject: [PATCH 3/4] ARM: STi: Supply I2C configuration to STiH415 SoC
Date: Tue,  1 Oct 2013 12:39:11 +0200
Message-Id: <1380623952-4252-4-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380623952-4252-1-git-send-email-maxime.coquelin@st.com>
References: <1380623952-4252-1-git-send-email-maxime.coquelin@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch supplies I2C configuration to STiH415 SoC.

Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
---
 arch/arm/boot/dts/stih415-pinctrl.dtsi |   36 ++++++++++++++++++++++
 arch/arm/boot/dts/stih415.dtsi         |   53 ++++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+)

diff --git a/arch/arm/boot/dts/stih415-pinctrl.dtsi b/arch/arm/boot/dts/stih415-pinctrl.dtsi
index 1d322b2..e56449d 100644
--- a/arch/arm/boot/dts/stih415-pinctrl.dtsi
+++ b/arch/arm/boot/dts/stih415-pinctrl.dtsi
@@ -86,6 +86,24 @@
 					};
 				};
 			};
+
+			sbc_i2c0 {
+				pinctrl_sbc_i2c0_default: sbc_i2c0-default {
+					st,pins {
+						sda = <&PIO4 6 ALT1 BIDIR>;
+						scl = <&PIO4 5 ALT1 BIDIR>;
+					};
+				};
+			};
+
+			sbc_i2c1 {
+				pinctrl_sbc_i2c1_default: sbc_i2c1-default {
+					st,pins {
+						sda = <&PIO3 2 ALT2 BIDIR>;
+						scl = <&PIO3 1 ALT2 BIDIR>;
+					};
+				};
+			};
 		};
 
 		pin-controller-front {
@@ -143,6 +161,24 @@
 				reg		= <0x7000 0x100>;
 				st,bank-name	= "PIO12";
 			};
+
+			i2c0 {
+				pinctrl_i2c0_default: i2c0-default {
+					st,pins {
+						sda = <&PIO9 3 ALT1 BIDIR>;
+						scl = <&PIO9 2 ALT1 BIDIR>;
+					};
+				};
+			};
+
+			i2c1 {
+				pinctrl_i2c1_default: i2c1-default {
+					st,pins {
+						sda = <&PIO12 1 ALT1 BIDIR>;
+						scl = <&PIO12 0 ALT1 BIDIR>;
+					};
+				};
+			};
 		};
 
 		pin-controller-rear {
diff --git a/arch/arm/boot/dts/stih415.dtsi b/arch/arm/boot/dts/stih415.dtsi
index 74ab8de..eb4fccb 100644
--- a/arch/arm/boot/dts/stih415.dtsi
+++ b/arch/arm/boot/dts/stih415.dtsi
@@ -9,6 +9,7 @@
 #include "stih41x.dtsi"
 #include "stih415-clock.dtsi"
 #include "stih415-pinctrl.dtsi"
+#include <dt-bindings/interrupt-controller/arm-gic.h>
 / {
 
 	L2: cache-controller {
@@ -83,5 +84,57 @@
 			pinctrl-names 	= "default";
 			pinctrl-0	= <&pinctrl_sbc_serial1>;
 		};
+
+		i2c@fed40000 {
+			compatible	= "st,comms-ssc-i2c";
+			reg		= <0xfed40000 0x110>;
+			interrupts	=  <GIC_SPI 187 IRQ_TYPE_EDGE_RISING>;
+			clocks		= <&CLKS_ICN_REG_0>;
+			clock-names	= "ssc";
+			clock-frequency = <400000>;
+			pinctrl-names	= "default";
+			pinctrl-0	= <&pinctrl_i2c0_default>;
+
+			status		= "disabled";
+		};
+
+		i2c@fed41000 {
+			compatible	= "st,comms-ssc-i2c";
+			reg		= <0xfed41000 0x110>;
+			interrupts	=  <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>;
+			clocks		= <&CLKS_ICN_REG_0>;
+			clock-names	= "ssc";
+			clock-frequency = <400000>;
+			pinctrl-names	= "default";
+			pinctrl-0	= <&pinctrl_i2c1_default>;
+
+			status		= "disabled";
+		};
+
+		i2c@fe540000 {
+			compatible	= "st,comms-ssc-i2c";
+			reg		= <0xfe540000 0x110>;
+			interrupts	=  <GIC_SPI 206 IRQ_TYPE_EDGE_RISING>;
+			clocks		= <&CLK_SYSIN>;
+			clock-names	= "ssc";
+			clock-frequency = <400000>;
+			pinctrl-names	= "default";
+			pinctrl-0	= <&pinctrl_sbc_i2c0_default>;
+
+			status		= "disabled";
+		};
+
+		i2c@fe541000 {
+			compatible	= "st,comms-ssc-i2c";
+			reg		= <0xfe541000 0x110>;
+			interrupts	=  <GIC_SPI 207 IRQ_TYPE_EDGE_RISING>;
+			clocks		= <&CLK_SYSIN>;
+			clock-names	= "ssc";
+			clock-frequency = <400000>;
+			pinctrl-names	= "default";
+			pinctrl-0	= <&pinctrl_sbc_i2c1_default>;
+
+			status		= "disabled";
+		};
 	};
 };
-- 
1.7.9.5

