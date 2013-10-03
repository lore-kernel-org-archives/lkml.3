Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab3JCKfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 06:35:18 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55903 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552Ab3JCKfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 06:35:11 -0400
Message-ID: <524D483D.9040907@ti.com>
Date: Thu, 3 Oct 2013 13:34:37 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <bcousson@baylibre.com>
CC: Roger Quadros <rogerq@ti.com>, <balbi@ti.com>, <tony@atomide.com>,
        <p.zabel@pengutronix.de>, <broonie@kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 05/10] ARM: dts: omap3-beagle: Use reset-gpios for
 hsusb2_reset
References: <1380012836-29900-1-git-send-email-rogerq@ti.com> <1380012836-29900-6-git-send-email-rogerq@ti.com>
In-Reply-To: <1380012836-29900-6-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

Could you please take the device tree related patches [5 to 10] in this series?
Thanks.

cheers,
-roger

On 09/24/2013 11:53 AM, Roger Quadros wrote:
> We no longer need to model the RESET line as a regulator since
> the USB phy-nop driver accepts "reset-gpios" property.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  arch/arm/boot/dts/omap3-beagle.dts |   13 +------------
>  1 files changed, 1 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/omap3-beagle.dts b/arch/arm/boot/dts/omap3-beagle.dts
> index dfd8310..71bde47 100644
> --- a/arch/arm/boot/dts/omap3-beagle.dts
> +++ b/arch/arm/boot/dts/omap3-beagle.dts
> @@ -44,17 +44,6 @@
>  		};
>  	};
>  
> -	/* HS USB Port 2 RESET */
> -	hsusb2_reset: hsusb2_reset_reg {
> -		compatible = "regulator-fixed";
> -		regulator-name = "hsusb2_reset";
> -		regulator-min-microvolt = <3300000>;
> -		regulator-max-microvolt = <3300000>;
> -		gpio = <&gpio5 19 0>;	/* gpio_147 */
> -		startup-delay-us = <70000>;
> -		enable-active-high;
> -	};
> -
>  	/* HS USB Port 2 Power */
>  	hsusb2_power: hsusb2_power_reg {
>  		compatible = "regulator-fixed";
> @@ -68,7 +57,7 @@
>  	/* HS USB Host PHY on PORT 2 */
>  	hsusb2_phy: hsusb2_phy {
>  		compatible = "usb-nop-xceiv";
> -		reset-supply = <&hsusb2_reset>;
> +		reset-gpios = <&gpio5 19 GPIO_ACTIVE_LOW>;	/* gpio_147 */
>  		vcc-supply = <&hsusb2_power>;
>  	};
>  
> 

