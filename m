Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab3EaOH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 10:07:28 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41756 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab3EaOHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 10:07:21 -0400
Message-ID: <51A8AE72.5010601@ti.com>
Date: Fri, 31 May 2013 16:06:42 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dan Murphy <dmurphy@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7] ARM: dts: omap4-panda: Update the LED support for
 the panda DTS
References: <1369826427-31963-1-git-send-email-dmurphy@ti.com>
In-Reply-To: <1369826427-31963-1-git-send-email-dmurphy@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On 05/29/2013 01:20 PM, Dan Murphy wrote:
> The GPIO for LED D1 on the omap4-panda a1-a3 rev and the omap4-panda-es
> are different.
> 
> A1-A3 = gpio_wk7clean
> ES = gpio_110
> 
> There is no change to LED D2
> 
> Abstract away the pinmux and the LED definitions for the two boards into
> the respective DTS files.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

That patch was good... until Florian introduces some new constant to
improve the readability of the DTS [1].

Could you rebase on the lastest for_3.11/dts and use the macros for the
GPIO and pinctrl nodes?

Thanks,
Benoit

[1] http://www.mail-archive.com/linux-omap@vger.kernel.org/msg89684.html

> ---
> v7 - Update headline to add spaces - https://patchwork.kernel.org/patch/2583661/
> v6 - Review comments updated - https://patchwork.kernel.org/patch/2582771/
> v5 - Provide pincrtl phandle to the gpio-led driver - https://patchwork.kernel.org/patch/2573981/
> 
>  arch/arm/boot/dts/omap4-panda-common.dtsi |   16 +++++++++++++++-
>  arch/arm/boot/dts/omap4-panda-es.dts      |   28 ++++++++++++++++++++++++++++
>  2 files changed, 43 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
> index 03bd60d..5fd59b3 100644
> --- a/arch/arm/boot/dts/omap4-panda-common.dtsi
> +++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
> @@ -16,8 +16,13 @@
>  		reg = <0x80000000 0x40000000>; /* 1 GB */
>  	};
>  
> -	leds {
> +	leds: leds {
>  		compatible = "gpio-leds";
> +		pinctrl-names = "default";
> +		pinctrl-0 = <
> +			&led_wkgpio_pins
> +		>;
> +
>  		heartbeat {
>  			label = "pandaboard::status1";
>  			gpios = <&gpio1 7 0>;
> @@ -137,6 +142,15 @@
>  	};
>  };
>  
> +&omap4_pmx_wkup {
> +	led_wkgpio_pins: pinmux_leds_wkpins {
> +		pinctrl-single,pins = <
> +			0x1a 0x3	/* gpio_wk7 OUTPUT | MODE 3 */
> +			0x1c 0x3	/* gpio_wk8 OUTPUT | MODE 3 */
> +		>;
> +	};
> +};
> +
>  &i2c1 {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&i2c1_pins>;
> diff --git a/arch/arm/boot/dts/omap4-panda-es.dts b/arch/arm/boot/dts/omap4-panda-es.dts
> index f1d8c21..c968a3b 100644
> --- a/arch/arm/boot/dts/omap4-panda-es.dts
> +++ b/arch/arm/boot/dts/omap4-panda-es.dts
> @@ -34,3 +34,31 @@
>  		0x5e 0x100	/* hdmi_sda.hdmi_sda INPUT | MODE 0 */
>  		>;
>  };
> +
> +&omap4_pmx_core {
> +	led_gpio_pins: gpio_led_pmx {
> +		pinctrl-single,pins = <
> +			0xb6 0x3	/* gpio_110 OUTPUT | MODE 3 */
> +		>;
> +	};
> +};
> +
> +&led_wkgpio_pins {
> +	pinctrl-single,pins = <
> +		0x1c 0x3	/* gpio_wk8 OUTPUT | MODE 3 */
> +	>;
> +};
> +
> +&leds {
> +	pinctrl-0 = <
> +		&led_gpio_pins
> +		&led_wkgpio_pins
> +	>;
> +
> +	heartbeat {
> +		gpios = <&gpio4 14 0>;
> +	};
> +	mmc {
> +		gpios = <&gpio1 8 0>;
> +	};
> +};
> 

