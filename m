Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab3HXVl6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 17:41:58 -0400
Received: from 2.mo2.mail-out.ovh.net ([188.165.53.149]:49884 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755782Ab3HXVl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 17:41:57 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jiri Kosina <jkosina@suse.cz>, Masanari Iida <standby24x7@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, James Hogan <james.hogan@imgtec.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: [RFC PATCH 3/3] ARM: at91/dt: move sama5 to generic pinconf
Date: Sat, 24 Aug 2013 23:40:00 +0200
Message-Id: <1377380400-11331-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377379926-11163-1-git-send-email-b.brezillon@overkiz.com>
References: <1377379926-11163-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 2923399109810419936
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrhedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrhedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add generic pinconf definitions and reference appropriate configs in
atmel,pins properties.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/sama5d3.dtsi    |  363 +++++++++++++++++++------------------
 arch/arm/boot/dts/sama5d3xdm.dtsi |    2 +-
 arch/arm/boot/dts/sama5d3xmb.dtsi |   12 +-
 3 files changed, 197 insertions(+), 180 deletions(-)

diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index a1d5e25..3e38383 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -402,7 +402,7 @@
 			pinctrl@fffff200 {
 				#address-cells = <1>;
 				#size-cells = <1>;
-				compatible = "atmel,at91sam9x5-pinctrl", "atmel,at91rm9200-pinctrl", "simple-bus";
+				compatible = "atmel,at91sam9x5-pinctrl", "atmel,at91rm9200-pinctrl", "generic-pinconf", "simple-bus";
 				ranges = <0xfffff200 0xfffff200 0xa00>;
 				atmel,mux-mask = <
 					/*   A          B          C  */
@@ -413,206 +413,223 @@
 					0xffffffff 0xbf9f8000 0x18000000	/* pioE */
 					>;
 
+				pcfg_none: pcfg_none {
+					bias-disable;
+				};
+
+				pcfg_pull_up: pcfg_pull_up {
+					bias-pull-up;
+				};
+
+				pcfg_deglitch: pcfg_deglitch {
+					input-deglitch = <1>;
+				};
+
+				pcfg_pull_up_deglitch: pcfg_pull_up_deglitch {
+					bias-pull-up;
+					input-deglitch = <1>;
+				};
+
 				/* shared pinctrl settings */
 				adc0 {
 					pinctrl_adc0_adtrg: adc0_adtrg {
 						atmel,pins =
-							<AT91_PIOD 19 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PD19 periph A ADTRG */
+							<AT91_PIOD 19 AT91_PERIPH_A &pcfg_none>;	/* PD19 periph A ADTRG */
 					};
 					pinctrl_adc0_ad0: adc0_ad0 {
 						atmel,pins =
-							<AT91_PIOD 20 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PD20 periph A AD0 */
+							<AT91_PIOD 20 AT91_PERIPH_A &pcfg_none>;	/* PD20 periph A AD0 */
 					};
 					pinctrl_adc0_ad1: adc0_ad1 {
 						atmel,pins =
-							<AT91_PIOD 21 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PD21 periph A AD1 */
+							<AT91_PIOD 21 AT91_PERIPH_A &pcfg_none>;	/* PD21 periph A AD1 */
 					};
 					pinctrl_adc0_ad2: adc0_ad2 {
 						atmel,pins =
-							<AT91_PIOD 22 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PD22 periph A AD2 */
+							<AT91_PIOD 22 AT91_PERIPH_A &pcfg_none>;	/* PD22 periph A AD2 */
 					};
 					pinctrl_adc0_ad3: adc0_ad3 {
 						atmel,pins =
-							<AT91_PIOD 23 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PD23 periph A AD3 */
+							<AT91_PIOD 23 AT91_PERIPH_A &pcfg_none>;	/* PD23 periph A AD3 */
 					};
 					pinctrl_adc0_ad4: adc0_ad4 {
 						atmel,pins =
-							<AT91_PIOD 24 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PD24 periph A AD4 */
+							<AT91_PIOD 24 AT91_PERIPH_A &pcfg_none>;	/* PD24 periph A AD4 */
 					};
 					pinctrl_adc0_ad5: adc0_ad5 {
 						atmel,pins =
-							<AT91_PIOD 25 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PD25 periph A AD5 */
+							<AT91_PIOD 25 AT91_PERIPH_A &pcfg_none>;	/* PD25 periph A AD5 */
 					};
 					pinctrl_adc0_ad6: adc0_ad6 {
 						atmel,pins =
-							<AT91_PIOD 26 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PD26 periph A AD6 */
+							<AT91_PIOD 26 AT91_PERIPH_A &pcfg_none>;	/* PD26 periph A AD6 */
 					};
 					pinctrl_adc0_ad7: adc0_ad7 {
 						atmel,pins =
-							<AT91_PIOD 27 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PD27 periph A AD7 */
+							<AT91_PIOD 27 AT91_PERIPH_A &pcfg_none>;	/* PD27 periph A AD7 */
 					};
 					pinctrl_adc0_ad8: adc0_ad8 {
 						atmel,pins =
-							<AT91_PIOD 28 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PD28 periph A AD8 */
+							<AT91_PIOD 28 AT91_PERIPH_A &pcfg_none>;	/* PD28 periph A AD8 */
 					};
 					pinctrl_adc0_ad9: adc0_ad9 {
 						atmel,pins =
-							<AT91_PIOD 29 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PD29 periph A AD9 */
+							<AT91_PIOD 29 AT91_PERIPH_A &pcfg_none>;	/* PD29 periph A AD9 */
 					};
 					pinctrl_adc0_ad10: adc0_ad10 {
 						atmel,pins =
-							<AT91_PIOD 30 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PD30 periph A AD10, conflicts with PCK0 */
+							<AT91_PIOD 30 AT91_PERIPH_A &pcfg_none>;	/* PD30 periph A AD10, conflicts with PCK0 */
 					};
 					pinctrl_adc0_ad11: adc0_ad11 {
 						atmel,pins =
-							<AT91_PIOD 31 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PD31 periph A AD11, conflicts with PCK1 */
+							<AT91_PIOD 31 AT91_PERIPH_A &pcfg_none>;	/* PD31 periph A AD11, conflicts with PCK1 */
 					};
 				};
 
 				can0 {
 					pinctrl_can0_rx_tx: can0_rx_tx {
 						atmel,pins =
-							<AT91_PIOD 14 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PD14 periph C RX, conflicts with SCK0, SPI0_NPCS1 */
-							 AT91_PIOD 15 AT91_PERIPH_C AT91_PINCTRL_NONE>;	/* PD15 periph C TX, conflicts with CTS0, SPI0_NPCS2 */
+							<AT91_PIOD 14 AT91_PERIPH_C &pcfg_none	/* PD14 periph C RX, conflicts with SCK0, SPI0_NPCS1 */
+							 AT91_PIOD 15 AT91_PERIPH_C &pcfg_none>;	/* PD15 periph C TX, conflicts with CTS0, SPI0_NPCS2 */
 					};
 				};
 
 				can1 {
 					pinctrl_can1_rx_tx: can1_rx_tx {
 						atmel,pins =
-							<AT91_PIOB 14 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB14 periph B RX, conflicts with GCRS */
-							 AT91_PIOB 15 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PB15 periph B TX, conflicts with GCOL */
+							<AT91_PIOB 14 AT91_PERIPH_B &pcfg_none	/* PB14 periph B RX, conflicts with GCRS */
+							 AT91_PIOB 15 AT91_PERIPH_B &pcfg_none>;	/* PB15 periph B TX, conflicts with GCOL */
 					};
 				};
 
 				dbgu {
 					pinctrl_dbgu: dbgu-0 {
 						atmel,pins =
-							<AT91_PIOB 30 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB30 periph A */
-							 AT91_PIOB 31 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;	/* PB31 periph A with pullup */
+							<AT91_PIOB 30 AT91_PERIPH_A &pcfg_none	/* PB30 periph A */
+							 AT91_PIOB 31 AT91_PERIPH_A &pcfg_pull_up>;	/* PB31 periph A with pullup */
 					};
 				};
 
 				i2c0 {
 					pinctrl_i2c0: i2c0-0 {
 						atmel,pins =
-							<AT91_PIOA 30 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA30 periph A TWD0 pin, conflicts with URXD1, ISI_VSYNC */
-							 AT91_PIOA 31 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PA31 periph A TWCK0 pin, conflicts with UTXD1, ISI_HSYNC */
+							<AT91_PIOA 30 AT91_PERIPH_A &pcfg_none	/* PA30 periph A TWD0 pin, conflicts with URXD1, ISI_VSYNC */
+							 AT91_PIOA 31 AT91_PERIPH_A &pcfg_none>;	/* PA31 periph A TWCK0 pin, conflicts with UTXD1, ISI_HSYNC */
 					};
 				};
 
 				i2c1 {
 					pinctrl_i2c1: i2c1-0 {
 						atmel,pins =
-							<AT91_PIOC 26 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC26 periph B TWD1 pin, conflicts with SPI1_NPCS1, ISI_D11 */
-							 AT91_PIOC 27 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PC27 periph B TWCK1 pin, conflicts with SPI1_NPCS2, ISI_D10 */
+							<AT91_PIOC 26 AT91_PERIPH_B &pcfg_none	/* PC26 periph B TWD1 pin, conflicts with SPI1_NPCS1, ISI_D11 */
+							 AT91_PIOC 27 AT91_PERIPH_B &pcfg_none>;	/* PC27 periph B TWCK1 pin, conflicts with SPI1_NPCS2, ISI_D10 */
 					};
 				};
 
 				isi {
 					pinctrl_isi: isi-0 {
 						atmel,pins =
-							<AT91_PIOA 16 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PA16 periph C ISI_D0, conflicts with LCDDAT16 */
-							 AT91_PIOA 17 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PA17 periph C ISI_D1, conflicts with LCDDAT17 */
-							 AT91_PIOA 18 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PA18 periph C ISI_D2, conflicts with LCDDAT18, TWD2 */
-							 AT91_PIOA 19 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PA19 periph C ISI_D3, conflicts with LCDDAT19, TWCK2 */
-							 AT91_PIOA 20 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PA20 periph C ISI_D4, conflicts with LCDDAT20, PWMH0 */
-							 AT91_PIOA 21 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PA21 periph C ISI_D5, conflicts with LCDDAT21, PWML0 */
-							 AT91_PIOA 22 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PA22 periph C ISI_D6, conflicts with LCDDAT22, PWMH1 */
-							 AT91_PIOA 23 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PA23 periph C ISI_D7, conflicts with LCDDAT23, PWML1 */
-							 AT91_PIOC 30 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC30 periph C ISI_PCK, conflicts with UTXD0 */
-							 AT91_PIOA 31 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PA31 periph C ISI_HSYNC, conflicts with TWCK0, UTXD1 */
-							 AT91_PIOA 30 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PA30 periph C ISI_VSYNC, conflicts with TWD0, URXD1 */
-							 AT91_PIOC 29 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC29 periph C ISI_PD8, conflicts with URXD0, PWMFI2 */
-							 AT91_PIOC 28 AT91_PERIPH_C AT91_PINCTRL_NONE>;	/* PC28 periph C ISI_PD9, conflicts with SPI1_NPCS3, PWMFI0 */
+							<AT91_PIOA 16 AT91_PERIPH_C &pcfg_none	/* PA16 periph C ISI_D0, conflicts with LCDDAT16 */
+							 AT91_PIOA 17 AT91_PERIPH_C &pcfg_none	/* PA17 periph C ISI_D1, conflicts with LCDDAT17 */
+							 AT91_PIOA 18 AT91_PERIPH_C &pcfg_none	/* PA18 periph C ISI_D2, conflicts with LCDDAT18, TWD2 */
+							 AT91_PIOA 19 AT91_PERIPH_C &pcfg_none	/* PA19 periph C ISI_D3, conflicts with LCDDAT19, TWCK2 */
+							 AT91_PIOA 20 AT91_PERIPH_C &pcfg_none	/* PA20 periph C ISI_D4, conflicts with LCDDAT20, PWMH0 */
+							 AT91_PIOA 21 AT91_PERIPH_C &pcfg_none	/* PA21 periph C ISI_D5, conflicts with LCDDAT21, PWML0 */
+							 AT91_PIOA 22 AT91_PERIPH_C &pcfg_none	/* PA22 periph C ISI_D6, conflicts with LCDDAT22, PWMH1 */
+							 AT91_PIOA 23 AT91_PERIPH_C &pcfg_none	/* PA23 periph C ISI_D7, conflicts with LCDDAT23, PWML1 */
+							 AT91_PIOC 30 AT91_PERIPH_C &pcfg_none	/* PC30 periph C ISI_PCK, conflicts with UTXD0 */
+							 AT91_PIOA 31 AT91_PERIPH_C &pcfg_none	/* PA31 periph C ISI_HSYNC, conflicts with TWCK0, UTXD1 */
+							 AT91_PIOA 30 AT91_PERIPH_C &pcfg_none	/* PA30 periph C ISI_VSYNC, conflicts with TWD0, URXD1 */
+							 AT91_PIOC 29 AT91_PERIPH_C &pcfg_none	/* PC29 periph C ISI_PD8, conflicts with URXD0, PWMFI2 */
+							 AT91_PIOC 28 AT91_PERIPH_C &pcfg_none>;	/* PC28 periph C ISI_PD9, conflicts with SPI1_NPCS3, PWMFI0 */
 					};
 					pinctrl_isi_pck_as_mck: isi_pck_as_mck-0 {
 						atmel,pins =
-							<AT91_PIOD 31 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PD31 periph B ISI_MCK */
+							<AT91_PIOD 31 AT91_PERIPH_B &pcfg_none>;	/* PD31 periph B ISI_MCK */
 					};
 				};
 
 				lcd {
 					pinctrl_lcd: lcd-0 {
 						atmel,pins =
-							<AT91_PIOA 24 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA24 periph A LCDPWM */
-							 AT91_PIOA 26 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA26 periph A LCDVSYNC */
-							 AT91_PIOA 27 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA27 periph A LCDHSYNC */
-							 AT91_PIOA 25 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA25 periph A LCDDISP */
-							 AT91_PIOA 29 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA29 periph A LCDDEN */
-							 AT91_PIOA 28 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA28 periph A LCDPCK */
-							 AT91_PIOA 0 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA0 periph A LCDD0 pin */
-							 AT91_PIOA 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA1 periph A LCDD1 pin */
-							 AT91_PIOA 2 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA2 periph A LCDD2 pin */
-							 AT91_PIOA 3 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA3 periph A LCDD3 pin */
-							 AT91_PIOA 4 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA4 periph A LCDD4 pin */
-							 AT91_PIOA 5 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA5 periph A LCDD5 pin */
-							 AT91_PIOA 6 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA6 periph A LCDD6 pin */
-							 AT91_PIOA 7 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA7 periph A LCDD7 pin */
-							 AT91_PIOA 8 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA8 periph A LCDD8 pin */
-							 AT91_PIOA 9 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA9 periph A LCDD9 pin */
-							 AT91_PIOA 10 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA10 periph A LCDD10 pin */
-							 AT91_PIOA 11 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA11 periph A LCDD11 pin */
-							 AT91_PIOA 12 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA12 periph A LCDD12 pin */
-							 AT91_PIOA 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA13 periph A LCDD13 pin */
-							 AT91_PIOA 14 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA14 periph A LCDD14 pin */
-							 AT91_PIOA 15 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA15 periph A LCDD15 pin */
-							 AT91_PIOC 14 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC14 periph C LCDD16 pin */
-							 AT91_PIOC 13 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC13 periph C LCDD17 pin */
-							 AT91_PIOC 12 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC12 periph C LCDD18 pin */
-							 AT91_PIOC 11 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC11 periph C LCDD19 pin */
-							 AT91_PIOC 10 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC10 periph C LCDD20 pin */
-							 AT91_PIOC 15 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC15 periph C LCDD21 pin */
-							 AT91_PIOE 27 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PE27 periph C LCDD22 pin */
-							 AT91_PIOE 28 AT91_PERIPH_C AT91_PINCTRL_NONE>;	/* PE28 periph C LCDD23 pin */
+							<AT91_PIOA 24 AT91_PERIPH_A &pcfg_none	/* PA24 periph A LCDPWM */
+							 AT91_PIOA 26 AT91_PERIPH_A &pcfg_none	/* PA26 periph A LCDVSYNC */
+							 AT91_PIOA 27 AT91_PERIPH_A &pcfg_none	/* PA27 periph A LCDHSYNC */
+							 AT91_PIOA 25 AT91_PERIPH_A &pcfg_none	/* PA25 periph A LCDDISP */
+							 AT91_PIOA 29 AT91_PERIPH_A &pcfg_none	/* PA29 periph A LCDDEN */
+							 AT91_PIOA 28 AT91_PERIPH_A &pcfg_none	/* PA28 periph A LCDPCK */
+							 AT91_PIOA 0 AT91_PERIPH_A &pcfg_none	/* PA0 periph A LCDD0 pin */
+							 AT91_PIOA 1 AT91_PERIPH_A &pcfg_none	/* PA1 periph A LCDD1 pin */
+							 AT91_PIOA 2 AT91_PERIPH_A &pcfg_none	/* PA2 periph A LCDD2 pin */
+							 AT91_PIOA 3 AT91_PERIPH_A &pcfg_none	/* PA3 periph A LCDD3 pin */
+							 AT91_PIOA 4 AT91_PERIPH_A &pcfg_none	/* PA4 periph A LCDD4 pin */
+							 AT91_PIOA 5 AT91_PERIPH_A &pcfg_none	/* PA5 periph A LCDD5 pin */
+							 AT91_PIOA 6 AT91_PERIPH_A &pcfg_none	/* PA6 periph A LCDD6 pin */
+							 AT91_PIOA 7 AT91_PERIPH_A &pcfg_none	/* PA7 periph A LCDD7 pin */
+							 AT91_PIOA 8 AT91_PERIPH_A &pcfg_none	/* PA8 periph A LCDD8 pin */
+							 AT91_PIOA 9 AT91_PERIPH_A &pcfg_none	/* PA9 periph A LCDD9 pin */
+							 AT91_PIOA 10 AT91_PERIPH_A &pcfg_none	/* PA10 periph A LCDD10 pin */
+							 AT91_PIOA 11 AT91_PERIPH_A &pcfg_none	/* PA11 periph A LCDD11 pin */
+							 AT91_PIOA 12 AT91_PERIPH_A &pcfg_none	/* PA12 periph A LCDD12 pin */
+							 AT91_PIOA 13 AT91_PERIPH_A &pcfg_none	/* PA13 periph A LCDD13 pin */
+							 AT91_PIOA 14 AT91_PERIPH_A &pcfg_none	/* PA14 periph A LCDD14 pin */
+							 AT91_PIOA 15 AT91_PERIPH_A &pcfg_none	/* PA15 periph A LCDD15 pin */
+							 AT91_PIOC 14 AT91_PERIPH_C &pcfg_none	/* PC14 periph C LCDD16 pin */
+							 AT91_PIOC 13 AT91_PERIPH_C &pcfg_none	/* PC13 periph C LCDD17 pin */
+							 AT91_PIOC 12 AT91_PERIPH_C &pcfg_none	/* PC12 periph C LCDD18 pin */
+							 AT91_PIOC 11 AT91_PERIPH_C &pcfg_none	/* PC11 periph C LCDD19 pin */
+							 AT91_PIOC 10 AT91_PERIPH_C &pcfg_none	/* PC10 periph C LCDD20 pin */
+							 AT91_PIOC 15 AT91_PERIPH_C &pcfg_none	/* PC15 periph C LCDD21 pin */
+							 AT91_PIOE 27 AT91_PERIPH_C &pcfg_none	/* PE27 periph C LCDD22 pin */
+							 AT91_PIOE 28 AT91_PERIPH_C &pcfg_none>;	/* PE28 periph C LCDD23 pin */
 					};
 				};
 
 				macb0 {
 					pinctrl_macb0_data_rgmii: macb0_data_rgmii {
 						atmel,pins =
-							<AT91_PIOB 0 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB0 periph A GTX0, conflicts with PWMH0 */
-							 AT91_PIOB 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB1 periph A GTX1, conflicts with PWML0 */
-							 AT91_PIOB 2 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB2 periph A GTX2, conflicts with TK1 */
-							 AT91_PIOB 3 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB3 periph A GTX3, conflicts with TF1 */
-							 AT91_PIOB 4 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB4 periph A GRX0, conflicts with PWMH1 */
-							 AT91_PIOB 5 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB5 periph A GRX1, conflicts with PWML1 */
-							 AT91_PIOB 6 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB6 periph A GRX2, conflicts with TD1 */
-							 AT91_PIOB 7 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PB7 periph A GRX3, conflicts with RK1 */
+							<AT91_PIOB 0 AT91_PERIPH_A &pcfg_none	/* PB0 periph A GTX0, conflicts with PWMH0 */
+							 AT91_PIOB 1 AT91_PERIPH_A &pcfg_none	/* PB1 periph A GTX1, conflicts with PWML0 */
+							 AT91_PIOB 2 AT91_PERIPH_A &pcfg_none	/* PB2 periph A GTX2, conflicts with TK1 */
+							 AT91_PIOB 3 AT91_PERIPH_A &pcfg_none	/* PB3 periph A GTX3, conflicts with TF1 */
+							 AT91_PIOB 4 AT91_PERIPH_A &pcfg_none	/* PB4 periph A GRX0, conflicts with PWMH1 */
+							 AT91_PIOB 5 AT91_PERIPH_A &pcfg_none	/* PB5 periph A GRX1, conflicts with PWML1 */
+							 AT91_PIOB 6 AT91_PERIPH_A &pcfg_none	/* PB6 periph A GRX2, conflicts with TD1 */
+							 AT91_PIOB 7 AT91_PERIPH_A &pcfg_none>;	/* PB7 periph A GRX3, conflicts with RK1 */
 					};
 					pinctrl_macb0_data_gmii: macb0_data_gmii {
 						atmel,pins =
-							<AT91_PIOB 19 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB19 periph B GTX4, conflicts with MCI1_CDA */
-							 AT91_PIOB 20 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB20 periph B GTX5, conflicts with MCI1_DA0 */
-							 AT91_PIOB 21 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB21 periph B GTX6, conflicts with MCI1_DA1 */
-							 AT91_PIOB 22 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB22 periph B GTX7, conflicts with MCI1_DA2 */
-							 AT91_PIOB 23 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB23 periph B GRX4, conflicts with MCI1_DA3 */
-							 AT91_PIOB 24 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB24 periph B GRX5, conflicts with MCI1_CK */
-							 AT91_PIOB 25 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB25 periph B GRX6, conflicts with SCK1 */
-							 AT91_PIOB 26 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PB26 periph B GRX7, conflicts with CTS1 */
+							<AT91_PIOB 19 AT91_PERIPH_B &pcfg_none	/* PB19 periph B GTX4, conflicts with MCI1_CDA */
+							 AT91_PIOB 20 AT91_PERIPH_B &pcfg_none	/* PB20 periph B GTX5, conflicts with MCI1_DA0 */
+							 AT91_PIOB 21 AT91_PERIPH_B &pcfg_none	/* PB21 periph B GTX6, conflicts with MCI1_DA1 */
+							 AT91_PIOB 22 AT91_PERIPH_B &pcfg_none	/* PB22 periph B GTX7, conflicts with MCI1_DA2 */
+							 AT91_PIOB 23 AT91_PERIPH_B &pcfg_none	/* PB23 periph B GRX4, conflicts with MCI1_DA3 */
+							 AT91_PIOB 24 AT91_PERIPH_B &pcfg_none	/* PB24 periph B GRX5, conflicts with MCI1_CK */
+							 AT91_PIOB 25 AT91_PERIPH_B &pcfg_none	/* PB25 periph B GRX6, conflicts with SCK1 */
+							 AT91_PIOB 26 AT91_PERIPH_B &pcfg_none>;	/* PB26 periph B GRX7, conflicts with CTS1 */
 					};
 					pinctrl_macb0_signal_rgmii: macb0_signal_rgmii {
 						atmel,pins =
-							<AT91_PIOB 8 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB8 periph A GTXCK, conflicts with PWMH2 */
-							 AT91_PIOB 9 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB9 periph A GTXEN, conflicts with PWML2 */
-							 AT91_PIOB 11 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB11 periph A GRXCK, conflicts with RD1 */
-							 AT91_PIOB 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB13 periph A GRXER, conflicts with PWML3 */
-							 AT91_PIOB 16 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB16 periph A GMDC */
-							 AT91_PIOB 17 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB17 periph A GMDIO */
-							 AT91_PIOB 18 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PB18 periph A G125CK */
+							<AT91_PIOB 8 AT91_PERIPH_A &pcfg_none	/* PB8 periph A GTXCK, conflicts with PWMH2 */
+							 AT91_PIOB 9 AT91_PERIPH_A &pcfg_none	/* PB9 periph A GTXEN, conflicts with PWML2 */
+							 AT91_PIOB 11 AT91_PERIPH_A &pcfg_none	/* PB11 periph A GRXCK, conflicts with RD1 */
+							 AT91_PIOB 13 AT91_PERIPH_A &pcfg_none	/* PB13 periph A GRXER, conflicts with PWML3 */
+							 AT91_PIOB 16 AT91_PERIPH_A &pcfg_none	/* PB16 periph A GMDC */
+							 AT91_PIOB 17 AT91_PERIPH_A &pcfg_none	/* PB17 periph A GMDIO */
+							 AT91_PIOB 18 AT91_PERIPH_A &pcfg_none>;	/* PB18 periph A G125CK */
 					};
 					pinctrl_macb0_signal_gmii: macb0_signal_gmii {
 						atmel,pins =
-							<AT91_PIOB 9 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB9 periph A GTXEN, conflicts with PWML2 */
-							 AT91_PIOB 10 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB10 periph A GTXER, conflicts with RF1 */
-							 AT91_PIOB 11 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB11 periph A GRXCK, conflicts with RD1 */
-							 AT91_PIOB 12 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB12 periph A GRXDV, conflicts with PWMH3 */
-							 AT91_PIOB 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB13 periph A GRXER, conflicts with PWML3 */
-							 AT91_PIOB 14 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB14 periph A GCRS, conflicts with CANRX1 */
-							 AT91_PIOB 15 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB15 periph A GCOL, conflicts with CANTX1 */
-							 AT91_PIOB 16 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB16 periph A GMDC */
-							 AT91_PIOB 17 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB17 periph A GMDIO */
-							 AT91_PIOB 27 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PB27 periph B G125CKO */
+							<AT91_PIOB 9 AT91_PERIPH_A &pcfg_none	/* PB9 periph A GTXEN, conflicts with PWML2 */
+							 AT91_PIOB 10 AT91_PERIPH_A &pcfg_none	/* PB10 periph A GTXER, conflicts with RF1 */
+							 AT91_PIOB 11 AT91_PERIPH_A &pcfg_none	/* PB11 periph A GRXCK, conflicts with RD1 */
+							 AT91_PIOB 12 AT91_PERIPH_A &pcfg_none	/* PB12 periph A GRXDV, conflicts with PWMH3 */
+							 AT91_PIOB 13 AT91_PERIPH_A &pcfg_none	/* PB13 periph A GRXER, conflicts with PWML3 */
+							 AT91_PIOB 14 AT91_PERIPH_A &pcfg_none	/* PB14 periph A GCRS, conflicts with CANRX1 */
+							 AT91_PIOB 15 AT91_PERIPH_A &pcfg_none	/* PB15 periph A GCOL, conflicts with CANTX1 */
+							 AT91_PIOB 16 AT91_PERIPH_A &pcfg_none	/* PB16 periph A GMDC */
+							 AT91_PIOB 17 AT91_PERIPH_A &pcfg_none	/* PB17 periph A GMDIO */
+							 AT91_PIOB 27 AT91_PERIPH_B &pcfg_none>;	/* PB27 periph B G125CKO */
 					};
 
 				};
@@ -620,198 +637,198 @@
 				macb1 {
 					pinctrl_macb1_rmii: macb1_rmii-0 {
 						atmel,pins =
-							<AT91_PIOC 0 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC0 periph A ETX0, conflicts with TIOA3 */
-							 AT91_PIOC 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC1 periph A ETX1, conflicts with TIOB3 */
-							 AT91_PIOC 2 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC2 periph A ERX0, conflicts with TCLK3 */
-							 AT91_PIOC 3 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC3 periph A ERX1, conflicts with TIOA4 */
-							 AT91_PIOC 4 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC4 periph A ETXEN, conflicts with TIOB4 */
-							 AT91_PIOC 5 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC5 periph A ECRSDV,conflicts with TCLK4 */
-							 AT91_PIOC 6 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC6 periph A ERXER, conflicts with TIOA5 */
-							 AT91_PIOC 7 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC7 periph A EREFCK, conflicts with TIOB5 */
-							 AT91_PIOC 8 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC8 periph A EMDC, conflicts with TCLK5 */
-							 AT91_PIOC 9 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PC9 periph A EMDIO  */
+							<AT91_PIOC 0 AT91_PERIPH_A &pcfg_none	/* PC0 periph A ETX0, conflicts with TIOA3 */
+							 AT91_PIOC 1 AT91_PERIPH_A &pcfg_none	/* PC1 periph A ETX1, conflicts with TIOB3 */
+							 AT91_PIOC 2 AT91_PERIPH_A &pcfg_none	/* PC2 periph A ERX0, conflicts with TCLK3 */
+							 AT91_PIOC 3 AT91_PERIPH_A &pcfg_none	/* PC3 periph A ERX1, conflicts with TIOA4 */
+							 AT91_PIOC 4 AT91_PERIPH_A &pcfg_none	/* PC4 periph A ETXEN, conflicts with TIOB4 */
+							 AT91_PIOC 5 AT91_PERIPH_A &pcfg_none	/* PC5 periph A ECRSDV,conflicts with TCLK4 */
+							 AT91_PIOC 6 AT91_PERIPH_A &pcfg_none	/* PC6 periph A ERXER, conflicts with TIOA5 */
+							 AT91_PIOC 7 AT91_PERIPH_A &pcfg_none	/* PC7 periph A EREFCK, conflicts with TIOB5 */
+							 AT91_PIOC 8 AT91_PERIPH_A &pcfg_none	/* PC8 periph A EMDC, conflicts with TCLK5 */
+							 AT91_PIOC 9 AT91_PERIPH_A &pcfg_none>;	/* PC9 periph A EMDIO  */
 					};
 				};
 
 				mmc0 {
 					pinctrl_mmc0_clk_cmd_dat0: mmc0_clk_cmd_dat0 {
 						atmel,pins =
-							<AT91_PIOD 9 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PD9 periph A MCI0_CK */
-							 AT91_PIOD 0 AT91_PERIPH_A AT91_PINCTRL_PULL_UP	/* PD0 periph A MCI0_CDA with pullup */
-							 AT91_PIOD 1 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;	/* PD1 periph A MCI0_DA0 with pullup */
+							<AT91_PIOD 9 AT91_PERIPH_A &pcfg_none	/* PD9 periph A MCI0_CK */
+							 AT91_PIOD 0 AT91_PERIPH_A &pcfg_pull_up	/* PD0 periph A MCI0_CDA with pullup */
+							 AT91_PIOD 1 AT91_PERIPH_A &pcfg_pull_up>;	/* PD1 periph A MCI0_DA0 with pullup */
 					};
 					pinctrl_mmc0_dat1_3: mmc0_dat1_3 {
 						atmel,pins =
-							<AT91_PIOD 2 AT91_PERIPH_A AT91_PINCTRL_PULL_UP	/* PD2 periph A MCI0_DA1 with pullup */
-							 AT91_PIOD 3 AT91_PERIPH_A AT91_PINCTRL_PULL_UP	/* PD3 periph A MCI0_DA2 with pullup */
-							 AT91_PIOD 4 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;	/* PD4 periph A MCI0_DA3 with pullup */
+							<AT91_PIOD 2 AT91_PERIPH_A &pcfg_pull_up	/* PD2 periph A MCI0_DA1 with pullup */
+							 AT91_PIOD 3 AT91_PERIPH_A &pcfg_pull_up	/* PD3 periph A MCI0_DA2 with pullup */
+							 AT91_PIOD 4 AT91_PERIPH_A &pcfg_pull_up>;	/* PD4 periph A MCI0_DA3 with pullup */
 					};
 					pinctrl_mmc0_dat4_7: mmc0_dat4_7 {
 						atmel,pins =
-							<AT91_PIOD 5 AT91_PERIPH_A AT91_PINCTRL_PULL_UP	/* PD5 periph A MCI0_DA4 with pullup, conflicts with TIOA0, PWMH2 */
-							 AT91_PIOD 6 AT91_PERIPH_A AT91_PINCTRL_PULL_UP	/* PD6 periph A MCI0_DA5 with pullup, conflicts with TIOB0, PWML2 */
-							 AT91_PIOD 7 AT91_PERIPH_A AT91_PINCTRL_PULL_UP	/* PD7 periph A MCI0_DA6 with pullup, conlicts with TCLK0, PWMH3 */
-							 AT91_PIOD 8 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;	/* PD8 periph A MCI0_DA7 with pullup, conflicts with PWML3 */
+							<AT91_PIOD 5 AT91_PERIPH_A &pcfg_pull_up	/* PD5 periph A MCI0_DA4 with pullup, conflicts with TIOA0, PWMH2 */
+							 AT91_PIOD 6 AT91_PERIPH_A &pcfg_pull_up	/* PD6 periph A MCI0_DA5 with pullup, conflicts with TIOB0, PWML2 */
+							 AT91_PIOD 7 AT91_PERIPH_A &pcfg_pull_up	/* PD7 periph A MCI0_DA6 with pullup, conlicts with TCLK0, PWMH3 */
+							 AT91_PIOD 8 AT91_PERIPH_A &pcfg_pull_up>;	/* PD8 periph A MCI0_DA7 with pullup, conflicts with PWML3 */
 					};
 				};
 
 				mmc1 {
 					pinctrl_mmc1_clk_cmd_dat0: mmc1_clk_cmd_dat0 {
 						atmel,pins =
-							<AT91_PIOB 24 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB24 periph A MCI1_CK, conflicts with GRX5 */
-							 AT91_PIOB 19 AT91_PERIPH_A AT91_PINCTRL_PULL_UP	/* PB19 periph A MCI1_CDA with pullup, conflicts with GTX4 */
-							 AT91_PIOB 20 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;	/* PB20 periph A MCI1_DA0 with pullup, conflicts with GTX5 */
+							<AT91_PIOB 24 AT91_PERIPH_A &pcfg_none	/* PB24 periph A MCI1_CK, conflicts with GRX5 */
+							 AT91_PIOB 19 AT91_PERIPH_A &pcfg_pull_up	/* PB19 periph A MCI1_CDA with pullup, conflicts with GTX4 */
+							 AT91_PIOB 20 AT91_PERIPH_A &pcfg_pull_up>;	/* PB20 periph A MCI1_DA0 with pullup, conflicts with GTX5 */
 					};
 					pinctrl_mmc1_dat1_3: mmc1_dat1_3 {
 						atmel,pins =
-							<AT91_PIOB 21 AT91_PERIPH_A AT91_PINCTRL_PULL_UP	/* PB21 periph A MCI1_DA1 with pullup, conflicts with GTX6 */
-							 AT91_PIOB 22 AT91_PERIPH_A AT91_PINCTRL_PULL_UP	/* PB22 periph A MCI1_DA2 with pullup, conflicts with GTX7 */
-							 AT91_PIOB 23 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;	/* PB23 periph A MCI1_DA3 with pullup, conflicts with GRX4 */
+							<AT91_PIOB 21 AT91_PERIPH_A &pcfg_pull_up	/* PB21 periph A MCI1_DA1 with pullup, conflicts with GTX6 */
+							 AT91_PIOB 22 AT91_PERIPH_A &pcfg_pull_up	/* PB22 periph A MCI1_DA2 with pullup, conflicts with GTX7 */
+							 AT91_PIOB 23 AT91_PERIPH_A &pcfg_pull_up>;	/* PB23 periph A MCI1_DA3 with pullup, conflicts with GRX4 */
 					};
 				};
 
 				mmc2 {
 					pinctrl_mmc2_clk_cmd_dat0: mmc2_clk_cmd_dat0 {
 						atmel,pins =
-							<AT91_PIOC 15 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC15 periph A MCI2_CK, conflicts with PCK2 */
-							 AT91_PIOC 10 AT91_PERIPH_A AT91_PINCTRL_PULL_UP	/* PC10 periph A MCI2_CDA with pullup */
-							 AT91_PIOC 11 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;	/* PC11 periph A MCI2_DA0 with pullup */
+							<AT91_PIOC 15 AT91_PERIPH_A &pcfg_none	/* PC15 periph A MCI2_CK, conflicts with PCK2 */
+							 AT91_PIOC 10 AT91_PERIPH_A &pcfg_pull_up	/* PC10 periph A MCI2_CDA with pullup */
+							 AT91_PIOC 11 AT91_PERIPH_A &pcfg_pull_up>;	/* PC11 periph A MCI2_DA0 with pullup */
 					};
 					pinctrl_mmc2_dat1_3: mmc2_dat1_3 {
 						atmel,pins =
-							<AT91_PIOC 12 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC12 periph A MCI2_DA1 with pullup, conflicts with TIOA1 */
-							 AT91_PIOC 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC13 periph A MCI2_DA2 with pullup, conflicts with TIOB1 */
-							 AT91_PIOC 14 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PC14 periph A MCI2_DA3 with pullup, conflicts with TCLK1 */
+							<AT91_PIOC 12 AT91_PERIPH_A &pcfg_none	/* PC12 periph A MCI2_DA1 with pullup, conflicts with TIOA1 */
+							 AT91_PIOC 13 AT91_PERIPH_A &pcfg_none	/* PC13 periph A MCI2_DA2 with pullup, conflicts with TIOB1 */
+							 AT91_PIOC 14 AT91_PERIPH_A &pcfg_none>;	/* PC14 periph A MCI2_DA3 with pullup, conflicts with TCLK1 */
 					};
 				};
 
 				nand0 {
 					pinctrl_nand0_ale_cle: nand0_ale_cle-0 {
 						atmel,pins =
-							<AT91_PIOE 21 AT91_PERIPH_A AT91_PINCTRL_PULL_UP	/* PE21 periph A with pullup */
-							 AT91_PIOE 22 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;	/* PE22 periph A with pullup */
+							<AT91_PIOE 21 AT91_PERIPH_A &pcfg_pull_up	/* PE21 periph A with pullup */
+							 AT91_PIOE 22 AT91_PERIPH_A &pcfg_pull_up>;	/* PE22 periph A with pullup */
 					};
 				};
 
 				spi0 {
 					pinctrl_spi0: spi0-0 {
 						atmel,pins =
-							<AT91_PIOD 10 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PD10 periph A SPI0_MISO pin */
-							 AT91_PIOD 11 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PD11 periph A SPI0_MOSI pin */
-							 AT91_PIOD 12 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PD12 periph A SPI0_SPCK pin */
+							<AT91_PIOD 10 AT91_PERIPH_A &pcfg_none	/* PD10 periph A SPI0_MISO pin */
+							 AT91_PIOD 11 AT91_PERIPH_A &pcfg_none	/* PD11 periph A SPI0_MOSI pin */
+							 AT91_PIOD 12 AT91_PERIPH_A &pcfg_none>;	/* PD12 periph A SPI0_SPCK pin */
 					};
 				};
 
 				spi1 {
 					pinctrl_spi1: spi1-0 {
 						atmel,pins =
-							<AT91_PIOC 22 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC22 periph A SPI1_MISO pin */
-							 AT91_PIOC 23 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC23 periph A SPI1_MOSI pin */
-							 AT91_PIOC 24 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PC24 periph A SPI1_SPCK pin */
+							<AT91_PIOC 22 AT91_PERIPH_A &pcfg_none	/* PC22 periph A SPI1_MISO pin */
+							 AT91_PIOC 23 AT91_PERIPH_A &pcfg_none	/* PC23 periph A SPI1_MOSI pin */
+							 AT91_PIOC 24 AT91_PERIPH_A &pcfg_none>;	/* PC24 periph A SPI1_SPCK pin */
 					};
 				};
 
 				ssc0 {
 					pinctrl_ssc0_tx: ssc0_tx {
 						atmel,pins =
-							<AT91_PIOC 16 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC16 periph A TK0 */
-							 AT91_PIOC 17 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC17 periph A TF0 */
-							 AT91_PIOC 18 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PC18 periph A TD0 */
+							<AT91_PIOC 16 AT91_PERIPH_A &pcfg_none	/* PC16 periph A TK0 */
+							 AT91_PIOC 17 AT91_PERIPH_A &pcfg_none	/* PC17 periph A TF0 */
+							 AT91_PIOC 18 AT91_PERIPH_A &pcfg_none>;	/* PC18 periph A TD0 */
 					};
 
 					pinctrl_ssc0_rx: ssc0_rx {
 						atmel,pins =
-							<AT91_PIOC 19 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC19 periph A RK0 */
-							 AT91_PIOC 20 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC20 periph A RF0 */
-							 AT91_PIOC 21 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PC21 periph A RD0 */
+							<AT91_PIOC 19 AT91_PERIPH_A &pcfg_none	/* PC19 periph A RK0 */
+							 AT91_PIOC 20 AT91_PERIPH_A &pcfg_none	/* PC20 periph A RF0 */
+							 AT91_PIOC 21 AT91_PERIPH_A &pcfg_none>;	/* PC21 periph A RD0 */
 					};
 				};
 
 				ssc1 {
 					pinctrl_ssc1_tx: ssc1_tx {
 						atmel,pins =
-							<AT91_PIOB 2 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB2 periph B TK1, conflicts with GTX2 */
-							 AT91_PIOB 3 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB3 periph B TF1, conflicts with GTX3 */
-							 AT91_PIOB 6 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PB6 periph B TD1, conflicts with TD1 */
+							<AT91_PIOB 2 AT91_PERIPH_B &pcfg_none	/* PB2 periph B TK1, conflicts with GTX2 */
+							 AT91_PIOB 3 AT91_PERIPH_B &pcfg_none	/* PB3 periph B TF1, conflicts with GTX3 */
+							 AT91_PIOB 6 AT91_PERIPH_B &pcfg_none>;	/* PB6 periph B TD1, conflicts with TD1 */
 					};
 
 					pinctrl_ssc1_rx: ssc1_rx {
 						atmel,pins =
-							<AT91_PIOB 7 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB7 periph B RK1, conflicts with EREFCK */
-							 AT91_PIOB 10 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB10 periph B RF1, conflicts with GTXER */
-							 AT91_PIOB 11 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PB11 periph B RD1, conflicts with GRXCK */
+							<AT91_PIOB 7 AT91_PERIPH_B &pcfg_none	/* PB7 periph B RK1, conflicts with EREFCK */
+							 AT91_PIOB 10 AT91_PERIPH_B &pcfg_none	/* PB10 periph B RF1, conflicts with GTXER */
+							 AT91_PIOB 11 AT91_PERIPH_B &pcfg_none>;	/* PB11 periph B RD1, conflicts with GRXCK */
 					};
 				};
 
 				uart0 {
 					pinctrl_uart0: uart0-0 {
 						atmel,pins =
-							<AT91_PIOC 29 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC29 periph A, conflicts with PWMFI2, ISI_D8 */
-							 AT91_PIOC 30 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;	/* PC30 periph A with pullup, conflicts with ISI_PCK */
+							<AT91_PIOC 29 AT91_PERIPH_A &pcfg_none	/* PC29 periph A, conflicts with PWMFI2, ISI_D8 */
+							 AT91_PIOC 30 AT91_PERIPH_A &pcfg_pull_up>;	/* PC30 periph A with pullup, conflicts with ISI_PCK */
 					};
 				};
 
 				uart1 {
 					pinctrl_uart1: uart1-0 {
 						atmel,pins =
-							<AT91_PIOA 30 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PA30 periph B, conflicts with TWD0, ISI_VSYNC */
-							 AT91_PIOA 31 AT91_PERIPH_B AT91_PINCTRL_PULL_UP>;	/* PA31 periph B with pullup, conflicts with TWCK0, ISI_HSYNC */
+							<AT91_PIOA 30 AT91_PERIPH_B &pcfg_none	/* PA30 periph B, conflicts with TWD0, ISI_VSYNC */
+							 AT91_PIOA 31 AT91_PERIPH_B &pcfg_pull_up>;	/* PA31 periph B with pullup, conflicts with TWCK0, ISI_HSYNC */
 					};
 				};
 
 				usart0 {
 					pinctrl_usart0: usart0-0 {
 						atmel,pins =
-							<AT91_PIOD 17 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PD17 periph A */
-							 AT91_PIOD 18 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;	/* PD18 periph A with pullup */
+							<AT91_PIOD 17 AT91_PERIPH_A &pcfg_none	/* PD17 periph A */
+							 AT91_PIOD 18 AT91_PERIPH_A &pcfg_pull_up>;	/* PD18 periph A with pullup */
 					};
 
 					pinctrl_usart0_rts_cts: usart0_rts_cts-0 {
 						atmel,pins =
-							<AT91_PIOD 15 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PD15 periph A, conflicts with SPI0_NPCS2, CANTX0 */
-							 AT91_PIOD 16 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PD16 periph A, conflicts with SPI0_NPCS3, PWMFI3 */
+							<AT91_PIOD 15 AT91_PERIPH_A &pcfg_none	/* PD15 periph A, conflicts with SPI0_NPCS2, CANTX0 */
+							 AT91_PIOD 16 AT91_PERIPH_A &pcfg_none>;	/* PD16 periph A, conflicts with SPI0_NPCS3, PWMFI3 */
 					};
 				};
 
 				usart1 {
 					pinctrl_usart1: usart1-0 {
 						atmel,pins =
-							<AT91_PIOB 28 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB28 periph A */
-							 AT91_PIOB 29 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;	/* PB29 periph A with pullup */
+							<AT91_PIOB 28 AT91_PERIPH_A &pcfg_none	/* PB28 periph A */
+							 AT91_PIOB 29 AT91_PERIPH_A &pcfg_pull_up>;	/* PB29 periph A with pullup */
 					};
 
 					pinctrl_usart1_rts_cts: usart1_rts_cts-0 {
 						atmel,pins =
-							<AT91_PIOB 26 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB26 periph A, conflicts with GRX7 */
-							 AT91_PIOB 27 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PB27 periph A, conflicts with G125CKO */
+							<AT91_PIOB 26 AT91_PERIPH_A &pcfg_none	/* PB26 periph A, conflicts with GRX7 */
+							 AT91_PIOB 27 AT91_PERIPH_A &pcfg_none>;	/* PB27 periph A, conflicts with G125CKO */
 					};
 				};
 
 				usart2 {
 					pinctrl_usart2: usart2-0 {
 						atmel,pins =
-							<AT91_PIOE 25 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PE25 periph B, conflicts with A25 */
-							 AT91_PIOE 26 AT91_PERIPH_B AT91_PINCTRL_PULL_UP>;	/* PE26 periph B with pullup, conflicts NCS0 */
+							<AT91_PIOE 25 AT91_PERIPH_B &pcfg_none	/* PE25 periph B, conflicts with A25 */
+							 AT91_PIOE 26 AT91_PERIPH_B &pcfg_pull_up>;	/* PE26 periph B with pullup, conflicts NCS0 */
 					};
 
 					pinctrl_usart2_rts_cts: usart2_rts_cts-0 {
 						atmel,pins =
-							<AT91_PIOE 23 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PE23 periph B, conflicts with A23 */
-							 AT91_PIOE 24 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PE24 periph B, conflicts with A24 */
+							<AT91_PIOE 23 AT91_PERIPH_B &pcfg_none	/* PE23 periph B, conflicts with A23 */
+							 AT91_PIOE 24 AT91_PERIPH_B &pcfg_none>;	/* PE24 periph B, conflicts with A24 */
 					};
 				};
 
 				usart3 {
 					pinctrl_usart3: usart3-0 {
 						atmel,pins =
-							<AT91_PIOE 18 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PE18 periph B, conflicts with A18 */
-							 AT91_PIOE 19 AT91_PERIPH_B AT91_PINCTRL_PULL_UP>;	/* PE19 periph B with pullup, conflicts with A19 */
+							<AT91_PIOE 18 AT91_PERIPH_B &pcfg_none	/* PE18 periph B, conflicts with A18 */
+							 AT91_PIOE 19 AT91_PERIPH_B &pcfg_pull_up>;	/* PE19 periph B with pullup, conflicts with A19 */
 					};
 
 					pinctrl_usart3_rts_cts: usart3_rts_cts-0 {
 						atmel,pins =
-							<AT91_PIOE 16 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PE16 periph B, conflicts with A16 */
-							 AT91_PIOE 17 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PE17 periph B, conflicts with A17 */
+							<AT91_PIOE 16 AT91_PERIPH_B &pcfg_none	/* PE16 periph B, conflicts with A16 */
+							 AT91_PIOE 17 AT91_PERIPH_B &pcfg_none>;	/* PE17 periph B, conflicts with A17 */
 					};
 				};
 
diff --git a/arch/arm/boot/dts/sama5d3xdm.dtsi b/arch/arm/boot/dts/sama5d3xdm.dtsi
index 1c296d6..a8d5f77 100644
--- a/arch/arm/boot/dts/sama5d3xdm.dtsi
+++ b/arch/arm/boot/dts/sama5d3xdm.dtsi
@@ -33,7 +33,7 @@
 				board {
 					pinctrl_qt1070_irq: qt1070_irq {
 						atmel,pins =
-							<AT91_PIOE 31 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP_DEGLITCH>; /* PE31 GPIO with pull up deglith */
+							<AT91_PIOE 31 AT91_PERIPH_GPIO &pcfg_pull_up_deglitch>; /* PE31 GPIO with pull up deglith */
 					};
 				};
 			};
diff --git a/arch/arm/boot/dts/sama5d3xmb.dtsi b/arch/arm/boot/dts/sama5d3xmb.dtsi
index 8a9e05d..126a3a8 100644
--- a/arch/arm/boot/dts/sama5d3xmb.dtsi
+++ b/arch/arm/boot/dts/sama5d3xmb.dtsi
@@ -87,32 +87,32 @@
 				board {
 					pinctrl_mmc0_cd: mmc0_cd {
 						atmel,pins =
-							<AT91_PIOD 17 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP_DEGLITCH>; /* PD17 GPIO with pullup deglitch */
+							<AT91_PIOD 17 AT91_PERIPH_GPIO &pcfg_pull_up_deglitch>; /* PD17 GPIO with pullup deglitch */
 					};
 
 					pinctrl_mmc1_cd: mmc1_cd {
 						atmel,pins =
-							<AT91_PIOD 18 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP_DEGLITCH>; /* PD18 GPIO with pullup deglitch */
+							<AT91_PIOD 18 AT91_PERIPH_GPIO &pcfg_pull_up_deglitch>; /* PD18 GPIO with pullup deglitch */
 					};
 
 					pinctrl_pck0_as_audio_mck: pck0_as_audio_mck {
 						atmel,pins =
-							<AT91_PIOD 30 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PD30 periph B */
+							<AT91_PIOD 30 AT91_PERIPH_B &pcfg_none>;	/* PD30 periph B */
 					};
 
 					pinctrl_isi_reset: isi_reset-0 {
 						atmel,pins =
-							<AT91_PIOE 24 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;   /* PE24 gpio */
+							<AT91_PIOE 24 AT91_PERIPH_GPIO &pcfg_none>;   /* PE24 gpio */
 					};
 
 					pinctrl_isi_power: isi_power-0 {
 						atmel,pins =
-							<AT91_PIOE 29 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>; /* PE29 gpio */
+							<AT91_PIOE 29 AT91_PERIPH_GPIO &pcfg_none>; /* PE29 gpio */
 					};
 
 					pinctrl_usba_vbus: usba_vbus {
 						atmel,pins =
-							<AT91_PIOD 29 AT91_PERIPH_GPIO AT91_PINCTRL_DEGLITCH>; /* PD29 GPIO with deglitch */
+							<AT91_PIOD 29 AT91_PERIPH_GPIO &pcfg_deglitch>; /* PD29 GPIO with deglitch */
 					};
 				};
 			};
-- 
1.7.9.5

