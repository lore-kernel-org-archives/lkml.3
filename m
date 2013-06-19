Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933968Ab3FSBXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:23:22 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58803 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932687Ab3FSBXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:23:21 -0400
Message-ID: <51C106A1.9030001@ti.com>
Date: Tue, 18 Jun 2013 20:17:21 -0500
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] ARM: dts: omap4-panda: Add USB Host support
References: <1371571487-14389-1-git-send-email-rogerq@ti.com> <1371571487-14389-2-git-send-email-rogerq@ti.com>
In-Reply-To: <1371571487-14389-2-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On 06/18/2013 11:04 AM, Roger Quadros wrote:
> Provide the RESET and Power regulators for the USB PHY,
> the USB Host port mode and the PHY device.
>
> Also provide pin multiplexer information for the USB host
> pins.
>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>   arch/arm/boot/dts/omap4-panda-common.dtsi |   62 +++++++++++++++++++++++++++++
>   1 files changed, 62 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
> index 00cbaa5..7a21e8e 100644
> --- a/arch/arm/boot/dts/omap4-panda-common.dtsi
> +++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
> @@ -59,6 +59,42 @@
>   			"AFML", "Line In",
>   			"AFMR", "Line In";
>   	};
> +
> +	/* HS USB Port 1 RESET */
> +	hsusb1_reset: hsusb1_reset_reg {
> +		compatible = "regulator-fixed";
> +		regulator-name = "hsusb1_reset";
> +		regulator-min-microvolt = <3300000>;
> +		regulator-max-microvolt = <3300000>;
> +		gpio = <&gpio2 30 0>;	/* gpio_62 */
> +		startup-delay-us = <70000>;
> +		enable-active-high;
> +	};

Is this really a regulator? Or just a GPIO line used to reset the USB PHY?

If this is the case, I don't think it should be represented as a regulator.

Regards,
Benoit

> +
> +	/* HS USB Port 1 Power */
> +	hsusb1_power: hsusb1_power_reg {
> +		compatible = "regulator-fixed";
> +		regulator-name = "hsusb1_vbus";
> +		regulator-min-microvolt = <3300000>;
> +		regulator-max-microvolt = <3300000>;
> +		gpio = <&gpio1 1 0>;	/* gpio_1 */
> +		startup-delay-us = <70000>;
> +		enable-active-high;
> +	};
> +
> +	/* HS USB Host PHY on PORT 1 */
> +	hsusb1_phy: hsusb1_phy {
> +		compatible = "usb-nop-xceiv";
> +		reset-supply = <&hsusb1_reset>;
> +		vcc-supply = <&hsusb1_power>;
> +	/**
> +	 * FIXME:
> +	 * put the right clock phandle here when available
> +	 *	clocks = <&auxclk3>;
> +	 *	clock-names = "main_clk";
> +	 */
> +		clock-frequency = <19200000>;
> +	};
>   };
>
>   &omap4_pmx_wkup {
> @@ -83,6 +119,7 @@
>   			&mcbsp1_pins
>   			&dss_hdmi_pins
>   			&tpd12s015_pins
> +			&hsusbb1_pins
>   	>;
>
>   	twl6030_pins: pinmux_twl6030_pins {
> @@ -133,6 +170,23 @@
>   		>;
>   	};
>
> +	hsusbb1_pins: pinmux_hsusbb1_pins {
> +		pinctrl-single,pins = <
> +			0x82 (PIN_INPUT_PULLDOWN | MUX_MODE4)	/* usbb1_ulpitll_clk.usbb1_ulpiphy_clk */
> +			0x84 (PIN_OUTPUT | MUX_MODE4)		/* usbb1_ulpitll_stp.usbb1_ulpiphy_stp */
> +			0x86 (PIN_INPUT_PULLDOWN | MUX_MODE4)	/* usbb1_ulpitll_dir.usbb1_ulpiphy_dir */
> +			0x88 (PIN_INPUT_PULLDOWN | MUX_MODE4)	/* usbb1_ulpitll_nxt.usbb1_ulpiphy_nxt */
> +			0x8a (PIN_INPUT_PULLDOWN | MUX_MODE4)	/* usbb1_ulpitll_dat0.usbb1_ulpiphy_dat0 */
> +			0x8c (PIN_INPUT_PULLDOWN | MUX_MODE4)	/* usbb1_ulpitll_dat1.usbb1_ulpiphy_dat1 */
> +			0x8e (PIN_INPUT_PULLDOWN | MUX_MODE4)	/* usbb1_ulpitll_dat2.usbb1_ulpiphy_dat2 */
> +			0x90 (PIN_INPUT_PULLDOWN | MUX_MODE4)	/* usbb1_ulpitll_dat3.usbb1_ulpiphy_dat3 */
> +			0x92 (PIN_INPUT_PULLDOWN | MUX_MODE4)	/* usbb1_ulpitll_dat4.usbb1_ulpiphy_dat4 */
> +			0x94 (PIN_INPUT_PULLDOWN | MUX_MODE4)	/* usbb1_ulpitll_dat5.usbb1_ulpiphy_dat5 */
> +			0x96 (PIN_INPUT_PULLDOWN | MUX_MODE4)	/* usbb1_ulpitll_dat6.usbb1_ulpiphy_dat6 */
> +			0x98 (PIN_INPUT_PULLDOWN | MUX_MODE4)	/* usbb1_ulpitll_dat7.usbb1_ulpiphy_dat7 */
> +		>;
> +	};
> +
>   	i2c1_pins: pinmux_i2c1_pins {
>   		pinctrl-single,pins = <
>   			0xe2 (PIN_INPUT_PULLUP | MUX_MODE0)	/* i2c1_scl */
> @@ -283,3 +337,11 @@
>   	mode = <3>;
>   	power = <50>;
>   };
> +
> +&usbhshost {
> +	port1-mode = "ehci-phy";
> +};
> +
> +&usbhsehci {
> +	phys = <&hsusb1_phy>;
> +};
>

