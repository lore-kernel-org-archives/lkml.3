Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaBGRyD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:54:03 -0500
Received: from 8.mo1.mail-out.ovh.net ([178.33.110.239]:51182 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751056AbaBGRyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:54:00 -0500
X-Greylist: delayed 2121 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Feb 2014 12:54:00 EST
Date: Fri, 7 Feb 2014 18:19:48 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [PATCH v2] ARM: at91: add Atmel's SAMA5D3 Xplained board
Message-ID: <20140207171948.GB9558@ns203013.ovh.net>
References: <20140204203054.GA21958@ldesroches-Latitude-E6320>
 <1391589347-26019-1-git-send-email-nicolas.ferre@atmel.com>
 <20140207080142.GR9558@ns203013.ovh.net>
 <52F4EFA4.6070205@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52F4EFA4.6070205@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 1579637571357682540
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrjeehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:37 Fri 07 Feb     , Nicolas Ferre wrote:
> On 07/02/2014 09:01, Jean-Christophe PLAGNIOL-VILLARD :
> > On 09:35 Wed 05 Feb     , Nicolas Ferre wrote:
> >> Add DT file for new SAMA5D3 Xpained board.
> >> This board is based on Atmel's SAMA5D36 Cortex-A5 SoC.
> >>
> >> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> >> ---
> >>  arch/arm/boot/dts/Makefile                  |   1 +
> >>  arch/arm/boot/dts/at91-sama5d3_xplained.dts | 233 ++++++++++++++++++++++++++++
> >>  2 files changed, 234 insertions(+)
> >>  create mode 100644 arch/arm/boot/dts/at91-sama5d3_xplained.dts
> >>
> >> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> >> index b9d6a8b485e0..6d1e43d46187 100644
> >> --- a/arch/arm/boot/dts/Makefile
> >> +++ b/arch/arm/boot/dts/Makefile
> >> @@ -38,6 +38,7 @@ dtb-$(CONFIG_ARCH_AT91) += at91sam9g35ek.dtb
> >>  dtb-$(CONFIG_ARCH_AT91) += at91sam9x25ek.dtb
> >>  dtb-$(CONFIG_ARCH_AT91) += at91sam9x35ek.dtb
> >>  # sama5d3
> >> +dtb-$(CONFIG_ARCH_AT91)	+= at91-sama5d3_xplained.dtb
> >>  dtb-$(CONFIG_ARCH_AT91)	+= sama5d31ek.dtb
> >>  dtb-$(CONFIG_ARCH_AT91)	+= sama5d33ek.dtb
> >>  dtb-$(CONFIG_ARCH_AT91)	+= sama5d34ek.dtb
> >> diff --git a/arch/arm/boot/dts/at91-sama5d3_xplained.dts b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
> >> new file mode 100644
> >> index 000000000000..fb1349ca60a4
> >> --- /dev/null
> >> +++ b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
> >> @@ -0,0 +1,233 @@
> >> +/*
> >> + * at91-sama5d3_xplained.dts - Device Tree file for the SAMA5D3 Xplained board
> >> + *
> >> + *  Copyright (C) 2014 Atmel,
> >> + *		  2014 Nicolas Ferre <nicolas.ferre@atmel.com>
> >> + *
> >> + * Licensed under GPLv2 or later.
> >> + */
> >> +/dts-v1/;
> >> +#include "sama5d36.dtsi"
> >> +
> >> +/ {
> >> +	model = "SAMA5D3 Xplained";
> >> +	compatible = "atmel,sama5d3-xplained", "atmel,sama5d3", "atmel,sama5";
> >> +
> >> +	chosen {
> >> +		bootargs = "console=ttyS0,115200";
> > can you describe it via linux,stdout
> 
> Well I would have liked, but the code in the serial driver is not there yet.
> So, I keep it like this for the moment.
> 
> >> +	};
> >> +
> >> +	memory {
> >> +		reg = <0x20000000 0x10000000>;
> >> +	};
> >> +
> >> +	ahb {
> >> +		apb {
> >> +			mmc0: mmc@f0000000 {
> >> +				pinc§trl-names = "default";
> > ?? this is SoC should never been seen here
this need to move to dtsi not here
> >> +				pinctrl-0 = <&pinctrl_mmc0_clk_cmd_dat0 &pinctrl_mmc0_dat1_3 &pinctrl_mmc0_dat4_7 &pinctrl_mmc0_cd>;
> >> +				status = "okay";
> >> +				slot@0 {
> >> +					reg = <0>;
> >> +					bus-width = <8>;
> >> +					cd-gpios = <&pioE 0 GPIO_ACTIVE_LOW>;
> >> +				};
> >> +			};
> >> +
> >> +			spi0: spi@f0004000 {
> >> +				cs-gpios = <&pioD 13 0>, <0>, <0>, <0>;
> > if you use only one CS no need to specified all
> > 
> > we need to add macro per SoC for the hw CS used as GPIO so it's more clear
> 
> No, I do not think so.

yes as you dopy &pioD 13 0 everywhere instead of doing

#define SAMA5D3_SPI_CS0_GPIO	&pioD 13 GPIO_ACTIVE_LOW

and then

			cs-gpios = <SAMA5D3_SPI_CS0_GPIO>;
and drop the
			, <0>, <0>, <0>;

> >> +				status = "okay";
> >> +			};
> >> +
> >> +			can0: can@f000c000 {
> >> +				status = "okay";
> >> +			};
> >> +
> >> +			i2c0: i2c@f0014000 {
> >> +				status = "okay";
> >> +			};
> >> +
> >> +			i2c1: i2c@f0018000 {
> >> +				status = "okay";
> >> +			};
> >> +
> >> +			macb0: ethernet@f0028000 {
> >> +				phy-mode = "rgmii";
> >> +				status = "okay";
> >> +			};
> >> +
> >> +			usart0: serial@f001c000 {
> >> +				status = "okay";
> >> +			};
> >> +
> >> +			usart1: serial@f0020000 {
> >> +				pinctrl-names = "default";
> > same as mmc
> >> +				pinctrl-0 = <&pinctrl_usart1 &pinctrl_usart1_rts_cts>;
> >> +				status = "okay";
> >> +			};
> >> +
> >> +			uart0: serial@f0024000 {
> >> +				status = "okay";
> >> +			};
> >> +
> >> +			mmc1: mmc@f8000000 {
> >> +				pinctrl-names = "default";
> > ditto
> >> +				pinctrl-0 = <&pinctrl_mmc1_clk_cmd_dat0 &pinctrl_mmc1_dat1_3 &pinctrl_mmc1_cd>;
> >> +				status = "okay";
> >> +				slot@0 {
> >> +					reg = <0>;
> >> +					bus-width = <4>;
> >> +					cd-gpios = <&pioE 1 GPIO_ACTIVE_HIGH>;
> >> +				};
> >> +			};
> >> +
> >> +			spi1: spi@f8008000 {
> >> +				cs-gpios = <&pioC 25 0>, <0>, <0>, <&pioD 16 0>;
> >> +				status = "okay";
> >> +			};
> >> +
> >> +			adc0: adc@f8018000 {
> >> +				pinctrl-names = "default";
> > ditto
> >> +				pinctrl-0 = <
> >> +					&pinctrl_adc0_adtrg
> >> +					&pinctrl_adc0_ad0
> >> +					&pinctrl_adc0_ad1
> >> +					&pinctrl_adc0_ad2
> >> +					&pinctrl_adc0_ad3
> >> +					&pinctrl_adc0_ad4
> >> +					&pinctrl_adc0_ad5
> >> +					&pinctrl_adc0_ad6
> >> +					&pinctrl_adc0_ad7
> >> +					&pinctrl_adc0_ad8
> >> +					&pinctrl_adc0_ad9
> >> +					>;
> >> +				status = "okay";
> >> +			};
> >> +
> >> +			i2c2: i2c@f801c000 {
> >> +				dmas = <0>, <0>;	/* Do not use DMA for i2c2 */
> > why?
> 
> Because we use the channels for other peripherals
> 
> >> +				status = "okay";
> >> +			};
> >> +
> >> +			macb1: ethernet@f802c000 {
> >> +				phy-mode = "rmii";
> >> +				status = "okay";
> >> +			};
> >> +
> >> +			dbgu: serial@ffffee00 {
> >> +				status = "okay";
> >> +			};
> >> +
> >> +			pinctrl@fffff200 {
> >> +				board {
> >> +					pinctrl_mmc0_cd: mmc0_cd {
> >> +						atmel,pins =
> >> +							<AT91_PIOE 0 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP_DEGLITCH>;
> >> +					};
> >> +
> >> +					pinctrl_mmc1_cd: mmc1_cd {
> >> +						atmel,pins =
> >> +							<AT91_PIOE 1 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP_DEGLITCH>;
> >> +					};
> >> +
> >> +					pinctrl_usba_vbus: usba_vbus {
> >> +						atmel,pins =
> >> +							<AT91_PIOE 9 AT91_PERIPH_GPIO AT91_PINCTRL_DEGLITCH>;	/* PE9, conflicts with A9 */
> > in this case we should have ifdef so we could choose what we want via make
> > file
> 
> No, we choose by modifying the DTS.
exactly what I've said describe it via ifdef in the dts
> 
> >> +					};
> >> +				};
> >> +			};
> >> +
> >> +			pmc: pmc@fffffc00 {
> >> +				main: mainck {
> >> +					clock-frequency = <12000000>;
> >> +				};
> >> +			};
> >> +		};
> >> +
> >> +		nand0: nand@60000000 {
> >> +			nand-bus-width = <8>;
> >> +			nand-ecc-mode = "hw";
> >> +			atmel,has-pmecc;
> >> +			atmel,pmecc-cap = <4>;
> >> +			atmel,pmecc-sector-size = <512>;
> >> +			nand-on-flash-bbt;
> >> +			status = "okay";
> >> +
> >> +			at91bootstrap@0 {
> >> +				label = "at91bootstrap";
> >> +				reg = <0x0 0x40000>;
> >> +			};
> >> +
> >> +			bootloader@40000 {
> >> +				label = "bootloader";
> >> +				reg = <0x40000 0x80000>;
> >> +			};
> >> +
> >> +			bootloaderenv@c0000 {
> >> +				label = "bootloader env";
> >> +				reg = <0xc0000 0xc0000>;
> >> +			};
> >> +
> >> +			dtb@180000 {
> >> +				label = "device tree";
> >> +				reg = <0x180000 0x80000>;
> >> +			};
> >> +
> >> +			kernel@200000 {
> >> +				label = "kernel";
> >> +				reg = <0x200000 0x600000>;
> >> +			};
> >> +
> >> +			rootfs@800000 {
> >> +				label = "rootfs";
> >> +				reg = <0x800000 0x0f800000>;
> >> +			};
> > more I read this partition more it's seems wrong those days
> > 
> > we really need to switch to UBI
> 
> I am using UBI with this layout.

so put the kernel & dts on UBI to have wareleveling on it too

and then we do not need to knwown the kernel/rootfs/dtc partition size and
position
> 
> >> +		};
> >> +
> >> +		usb0: gadget@00500000 {
> >> +			atmel,vbus-gpio = <&pioE 9 GPIO_ACTIVE_HIGH>;	/* PE9, conflicts with A9 */
> >> +			pinctrl-names = "default";
> >> +			pinctrl-0 = <&pinctrl_usba_vbus>;
> >> +			status = "okay";
> >> +		};
> >> +
> >> +		usb1: ohci@00600000 {
> >> +			num-ports = <3>;
> >> +			atmel,vbus-gpio = <0
> >> +					   &pioE 3 GPIO_ACTIVE_LOW
> >> +					   &pioE 4 GPIO_ACTIVE_LOW
> >> +					  >;
> >> +			status = "okay";
> >> +		};
> >> +
> >> +		usb2: ehci@00700000 {
> >> +			status = "okay";
> >> +		};
> >> +	};
> >> +
> >> +	gpio_keys {
> >> +		compatible = "gpio-keys";
> >> +
> >> +		bp3 {
> >> +			label = "PB_USER";
> >> +			gpios = <&pioE 29 GPIO_ACTIVE_LOW>;
> >> +			linux,code = <0x104>;
> >> +			gpio-key,wakeup;
> >> +		};
> >> +	};
> >> +
> >> +	leds {
> >> +		compatible = "gpio-leds";
> >> +
> >> +		d2 {
> >> +			label = "d2";
> >> +			gpios = <&pioE 23 GPIO_ACTIVE_LOW>;	/* PE23, conflicts with A23, CTS2 */
> >> +			linux,default-trigger = "heartbeat";
> >> +		};
> >> +
> >> +		d3 {
> >> +			label = "d3";
> >> +			gpios = <&pioE 24 GPIO_ACTIVE_HIGH>;
> >> +		};
> >> +	};
> >> +};
> >> -- 
> >> 1.8.2.2
> >>
> > 
> 
> 
> -- 
> Nicolas Ferre
