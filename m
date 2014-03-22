Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbaCVQSJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 12:18:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:55414 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbaCVQQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 12:16:53 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: atull@altera.com
Cc: linus.walleij@linaro.org, gnurou@gmail.com, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, dinguyen@altera.com,
        delicious.quinoa@gmail.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        devicetree@vger.kernel.org
Subject: [PATCH 1/7] ARM: dts: socfpga: add gpio pieces
Date: Sat, 22 Mar 2014 17:16:38 +0100
Message-Id: <1395505004-22650-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1395505004-22650-1-git-send-email-bigeasy@linutronix.de>
References: <1395505004-22650-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cycloneV has three gpio controllers, the first two with 29 gpios, the last
one with 27. This patch adds the three controller with the gpio driver which is
now sitting the gpio tree.

Cc: devicetree@vger.kernel.org
Acked-by: Alan Tull <atull@altera.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
v1…v2:
	- #gpio-cells = <2>
	- third gpio block has now only 27 gpios

 arch/arm/boot/dts/socfpga.dtsi | 64 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
index 537f1a5..2a84e67 100644
--- a/arch/arm/boot/dts/socfpga.dtsi
+++ b/arch/arm/boot/dts/socfpga.dtsi
@@ -463,6 +463,70 @@
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
+				#gpio-cells = <2>;
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
+				#gpio-cells = <2>;
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
+				#gpio-cells = <2>;
+				/*
+				 * Despite what the documentation says here, the
+				 * third gpio block has only 27 gpios available
+				 */
+				snps,nr-gpios = <27>;
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

