Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964938AbaESRhH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:37:07 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:36642 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964853AbaESRhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:37:00 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 7/7] ARM: dts: berlin: add the pinctrl node and muxing setup for uarts
Date: Mon, 19 May 2014 19:36:35 +0200
Message-Id: <1400520995-27365-8-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1400520995-27365-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1400520995-27365-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antoine Tenart <antoine.tenart@free-electrons.com>

Add pinctrl bindings and system control nodes to what we currently know
about Berlin SoCs. Where available, also set default pinctrl property
for uarts, when there is only one pinmux option for it.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v3->v4:
- remove "marvell," prefix from pinctrl function/groups property

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: zmxu@marvell.com
Cc: jszhang@marvell.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/berlin2.dtsi   | 26 ++++++++++++++++++++++++++
 arch/arm/boot/dts/berlin2cd.dtsi | 12 ++++++++++++
 arch/arm/boot/dts/berlin2q.dtsi  | 19 +++++++++++++++++++
 3 files changed, 57 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2.dtsi b/arch/arm/boot/dts/berlin2.dtsi
index 591d4b8c1c2b..2477dac4d643 100644
--- a/arch/arm/boot/dts/berlin2.dtsi
+++ b/arch/arm/boot/dts/berlin2.dtsi
@@ -296,6 +296,8 @@
 				reg-io-width = <1>;
 				interrupts = <8>;
 				clocks = <&refclk>;
+				pinctrl-0 = <&uart0_pmux>;
+				pinctrl-names = "default";
 				status = "disabled";
 			};
 
@@ -306,6 +308,8 @@
 				reg-io-width = <1>;
 				interrupts = <9>;
 				clocks = <&refclk>;
+				pinctrl-0 = <&uart1_pmux>;
+				pinctrl-names = "default";
 				status = "disabled";
 			};
 
@@ -316,9 +320,31 @@
 				reg-io-width = <1>;
 				interrupts = <10>;
 				clocks = <&refclk>;
+				pinctrl-0 = <&uart2_pmux>;
+				pinctrl-names = "default";
 				status = "disabled";
 			};
 
+			sysctrl: system-controller@d000 {
+				compatible = "marvell,berlin2-system-ctrl";
+				reg = <0xd000 0x100>;
+
+				uart0_pmux: uart0-pmux {
+					groups = "GSM4";
+					function = "uart0";
+				};
+
+				uart1_pmux: uart1-pmux {
+					groups = "GSM5";
+					function = "uart1";
+				};
+
+				uart2_pmux: uart2-pmux {
+					groups = "GSM3";
+					function = "uart2";
+				};
+			};
+
 			sic: interrupt-controller@e000 {
 				compatible = "snps,dw-apb-ictl";
 				reg = <0xe000 0x400>;
diff --git a/arch/arm/boot/dts/berlin2cd.dtsi b/arch/arm/boot/dts/berlin2cd.dtsi
index 1385caa6d029..cc1df65da504 100644
--- a/arch/arm/boot/dts/berlin2cd.dtsi
+++ b/arch/arm/boot/dts/berlin2cd.dtsi
@@ -234,6 +234,11 @@
 			reg = <0xea0000 0x400>;
 			clocks = <&refclk>;
 			clock-names = "refclk";
+
+			uart0_pmux: uart0-pmux {
+				groups = "G6";
+				function = "uart0";
+			};
 		};
 
 		apb@fc0000 {
@@ -281,6 +286,8 @@
 				reg-io-width = <1>;
 				interrupts = <8>;
 				clocks = <&refclk>;
+				pinctrl-0 = <&uart0_pmux>;
+				pinctrl-names = "default";
 				status = "disabled";
 			};
 
@@ -294,6 +301,11 @@
 				status = "disabled";
 			};
 
+			sysctrl: system-controller@d000 {
+				compatible = "marvell,berlin2cd-system-ctrl";
+				reg = <0xd000 0x100>;
+			};
+
 			sic: interrupt-controller@e000 {
 				compatible = "snps,dw-apb-ictl";
 				reg = <0xe000 0x400>;
diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
index cd3287c95f1a..81712f5954ef 100644
--- a/arch/arm/boot/dts/berlin2q.dtsi
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -294,6 +294,8 @@
 				interrupts = <8>;
 				clocks = <&refclk>;
 				reg-shift = <2>;
+				pinctrl-0 = <&uart0_pmux>;
+				pinctrl-names = "default";
 				status = "disabled";
 			};
 
@@ -304,9 +306,26 @@
 				interrupts = <9>;
 				clocks = <&refclk>;
 				reg-shift = <2>;
+				pinctrl-0 = <&uart1_pmux>;
+				pinctrl-names = "default";
 				status = "disabled";
 			};
 
+			sysctrl: pin-controller@d000 {
+				compatible = "marvell,berlin2q-system-ctrl";
+				reg = <0xd000 0x100>;
+
+				uart0_pmux: uart0-pmux {
+					groups = "GSM12";
+					function = "uart0";
+				};
+
+				uart1_pmux: uart1-pmux {
+					groups = "GSM14";
+					function = "uart1";
+				};
+			};
+
 			sic: interrupt-controller@e000 {
 				compatible = "snps,dw-apb-ictl";
 				reg = <0xe000 0x30>;
-- 
1.9.1

