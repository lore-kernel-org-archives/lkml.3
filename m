Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245AbaJVHQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 03:16:08 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:39032 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754175AbaJVHQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 03:16:05 -0400
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
Subject: [PATCH v4 4/8] ARM: DT: STi: STiH407: Add DT node for MiPHY28lp
Date: Wed, 22 Oct 2014 09:14:23 +0200
Message-Id: <1413962067-25557-5-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413962067-25557-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1413962067-25557-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-22_03:2014-10-21,2014-10-22,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MiPHY28lp is a Generic PHY which can serve various SATA, PCIe or
USB3 devices. The two first ports can be use for either; both SATA, both
PCIe or one of each in any configuration.
The Third port is only for USB3.

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
---
 arch/arm/boot/dts/stih407-b2120.dts | 11 +++++++
 arch/arm/boot/dts/stih407.dtsi      | 65 +++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+)

diff --git a/arch/arm/boot/dts/stih407-b2120.dts b/arch/arm/boot/dts/stih407-b2120.dts
index fe69f92..d0837fb 100644
--- a/arch/arm/boot/dts/stih407-b2120.dts
+++ b/arch/arm/boot/dts/stih407-b2120.dts
@@ -74,5 +74,16 @@
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
diff --git a/arch/arm/boot/dts/stih407.dtsi b/arch/arm/boot/dts/stih407.dtsi
index 4f9024f..b8cc9a3 100644
--- a/arch/arm/boot/dts/stih407.dtsi
+++ b/arch/arm/boot/dts/stih407.dtsi
@@ -259,5 +259,70 @@
 
 			status = "disabled";
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
+				      <0x9b04000 0xff>,
+				      <0x114 0x4>, /* sysctrl MiPHY cntrl */
+				      <0x818 0x4>, /* sysctrl MiPHY status*/
+				      <0xe0  0x4>, /* sysctrl PCIe */
+				      <0xec  0x4>; /* sysctrl SATA */
+				reg-names = "sata-up",
+					    "pcie-up",
+					    "pipew",
+					    "miphy-ctrl-glue",
+					    "miphy-status-glue",
+					    "pcie-glue",
+					    "sata-glue";
+				#phy-cells = <1>;
+
+				reset-names = "miphy-sw-rst";
+				resets = <&softreset STIH407_MIPHY0_SOFTRESET>;
+			};
+
+			phy_port1: port@9b2a000 {
+				reg = <0x9b2a000 0xff>,
+				      <0x9b19000 0xff>,
+				      <0x9b14000 0xff>,
+				      <0x118 0x4>,
+				      <0x81c 0x4>,
+				      <0xe4  0x4>,
+				      <0xf0  0x4>;
+				reg-names = "sata-up",
+					    "pcie-up",
+					    "pipew",
+					    "miphy-ctrl-glue",
+					    "miphy-status-glue",
+					    "pcie-glue",
+					    "sata-glue";
+				#phy-cells = <1>;
+
+				reset-names = "miphy-sw-rst";
+				resets = <&softreset STIH407_MIPHY1_SOFTRESET>;
+			};
+
+			phy_port2: port@8f95000 {
+				reg = <0x8f95000 0xff>,
+				      <0x8f90000 0xff>,
+				      <0x11c 0x4>,
+				      <0x820 0x4>;
+				reg-names = "pipew",
+				    "usb3-up",
+				    "miphy-ctrl-glue",
+				    "miphy-status-glue";
+				#phy-cells = <1>;
+
+				reset-names = "miphy-sw-rst";
+				resets = <&softreset STIH407_MIPHY2_SOFTRESET>;
+			};
+		};
 	};
 };
-- 
1.9.1

