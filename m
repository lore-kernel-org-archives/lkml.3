Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446AbaFCHdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:33:21 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43981 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932313AbaFCHdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:33:14 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ARM: dts: berlin: add I2C nodes for BG2Q
Date: Tue,  3 Jun 2014 09:33:09 +0200
Message-Id: <1401780790-17830-2-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401780790-17830-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1401780790-17830-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Marvell Berlin BG2Q has 4 TWSI compatible with the Synopsys
DesignWare I2C driver. Add the corresponding nodes.

The pin-muxing setup is also done here, since there cannot be another
muxing setup if I2C{0,1,2,3} are enabled.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 arch/arm/boot/dts/berlin2q.dtsi | 72 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
index 635a16a64cb4..0624868e36e3 100644
--- a/arch/arm/boot/dts/berlin2q.dtsi
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -191,6 +191,32 @@
 				};
 			};
 
+			i2c0: i2c@1400 {
+				compatible = "snps,designware-i2c";
+				#address-cells = <1>;
+				#size-cells = <0>;
+				reg = <0x1400 0x100>;
+				interrupt-parent = <&aic>;
+				interrupts = <4>;
+				clocks = <&chip CLKID_CFG>;
+				pinctrl-0 = <&twsi0_pmux>;
+				pinctrl-names = "default";
+				status = "disabled";
+			};
+
+			i2c1: i2c@1800 {
+				compatible = "snps,designware-i2c";
+				#address-cells = <1>;
+				#size-cells = <0>;
+				reg = <0x1800 0x100>;
+				interrupt-parent = <&aic>;
+				interrupts = <5>;
+				clocks = <&chip CLKID_CFG>;
+				pinctrl-0 = <&twsi1_pmux>;
+				pinctrl-names = "default";
+				status = "disabled";
+			};
+
 			timer0: timer@2c00 {
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c00 0x14>;
@@ -301,6 +327,16 @@
 			reg = <0xea0000 0x400>, <0xdd0170 0x10>;
 			clocks = <&refclk>;
 			clock-names = "refclk";
+
+			twsi0_pmux: twsi0-pmux {
+				groups = "G6";
+				function = "twsi0";
+			};
+
+			twsi1_pmux: twsi1-pmux {
+				groups = "G7";
+				function = "twsi1";
+			};
 		};
 
 		apb@fc0000 {
@@ -311,6 +347,32 @@
 			ranges = <0 0xfc0000 0x10000>;
 			interrupt-parent = <&sic>;
 
+			i2c2: i2c@7000 {
+				compatible = "snps,designware-i2c";
+				#address-cells = <1>;
+				#size-cells = <0>;
+				reg = <0x7000 0x100>;
+				interrupt-parent = <&sic>;
+				interrupts = <6>;
+				clocks = <&refclk>;
+				pinctrl-0 = <&twsi2_pmux>;
+				pinctrl-names = "default";
+				status = "disabled";
+			};
+
+			i2c3: i2c@8000 {
+				compatible = "snps,designware-i2c";
+				#address-cells = <1>;
+				#size-cells = <0>;
+				reg = <0x8000 0x100>;
+				interrupt-parent = <&sic>;
+				interrupts = <7>;
+				clocks = <&refclk>;
+				pinctrl-0 = <&twsi3_pmux>;
+				pinctrl-names = "default";
+				status = "disabled";
+			};
+
 			uart0: uart@9000 {
 				compatible = "snps,dw-apb-uart";
 				reg = <0x9000 0x100>;
@@ -348,6 +410,16 @@
 					groups = "GSM14";
 					function = "uart1";
 				};
+
+				twsi2_pmux: twsi2-pmux {
+					groups = "GSM13";
+					function = "twsi2";
+				};
+
+				twsi3_pmux: twsi3-pmux {
+					groups = "GSM14";
+					function = "twsi3";
+				};
 			};
 
 			sic: interrupt-controller@e000 {
-- 
1.9.1

