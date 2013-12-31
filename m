Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab3LaQf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 11:35:58 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:35313 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab3LaQfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 11:35:55 -0500
From: jjhiblot@traphandler.com
To: nicolas.ferre@atmel.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jean-jacques hiblot <jean-jacques.hiblot@jdsu.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH 2/6] at91: dt: sam9261: Added support for the lcd display
Date: Tue, 31 Dec 2013 17:32:10 +0100
Message-Id: <1388507534-10570-3-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1388507534-10570-1-git-send-email-jjhiblot@traphandler.com>
References: <1388507534-10570-1-git-send-email-jjhiblot@traphandler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: jean-jacques hiblot <jean-jacques.hiblot@jdsu.com>

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 arch/arm/boot/dts/at91sam9261.dtsi  | 37 ++++++++++++++++++++++++++++++++++++-
 arch/arm/boot/dts/at91sam9261ek.dts | 31 +++++++++++++++++++++++++++++++
 arch/arm/mach-at91/at91sam9261.c    |  1 +
 3 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/at91sam9261.dtsi b/arch/arm/boot/dts/at91sam9261.dtsi
index ce23d7d..7ee0fff 100644
--- a/arch/arm/boot/dts/at91sam9261.dtsi
+++ b/arch/arm/boot/dts/at91sam9261.dtsi
@@ -290,7 +290,33 @@
 						atmel,pins = <AT91_PIOC 24 AT91_PERIPH_B AT91_PINCTRL_NONE>;
 					};
 				};
-
+				fb {
+					pinctrl_fb: fb-0 {
+						atmel,pins =
+							<AT91_PIOB 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB1 periph A */
+							 AT91_PIOB 2 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB2 periph A */
+							 AT91_PIOB 3 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB3 periph A */
+							 AT91_PIOB 7 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB7 periph A */
+							 AT91_PIOB 8 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB8 periph A */
+							 AT91_PIOB 9 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB9 periph A */
+							 AT91_PIOB 10 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB10 periph A */
+							 AT91_PIOB 11 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB11 periph A */
+							 AT91_PIOB 12 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB12 periph A */
+							 AT91_PIOB 15 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB15 periph A */
+							 AT91_PIOB 16 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB16 periph A */
+							 AT91_PIOB 17 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB17 periph A */
+							 AT91_PIOB 18 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB18 periph A */
+							 AT91_PIOB 19 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB19 periph A */
+							 AT91_PIOB 20 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB20 periph A */
+							 AT91_PIOB 23 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB23 periph B */
+							 AT91_PIOB 24 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB24 periph B */
+							 AT91_PIOB 25 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB25 periph B */
+							 AT91_PIOB 26 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB26 periph B */
+							 AT91_PIOB 27 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB27 periph B */
+							 AT91_PIOB 28 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB28 periph B */
+							 >;
+					};
+				};
 				pioA: gpio@fffff400 {
 					compatible = "atmel,at91rm9200-gpio";
 					reg = <0xfffff400 0x200>;
@@ -436,6 +462,15 @@
 			};
 		};
 
+		fb0: fb@0x00600000 {
+			compatible = "atmel,at91sam9261-lcdc";
+			reg = <0x00600000 0x1000>;
+			interrupts = <21 IRQ_TYPE_LEVEL_HIGH 3>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_fb>;
+			status = "disabled";
+		};
+
 		nand0: nand@40000000 {
 			compatible = "atmel,at91rm9200-nand";
 			#address-cells = <1>;
diff --git a/arch/arm/boot/dts/at91sam9261ek.dts b/arch/arm/boot/dts/at91sam9261ek.dts
index f3d22a9..03c05fc 100644
--- a/arch/arm/boot/dts/at91sam9261ek.dts
+++ b/arch/arm/boot/dts/at91sam9261ek.dts
@@ -52,6 +52,37 @@
 				reg = <0x0 0x20000>;
 			};
 		};
+
+		fb0: fb@0x00600000 {
+			display = <&display0>;
+			status = "okay";
+			atmel,power-control-gpio = <&pioA 12 GPIO_ACTIVE_LOW>;
+			display0: display {
+				bits-per-pixel = <16>;
+				atmel,lcdcon-backlight;
+				atmel,dmacon = <0x1>;
+				atmel,lcdcon2 = <0x80008002>;
+				atmel,guard-time = <1>;
+				atmel,lcd-wiring-mode = "BRG";
+
+				display-timings {
+					native-mode = <&timing0>;
+					timing0: timing0 {
+						clock-frequency = <4965000>;
+						hactive = <240>;
+						vactive = <320>;
+						hback-porch = <1>;
+						hfront-porch = <33>;
+						vback-porch = <1>;
+						vfront-porch = <0>;
+						hsync-len = <5>;
+						vsync-len = <1>;
+						hsync-active = <1>;
+						vsync-active = <1>;
+					};
+				};
+			};
+		};
 	};
 
 	leds {
diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
index 200d17a..a67bfe6 100644
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@ -197,6 +197,7 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	/* more tc lookup table for DT entries */
 	CLKDEV_CON_DEV_ID("t0_clk", "fffa0000.timer", &tc0_clk),
 	CLKDEV_CON_DEV_ID("hclk", "500000.ohci", &ohci_clk),
+	CLKDEV_CON_DEV_ID("hclk", "600000.fb", &hck1),
 	CLKDEV_CON_DEV_ID("spi_clk", "fffc8000.spi", &spi0_clk),
 	CLKDEV_CON_DEV_ID("spi_clk", "fffcc000.spi", &spi1_clk),
 	CLKDEV_CON_DEV_ID("mci_clk", "fffa8000.mmc", &mmc_clk),
-- 
1.8.4.2

