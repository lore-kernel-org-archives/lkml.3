Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbbAWV7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 16:59:44 -0500
Received: from gn237.zone.eu ([217.146.67.237]:20437 "EHLO gn237.zone.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbbAWV7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 16:59:41 -0500
Message-ID: <1422050375.1799.9.camel@plaes.org>
Subject: Re: [PATCH] ARM: dts: sun4i: Add initial dts for Gemei G9 tablet
From: Priit Laes <plaes@plaes.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 23 Jan 2015 23:59:35 +0200
In-Reply-To: <20150123212203.GB8470@lukather>
References: <1422045409-1251-1-git-send-email-plaes@plaes.org>
	 <20150123212203.GB8470@lukather>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.13.9 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2015-01-23 at 22:22 +0100, Maxime Ripard wrote:
> On Fri, Jan 23, 2015 at 10:36:49PM +0200, Priit Laes wrote:
> > Gemei G9 is an A10 based tablet, with 1G RAM, 16G NAND, 1024x768 
> > IPS LCD display, stereo speakers, 1.3MP front camera and 5 MP
> > rear camera, 8000mAh battery, GT901 2+1 touchscreen, Bosch BMA250 
> > accelerometer and RTL8188CUS USB wifi. It also has MicroSD slot, 
> > miniHDMI, 1 x MicroUSB OTG port and 1 x MicroUSB host port and 
> > 3.5mm headphone jack.
> > More details are available at: http://linux-sunxi.org/Gemei_G9
> > 
[..]
> > 
> > +/ {
> > +    model = "Gemei G9 Tablet";
> > +    compatible = "gemei,g9", "allwinner,sun4i-a10";
> > +};
> > +
> > +/*
> > + * http://linux-sunxi.org/Gemei_G9
> 
> Please don't put URL in the DT. This is very likely to change in the 
> future, and won't be valid anymore.

OK! The URL in commit message is ok to stay?
> 
> > + *
> > + * TODO:
> > + *   2x cameras via CSI
> > + *   AXP battery management
> > + *   AXP power enable key
> > + *   Keys (LRADC)
> > + *   NAND
> > + *   OTG
> > + *   Touchscreen - gt801_2plus1 @ i2c adapter 2 @ 0x48
> > + */
> > +
> > +
> > +&ehci0 {
> > +    status = "okay";
> > +};
> 
> Indentation with one tabulation please.

Oops.. will do.
> 
> 
> > +&ehci1 {
> > +    status = "okay";
> > +};
> > +
> > +&i2c0 {
> > +    pinctrl-names = "default";
> > +    pinctrl-0 = <&i2c0_pins_a>;
> > +    status = "okay";
> > +
> > +    axp209: pmic@34 {
> > +        compatible = "x-powers,axp209";
> > +        reg = <0x34>;
> > +        interrupts = <0>;
> > +
> > +        interrupt-controller;
> > +        #interrupt-cells = <1>;
> > +    };
> > +};
> > +
> > +&i2c1 {
> > +    pinctrl-names = "default";
> > +    pinctrl-0 = <&i2c1_pins_a>;
> > +    status = "okay";
> > +
> > +    /* Accelerometer */
> > +    bma250@18 {
> > +        compatible = "bosch,bma250";
> > +        reg = <0x18>;
> 
> Is there a driver for this? It looks weird that it doesn't need more 
> properties than that.

Yes, it's supported by drivers/iio/accel/bma180.c though I have to 
admit that this name is a bit misleading. (bosch-bma.c would 
better, I guess).

And I was a bit surprised that it worked out of the box too, but the 
device was present under /sys and I was able to read x, y, z and 
temperature values.

> > +    };
> > +};
> > +
> > +&reg_usb1_vbus {
> > +    status = "okay";
> > +};
> > +
> > +&reg_usb2_vbus {
> > +    status = "okay";
> > +};
> > +
> > +&mmc0 {
> > +    pinctrl-names = "default";
> > +    pinctrl-0 = <&mmc0_pins_a>, <&mmc0_cd_pin_reference_design>;
> > +    vmmc-supply = <&reg_vcc3v3>;
> > +    bus-width = <4>;
> > +    cd-gpios = <&pio 7 1 GPIO_ACTIVE_HIGH>; /* PH01 */
> > +    cd-inverted;
> > +    status = "okay";
> > +};
> > +
> > +
> 
> Remove that extra new line.

Will do.
> 
> > +&uart0  {
> > +    pinctrl-names = "default";
> > +    pinctrl-0 = <&uart0_pins_a>;
> > +    status = "okay";
> > +};
> > +
> > +&usbphy {
> > +    usb1_vbus-supply = <&reg_usb1_vbus>;
> > +    usb2_vbus-supply = <&reg_usb2_vbus>;
> > +    status = "okay";
> > +};
> > --
> > 2.2.2
> > 
> 
> Looks good otherwise, thanks! Maxime
> 
