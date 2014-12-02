Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbaLBOD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:03:29 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:52132 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbaLBOD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:03:28 -0500
Date: Tue, 2 Dec 2014 22:03:14 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Philippe Reynes <tremyfr@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] apf27dev: add max5821 to the dts
Message-ID: <20141202140313.GI2411@dragon>
References: <1417120439-11784-1-git-send-email-tremyfr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417120439-11784-1-git-send-email-tremyfr@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 09:33:59PM +0100, Philippe Reynes wrote:
> 
> Signed-off-by: Philippe Reynes <tremyfr@gmail.com>

Applied, thanks.

> ---
>  arch/arm/boot/dts/imx27-apf27dev.dts |   21 +++++++++++++++++++++
>  1 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/imx27-apf27dev.dts b/arch/arm/boot/dts/imx27-apf27dev.dts
> index da306c5..bba3f41 100644
> --- a/arch/arm/boot/dts/imx27-apf27dev.dts
> +++ b/arch/arm/boot/dts/imx27-apf27dev.dts
> @@ -59,6 +59,21 @@
>  			linux,default-trigger = "heartbeat";
>  		};
>  	};
> +
> +	regulators {
> +		compatible = "simple-bus";
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		reg_max5821: regulator@0 {
> +			compatible = "regulator-fixed";
> +			reg = <0>;
> +			regulator-name = "max5821-reg";
> +			regulator-min-microvolt = <2500000>;
> +			regulator-max-microvolt = <2500000>;
> +			regulator-always-on;
> +		};
> +	};
>  };
>  
>  &cspi1 {
> @@ -107,6 +122,12 @@
>  		compatible = "dallas,ds1374";
>  		reg = <0x68>;
>  	};
> +
> +	max5821@38 {
> +		compatible = "maxim,max5821";
> +		reg = <0x38>;
> +		vref-supply = <&reg_max5821>;
> +	};
>  };
>  
>  &i2c2 {
> -- 
> 1.7.4.4
> 
