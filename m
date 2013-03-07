Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab3CGDjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 22:39:24 -0500
Received: from nasmtp01.atmel.com ([192.199.1.246]:57693 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932263Ab3CGDjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 22:39:22 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <grant.likely@secretlab.ca>, <nicolas.ferre@atmel.com>,
        <plagnioj@jcrosoft.com>, <richard.genoud@gmail.com>,
        <JM.Lin@atmel.com>, <wenyou.yang@atmel.com>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 16/16] ARM: dts: add pinctrl property for spi node for atmel SoC
Date: Thu, 7 Mar 2013 11:36:14 +0800
Message-ID: <1362627374-9582-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362626715-6549-1-git-send-email-wenyou.yang@atmel.com>
References: <1362626715-6549-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/at91sam9260.dtsi |   22 ++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9263.dtsi |   22 ++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9g45.dtsi |   22 ++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9n12.dtsi |   22 ++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9x5.dtsi  |   22 ++++++++++++++++++++++
 5 files changed, 110 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
index 6e31dc8..39253b9 100644
--- a/arch/arm/boot/dts/at91sam9260.dtsi
+++ b/arch/arm/boot/dts/at91sam9260.dtsi
@@ -322,6 +322,24 @@
 					};
 				};
 
+				spi0 {
+					pinctrl_spi0: spi0-0 {
+						atmel,pins =
+							<0 0 0x1 0x0	/* PA0 periph A SPI0_MISO pin */
+							 0 1 0x1 0x0	/* PA1 periph A SPI0_MOSI pin */
+							 0 2 0x1 0x0>;	/* PA2 periph A SPI0_SPCK pin */
+					};
+				};
+
+				spi1 {
+					pinctrl_spi1: spi1-0 {
+						atmel,pins =
+							<1 0 0x1 0x0	/* PB0 periph A SPI1_MISO pin */
+							 1 1 0x1 0x0	/* PB1 periph A SPI1_MOSI pin */
+							 1 2 0x1 0x0>;	/* PB2 periph A SPI1_SPCK pin */
+					};
+				};
+
 				pioA: gpio@fffff400 {
 					compatible = "atmel,at91rm9200-gpio";
 					reg = <0xfffff400 0x200>;
@@ -477,6 +495,8 @@
 				compatible = "atmel,at91rm9200-spi";
 				reg = <0xfffc8000 0x200>;
 				interrupts = <12 4 3>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_spi0>;
 				status = "disabled";
 			};
 
@@ -486,6 +506,8 @@
 				compatible = "atmel,at91rm9200-spi";
 				reg = <0xfffcc000 0x200>;
 				interrupts = <13 4 3>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_spi1>;
 				status = "disabled";
 			};
 
diff --git a/arch/arm/boot/dts/at91sam9263.dtsi b/arch/arm/boot/dts/at91sam9263.dtsi
index 6c6d9ae..94b58ab 100644
--- a/arch/arm/boot/dts/at91sam9263.dtsi
+++ b/arch/arm/boot/dts/at91sam9263.dtsi
@@ -303,6 +303,24 @@
 					};
 				};
 
+				spi0 {
+					pinctrl_spi0: spi0-0 {
+						atmel,pins =
+							<0 0 0x2 0x0	/* PA0 periph B SPI0_MISO pin */
+							 0 1 0x2 0x0	/* PA1 periph B SPI0_MOSI pin */
+							 0 2 0x2 0x0>;	/* PA2 periph B SPI0_SPCK pin */
+					};
+				};
+
+				spi1 {
+					pinctrl_spi1: spi1-0 {
+						atmel,pins =
+							<1 12 0x1 0x0	/* PB12 periph A SPI1_MISO pin */
+							 1 13 0x1 0x0	/* PB13 periph A SPI1_MOSI pin */
+							 1 14 0x1 0x0>;	/* PB14 periph A SPI1_SPCK pin */
+					};
+				};
+
 				pioA: gpio@fffff200 {
 					compatible = "atmel,at91rm9200-gpio";
 					reg = <0xfffff200 0x200>;
@@ -469,6 +487,8 @@
 				compatible = "atmel,at91rm9200-spi";
 				reg = <0xfffa4000 0x200>;
 				interrupts = <14 4 3>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_spi0>;
 				status = "disabled";
 			};
 
@@ -478,6 +498,8 @@
 				compatible = "atmel,at91rm9200-spi";
 				reg = <0xfffa8000 0x200>;
 				interrupts = <15 4 3>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_spi1>;
 				status = "disabled";
 			};
 		};
diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index e085b8a..cfdf429 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -322,6 +322,24 @@
 					};
 				};
 
+				spi0 {
+					pinctrl_spi0: spi0-0 {
+						atmel,pins =
+							<1 0 0x1 0x0	/* PB0 periph A SPI0_MISO pin */
+							 1 1 0x1 0x0	/* PB1 periph A SPI0_MOSI pin */
+							 1 2 0x1 0x0>;	/* PB2 periph A SPI0_SPCK pin */
+					};
+				};
+
+				spi1 {
+					pinctrl_spi1: spi1-0 {
+						atmel,pins =
+							<1 14 0x1 0x0	/* PB14 periph A SPI1_MISO pin */
+							 1 15 0x1 0x0	/* PB15 periph A SPI1_MOSI pin */
+							 1 16 0x1 0x0>;	/* PB16 periph A SPI1_SPCK pin */
+					};
+				};
+
 				pioA: gpio@fffff200 {
 					compatible = "atmel,at91rm9200-gpio";
 					reg = <0xfffff200 0x200>;
@@ -538,6 +556,8 @@
 				compatible = "atmel,at91rm9200-spi";
 				reg = <0xfffa4000 0x200>;
 				interrupts = <14 4 3>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_spi0>;
 				status = "disabled";
 			};
 
@@ -547,6 +567,8 @@
 				compatible = "atmel,at91rm9200-spi";
 				reg = <0xfffa8000 0x200>;
 				interrupts = <15 4 3>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_spi1>;
 				status = "disabled";
 			};
 		};
diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi b/arch/arm/boot/dts/at91sam9n12.dtsi
index f3f87ef3..b2961f1 100644
--- a/arch/arm/boot/dts/at91sam9n12.dtsi
+++ b/arch/arm/boot/dts/at91sam9n12.dtsi
@@ -261,6 +261,24 @@
 					};
 				};
 
+				spi0 {
+					pinctrl_spi0: spi0-0 {
+						atmel,pins =
+							<0 11 0x1 0x0	/* PA11 periph A SPI0_MISO pin */
+							 0 12 0x1 0x0	/* PA12 periph A SPI0_MOSI pin */
+							 0 13 0x1 0x0>;	/* PA13 periph A SPI0_SPCK pin */
+					};
+				};
+
+				spi1 {
+					pinctrl_spi1: spi1-0 {
+						atmel,pins =
+							<0 21 0x2 0x0	/* PA21 periph B SPI1_MISO pin */
+							 0 22 0x2 0x0	/* PA22 periph B SPI1_MOSI pin */
+							 0 23 0x2 0x0>;	/* PA23 periph B SPI1_SPCK pin */
+					};
+				};
+
 				pioA: gpio@fffff400 {
 					compatible = "atmel,at91sam9x5-gpio", "atmel,at91rm9200-gpio";
 					reg = <0xfffff400 0x200>;
@@ -380,6 +398,8 @@
 				compatible = "atmel,at91rm9200-spi";
 				reg = <0xf0000000 0x100>;
 				interrupts = <13 4 3>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_spi0>;
 				status = "disabled";
 			};
 
@@ -389,6 +409,8 @@
 				compatible = "atmel,at91rm9200-spi";
 				reg = <0xf0004000 0x100>;
 				interrupts = <14 4 3>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_spi1>;
 				status = "disabled";
 			};
 		};
diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index 83a4889..04fbf9d 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -319,6 +319,24 @@
 					};
 				};
 
+				spi0 {
+					pinctrl_spi0: spi0-0 {
+						atmel,pins =
+							<0 11 0x1 0x0	/* PA11 periph A SPI0_MISO pin */
+							 0 12 0x1 0x0	/* PA12 periph A SPI0_MOSI pin */
+							 0 13 0x1 0x0>;	/* PA13 periph A SPI0_SPCK pin */
+					};
+				};
+
+				spi1 {
+					pinctrl_spi1: spi1-0 {
+						atmel,pins =
+							<0 21 0x2 0x0	/* PA21 periph B SPI1_MISO pin */
+							 0 22 0x2 0x0	/* PA22 periph B SPI1_MOSI pin */
+							 0 23 0x2 0x0>;	/* PA23 periph B SPI1_SPCK pin */
+					};
+				};
+
 				pioA: gpio@fffff400 {
 					compatible = "atmel,at91sam9x5-gpio", "atmel,at91rm9200-gpio";
 					reg = <0xfffff400 0x200>;
@@ -512,6 +530,8 @@
 				compatible = "atmel,at91rm9200-spi";
 				reg = <0xf0000000 0x100>;
 				interrupts = <13 4 3>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_spi0>;
 				status = "disabled";
 			};
 
@@ -521,6 +541,8 @@
 				compatible = "atmel,at91rm9200-spi";
 				reg = <0xf0004000 0x100>;
 				interrupts = <14 4 3>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_spi1>;
 				status = "disabled";
 			};
 		};
-- 
1.7.9.5

