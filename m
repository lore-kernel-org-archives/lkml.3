Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbaFWKUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 06:20:47 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:57882 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaFWKUp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 06:20:45 -0400
Date: Mon, 23 Jun 2014 12:18:39 +0200
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: add support for Ka-Ro TX51
Message-ID: <20140623121839.679f35ee@ipc1.ka-ro>
In-Reply-To: <20140618150152.GP8860@dragon>
References: <1402578584-12640-1-git-send-email-LW@KARO-electronics.de>
 <20140618150152.GP8860@dragon>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Shawn Guo wrote:
> On Thu, Jun 12, 2014 at 03:09:44PM +0200, Lothar Waßmann wrote:
> > Add support for Ka-Ro electronics i.MX51 based TX51 modules
> > 
> > Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
> > ---
> >  arch/arm/boot/dts/Makefile       |    1 +
> >  arch/arm/boot/dts/imx51-tx51.dts |  620 ++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 621 insertions(+)
> >  create mode 100644 arch/arm/boot/dts/imx51-tx51.dts
> > 
> > diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> > index 0f1e8be..8dd4dbc 100644
> > --- a/arch/arm/boot/dts/Makefile
> > +++ b/arch/arm/boot/dts/Makefile
> > @@ -177,6 +177,7 @@ dtb-$(CONFIG_ARCH_MXC) += \
> >  	imx51-babbage.dtb \
> >  	imx51-digi-connectcore-jsk.dtb \
> >  	imx51-eukrea-mbimxsd51-baseboard.dtb \
> > +	imx51-tx51.dtb \
> >  	imx53-ard.dtb \
> >  	imx53-m53evk.dtb \
> >  	imx53-mba53.dtb \
> > diff --git a/arch/arm/boot/dts/imx51-tx51.dts b/arch/arm/boot/dts/imx51-tx51.dts
> > new file mode 100644
> > index 0000000..9ae7758
> > --- /dev/null
> > +++ b/arch/arm/boot/dts/imx51-tx51.dts
> > @@ -0,0 +1,620 @@
> > +/*
> > + * Copyright 2012-2014 Lothar Waßmann <LW@KARO-electronics.de>
> > + *
> > + * The code contained herein is licensed under the GNU General Public
> > + * License. You may obtain a copy of the GNU General Public License
> > + * Version 2 at the following locations:
> > + *
> > + * http://www.opensource.org/licenses/gpl-license.html
> > + * http://www.gnu.org/copyleft/gpl.html
> > + */
> > +
> > +/dts-v1/;
> > +#include "imx51.dtsi"
> > +#include <dt-bindings/gpio/gpio.h>
> > +#include <dt-bindings/input/input.h>
> 
> imx51.dtsi already includes them.
> 
OK.

> > +#include <dt-bindings/pwm/pwm.h>
> > +
> > +/ {
> > +	model = "Ka-Ro electronics TX51 module";
> > +	compatible = "karo,tx51", "fsl,imx51";
> > +
> > +	aliases {
> > +		backlight = &backlight;
> > +		display = &display;
> > +		i2c1 = &i2c_gpio;
> > +		usbotg = &usbotg;
> > +	};
> > +
> > +	chosen {
> > +		stdout-path = &uart1;
> > +	};
> > +
> > +	backlight: pwm-backlight {
> > +		compatible = "pwm-backlight";
> > +
> 
> Drop this new line.
> 
OK.

> > +		pwms = <&pwm1 0 500000 PWM_POLARITY_INVERTED>;
> > +		power-supply = <&reg_3v3>;
> > +		brightness-levels = <
> > +			  0  1  2  3  4  5  6  7  8  9
> > +			 10 11 12 13 14 15 16 17 18 19
> > +			 20 21 22 23 24 25 26 27 28 29
> > +			 30 31 32 33 34 35 36 37 38 39
> > +			 40 41 42 43 44 45 46 47 48 49
> > +			 50 51 52 53 54 55 56 57 58 59
> > +			 60 61 62 63 64 65 66 67 68 69
> > +			 70 71 72 73 74 75 76 77 78 79
> > +			 80 81 82 83 84 85 86 87 88 89
> > +			 90 91 92 93 94 95 96 97 98 99
> > +			100
> > +		>;
> > +		default-brightness-level = <50>;
> > +	};
> > +
> > +	clocks {
> > +		ckih1 {
> > +			clock-frequency = <0>;
> > +		};
> > +
> > +		mclk: clock@0 {
> > +			compatible = "fixed-clock";
> > +			reg = <0>;
> > +			#clock-cells = <0>;
> > +			clock-frequency = <27000000>;
> > +		};
> > +
> > +		clk_26M: clock@1 {
> 
> When using generic name, you will need clock-output-names property.
> Otherwise, the clocks will fail in registration except the first one,
> because of clock name collision.
> 
Didn't recognize that yet.

[...]
> > +	usbphy {
> > +		#address-cells = <1>;
> > +		#size-cells = <0>;
> > +		compatible = "simple-bus";
> > +
> > +		usbh1phy: usbh1phy@0 {
> 
> The node name should be something generic like usbphy?
> 
OK.

> > +			compatible = "usb-nop-xceiv";
> > +			reg = <0>;
> > +			clocks = <&clk_26M>;
> > +			clock-names = "main_clk";
> > +		};
> > +	};
> > +};
> > +
> > +&audmux {
> > +	status = "okay";
> > +};
> > +
> > +&fec {
> > +	pinctrl-names = "default";
> > +	pinctrl-0 = <&pinctrl_fec>;
> > +	phy-mode = "mii";
> > +//	phy-reset-gpios = <&gpio2 14 GPIO_ACTIVE_LOW>;
> 
> Drop it?
> 
Leftover from debugging...

> > +	phy-handle = <&phy0>;
> > +	mac-address = [000000000000]; /* will be set by U-Boot */
> 
> Shouldn't it be local-mac-address?
> 
probably yes, but both 'mac-address' and 'local-mac-address' are being
set up by U-Boot anyway.

[...]
> > +&ipu_di0_disp0 {
> > +	remote-endpoint = <&display0_in>;
> > +};
> > +
> > +&kpp {
> > +	status = "okay";
> 
> Put 'status' at the bottom of property list.
>
OK.

> > +
> > +	linux,keymap = <	/* sample keymap */
> > +		MATRIX_KEY(0, 0, KEY_POWER)
> > +		MATRIX_KEY(0, 1, KEY_KP0)
> > +		MATRIX_KEY(0, 2, KEY_KP1)
> > +		MATRIX_KEY(0, 3, KEY_KP2)
> > +		MATRIX_KEY(1, 0, KEY_KP3)
> > +		MATRIX_KEY(1, 1, KEY_KP4)
> > +		MATRIX_KEY(1, 2, KEY_KP5)
> > +		MATRIX_KEY(1, 3, KEY_KP6)
> > +		MATRIX_KEY(2, 0, KEY_KP7)
> > +		MATRIX_KEY(2, 1, KEY_KP8)
> > +		MATRIX_KEY(2, 2, KEY_KP9)
> > +	>;
> > +};
> > +
> > +&esdhc1 {
> > +	cd-gpios = <&gpio3 8 GPIO_ACTIVE_LOW>;
> > +	fsl,wp-controller;
> 
> Does it work for you, since the driver does not support it as of today?
> 
What driver doesn't support what?
AFAICT the sdhci-esdhc-imx.c driver supports both of these properties.

> > +	status = "okay";
> > +};
> > +
> > +&esdhc2 {
> > +	cd-gpios = <&gpio3 6 GPIO_ACTIVE_LOW>;
> > +	fsl,wp-controller;
> > +	status = "okay";
> > +};
> > +
> > +&pwm1 {
> > +	pinctrl-names = "default";
> > +	pinctrl-0 = <&pinctrl_pwm1>;
> > +};
> > +
> > +&ecspi1 {
> > +	fsl,spi-num-chipselects = <2>;
> > +	cs-gpios = <&gpio4 24 GPIO_ACTIVE_LOW &gpio4 25 GPIO_ACTIVE_LOW>;
> 
> More readable to write it like below?
> 
> 	cs-gpios = <&gpio4 24 GPIO_ACTIVE_LOW>,
> 		   <&gpio4 25 GPIO_ACTIVE_LOW>;
> 
OK.

> > +	status = "okay";
> > +
> > +	spidev0: spi@0 {
> > +		compatible = "spidev";
> > +		reg = <0>;
> > +		spi-max-frequency = <54000000>;
> > +	};
> > +
> > +	spidev1: spi@1 {
> > +		compatible = "spidev";
> > +		reg = <1>;
> > +		spi-max-frequency = <54000000>;
> > +	};
> 
> I'm not sure we should have these two devices.
> 
Why not? With this the SPI bus can readily be used with the spidev
driver from Documentation/spi/spidev_test.c (which is what most of our
customers are asking for)!

> > +};
> > +
> > +&ssi1 {
> > +	fsl,mode = "i2s-slave";
> > +	codec-handle = <&sgtl5000>;
> > +	status = "okay";
> > +};
> > +
> > +&ssi2 {
> > +	status = "disabled";
> > +};
> 
> Why is this needed, since the device is disabled in imx51.dtsi?
> 
That's included here as a placeholder in case someone wants to enable
the second SSI interface so that they...

> > +&nfc {
> 
> Please sort the nodes alphabetically.
> 
...won't have this problem. ;)


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
