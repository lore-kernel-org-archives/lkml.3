Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbaHYLIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 07:08:49 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:35704 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbaHYLIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 07:08:48 -0400
Date: Mon, 25 Aug 2014 07:08:46 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Wei Ni <wni@nvidia.com>
Cc: khali@linux-fr.org, linux@roeck-us.net, swarren@wwwdotorg.org,
        lm-sensors@lm-sensors.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] ARM: tegra: dalmore: add thermal zones for nct1008
Message-ID: <20140825110844.GB12349@developer>
References: <1408948188-4181-1-git-send-email-wni@nvidia.com>
 <1408948188-4181-5-git-send-email-wni@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408948188-4181-5-git-send-email-wni@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 02:29:48PM +0800, Wei Ni wrote:
> From: lightning314 <wni@nvidia.com>
> 
> Add dt node to describe the thermal zone for the nct1008.
> 
> Signed-off-by: Wei Ni <wni@nvidia.com>
> ---
>  arch/arm/boot/dts/tegra114-dalmore.dts | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
> index 5c21d21..94a1b5d 100644
> --- a/arch/arm/boot/dts/tegra114-dalmore.dts
> +++ b/arch/arm/boot/dts/tegra114-dalmore.dts
> @@ -779,12 +779,14 @@
>  				<&gpio TEGRA_GPIO(V, 3) GPIO_ACTIVE_HIGH>;
>  		};
>  
> -		temperature-sensor@4c {
> +		nct1008: temperature-sensor@4c {
>  			compatible = "onnn,nct1008";
>  			reg = <0x4c>;
>  			vcc-supply = <&palmas_ldo6_reg>;
>  			interrupt-parent = <&gpio>;
>  			interrupts = <TEGRA_GPIO(O, 4) IRQ_TYPE_LEVEL_LOW>;
> +
> +			#thermal-sensor-cells = <1>;
>  		};
>  	};
>  
> @@ -1283,4 +1285,20 @@
>  			 <&tegra_car TEGRA114_CLK_EXTERN1>;
>  		clock-names = "pll_a", "pll_a_out0", "mclk";
>  	};
> +
> +	thermal-zones {
> +		nct1008-local {
> +			polling-delay-passive = <2000>; /* milliseconds */
> +			polling-delay = <0>; /* milliseconds */
> +
> +			thermal-sensors = <&nct1008 0>;
> +		};
> +
> +		nct1008-remote {
> +			polling-delay-passive = <1000>; /* milliseconds */
> +			polling-delay = <0>; /* milliseconds */
> +
> +			thermal-sensors = <&nct1008 1>;
> +		};
> +	};

The above zones misses the required properties, as per the thermal.txt
binding description. Could you please have a look on those that are
required and improve the zones above?

>  };
> -- 
> 1.8.1.5
> 
