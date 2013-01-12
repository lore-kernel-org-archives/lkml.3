Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab3ALVnE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 16:43:04 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:64074 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754304Ab3ALVnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 16:43:02 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+VjhVuFFeknYIa4OSJSuUDrFmGYLYjtaI=
Date: Sat, 12 Jan 2013 16:42:57 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Dove: move CuBox led pinctrl to gpio-leds node
Message-ID: <20130112214257.GF13433@titan.lakedaemon.net>
References: <1356646870-2903-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356646870-2903-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian,

On Thu, Dec 27, 2012 at 11:21:10PM +0100, Sebastian Hesselbarth wrote:
> gpio-leds has support for pinctrl allocation, make use of it.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/boot/dts/dove-cubox.dts |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/dove-cubox.dts b/arch/arm/boot/dts/dove-cubox.dts
> index cdee96f..bed5b62 100644
> --- a/arch/arm/boot/dts/dove-cubox.dts
> +++ b/arch/arm/boot/dts/dove-cubox.dts
> @@ -17,6 +17,9 @@
>  
>  	leds {
>  		compatible = "gpio-leds";
> +		pinctrl-0 = <&pmx_gpio_18>;
> +		pinctrl-names = "default";
> +
>  		power {
>  			label = "Power";
>  			gpios = <&gpio0 18 1>;
> @@ -47,7 +50,7 @@
>  };
>  
>  &pinctrl {
> -	pinctrl-0 = <&pmx_gpio_12 &pmx_gpio_18>;
> +	pinctrl-0 = <&pmx_gpio_12>;
>  	pinctrl-names = "default";
>  
>  	pmx_gpio_12: pmx-gpio-12 {
> -- 
> 1.7.10.4

I'm getting a merge conflict wit hthe above:

&pinctrl {
<<<<<<< HEAD
        pinctrl-0 = <&pmx_gpio_18>;
======= 
        pinctrl-0 = <&pmx_gpio_12>;
>>>>>>> ARM: Dove: move CuBox led pinctrl to gpio-leds node
        pinctrl-names = "default";

        pmx_gpio_18: pmx-gpio-18 {
                marvell,pins = "mpp18";
                marvell,function = "gpio";
        };
};


Am I missing something?

thx,

Jason.
