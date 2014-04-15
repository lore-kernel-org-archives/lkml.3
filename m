Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578AbaDOIHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:07:46 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37922 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751088AbaDOIHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:07:31 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ARM: dts: berlin: add GPIO nodes for the BG2Q
Date: Tue, 15 Apr 2014 10:07:25 +0200
Message-Id: <1397549245-3338-3-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397549245-3338-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1397549245-3338-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Marvell Berlin BG2Q has 6 GPIO ports compatible with the snps,dw-apb-gpio
driver. This patch add the corresponding device tree nodes.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 arch/arm/boot/dts/berlin2q.dtsi | 102 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
index e6e556055dfc..b2625f896bc5 100644
--- a/arch/arm/boot/dts/berlin2q.dtsi
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -109,6 +109,78 @@
 			ranges = <0 0xe80000 0x10000>;
 			interrupt-parent = <&aic>;
 
+			gpio0: gpio@0400 {
+				compatible = "snps,dw-apb-gpio";
+				reg = <0x0400 0x400>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				porta: gpio-controller@0 {
+					compatible = "snps,dw-apb-gpio-port";
+					gpio-controller;
+					#gpio-cells = <2>;
+					snps,nr-gpios = <32>;
+					reg = <0>;
+					interrupt-controller;
+					#interrupt-cells = <2>;
+					interrupts = <0>;
+				};
+			};
+
+			gpio1: gpio@0800 {
+				compatible = "snps,dw-apb-gpio";
+				reg = <0x0800 0x400>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				portb: gpio-controller@1 {
+					compatible = "snps,dw-apb-gpio-port";
+					gpio-controller;
+					#gpio-cells = <2>;
+					snps,nr-gpios = <32>;
+					reg = <0>;
+					interrupt-controller;
+					#interrupt-cells = <2>;
+					interrupts = <1>;
+				};
+			};
+
+			gpio2: gpio@0c00 {
+				compatible = "snps,dw-apb-gpio";
+				reg = <0x0c00 0x400>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				portc: gpio-controller@2 {
+					compatible = "snps,dw-apb-gpio-port";
+					gpio-controller;
+					#gpio-cells = <2>;
+					snps,nr-gpios = <32>;
+					reg = <0>;
+					interrupt-controller;
+					#interrupt-cells = <2>;
+					interrupts = <2>;
+				};
+			};
+
+			gpio3: gpio@1000 {
+				compatible = "snps,dw-apb-gpio";
+				reg = <0x1000 0x400>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				portd: gpio-controller@3 {
+					compatible = "snps,dw-apb-gpio-port";
+					gpio-controller;
+					#gpio-cells = <2>;
+					snps,nr-gpios = <32>;
+					reg = <0>;
+					interrupt-controller;
+					#interrupt-cells = <2>;
+					interrupts = <3>;
+				};
+			};
+
 			timer0: timer@2c00 {
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c00 0x14>;
@@ -181,6 +253,36 @@
 				interrupt-parent = <&gic>;
 				interrupts = <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>;
 			};
+
+			gpio4: gpio@5000 {
+				compatible = "snps,dw-apb-gpio";
+				reg = <0x5000 0x400>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				porte: gpio-controller@4 {
+					compatible = "snps,dw-apb-gpio-port";
+					gpio-controller;
+					#gpio-cells = <2>;
+					snps,nr-gpios = <32>;
+					reg = <0>;
+				};
+			};
+
+			gpio5: gpio@c000 {
+				compatible = "snps,dw-apb-gpio";
+				reg = <0xc000 0x400>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				portf: gpio-controller@5 {
+					compatible = "snps,dw-apb-gpio-port";
+					gpio-controller;
+					#gpio-cells = <2>;
+					snps,nr-gpios = <32>;
+					reg = <0>;
+				};
+			};
 		};
 
 		pinctrl: pinctrl@0 {
-- 
1.8.3.2

