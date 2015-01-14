Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbbANJ47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 04:56:59 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:48882 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753985AbbANJ4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 04:56:54 -0500
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: [PATCH 2/3] ARM: DT: STi: STiH407: Add DT node for MiPHY28lp
Date: Wed, 14 Jan 2015 10:54:58 +0100
Message-Id: <1421229299-8206-3-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421229299-8206-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1421229299-8206-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-14_04:2015-01-14,2015-01-14,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MiPHY28lp is a Generic PHY which can serve various SATA, PCIe or
USB3 devices. The two first ports can be use for either; both SATA, both
PCIe or one of each in any configuration.
The Third port is only for USB3.

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
---
 arch/arm/boot/dts/stih407-family.dtsi | 53 +++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/stihxxx-b2120.dtsi  | 11 ++++++++
 2 files changed, 64 insertions(+)

diff --git a/arch/arm/boot/dts/stih407-family.dtsi b/arch/arm/boot/dts/stih407-family.dtsi
index d4a8f84..c06a546 100644
--- a/arch/arm/boot/dts/stih407-family.dtsi
+++ b/arch/arm/boot/dts/stih407-family.dtsi
@@ -283,5 +283,58 @@
 				 <&picophyreset STIH407_PICOPHY0_RESET>;
 			reset-names = "global", "port";
 		};
+
+		miphy28lp_phy: miphy28lp@9b22000 {
+			compatible = "st,miphy28lp-phy";
+			st,syscfg = <&syscfg_core>;
+			#address-cells	= <1>;
+			#size-cells	= <1>;
+			ranges;
+
+			phy_port0: port@9b22000 {
+				reg = <0x9b22000 0xff>,
+				      <0x9b09000 0xff>,
+				      <0x9b04000 0xff>;
+				reg-names = "sata-up",
+					    "pcie-up",
+					    "pipew";
+
+				st,syscfg = <0x114 0x818 0xe0 0xec>;
+				#phy-cells = <1>;
+
+				reset-names = "miphy-sw-rst";
+				resets = <&softreset STIH407_MIPHY0_SOFTRESET>;
+			};
+
+			phy_port1: port@9b2a000 {
+				reg = <0x9b2a000 0xff>,
+				      <0x9b19000 0xff>,
+				      <0x9b14000 0xff>;
+				reg-names = "sata-up",
+					    "pcie-up",
+					    "pipew";
+
+				st,syscfg = <0x118 0x81c 0xe4 0xf0>;
+
+				#phy-cells = <1>;
+
+				reset-names = "miphy-sw-rst";
+				resets = <&softreset STIH407_MIPHY1_SOFTRESET>;
+			};
+
+			phy_port2: port@8f95000 {
+				reg = <0x8f95000 0xff>,
+				      <0x8f90000 0xff>;
+				reg-names = "pipew",
+					    "usb3-up";
+
+				st,syscfg = <0x11c 0x820>;
+
+				#phy-cells = <1>;
+
+				reset-names = "miphy-sw-rst";
+				resets = <&softreset STIH407_MIPHY2_SOFTRESET>;
+			};
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/stihxxx-b2120.dtsi b/arch/arm/boot/dts/stihxxx-b2120.dtsi
index 0074bd4..8af5282 100644
--- a/arch/arm/boot/dts/stihxxx-b2120.dtsi
+++ b/arch/arm/boot/dts/stihxxx-b2120.dtsi
@@ -55,5 +55,16 @@
 			st,i2c-min-scl-pulse-width-us = <0>;
 			st,i2c-min-sda-pulse-width-us = <5>;
 		};
+
+		miphy28lp_phy: miphy28lp@9b22000 {
+
+			phy_port0: port@9b22000 {
+				st,osc-rdy;
+			};
+
+			phy_port1: port@9b2a000 {
+				st,osc-force-ext;
+			};
+		};
 	};
 };
-- 
1.9.1

