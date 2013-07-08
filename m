Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab3GHIZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 04:25:49 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:43213 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751534Ab3GHIZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 04:25:47 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH v1 4/4] ARM: STi: Add STiH416 ethernet support.
Date: Mon,  8 Jul 2013 09:18:20 +0100
Message-Id: <1373271500-11715-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1373271301-11060-1-git-send-email-srinivas.kandagatla@st.com>
References: <1373271301-11060-1-git-send-email-srinivas.kandagatla@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch adds support to STiH416 SOC, which has two ethernet
snps,dwmac controllers version 3.710. With this patch B2000 and B2020
boards can boot with ethernet in MII and RGMII modes.

Tested on both B2020 and B2000.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 arch/arm/boot/dts/stih416-pinctrl.dtsi |   82 ++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/stih416.dtsi         |   36 ++++++++++++++
 2 files changed, 118 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/stih416-pinctrl.dtsi b/arch/arm/boot/dts/stih416-pinctrl.dtsi
index 0f246c9..c7bbde7 100644
--- a/arch/arm/boot/dts/stih416-pinctrl.dtsi
+++ b/arch/arm/boot/dts/stih416-pinctrl.dtsi
@@ -97,6 +97,59 @@
 					};
 				};
 			};
+
+			gmac1 {
+				pinctrl_mii1: mii1 {
+					st,pins {
+						txd0 = <&PIO0 0 ALT1 OUT SE_NICLK_IO 0 CLK_A>;
+						txd1 = <&PIO0 1 ALT1 OUT SE_NICLK_IO 0 CLK_A>;
+						txd2 = <&PIO0 2 ALT1 OUT SE_NICLK_IO 0 CLK_A>;
+						txd3 = <&PIO0 3 ALT1 OUT SE_NICLK_IO 0 CLK_A>;
+						txer = <&PIO0 4 ALT1 OUT SE_NICLK_IO 0 CLK_A>;
+						txen = <&PIO0 5 ALT1 OUT SE_NICLK_IO 0 CLK_A>;
+						txclk = <&PIO0 6 ALT1 IN NICLK 0 CLK_A>;
+						col =   <&PIO0 7 ALT1 IN BYPASS 1000>;
+
+						mdio =  <&PIO1 0 ALT1 OUT BYPASS 1500>;
+						mdc =   <&PIO1 1 ALT1 OUT NICLK 0 CLK_A>;
+						crs =   <&PIO1 2 ALT1 IN BYPASS 1000>;
+						mdint = <&PIO1 3 ALT1 IN BYPASS 0>;
+						rxd0 =  <&PIO1 4 ALT1 IN SE_NICLK_IO 0 CLK_A>;
+						rxd1 =  <&PIO1 5 ALT1 IN SE_NICLK_IO 0 CLK_A>;
+						rxd2 =  <&PIO1 6 ALT1 IN SE_NICLK_IO 0 CLK_A>;
+						rxd3 =  <&PIO1 7 ALT1 IN SE_NICLK_IO 0 CLK_A>;
+
+						rxdv =  <&PIO2 0 ALT1 IN SE_NICLK_IO 0 CLK_A>;
+						rx_er = <&PIO2 1 ALT1 IN SE_NICLK_IO 0 CLK_A>;
+						rxclk = <&PIO2 2 ALT1 IN NICLK 0 CLK_A>;
+					 	phyclk = <&PIO2 3 ALT1 OUT NICLK 0 CLK_A>;
+					};
+				};
+				pinctrl_rgmii1: rgmii1-0 {
+					st,pins {
+						txd0 =  <&PIO0 0 ALT1 OUT DE_IO 500 CLK_A>;
+						txd1 =  <&PIO0 1 ALT1 OUT DE_IO 500 CLK_A>;
+						txd2 =  <&PIO0 2 ALT1 OUT DE_IO 500 CLK_A>;
+						txd3 =  <&PIO0 3 ALT1 OUT DE_IO 500 CLK_A>;
+						txen =  <&PIO0 5 ALT1 OUT DE_IO 0   CLK_A>;
+						txclk = <&PIO0 6 ALT1 IN  NICLK 0   CLK_A>;
+
+						mdio = <&PIO1 0 ALT1 OUT BYPASS 0>;
+						mdc  = <&PIO1 1 ALT1 OUT NICLK  0 CLK_A>;
+						rxd0 = <&PIO1 4 ALT1 IN DE_IO 500 CLK_A>;
+						rxd1 = <&PIO1 5 ALT1 IN DE_IO 500 CLK_A>;
+						rxd2 = <&PIO1 6 ALT1 IN DE_IO 500 CLK_A>;
+						rxd3 = <&PIO1 7 ALT1 IN DE_IO 500 CLK_A>;
+
+						rxdv   = <&PIO2 0 ALT1 IN  DE_IO 500 CLK_A>;
+						rxclk  = <&PIO2 2 ALT1 IN  NICLK 0   CLK_A>;
+						phyclk = <&PIO2 3 ALT4 OUT NICLK 0   CLK_B>;
+
+						clk125= <&PIO3 7 ALT4 IN NICLK 0 CLK_A>;
+					};
+				};
+			};
+
 		};
 
 		pin-controller-front {
@@ -230,6 +283,35 @@
 					};
 				};
 			};
+
+			gmac0 {
+				pinctrl_mii0: mii0 {
+					st,pins {
+						mdint = <&PIO13 6 ALT2 IN  BYPASS      0>;
+						txen =  <&PIO13 7 ALT2 OUT SE_NICLK_IO 0 CLK_A>;
+						txd0 =  <&PIO14 0 ALT2 OUT SE_NICLK_IO 0 CLK_A>;
+						txd1 =  <&PIO14 1 ALT2 OUT SE_NICLK_IO 0 CLK_A>;
+						txd2 =  <&PIO14 2 ALT2 OUT SE_NICLK_IO 0 CLK_B>;
+						txd3 =  <&PIO14 3 ALT2 OUT SE_NICLK_IO 0 CLK_B>;
+
+						txclk = <&PIO15 0 ALT2 IN  NICLK       0 CLK_A>;
+						txer =  <&PIO15 1 ALT2 OUT SE_NICLK_IO 0 CLK_A>;
+						crs = <&PIO15 2 ALT2 IN  BYPASS 1000>;
+						col = <&PIO15 3 ALT2 IN  BYPASS 1000>;
+						mdio= <&PIO15 4 ALT2 OUT BYPASS 1500>;
+						mdc = <&PIO15 5 ALT2 OUT NICLK  0    CLK_B>;
+
+						rxd0 =  <&PIO16 0 ALT2 IN SE_NICLK_IO 0 CLK_A>;
+						rxd1 =  <&PIO16 1 ALT2 IN SE_NICLK_IO 0 CLK_A>;
+						rxd2 =  <&PIO16 2 ALT2 IN SE_NICLK_IO 0 CLK_A>;
+						rxd3 =  <&PIO16 3 ALT2 IN SE_NICLK_IO 0 CLK_A>;
+						rxdv =  <&PIO15 6 ALT2 IN SE_NICLK_IO 0 CLK_A>;
+						rx_er = <&PIO15 7 ALT2 IN SE_NICLK_IO 0 CLK_A>;
+						rxclk = <&PIO17 0 ALT2 IN NICLK 0 CLK_A>;
+					 	phyclk = <&PIO13 5 ALT2 OUT NICLK 0 CLK_B>;
+					};
+				};
+			};
 		};
 
 		pin-controller-fvdp-fe {
diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
index 1a0326e..f43035b 100644
--- a/arch/arm/boot/dts/stih416.dtsi
+++ b/arch/arm/boot/dts/stih416.dtsi
@@ -92,5 +92,41 @@
 			pinctrl-0 	= <&pinctrl_sbc_serial1>;
 			clocks          = <&CLK_SYSIN>;
 		};
+
+		ethernet0: ethernet@fe810000{
+			device_type 	= "network";
+			compatible	= "snps,dwmac", "snps,dwmac-3.610";
+			status 		= "disabled";
+			reg 		= <0xfe810000 0x8000>;
+
+			interrupts = <0 133 0>, <0 134 0>, <0 135 0>;
+			interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";
+
+			snps,pbl 	= <32>;
+			snps,mixed-burst;
+
+			pinctrl-names 	= "default";
+			pinctrl-0	= <&pinctrl_mii0>;
+			clock-names	= "stmmaceth";
+			clocks		= <&CLK_S_ICN_REG_0>;
+		};
+
+		ethernet1: ethernet@fef08000 {
+			device_type = "network";
+			compatible	= "snps,dwmac", "snps,dwmac-3.610";
+			status 		= "disabled";
+			reg		= <0xfef08000 0x8000>;
+			interrupts = <0 136 0>, <0 137 0>, <0 138 0>;
+			interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";
+
+			snps,pbl	= <32>;
+			snps,mixed-burst;
+
+			pinctrl-names 	= "default";
+			pinctrl-0	= <&pinctrl_mii1>;
+			clock-names	= "stmmaceth";
+			clocks		= <&CLK_S_ICN_REG_0>;
+		};
+
 	};
 };
-- 
1.7.6.5

