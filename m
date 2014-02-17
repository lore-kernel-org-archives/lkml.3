Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbaBQM5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 07:57:18 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42768 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbaBQM5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 07:57:15 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: alexandre.torgue@st.com, Lee Jones <lee.jones@linaro.org>,
        devicetree@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: [PATCH 2/3] ARM: DT: STi: Add DT node for ST's SATA device
Date: Mon, 17 Feb 2014 12:56:57 +0000
Message-Id: <1392641818-23419-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392641818-23419-1-git-send-email-lee.jones@linaro.org>
References: <1392641818-23419-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: devicetree@vger.kernel.org
Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
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
index 9fd8efb..d1c874f 100644
--- a/arch/arm/boot/dts/stih416.dtsi
+++ b/arch/arm/boot/dts/stih416.dtsi
@@ -153,5 +153,21 @@
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
+			phy-names       = "ahci_phy";
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

