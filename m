Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbaBYLm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:42:28 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:32937 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbaBYLlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:41:50 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, DCG_UPD_stlinux_kernel@list.st.com,
        devicetree@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: [PATCH v2 2/3] ARM: DT: STi: Add DT node for ST's SATA device
Date: Tue, 25 Feb 2014 11:41:20 +0000
Message-Id: <1393328481-7251-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393328481-7251-1-git-send-email-lee.jones@linaro.org>
References: <1393328481-7251-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: devicetree@vger.kernel.org
Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Acked-by: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih416-b2020-revE.dts |  4 ++++
 arch/arm/boot/dts/stih416-b2020.dts      |  4 ++++
 arch/arm/boot/dts/stih416.dtsi           | 16 ++++++++++++++++
 3 files changed, 24 insertions(+)

diff --git a/arch/arm/boot/dts/stih416-b2020-revE.dts b/arch/arm/boot/dts/stih416-b2020-revE.dts
index 693d0ec..7350a86 100644
--- a/arch/arm/boot/dts/stih416-b2020-revE.dts
+++ b/arch/arm/boot/dts/stih416-b2020-revE.dts
@@ -37,5 +37,9 @@
 			st,pcie-tx-pol-inv;
 			st,sata-gen = <3>;
 		};
+
+		sata0: sata@fe380000{
+			status = "okay";
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/stih416-b2020.dts b/arch/arm/boot/dts/stih416-b2020.dts
index fd9cbad..ebd784b 100644
--- a/arch/arm/boot/dts/stih416-b2020.dts
+++ b/arch/arm/boot/dts/stih416-b2020.dts
@@ -18,5 +18,9 @@
 			st,pcie_tx_pol_inv = <1>;
 			st,sata_gen = "gen3";
 		};
+
+		sata0: sata@fe380000{
+			status = "okay";
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
index 0d3f59c..313d4fd 100644
--- a/arch/arm/boot/dts/stih416.dtsi
+++ b/arch/arm/boot/dts/stih416.dtsi
@@ -205,5 +205,21 @@
 			#phy-cells 	= <2>;
 			st,syscfg  	= <&syscfg_rear>;
 		};
+
+		sata0: sata@fe380000 {
+			compatible      = "st,ahci";
+			reg             = <0xfe380000 0x1000>;
+			interrupts      = <GIC_SPI 157 IRQ_TYPE_NONE>;
+			interrupt-names = "hostc";
+			phys	        = <&miphy365x_phy MIPHY_PORT_0 MIPHY_TYPE_SATA>;
+			phy-names       = "sata-phy";
+			resets	        = <&powerdown STIH416_SATA0_POWERDOWN>,
+					  <&softreset STIH416_SATA0_SOFTRESET>;
+			reset-names     = "pwr-dwn", "sw-rst";
+			clock-names     = "ahci_clk";
+			clocks	        = <&CLK_S_ICN_REG_0>;
+
+			status	        = "disabled";
+		};
 	};
 };
-- 
1.8.3.2

