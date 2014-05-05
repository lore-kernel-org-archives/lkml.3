Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbaEEF1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 01:27:52 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35605 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754597AbaEEF1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 01:27:37 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, linus.walleij@linaro.org
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 7/7] ARM: dts: berlin: add the pinctrl node and muxing setup for uarts
Date: Mon,  5 May 2014 07:27:29 +0200
Message-Id: <1399267649-20218-8-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399267649-20218-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1399267649-20218-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The uart0 pinmux configuration is in the dtsi because uart0 will always
use uart0-pmux to work, no other possibility. Same thing for uart1 and
uart2 (BG2).

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
 arch/arm/boot/dts/berlin2.dtsi   | 31 +++++++++++++++++++++++++++++++
 arch/arm/boot/dts/berlin2cd.dtsi | 17 +++++++++++++++++
 arch/arm/boot/dts/berlin2q.dtsi  | 24 ++++++++++++++++++++++++
 3 files changed, 72 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2.dtsi b/arch/arm/boot/dts/berlin2.dtsi
index 56a1af2f1052..fb58f43eab52 100644
--- a/arch/arm/boot/dts/berlin2.dtsi
+++ b/arch/arm/boot/dts/berlin2.dtsi
@@ -176,6 +176,11 @@
 			};
 		};
 
+		soc_pinctrl: pin-controller@ea0000 {
+			compatible = "marvell,berlin2-soc-pinctrl";
+			reg = <0xea0000 0x4c>;
+		};
+
 		apb@fc0000 {
 			compatible = "simple-bus";
 			#address-cells = <1>;
@@ -184,6 +189,26 @@
 			ranges = <0 0xfc0000 0x10000>;
 			interrupt-parent = <&sic>;
 
+			sm_pinctrl: pin-controller@0000 {
+				compatible = "marvell,berlin2-sysmgr-pinctrl";
+				reg = <0x0000 0x44>;
+
+				uart0_pmux: uart0-pmux {
+					marvell,groups = "GSM4";
+					marvell,function = "uart0";
+				};
+
+				uart1_pmux: uart1-pmux {
+					marvell,groups = "GSM5";
+					marvell,function = "uart1";
+				};
+
+				uart2_pmux: uart2-pmux {
+					marvell,groups = "GSM3";
+					marvell,function = "uart2";
+				};
+			};
+
 			uart0: serial@9000 {
 				compatible = "snps,dw-apb-uart";
 				reg = <0x9000 0x100>;
@@ -191,6 +216,8 @@
 				reg-io-width = <1>;
 				interrupts = <8>;
 				clocks = <&smclk>;
+				pinctrl-0 = <&uart0_pmux>;
+				pinctrl-names = "default";
 				status = "disabled";
 			};
 
@@ -201,6 +228,8 @@
 				reg-io-width = <1>;
 				interrupts = <9>;
 				clocks = <&smclk>;
+				pinctrl-0 = <&uart1_pmux>;
+				pinctrl-names = "default";
 				status = "disabled";
 			};
 
@@ -211,6 +240,8 @@
 				reg-io-width = <1>;
 				interrupts = <10>;
 				clocks = <&smclk>;
+				pinctrl-0 = <&uart2_pmux>;
+				pinctrl-names = "default";
 				status = "disabled";
 			};
 
diff --git a/arch/arm/boot/dts/berlin2cd.dtsi b/arch/arm/boot/dts/berlin2cd.dtsi
index 094968c27533..a802d3fe5da6 100644
--- a/arch/arm/boot/dts/berlin2cd.dtsi
+++ b/arch/arm/boot/dts/berlin2cd.dtsi
@@ -169,6 +169,11 @@
 			};
 		};
 
+		soc_pinctrl: pin-controller@ae0000 {
+			compatible = "marvell,berlin2cd-soc-pinctrl";
+			reg = <0xea0000 0x4c>;
+		};
+
 		apb@fc0000 {
 			compatible = "simple-bus";
 			#address-cells = <1>;
@@ -177,6 +182,16 @@
 			ranges = <0 0xfc0000 0x10000>;
 			interrupt-parent = <&sic>;
 
+			sm_pinctrl: pin-controller@0000 {
+				compatible = "marvell,berlin2cd-sysmgr-pinctrl";
+				reg = <0x0000 0x44>;
+
+				uart0_pmux: uart0-pmux {
+					marvell,groups = "G6";
+					marvell,function = "uart0";
+				};
+			};
+
 			uart0: serial@9000 {
 				compatible = "snps,dw-apb-uart";
 				reg = <0x9000 0x100>;
@@ -184,6 +199,8 @@
 				reg-io-width = <1>;
 				interrupts = <8>;
 				clocks = <&smclk>;
+				pinctrl-0 = <&uart0_pmux>;
+				pinctrl-names = "default";
 				status = "disabled";
 			};
 
diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
index 07452a7483fa..734debbf072f 100644
--- a/arch/arm/boot/dts/berlin2q.dtsi
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -183,6 +183,11 @@
 			};
 		};
 
+		soc_pinctrl: pin-controller@ea0000 {
+			compatible = "marvell,berlin2q-soc-pinctrl";
+			reg = <0xea0000 0x4c>;
+		};
+
 		apb@fc0000 {
 			compatible = "simple-bus";
 			#address-cells = <1>;
@@ -198,6 +203,8 @@
 				interrupts = <8>;
 				clocks = <&smclk>;
 				reg-shift = <2>;
+				pinctrl-0 = <&uart0_pmux>;
+				pinctrl-names = "default";
 				status = "disabled";
 			};
 
@@ -208,9 +215,26 @@
 				interrupts = <9>;
 				clocks = <&smclk>;
 				reg-shift = <2>;
+				pinctrl-0 = <&uart1_pmux>;
+				pinctrl-names = "default";
 				status = "disabled";
 			};
 
+			sm_pinctrl: pin-controller@d000 {
+				compatible = "marvell,berlin2q-sysmgr-pinctrl";
+				reg = <0xd000 0x44>;
+
+				uart0_pmux: uart0-pmux {
+					marvell,groups = "GSM12";
+					marvell,function = "uart0";
+				};
+
+				uart1_pmux: uart1-pmux {
+					marvell,groups = "GSM14";
+					marvell,function = "uart1";
+				};
+			};
+
 			sic: interrupt-controller@e000 {
 				compatible = "snps,dw-apb-ictl";
 				reg = <0xe000 0x30>;
-- 
1.8.3.2

