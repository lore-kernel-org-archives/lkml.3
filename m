Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870Ab3HHORJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 10:17:09 -0400
Received: from 6.mo2.mail-out.ovh.net ([87.98.165.38]:60216 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757845Ab3HHORG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 10:17:06 -0400
Date: Thu, 8 Aug 2013 16:10:45 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH] ARM: at91/dt: split sama5d3 definition
Message-ID: <20130808141045.GB18627@ns203013.ovh.net>
References: <1375865341-8974-1-git-send-email-b.brezillon@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375865341-8974-1-git-send-email-b.brezillon@overkiz.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 12024892481921657721
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrtdeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrtdeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:49 Wed 07 Aug     , Boris BREZILLON wrote:
> This patch splits the sama5d3 SoCs definition:
> - a common base for all sama5d3 SoCs (sama5d3.dtsi)
> - several optional peripheral definitions which will be included by sama5d3
>   specific SoCs (sama5d3_'periph name'.dtsi)
> - sama5d3 specific SoC definitions (sama5d3x.dtsi)
> 
> This provides a better representation of the real hardware (drop unneed
> dt nodes) and avoids peripheral id conflict (which is not the case for
> current sama5d3 SoCs, but could be if other SoCs of this family are
> released).

same comment as the other patch

too much file for no real advantage so no for me

Best Regards,
J.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
>  arch/arm/boot/dts/sama5d3.dtsi      |  203 -----------------------------------
>  arch/arm/boot/dts/sama5d31.dtsi     |   16 +++
>  arch/arm/boot/dts/sama5d31ek.dts    |    3 +-
>  arch/arm/boot/dts/sama5d33.dtsi     |   14 +++
>  arch/arm/boot/dts/sama5d33ek.dts    |    1 +
>  arch/arm/boot/dts/sama5d34.dtsi     |   16 +++
>  arch/arm/boot/dts/sama5d34ek.dts    |    1 +
>  arch/arm/boot/dts/sama5d35.dtsi     |   18 ++++
>  arch/arm/boot/dts/sama5d35ek.dts    |    1 +
>  arch/arm/boot/dts/sama5d3_can.dtsi  |   54 ++++++++++
>  arch/arm/boot/dts/sama5d3_emac.dtsi |   44 ++++++++
>  arch/arm/boot/dts/sama5d3_gmac.dtsi |   77 +++++++++++++
>  arch/arm/boot/dts/sama5d3_lcd.dtsi  |   55 ++++++++++
>  arch/arm/boot/dts/sama5d3_mci2.dtsi |   47 ++++++++
>  arch/arm/boot/dts/sama5d3_tcb1.dtsi |   27 +++++
>  arch/arm/boot/dts/sama5d3_uart.dtsi |   53 +++++++++
>  arch/arm/boot/dts/sama5d3xcm.dtsi   |    1 -
>  17 files changed, 426 insertions(+), 205 deletions(-)
>  create mode 100644 arch/arm/boot/dts/sama5d31.dtsi
>  create mode 100644 arch/arm/boot/dts/sama5d33.dtsi
>  create mode 100644 arch/arm/boot/dts/sama5d34.dtsi
>  create mode 100644 arch/arm/boot/dts/sama5d35.dtsi
>  create mode 100644 arch/arm/boot/dts/sama5d3_can.dtsi
>  create mode 100644 arch/arm/boot/dts/sama5d3_emac.dtsi
>  create mode 100644 arch/arm/boot/dts/sama5d3_gmac.dtsi
>  create mode 100644 arch/arm/boot/dts/sama5d3_lcd.dtsi
>  create mode 100644 arch/arm/boot/dts/sama5d3_mci2.dtsi
>  create mode 100644 arch/arm/boot/dts/sama5d3_tcb1.dtsi
>  create mode 100644 arch/arm/boot/dts/sama5d3_uart.dtsi
> 
> diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
> index a1d5e25..b72f310 100644
> --- a/arch/arm/boot/dts/sama5d3.dtsi
> +++ b/arch/arm/boot/dts/sama5d3.dtsi
> @@ -31,7 +31,6 @@
>  		gpio3 = &pioD;
>  		gpio4 = &pioE;
>  		tcb0 = &tcb0;
> -		tcb1 = &tcb1;
>  		i2c0 = &i2c0;
>  		i2c1 = &i2c1;
>  		i2c2 = &i2c2;
> @@ -100,15 +99,6 @@
>  				status = "disabled";
>  			};
>  
> -			can0: can@f000c000 {
> -				compatible = "atmel,at91sam9x5-can";
> -				reg = <0xf000c000 0x300>;
> -				interrupts = <40 IRQ_TYPE_LEVEL_HIGH 3>;
> -				pinctrl-names = "default";
> -				pinctrl-0 = <&pinctrl_can0_rx_tx>;
> -				status = "disabled";
> -			};
> -
>  			tcb0: timer@f0010000 {
>  				compatible = "atmel,at91sam9x5-tcb";
>  				reg = <0xf0010000 0x100>;
> @@ -161,15 +151,6 @@
>  				status = "disabled";
>  			};
>  
> -			macb0: ethernet@f0028000 {
> -				compatible = "cdns,pc302-gem", "cdns,gem";
> -				reg = <0xf0028000 0x100>;
> -				interrupts = <34 IRQ_TYPE_LEVEL_HIGH 3>;
> -				pinctrl-names = "default";
> -				pinctrl-0 = <&pinctrl_macb0_data_rgmii &pinctrl_macb0_signal_rgmii>;
> -				status = "disabled";
> -			};
> -
>  			isi: isi@f0034000 {
>  				compatible = "atmel,at91sam9g45-isi";
>  				reg = <0xf0034000 0x4000>;
> @@ -190,19 +171,6 @@
>  				#size-cells = <0>;
>  			};
>  
> -			mmc2: mmc@f8004000 {
> -				compatible = "atmel,hsmci";
> -				reg = <0xf8004000 0x600>;
> -				interrupts = <23 IRQ_TYPE_LEVEL_HIGH 0>;
> -				dmas = <&dma1 2 AT91_DMA_CFG_PER_ID(1)>;
> -				dma-names = "rxtx";
> -				pinctrl-names = "default";
> -				pinctrl-0 = <&pinctrl_mmc2_clk_cmd_dat0 &pinctrl_mmc2_dat1_3>;
> -				status = "disabled";
> -				#address-cells = <1>;
> -				#size-cells = <0>;
> -			};
> -
>  			spi1: spi@f8008000 {
>  				#address-cells = <1>;
>  				#size-cells = <0>;
> @@ -226,20 +194,6 @@
>  				status = "disabled";
>  			};
>  
> -			can1: can@f8010000 {
> -				compatible = "atmel,at91sam9x5-can";
> -				reg = <0xf8010000 0x300>;
> -				interrupts = <41 IRQ_TYPE_LEVEL_HIGH 3>;
> -				pinctrl-names = "default";
> -				pinctrl-0 = <&pinctrl_can1_rx_tx>;
> -			};
> -
> -			tcb1: timer@f8014000 {
> -				compatible = "atmel,at91sam9x5-tcb";
> -				reg = <0xf8014000 0x100>;
> -				interrupts = <27 IRQ_TYPE_LEVEL_HIGH 0>;
> -			};
> -
>  			adc0: adc@f8018000 {
>  				compatible = "atmel,at91sam9260-adc";
>  				reg = <0xf8018000 0x100>;
> @@ -336,15 +290,6 @@
>  				status = "disabled";
>  			};
>  
> -			macb1: ethernet@f802c000 {
> -				compatible = "cdns,at32ap7000-macb", "cdns,macb";
> -				reg = <0xf802c000 0x100>;
> -				interrupts = <35 IRQ_TYPE_LEVEL_HIGH 3>;
> -				pinctrl-names = "default";
> -				pinctrl-0 = <&pinctrl_macb1_rmii>;
> -				status = "disabled";
> -			};
> -
>  			sha@f8034000 {
>  				compatible = "atmel,sam9g46-sha";
>  				reg = <0xf8034000 0x100>;
> @@ -469,22 +414,6 @@
>  					};
>  				};
>  
> -				can0 {
> -					pinctrl_can0_rx_tx: can0_rx_tx {
> -						atmel,pins =
> -							<AT91_PIOD 14 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PD14 periph C RX, conflicts with SCK0, SPI0_NPCS1 */
> -							 AT91_PIOD 15 AT91_PERIPH_C AT91_PINCTRL_NONE>;	/* PD15 periph C TX, conflicts with CTS0, SPI0_NPCS2 */
> -					};
> -				};
> -
> -				can1 {
> -					pinctrl_can1_rx_tx: can1_rx_tx {
> -						atmel,pins =
> -							<AT91_PIOB 14 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB14 periph B RX, conflicts with GCRS */
> -							 AT91_PIOB 15 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PB15 periph B TX, conflicts with GCOL */
> -					};
> -				};
> -
>  				dbgu {
>  					pinctrl_dbgu: dbgu-0 {
>  						atmel,pins =
> @@ -532,107 +461,6 @@
>  					};
>  				};
>  
> -				lcd {
> -					pinctrl_lcd: lcd-0 {
> -						atmel,pins =
> -							<AT91_PIOA 24 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA24 periph A LCDPWM */
> -							 AT91_PIOA 26 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA26 periph A LCDVSYNC */
> -							 AT91_PIOA 27 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA27 periph A LCDHSYNC */
> -							 AT91_PIOA 25 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA25 periph A LCDDISP */
> -							 AT91_PIOA 29 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA29 periph A LCDDEN */
> -							 AT91_PIOA 28 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA28 periph A LCDPCK */
> -							 AT91_PIOA 0 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA0 periph A LCDD0 pin */
> -							 AT91_PIOA 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA1 periph A LCDD1 pin */
> -							 AT91_PIOA 2 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA2 periph A LCDD2 pin */
> -							 AT91_PIOA 3 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA3 periph A LCDD3 pin */
> -							 AT91_PIOA 4 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA4 periph A LCDD4 pin */
> -							 AT91_PIOA 5 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA5 periph A LCDD5 pin */
> -							 AT91_PIOA 6 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA6 periph A LCDD6 pin */
> -							 AT91_PIOA 7 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA7 periph A LCDD7 pin */
> -							 AT91_PIOA 8 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA8 periph A LCDD8 pin */
> -							 AT91_PIOA 9 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA9 periph A LCDD9 pin */
> -							 AT91_PIOA 10 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA10 periph A LCDD10 pin */
> -							 AT91_PIOA 11 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA11 periph A LCDD11 pin */
> -							 AT91_PIOA 12 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA12 periph A LCDD12 pin */
> -							 AT91_PIOA 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA13 periph A LCDD13 pin */
> -							 AT91_PIOA 14 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA14 periph A LCDD14 pin */
> -							 AT91_PIOA 15 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA15 periph A LCDD15 pin */
> -							 AT91_PIOC 14 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC14 periph C LCDD16 pin */
> -							 AT91_PIOC 13 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC13 periph C LCDD17 pin */
> -							 AT91_PIOC 12 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC12 periph C LCDD18 pin */
> -							 AT91_PIOC 11 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC11 periph C LCDD19 pin */
> -							 AT91_PIOC 10 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC10 periph C LCDD20 pin */
> -							 AT91_PIOC 15 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC15 periph C LCDD21 pin */
> -							 AT91_PIOE 27 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PE27 periph C LCDD22 pin */
> -							 AT91_PIOE 28 AT91_PERIPH_C AT91_PINCTRL_NONE>;	/* PE28 periph C LCDD23 pin */
> -					};
> -				};
> -
> -				macb0 {
> -					pinctrl_macb0_data_rgmii: macb0_data_rgmii {
> -						atmel,pins =
> -							<AT91_PIOB 0 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB0 periph A GTX0, conflicts with PWMH0 */
> -							 AT91_PIOB 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB1 periph A GTX1, conflicts with PWML0 */
> -							 AT91_PIOB 2 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB2 periph A GTX2, conflicts with TK1 */
> -							 AT91_PIOB 3 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB3 periph A GTX3, conflicts with TF1 */
> -							 AT91_PIOB 4 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB4 periph A GRX0, conflicts with PWMH1 */
> -							 AT91_PIOB 5 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB5 periph A GRX1, conflicts with PWML1 */
> -							 AT91_PIOB 6 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB6 periph A GRX2, conflicts with TD1 */
> -							 AT91_PIOB 7 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PB7 periph A GRX3, conflicts with RK1 */
> -					};
> -					pinctrl_macb0_data_gmii: macb0_data_gmii {
> -						atmel,pins =
> -							<AT91_PIOB 19 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB19 periph B GTX4, conflicts with MCI1_CDA */
> -							 AT91_PIOB 20 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB20 periph B GTX5, conflicts with MCI1_DA0 */
> -							 AT91_PIOB 21 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB21 periph B GTX6, conflicts with MCI1_DA1 */
> -							 AT91_PIOB 22 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB22 periph B GTX7, conflicts with MCI1_DA2 */
> -							 AT91_PIOB 23 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB23 periph B GRX4, conflicts with MCI1_DA3 */
> -							 AT91_PIOB 24 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB24 periph B GRX5, conflicts with MCI1_CK */
> -							 AT91_PIOB 25 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB25 periph B GRX6, conflicts with SCK1 */
> -							 AT91_PIOB 26 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PB26 periph B GRX7, conflicts with CTS1 */
> -					};
> -					pinctrl_macb0_signal_rgmii: macb0_signal_rgmii {
> -						atmel,pins =
> -							<AT91_PIOB 8 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB8 periph A GTXCK, conflicts with PWMH2 */
> -							 AT91_PIOB 9 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB9 periph A GTXEN, conflicts with PWML2 */
> -							 AT91_PIOB 11 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB11 periph A GRXCK, conflicts with RD1 */
> -							 AT91_PIOB 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB13 periph A GRXER, conflicts with PWML3 */
> -							 AT91_PIOB 16 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB16 periph A GMDC */
> -							 AT91_PIOB 17 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB17 periph A GMDIO */
> -							 AT91_PIOB 18 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PB18 periph A G125CK */
> -					};
> -					pinctrl_macb0_signal_gmii: macb0_signal_gmii {
> -						atmel,pins =
> -							<AT91_PIOB 9 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB9 periph A GTXEN, conflicts with PWML2 */
> -							 AT91_PIOB 10 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB10 periph A GTXER, conflicts with RF1 */
> -							 AT91_PIOB 11 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB11 periph A GRXCK, conflicts with RD1 */
> -							 AT91_PIOB 12 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB12 periph A GRXDV, conflicts with PWMH3 */
> -							 AT91_PIOB 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB13 periph A GRXER, conflicts with PWML3 */
> -							 AT91_PIOB 14 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB14 periph A GCRS, conflicts with CANRX1 */
> -							 AT91_PIOB 15 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB15 periph A GCOL, conflicts with CANTX1 */
> -							 AT91_PIOB 16 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB16 periph A GMDC */
> -							 AT91_PIOB 17 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB17 periph A GMDIO */
> -							 AT91_PIOB 27 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PB27 periph B G125CKO */
> -					};
> -
> -				};
> -
> -				macb1 {
> -					pinctrl_macb1_rmii: macb1_rmii-0 {
> -						atmel,pins =
> -							<AT91_PIOC 0 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC0 periph A ETX0, conflicts with TIOA3 */
> -							 AT91_PIOC 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC1 periph A ETX1, conflicts with TIOB3 */
> -							 AT91_PIOC 2 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC2 periph A ERX0, conflicts with TCLK3 */
> -							 AT91_PIOC 3 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC3 periph A ERX1, conflicts with TIOA4 */
> -							 AT91_PIOC 4 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC4 periph A ETXEN, conflicts with TIOB4 */
> -							 AT91_PIOC 5 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC5 periph A ECRSDV,conflicts with TCLK4 */
> -							 AT91_PIOC 6 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC6 periph A ERXER, conflicts with TIOA5 */
> -							 AT91_PIOC 7 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC7 periph A EREFCK, conflicts with TIOB5 */
> -							 AT91_PIOC 8 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC8 periph A EMDC, conflicts with TCLK5 */
> -							 AT91_PIOC 9 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PC9 periph A EMDIO  */
> -					};
> -				};
> -
>  				mmc0 {
>  					pinctrl_mmc0_clk_cmd_dat0: mmc0_clk_cmd_dat0 {
>  						atmel,pins =
> @@ -670,21 +498,6 @@
>  					};
>  				};
>  
> -				mmc2 {
> -					pinctrl_mmc2_clk_cmd_dat0: mmc2_clk_cmd_dat0 {
> -						atmel,pins =
> -							<AT91_PIOC 15 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC15 periph A MCI2_CK, conflicts with PCK2 */
> -							 AT91_PIOC 10 AT91_PERIPH_A AT91_PINCTRL_PULL_UP	/* PC10 periph A MCI2_CDA with pullup */
> -							 AT91_PIOC 11 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;	/* PC11 periph A MCI2_DA0 with pullup */
> -					};
> -					pinctrl_mmc2_dat1_3: mmc2_dat1_3 {
> -						atmel,pins =
> -							<AT91_PIOC 12 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC12 periph A MCI2_DA1 with pullup, conflicts with TIOA1 */
> -							 AT91_PIOC 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC13 periph A MCI2_DA2 with pullup, conflicts with TIOB1 */
> -							 AT91_PIOC 14 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PC14 periph A MCI2_DA3 with pullup, conflicts with TCLK1 */
> -					};
> -				};
> -
>  				nand0 {
>  					pinctrl_nand0_ale_cle: nand0_ale_cle-0 {
>  						atmel,pins =
> @@ -743,22 +556,6 @@
>  					};
>  				};
>  
> -				uart0 {
> -					pinctrl_uart0: uart0-0 {
> -						atmel,pins =
> -							<AT91_PIOC 29 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC29 periph A, conflicts with PWMFI2, ISI_D8 */
> -							 AT91_PIOC 30 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;	/* PC30 periph A with pullup, conflicts with ISI_PCK */
> -					};
> -				};
> -
> -				uart1 {
> -					pinctrl_uart1: uart1-0 {
> -						atmel,pins =
> -							<AT91_PIOA 30 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PA30 periph B, conflicts with TWD0, ISI_VSYNC */
> -							 AT91_PIOA 31 AT91_PERIPH_B AT91_PINCTRL_PULL_UP>;	/* PA31 periph B with pullup, conflicts with TWCK0, ISI_HSYNC */
> -					};
> -				};
> -
>  				usart0 {
>  					pinctrl_usart0: usart0-0 {
>  						atmel,pins =
> diff --git a/arch/arm/boot/dts/sama5d31.dtsi b/arch/arm/boot/dts/sama5d31.dtsi
> new file mode 100644
> index 0000000..7997dc9
> --- /dev/null
> +++ b/arch/arm/boot/dts/sama5d31.dtsi
> @@ -0,0 +1,16 @@
> +/*
> + * sama5d31.dtsi - Device Tree Include file for SAMA5D31 SoC
> + *
> + *  Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
> + *
> + * Licensed under GPLv2 or later.
> + */
> +#include "sama5d3.dtsi"
> +#include "sama5d3_lcd.dtsi"
> +#include "sama5d3_emac.dtsi"
> +#include "sama5d3_mci2.dtsi"
> +#include "sama5d3_uart.dtsi"
> +
> +/ {
> +	compatible = "atmel,samad31", "atmel,sama5d3", "atmel,sama5";
> +};
> diff --git a/arch/arm/boot/dts/sama5d31ek.dts b/arch/arm/boot/dts/sama5d31ek.dts
> index 027bac7..04eec0d 100644
> --- a/arch/arm/boot/dts/sama5d31ek.dts
> +++ b/arch/arm/boot/dts/sama5d31ek.dts
> @@ -7,12 +7,13 @@
>   * Licensed under GPLv2 or later.
>   */
>  /dts-v1/;
> +#include "sama5d31.dtsi"
>  #include "sama5d3xmb.dtsi"
>  #include "sama5d3xdm.dtsi"
>  
>  / {
>  	model = "Atmel SAMA5D31-EK";
> -	compatible = "atmel,sama5d31ek", "atmel,sama5d3xmb", "atmel,sama5d3xcm", "atmel,sama5d3", "atmel,sama5";
> +	compatible = "atmel,sama5d31ek", "atmel,sama5d3xmb", "atmel,sama5d3xcm", "atmel,sama5d31", "atmel,sama5d3", "atmel,sama5";
>  
>  	ahb {
>  		apb {
> diff --git a/arch/arm/boot/dts/sama5d33.dtsi b/arch/arm/boot/dts/sama5d33.dtsi
> new file mode 100644
> index 0000000..39f8322
> --- /dev/null
> +++ b/arch/arm/boot/dts/sama5d33.dtsi
> @@ -0,0 +1,14 @@
> +/*
> + * sama5d33.dtsi - Device Tree Include file for SAMA5D33 SoC
> + *
> + *  Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
> + *
> + * Licensed under GPLv2 or later.
> + */
> +#include "sama5d3.dtsi"
> +#include "sama5d3_lcd.dtsi"
> +#include "sama5d3_gmac.dtsi"
> +
> +/ {
> +	compatible = "atmel,samad33", "atmel,sama5d3", "atmel,sama5";
> +};
> diff --git a/arch/arm/boot/dts/sama5d33ek.dts b/arch/arm/boot/dts/sama5d33ek.dts
> index 99bd0c8..9856442 100644
> --- a/arch/arm/boot/dts/sama5d33ek.dts
> +++ b/arch/arm/boot/dts/sama5d33ek.dts
> @@ -7,6 +7,7 @@
>   * Licensed under GPLv2 or later.
>   */
>  /dts-v1/;
> +#include "sama5d33.dtsi"
>  #include "sama5d3xmb.dtsi"
>  #include "sama5d3xdm.dtsi"
>  
> diff --git a/arch/arm/boot/dts/sama5d34.dtsi b/arch/arm/boot/dts/sama5d34.dtsi
> new file mode 100644
> index 0000000..89cda2c
> --- /dev/null
> +++ b/arch/arm/boot/dts/sama5d34.dtsi
> @@ -0,0 +1,16 @@
> +/*
> + * sama5d34.dtsi - Device Tree Include file for SAMA5D34 SoC
> + *
> + *  Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
> + *
> + * Licensed under GPLv2 or later.
> + */
> +#include "sama5d3.dtsi"
> +#include "sama5d3_lcd.dtsi"
> +#include "sama5d3_gmac.dtsi"
> +#include "sama5d3_can.dtsi"
> +#include "sama5d3_mci2.dtsi"
> +
> +/ {
> +	compatible = "atmel,samad34", "atmel,sama5d3", "atmel,sama5";
> +};
> diff --git a/arch/arm/boot/dts/sama5d34ek.dts b/arch/arm/boot/dts/sama5d34ek.dts
> index fb8ee11..2c5d954 100644
> --- a/arch/arm/boot/dts/sama5d34ek.dts
> +++ b/arch/arm/boot/dts/sama5d34ek.dts
> @@ -7,6 +7,7 @@
>   * Licensed under GPLv2 or later.
>   */
>  /dts-v1/;
> +#include "sama5d34.dtsi"
>  #include "sama5d3xmb.dtsi"
>  #include "sama5d3xdm.dtsi"
>  
> diff --git a/arch/arm/boot/dts/sama5d35.dtsi b/arch/arm/boot/dts/sama5d35.dtsi
> new file mode 100644
> index 0000000..d20cd71
> --- /dev/null
> +++ b/arch/arm/boot/dts/sama5d35.dtsi
> @@ -0,0 +1,18 @@
> +/*
> + * sama5d35.dtsi - Device Tree Include file for SAMA5D35 SoC
> + *
> + *  Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
> + *
> + * Licensed under GPLv2 or later.
> + */
> +#include "sama5d3.dtsi"
> +#include "sama5d3_gmac.dtsi"
> +#include "sama5d3_emac.dtsi"
> +#include "sama5d3_can.dtsi"
> +#include "sama5d3_mci2.dtsi"
> +#include "sama5d3_uart.dtsi"
> +#include "sama5d3_tcb1.dtsi"
> +
> +/ {
> +	compatible = "atmel,samad35", "atmel,sama5d3", "atmel,sama5";
> +};
> diff --git a/arch/arm/boot/dts/sama5d35ek.dts b/arch/arm/boot/dts/sama5d35ek.dts
> index 509a53d..47001d9 100644
> --- a/arch/arm/boot/dts/sama5d35ek.dts
> +++ b/arch/arm/boot/dts/sama5d35ek.dts
> @@ -7,6 +7,7 @@
>   * Licensed under GPLv2 or later.
>   */
>  /dts-v1/;
> +#include "sama5d35.dtsi"
>  #include "sama5d3xmb.dtsi"
>  
>  / {
> diff --git a/arch/arm/boot/dts/sama5d3_can.dtsi b/arch/arm/boot/dts/sama5d3_can.dtsi
> new file mode 100644
> index 0000000..8ed3260
> --- /dev/null
> +++ b/arch/arm/boot/dts/sama5d3_can.dtsi
> @@ -0,0 +1,54 @@
> +/*
> + * at91sama5d3_can.dtsi - Device Tree Include file for AT91SAM9x5 SoC with
> + * CAN support
> + *
> + * Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
> + *
> + * Licensed under GPLv2.
> + */
> +
> +#include <dt-bindings/pinctrl/at91.h>
> +#include <dt-bindings/interrupt-controller/irq.h>
> +
> +/ {
> +	ahb {
> +		apb {
> +			pinctrl@fffff200 {
> +				can0 {
> +					pinctrl_can0_rx_tx: can0_rx_tx {
> +						atmel,pins =
> +							<AT91_PIOD 14 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PD14 periph C RX, conflicts with SCK0, SPI0_NPCS1 */
> +							 AT91_PIOD 15 AT91_PERIPH_C AT91_PINCTRL_NONE>;	/* PD15 periph C TX, conflicts with CTS0, SPI0_NPCS2 */
> +					};
> +				};
> +
> +				can1 {
> +					pinctrl_can1_rx_tx: can1_rx_tx {
> +						atmel,pins =
> +							<AT91_PIOB 14 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB14 periph B RX, conflicts with GCRS */
> +							 AT91_PIOB 15 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PB15 periph B TX, conflicts with GCOL */
> +					};
> +				};
> +
> +			};
> +
> +			can0: can@f000c000 {
> +				compatible = "atmel,at91sam9x5-can";
> +				reg = <0xf000c000 0x300>;
> +				interrupts = <40 IRQ_TYPE_LEVEL_HIGH 3>;
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_can0_rx_tx>;
> +				status = "disabled";
> +			};
> +
> +			can1: can@f8010000 {
> +				compatible = "atmel,at91sam9x5-can";
> +				reg = <0xf8010000 0x300>;
> +				interrupts = <41 IRQ_TYPE_LEVEL_HIGH 3>;
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_can1_rx_tx>;
> +				status = "disabled";
> +			};
> +		};
> +	};
> +};
> diff --git a/arch/arm/boot/dts/sama5d3_emac.dtsi b/arch/arm/boot/dts/sama5d3_emac.dtsi
> new file mode 100644
> index 0000000..4d4f351
> --- /dev/null
> +++ b/arch/arm/boot/dts/sama5d3_emac.dtsi
> @@ -0,0 +1,44 @@
> +/*
> + * at91sama5d3_emac.dtsi - Device Tree Include file for AT91SAM9x5 SoC with
> + * Ethernet.
> + *
> + * Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
> + *
> + * Licensed under GPLv2.
> + */
> +
> +#include <dt-bindings/pinctrl/at91.h>
> +#include <dt-bindings/interrupt-controller/irq.h>
> +
> +/ {
> +	ahb {
> +		apb {
> +			pinctrl@fffff200 {
> +				macb1 {
> +					pinctrl_macb1_rmii: macb1_rmii-0 {
> +						atmel,pins =
> +							<AT91_PIOC 0 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC0 periph A ETX0, conflicts with TIOA3 */
> +							 AT91_PIOC 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC1 periph A ETX1, conflicts with TIOB3 */
> +							 AT91_PIOC 2 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC2 periph A ERX0, conflicts with TCLK3 */
> +							 AT91_PIOC 3 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC3 periph A ERX1, conflicts with TIOA4 */
> +							 AT91_PIOC 4 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC4 periph A ETXEN, conflicts with TIOB4 */
> +							 AT91_PIOC 5 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC5 periph A ECRSDV,conflicts with TCLK4 */
> +							 AT91_PIOC 6 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC6 periph A ERXER, conflicts with TIOA5 */
> +							 AT91_PIOC 7 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC7 periph A EREFCK, conflicts with TIOB5 */
> +							 AT91_PIOC 8 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC8 periph A EMDC, conflicts with TCLK5 */
> +							 AT91_PIOC 9 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PC9 periph A EMDIO  */
> +					};
> +				};
> +			};
> +
> +			macb1: ethernet@f802c000 {
> +				compatible = "cdns,at32ap7000-macb", "cdns,macb";
> +				reg = <0xf802c000 0x100>;
> +				interrupts = <35 IRQ_TYPE_LEVEL_HIGH 3>;
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_macb1_rmii>;
> +				status = "disabled";
> +			};
> +		};
> +	};
> +};
> diff --git a/arch/arm/boot/dts/sama5d3_gmac.dtsi b/arch/arm/boot/dts/sama5d3_gmac.dtsi
> new file mode 100644
> index 0000000..0ba8be3
> --- /dev/null
> +++ b/arch/arm/boot/dts/sama5d3_gmac.dtsi
> @@ -0,0 +1,77 @@
> +/*
> + * at91sama5d3_gmac.dtsi - Device Tree Include file for AT91SAM9x5 SoC with
> + * Gigabit Ethernet.
> + *
> + * Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
> + *
> + * Licensed under GPLv2.
> + */
> +
> +#include <dt-bindings/pinctrl/at91.h>
> +#include <dt-bindings/interrupt-controller/irq.h>
> +
> +/ {
> +	ahb {
> +		apb {
> +			pinctrl@fffff200 {
> +				macb0 {
> +					pinctrl_macb0_data_rgmii: macb0_data_rgmii {
> +						atmel,pins =
> +							<AT91_PIOB 0 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB0 periph A GTX0, conflicts with PWMH0 */
> +							 AT91_PIOB 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB1 periph A GTX1, conflicts with PWML0 */
> +							 AT91_PIOB 2 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB2 periph A GTX2, conflicts with TK1 */
> +							 AT91_PIOB 3 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB3 periph A GTX3, conflicts with TF1 */
> +							 AT91_PIOB 4 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB4 periph A GRX0, conflicts with PWMH1 */
> +							 AT91_PIOB 5 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB5 periph A GRX1, conflicts with PWML1 */
> +							 AT91_PIOB 6 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB6 periph A GRX2, conflicts with TD1 */
> +							 AT91_PIOB 7 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PB7 periph A GRX3, conflicts with RK1 */
> +					};
> +					pinctrl_macb0_data_gmii: macb0_data_gmii {
> +						atmel,pins =
> +							<AT91_PIOB 19 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB19 periph B GTX4, conflicts with MCI1_CDA */
> +							 AT91_PIOB 20 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB20 periph B GTX5, conflicts with MCI1_DA0 */
> +							 AT91_PIOB 21 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB21 periph B GTX6, conflicts with MCI1_DA1 */
> +							 AT91_PIOB 22 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB22 periph B GTX7, conflicts with MCI1_DA2 */
> +							 AT91_PIOB 23 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB23 periph B GRX4, conflicts with MCI1_DA3 */
> +							 AT91_PIOB 24 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB24 periph B GRX5, conflicts with MCI1_CK */
> +							 AT91_PIOB 25 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB25 periph B GRX6, conflicts with SCK1 */
> +							 AT91_PIOB 26 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PB26 periph B GRX7, conflicts with CTS1 */
> +					};
> +					pinctrl_macb0_signal_rgmii: macb0_signal_rgmii {
> +						atmel,pins =
> +							<AT91_PIOB 8 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB8 periph A GTXCK, conflicts with PWMH2 */
> +							 AT91_PIOB 9 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB9 periph A GTXEN, conflicts with PWML2 */
> +							 AT91_PIOB 11 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB11 periph A GRXCK, conflicts with RD1 */
> +							 AT91_PIOB 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB13 periph A GRXER, conflicts with PWML3 */
> +							 AT91_PIOB 16 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB16 periph A GMDC */
> +							 AT91_PIOB 17 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB17 periph A GMDIO */
> +							 AT91_PIOB 18 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PB18 periph A G125CK */
> +					};
> +					pinctrl_macb0_signal_gmii: macb0_signal_gmii {
> +						atmel,pins =
> +							<AT91_PIOB 9 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB9 periph A GTXEN, conflicts with PWML2 */
> +							 AT91_PIOB 10 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB10 periph A GTXER, conflicts with RF1 */
> +							 AT91_PIOB 11 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB11 periph A GRXCK, conflicts with RD1 */
> +							 AT91_PIOB 12 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB12 periph A GRXDV, conflicts with PWMH3 */
> +							 AT91_PIOB 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB13 periph A GRXER, conflicts with PWML3 */
> +							 AT91_PIOB 14 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB14 periph A GCRS, conflicts with CANRX1 */
> +							 AT91_PIOB 15 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB15 periph A GCOL, conflicts with CANTX1 */
> +							 AT91_PIOB 16 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB16 periph A GMDC */
> +							 AT91_PIOB 17 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB17 periph A GMDIO */
> +							 AT91_PIOB 27 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PB27 periph B G125CKO */
> +					};
> +
> +				};
> +			};
> +
> +			macb0: ethernet@f0028000 {
> +				compatible = "cdns,pc302-gem", "cdns,gem";
> +				reg = <0xf0028000 0x100>;
> +				interrupts = <34 IRQ_TYPE_LEVEL_HIGH 3>;
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_macb0_data_rgmii &pinctrl_macb0_signal_rgmii>;
> +				status = "disabled";
> +			};
> +		};
> +	};
> +};
> diff --git a/arch/arm/boot/dts/sama5d3_lcd.dtsi b/arch/arm/boot/dts/sama5d3_lcd.dtsi
> new file mode 100644
> index 0000000..01f52a7
> --- /dev/null
> +++ b/arch/arm/boot/dts/sama5d3_lcd.dtsi
> @@ -0,0 +1,55 @@
> +/*
> + * at91sama5d3_lcd.dtsi - Device Tree Include file for AT91SAM9x5 SoC with
> + * LCD support
> + *
> + * Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
> + *
> + * Licensed under GPLv2.
> + */
> +
> +#include <dt-bindings/pinctrl/at91.h>
> +#include <dt-bindings/interrupt-controller/irq.h>
> +
> +/ {
> +	ahb {
> +		apb {
> +			pinctrl@fffff200 {
> +				lcd {
> +					pinctrl_lcd: lcd-0 {
> +						atmel,pins =
> +							<AT91_PIOA 24 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA24 periph A LCDPWM */
> +							 AT91_PIOA 26 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA26 periph A LCDVSYNC */
> +							 AT91_PIOA 27 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA27 periph A LCDHSYNC */
> +							 AT91_PIOA 25 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA25 periph A LCDDISP */
> +							 AT91_PIOA 29 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA29 periph A LCDDEN */
> +							 AT91_PIOA 28 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA28 periph A LCDPCK */
> +							 AT91_PIOA 0 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA0 periph A LCDD0 pin */
> +							 AT91_PIOA 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA1 periph A LCDD1 pin */
> +							 AT91_PIOA 2 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA2 periph A LCDD2 pin */
> +							 AT91_PIOA 3 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA3 periph A LCDD3 pin */
> +							 AT91_PIOA 4 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA4 periph A LCDD4 pin */
> +							 AT91_PIOA 5 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA5 periph A LCDD5 pin */
> +							 AT91_PIOA 6 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA6 periph A LCDD6 pin */
> +							 AT91_PIOA 7 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA7 periph A LCDD7 pin */
> +							 AT91_PIOA 8 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA8 periph A LCDD8 pin */
> +							 AT91_PIOA 9 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA9 periph A LCDD9 pin */
> +							 AT91_PIOA 10 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA10 periph A LCDD10 pin */
> +							 AT91_PIOA 11 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA11 periph A LCDD11 pin */
> +							 AT91_PIOA 12 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA12 periph A LCDD12 pin */
> +							 AT91_PIOA 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA13 periph A LCDD13 pin */
> +							 AT91_PIOA 14 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA14 periph A LCDD14 pin */
> +							 AT91_PIOA 15 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA15 periph A LCDD15 pin */
> +							 AT91_PIOC 14 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC14 periph C LCDD16 pin */
> +							 AT91_PIOC 13 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC13 periph C LCDD17 pin */
> +							 AT91_PIOC 12 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC12 periph C LCDD18 pin */
> +							 AT91_PIOC 11 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC11 periph C LCDD19 pin */
> +							 AT91_PIOC 10 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC10 periph C LCDD20 pin */
> +							 AT91_PIOC 15 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC15 periph C LCDD21 pin */
> +							 AT91_PIOE 27 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PE27 periph C LCDD22 pin */
> +							 AT91_PIOE 28 AT91_PERIPH_C AT91_PINCTRL_NONE>;	/* PE28 periph C LCDD23 pin */
> +					};
> +				};
> +			};
> +		};
> +	};
> +};
> diff --git a/arch/arm/boot/dts/sama5d3_mci2.dtsi b/arch/arm/boot/dts/sama5d3_mci2.dtsi
> new file mode 100644
> index 0000000..38e88e3
> --- /dev/null
> +++ b/arch/arm/boot/dts/sama5d3_mci2.dtsi
> @@ -0,0 +1,47 @@
> +/*
> + * at91sama5d3_mci2.dtsi - Device Tree Include file for AT91SAM9x5 SoC with
> + * 3 MMC ports
> + *
> + * Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
> + *
> + * Licensed under GPLv2.
> + */
> +
> +#include <dt-bindings/pinctrl/at91.h>
> +#include <dt-bindings/interrupt-controller/irq.h>
> +
> +/ {
> +	ahb {
> +		apb {
> +			pinctrl@fffff200 {
> +				mmc2 {
> +					pinctrl_mmc2_clk_cmd_dat0: mmc2_clk_cmd_dat0 {
> +						atmel,pins =
> +							<AT91_PIOC 15 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC15 periph A MCI2_CK, conflicts with PCK2 */
> +							 AT91_PIOC 10 AT91_PERIPH_A AT91_PINCTRL_PULL_UP	/* PC10 periph A MCI2_CDA with pullup */
> +							 AT91_PIOC 11 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;	/* PC11 periph A MCI2_DA0 with pullup */
> +					};
> +					pinctrl_mmc2_dat1_3: mmc2_dat1_3 {
> +						atmel,pins =
> +							<AT91_PIOC 12 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC12 periph A MCI2_DA1 with pullup, conflicts with TIOA1 */
> +							 AT91_PIOC 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC13 periph A MCI2_DA2 with pullup, conflicts with TIOB1 */
> +							 AT91_PIOC 14 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PC14 periph A MCI2_DA3 with pullup, conflicts with TCLK1 */
> +					};
> +				};
> +			};
> +
> +			mmc2: mmc@f8004000 {
> +				compatible = "atmel,hsmci";
> +				reg = <0xf8004000 0x600>;
> +				interrupts = <23 IRQ_TYPE_LEVEL_HIGH 0>;
> +				dmas = <&dma1 2 AT91_DMA_CFG_PER_ID(1)>;
> +				dma-names = "rxtx";
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_mmc2_clk_cmd_dat0 &pinctrl_mmc2_dat1_3>;
> +				status = "disabled";
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +			};
> +		};
> +	};
> +};
> diff --git a/arch/arm/boot/dts/sama5d3_tcb1.dtsi b/arch/arm/boot/dts/sama5d3_tcb1.dtsi
> new file mode 100644
> index 0000000..5264bb4
> --- /dev/null
> +++ b/arch/arm/boot/dts/sama5d3_tcb1.dtsi
> @@ -0,0 +1,27 @@
> +/*
> + * at91sama5d3_tcb1.dtsi - Device Tree Include file for AT91SAM9x5 SoC with
> + * 2 TC blocks.
> + *
> + * Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
> + *
> + * Licensed under GPLv2.
> + */
> +
> +#include <dt-bindings/pinctrl/at91.h>
> +#include <dt-bindings/interrupt-controller/irq.h>
> +
> +/ {
> +	aliases {
> +		tcb1 = &tcb1;
> +	};
> +
> +	ahb {
> +		apb {
> +			tcb1: timer@f8014000 {
> +				compatible = "atmel,at91sam9x5-tcb";
> +				reg = <0xf8014000 0x100>;
> +				interrupts = <27 IRQ_TYPE_LEVEL_HIGH 0>;
> +			};
> +		};
> +	};
> +};
> diff --git a/arch/arm/boot/dts/sama5d3_uart.dtsi b/arch/arm/boot/dts/sama5d3_uart.dtsi
> new file mode 100644
> index 0000000..98fcb2d
> --- /dev/null
> +++ b/arch/arm/boot/dts/sama5d3_uart.dtsi
> @@ -0,0 +1,53 @@
> +/*
> + * at91sama5d3_uart.dtsi - Device Tree Include file for AT91SAM9x5 SoC with
> + * UART support
> + *
> + * Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
> + *
> + * Licensed under GPLv2.
> + */
> +
> +#include <dt-bindings/pinctrl/at91.h>
> +#include <dt-bindings/interrupt-controller/irq.h>
> +
> +/ {
> +	ahb {
> +		apb {
> +			pinctrl@fffff200 {
> +				uart0 {
> +					pinctrl_uart0: uart0-0 {
> +						atmel,pins =
> +							<AT91_PIOC 29 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC29 periph A, conflicts with PWMFI2, ISI_D8 */
> +							 AT91_PIOC 30 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;	/* PC30 periph A with pullup, conflicts with ISI_PCK */
> +					};
> +				};
> +
> +				uart1 {
> +					pinctrl_uart1: uart1-0 {
> +						atmel,pins =
> +							<AT91_PIOA 30 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PA30 periph B, conflicts with TWD0, ISI_VSYNC */
> +							 AT91_PIOA 31 AT91_PERIPH_B AT91_PINCTRL_PULL_UP>;	/* PA31 periph B with pullup, conflicts with TWCK0, ISI_HSYNC */
> +					};
> +				};
> +			};
> +
> +			uart0: serial@f0024000 {
> +				compatible = "atmel,at91sam9260-usart";
> +				reg = <0xf0024000 0x200>;
> +				interrupts = <16 IRQ_TYPE_LEVEL_HIGH 5>;
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_uart0>;
> +				status = "disabled";
> +			};
> +
> +			uart1: serial@f8028000 {
> +				compatible = "atmel,at91sam9260-usart";
> +				reg = <0xf8028000 0x200>;
> +				interrupts = <17 IRQ_TYPE_LEVEL_HIGH 5>;
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_uart1>;
> +				status = "disabled";
> +			};
> +		};
> +	};
> +};
> diff --git a/arch/arm/boot/dts/sama5d3xcm.dtsi b/arch/arm/boot/dts/sama5d3xcm.dtsi
> index 1f80508..6a1871b 100644
> --- a/arch/arm/boot/dts/sama5d3xcm.dtsi
> +++ b/arch/arm/boot/dts/sama5d3xcm.dtsi
> @@ -6,7 +6,6 @@
>   *
>   * Licensed under GPLv2 or later.
>   */
> -#include "sama5d3.dtsi"
>  
>  / {
>  	compatible = "atmel,samad3xcm", "atmel,sama5d3", "atmel,sama5";
> -- 
> 1.7.9.5
> 
