Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbaCTTzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 15:55:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:45262 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759230AbaCTTzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 15:55:33 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Alan Tull <atull@altera.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dinh Nguyen <dinguyen@altera.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        devicetree@vger.kernel.org
Subject: [PATCH 3/3] ARM: dts: socfpga: add gpio pieces
Date: Thu, 20 Mar 2014 20:55:24 +0100
Message-Id: <1395345324-18299-4-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1395345324-18299-1-git-send-email-bigeasy@linutronix.de>
References: <1395345324-18299-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cycloneV has three gpio controllers, each one with 29 gpios. This patch
adds the three controller with the gpio driver which is now sitting the
gpio tree.

Cc: devicetree@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/arm/boot/dts/socfpga.dtsi | 60 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
index 537f1a5..c3a97e1 100644
--- a/arch/arm/boot/dts/socfpga.dtsi
+++ b/arch/arm/boot/dts/socfpga.dtsi
@@ -463,6 +463,66 @@
 			status = "disabled";
 		};
 
+		gpio@ff708000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "snps,dw-apb-gpio";
+			reg = <0xff708000 0x1000>;
+			clocks = <&per_base_clk>;
+			status = "disabled";
+
+			gpio0: gpio-controller@0 {
+				compatible = "snps,dw-apb-gpio-port";
+				gpio-controller;
+				#gpio-cells = <1>;
+				snps,nr-gpios = <29>;
+				reg = <0>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				interrupts = <0 164 4>;
+			};
+		};
+
+		gpio@ff709000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "snps,dw-apb-gpio";
+			reg = <0xff709000 0x1000>;
+			clocks = <&per_base_clk>;
+			status = "disabled";
+
+			gpio1: gpio-controller@0 {
+				compatible = "snps,dw-apb-gpio-port";
+				gpio-controller;
+				#gpio-cells = <1>;
+				snps,nr-gpios = <29>;
+				reg = <0>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				interrupts = <0 165 4>;
+			};
+		};
+
+		gpio@ff70a000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "snps,dw-apb-gpio";
+			reg = <0xff70a000 0x1000>;
+			clocks = <&per_base_clk>;
+			status = "disabled";
+
+			gpio2: gpio-controller@0 {
+				compatible = "snps,dw-apb-gpio-port";
+				gpio-controller;
+				#gpio-cells = <1>;
+				snps,nr-gpios = <29>;
+				reg = <0>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				interrupts = <0 166 4>;
+			};
+		};
+
 		L2: l2-cache@fffef000 {
 			compatible = "arm,pl310-cache";
 			reg = <0xfffef000 0x1000>;
-- 
1.9.1

