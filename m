Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbaGaTUv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 15:20:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39497 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbaGaTUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 15:20:49 -0400
Message-ID: <53DA9709.10602@suse.de>
Date: Thu, 31 Jul 2014 21:20:41 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>, linux-samsung-soc@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 4/4] ARM: dts: Add exynos5250-spring device tree
References: <1406822910-6255-1-git-send-email-afaerber@suse.de> <1406822910-6255-5-git-send-email-afaerber@suse.de> <53DA936E.9060004@gmail.com>
In-Reply-To: <53DA936E.9060004@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

Am 31.07.2014 21:05, schrieb Tomasz Figa:
> Hi Andreas,
> 
> Sorry for joining the party a bit late, but there were patches with less
> people involved so I preferred to review them first.
> 
> You can find my comments inline.
> 
> On 31.07.2014 18:08, Andreas Färber wrote:
>> Adds initial support for the HP Chromebook 11.
> 
> [snip]
> 
>> +	gpio-keys {
>> +		compatible = "gpio-keys";
>> +		pinctrl-names = "default";
>> +		pinctrl-0 = <&power_key_irq>, <&lid_irq>;
>> +
>> +		power {
>> +			label = "Power";
>> +			gpios = <&gpx1 3 GPIO_ACTIVE_LOW>;
>> +			linux,code = <KEY_POWER>;
> 
> I assume the key is debounced in hardware, so there is no need for
> debounce-interval here. Is this correct?

You're asking the wrong person... This is copied from
-cros-common/-snow. Downstream 3.8 does not have a debounce-interval
property.

> 
>> +			gpio-key,wakeup;
>> +		};
>> +
>> +		lid-switch {
>> +			label = "Lid";
>> +			gpios = <&gpx3 5 GPIO_ACTIVE_LOW>;
>> +			linux,input-type = <5>; /* EV_SW */
>> +			linux,code = <0>; /* SW_LID */
>> +			debounce-interval = <1>;
>> +			gpio-key,wakeup;
>> +		};
>> +	};
>> +
>> +	usb3_vbus_reg: regulator-usb3 {
>> +		compatible = "regulator-fixed";
>> +		regulator-name = "P5.0V_USB3CON";
>> +		regulator-min-microvolt = <5000000>;
>> +		regulator-max-microvolt = <5000000>;
>> +		gpio = <&gpe1 0 GPIO_ACTIVE_LOW>;
>> +		enable-active-high;
>> +	};
>> +
>> +	usb@12110000 {
> 
> Since this is a brand new dts file, it should use the reference based
> syntax, which would be something like
> 
> &usbhost {
> 	...
> };
> 
> below the / { ... }; block.

You will find that I already did that for all nodes that have a label.
Since there are lots of usb nodes, please suggest specific label names.

I originally tried to stay out of existing code, then I was asked to fix
-cros-common, clean up -snow too, now the SoC, ... ;)

>> +		samsung,vbus-gpio = <&gpx1 1 GPIO_ACTIVE_HIGH>;
>> +	};
>> +
>> +	usb-hub {
>> +		compatible = "smsc,usb3503a";
>> +		reset-gpios = <&hsic_reset>;
> 
> Hmm, why a -gpios property points to a pinctrl node? Shouldn't there be
> a phandle to GPIO bank + GPIO specifier instead?

Dunno, can change it. Can I just copy the gpio property from the
regulator above?

>> +	};
>> +
>> +	fixed-rate-clocks {
>> +		xxti {
>> +			compatible = "samsung,clock-xxti";
>> +			clock-frequency = <24000000>;
>> +		};
>> +	};
> 
> This is also referencing a node from higher level, so it should be done
> using a reference.
> 
>> +
>> +	hdmi {
>> +		hpd-gpio = <&gpx3 7 GPIO_ACTIVE_HIGH>;
>> +		pinctrl-names = "default";
>> +		pinctrl-0 = <&hdmi_hpd_irq>;
>> +		phy = <&hdmiphy>;
>> +		ddc = <&i2c_2>;
>> +		hdmi-en-supply = <&s5m_ldo8_reg>;
>> +		vdd-supply = <&s5m_ldo8_reg>;
>> +		vdd_osc-supply = <&s5m_ldo10_reg>;
>> +		vdd_pll-supply = <&s5m_ldo8_reg>;
>> +	};
> 
> Ditto.

hdmi?

> 
>> +
>> +	fimd@14400000 {
>> +		status = "okay";
>> +		samsung,invert-vclk;
>> +	};
> 
> Ditto.

fimd?

> 
>> +
>> +	dp-controller@145B0000 {
>> +		status = "okay";
>> +		pinctrl-names = "default";
>> +		pinctrl-0 = <&dp_hpd>;
>> +		samsung,color-space = <0>;
>> +		samsung,dynamic-range = <0>;
>> +		samsung,ycbcr-coeff = <0>;
>> +		samsung,color-depth = <1>;
>> +		samsung,link-rate = <0x0a>;
>> +		samsung,lane-count = <1>;
>> +		samsung,hpd-gpio = <&gpc3 0 GPIO_ACTIVE_HIGH>;
>> +	};
> 
> Ditto.

dp_controller? display_port_controller?

> 
>> +};
>> +
>> +&dp_hpd {
>> +	samsung,pins = "gpc3-0";
>> +	samsung,pin-function = <0>;
>> +	samsung,pin-pud = <3>;
>> +	samsung,pin-drv = <0>;
>> +};
> 
> Hmm, what node is this referencing? I believe this should rather
> reference the pin controller and add a new board-specific pinconf/pinmux
> group instead....

It's a -pinctrl node. See v3->v4 change log and discussion on v3.

>> +
>> +&i2c_0 {
>> +	status = "okay";
>> +	samsung,i2c-sda-delay = <100>;
>> +	samsung,i2c-max-bus-freq = <378000>;
> 
> [snip]
> 
>> +/*
>> + * Disabled pullups since external part has its own pullups and
>> + * double-pulling gets us out of spec in some cases.
>> + */
>> +&i2c2_bus {
>> +	samsung,pin-pud = <0>;
>> +};
> 
> OK, here overriding a generic pinconf group is justified and nicely
> explained by a comment.

You seem to assume that I actually understand these things. ;)
Just copied from -cros-common/-snow.

>> +
>> +&i2c_2 {
>> +	status = "okay";
>> +	samsung,i2c-sda-delay = <100>;
>> +	samsung,i2c-max-bus-freq = <66000>;
>> +
>> +	hdmiddc@50 {
>> +		compatible = "samsung,exynos4210-hdmiddc";
>> +		reg = <0x50>;
>> +	};
> 
> I don't think this matches current Exynos HDMI bindings, which I believe
> have been changed to just take a phandle to i2c bus instead.

Copied from -cros-common/-snow.

>> +};
>> +
>> +&i2c_3 {
>> +	status = "okay";
>> +	samsung,i2c-sda-delay = <100>;
>> +	samsung,i2c-max-bus-freq = <66000>;
>> +};
> 
> [snip]
> 
>> +&sd1_clk {
>> +	samsung,pin-drv = <0>;
>> +};
>> +
>> +&sd1_cmd {
>> +	samsung,pin-pud = <3>;
>> +	samsung,pin-drv = <0>;
>> +};
>> +
>> +&sd1_cd {
>> +	samsung,pin-drv = <0>;
>> +};
>> +
>> +&sd1_bus4 {
>> +	samsung,pin-drv = <0>;
>> +};
> 
> Here generic settings are being overridden, so it might be a good idea
> to explain why, like with i2c pull-up above.

Snow does not have an explanation either, so please suggest what comment
you'd like to see. Consider me just a user with no specs. :)

Cheers,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
