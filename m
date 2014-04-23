Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaDWWv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 18:51:29 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33685 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751289AbaDWWv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 18:51:28 -0400
Date: Thu, 24 Apr 2014 00:51:25 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 4/5] ARM: berlin/dt: add sdio clocks to BG2CD
Message-ID: <20140423225125.GB12738@kwain>
References: <1398261667-12621-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1398261667-12621-5-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398261667-12621-5-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexandre,

On Wed, Apr 23, 2014 at 04:01:06PM +0200, Alexandre Belloni wrote:
> Add sdio clocks to the berlin2cd.dtsi
> Also reorder the PLLs nodes by address
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  arch/arm/boot/dts/berlin2cd.dtsi | 42 ++++++++++++++++++++++++++--------------
>  1 file changed, 28 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/berlin2cd.dtsi b/arch/arm/boot/dts/berlin2cd.dtsi
> index bd4e9dd4867e..9b3faeee0728 100644
> --- a/arch/arm/boot/dts/berlin2cd.dtsi
> +++ b/arch/arm/boot/dts/berlin2cd.dtsi
> @@ -79,20 +79,6 @@
>  			clocks = <&twdclk>;
>  		};
>  
> -		syspll: syspll@ea0014 {
> -			compatible = "marvell,berlin2-pll";
> -			clocks = <&smclk>;
> -			#clock-cells = <0>;
> -			reg = <0xf7ea0014 8>;
> -		};
> -
> -		cpupll: cpupll@ea003c {
> -			compatible = "marvell,berlin2-pll";
> -			clocks = <&smclk>;
> -			#clock-cells = <0>;
> -			reg = <0xf7ea003c 8>;
> -		};
> -
>  		apb@e80000 {
>  			compatible = "simple-bus";
>  			#address-cells = <1>;
> @@ -183,6 +169,34 @@
>  			};
>  		};
>  
> +		syspll: syspll@ea0014 {
> +			compatible = "marvell,berlin2-pll";
> +			clocks = <&smclk>;
> +			#clock-cells = <0>;
> +			reg = <0xf7ea0014 8>;

You can drop the 'f7' here

> +		};
> +
> +		cpupll: cpupll@ea003c {
> +			compatible = "marvell,berlin2-pll";
> +			clocks = <&smclk>;
> +			#clock-cells = <0>;
> +			reg = <0xf7ea003c 8>;

and here.

Thanks!

Antoine

> +		};
> +
> +		sdio0xinclk: sdio0xinclk@ea023c {
> +			compatible = "marvell,berlin-clk";
> +			clocks = <&syspll>;
> +			#clock-cells = <0>;
> +			reg = <0xea023c 4>;
> +		};
> +
> +		sdio1xinclk: sdio1xinclk@ea0240 {
> +			compatible = "marvell,berlin-clk";
> +			clocks = <&syspll>;
> +			#clock-cells = <0>;
> +			reg = <0xea0240 4>;
> +		};
> +
>  		apb@fc0000 {
>  			compatible = "simple-bus";
>  			#address-cells = <1>;
> -- 
> 1.9.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
