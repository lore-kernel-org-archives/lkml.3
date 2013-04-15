Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490Ab3DOMj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 08:39:28 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55851 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933304Ab3DOMjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 08:39:24 -0400
Message-ID: <516BF4F3.5060904@ti.com>
Date: Mon, 15 Apr 2013 15:39:15 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <b-cousson@ti.com>, <tony@atomide.com>
CC: Roger Quadros <rogerq@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: omap3-beagle-xm: Add USB Host support for Rev
 Ax/Bx
References: <1366029306-1824-1-git-send-email-rogerq@ti.com>
In-Reply-To: <1366029306-1824-1-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2013 03:35 PM, Roger Quadros wrote:
> Provide RESET and Power regulators for the USB PHY,
> the USB Host port mode and the PHY device.
> 
> Also provide pin multiplexer information for USB host
> pins.
> 
> This will not work for Rev Cx boards because of reversed logic
> for USB_POWER_Enable.
> 
> CC: Benoît Cousson <b-cousson@ti.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  arch/arm/boot/dts/omap3-beagle-xm.dts |   62 +++++++++++++++++++++++++++++++++
>  1 files changed, 62 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/omap3-beagle-xm.dts b/arch/arm/boot/dts/omap3-beagle-xm.dts
> index 5a31964..d394c51 100644
> --- a/arch/arm/boot/dts/omap3-beagle-xm.dts
> +++ b/arch/arm/boot/dts/omap3-beagle-xm.dts
> @@ -57,6 +57,60 @@
>  		ti,mcbsp = <&mcbsp2>;
>  		ti,codec = <&twl_audio>;
>  	};
> +
> +	/* HS USB Port 2 RESET */
> +	hsusb2_reset: hsusb2_reset_reg {
> +		compatible = "regulator-fixed";
> +		regulator-name = "hsusb2_reset";
> +		regulator-min-microvolt = <3300000>;
> +		regulator-max-microvolt = <3300000>;
> +		gpio = <&gpio5 19 0>;	/* gpio_147 */
> +		startup-delay-us = <70000>;
> +		enable-active-high;
> +	};
> +
> +	/* HS USB Port 2 Power */
> +	hsusb2_power: hsusb2_power_reg {
> +		compatible = "regulator-fixed";
> +		regulator-name = "hsusb2_vbus";
> +		regulator-min-microvolt = <3300000>;
> +		regulator-max-microvolt = <3300000>;
> +		gpio = <&twl_gpio 18 0>;	/* GPIO LEDA */
> +		startup-delay-us = <70000>;
> +		enable-active-high;	/* FIXME: active-low for Rev. C */

Benoit & Tony,

Any ideas how to tackle the reversed logic for Rev. C boards?

> +	};
> +
> +	/* HS USB Host PHY on PORT 2 */
> +	hsusb2_phy: hsusb2_phy {
> +		compatible = "usb-nop-xceiv";
> +		reset-supply = <&hsusb2_reset>;
> +		vcc-supply = <&hsusb2_power>;
> +	};
> +
> +};

cheers,
-roger

