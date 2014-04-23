Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbaDWWtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 18:49:50 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33678 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751401AbaDWWtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 18:49:49 -0400
Date: Thu, 24 Apr 2014 00:49:46 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 5/5] ARM: berlin/dt: add sdio clocks to BG2Q
Message-ID: <20140423224946.GA12738@kwain>
References: <1398261667-12621-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1398261667-12621-6-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398261667-12621-6-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexandre,

On Wed, Apr 23, 2014 at 04:01:07PM +0200, Alexandre Belloni wrote:
> Add sdio clocks to the berlin2q.dtsi
> Also reorder the syspll node
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  arch/arm/boot/dts/berlin2q.dtsi | 28 +++++++++++++++++++++-------
>  1 file changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
> index 5925e6a16749..0fc826305614 100644
> --- a/arch/arm/boot/dts/berlin2q.dtsi
> +++ b/arch/arm/boot/dts/berlin2q.dtsi
> @@ -102,13 +102,6 @@
>  			reg = <0xdd0170 0x8>;
>  		};
>  
> -		syspll: syspll@ea0030 {
> -			compatible = "marvell,berlin2q-pll";
> -			clocks = <&smclk>;
> -			#clock-cells = <0>;
> -			reg = <0xea0030 0x8>;
> -		};
> -
>  		apb@e80000 {
>  			compatible = "simple-bus";
>  			#address-cells = <1>;
> @@ -191,6 +184,27 @@
>  			};
>  		};
>  
> +		syspll: syspll@ea0030 {
> +			compatible = "marvell,berlin2q-pll";
> +			clocks = <&smclk>;
> +			#clock-cells = <0>;
> +			reg = <0xea0030 0x8>;
> +		};
> +
> +		sdio0xinclk: sdio0xinclk@ea0158 {
> +			compatible = "marvell,berlin-clk";
> +			clocks = <&syspll>;
> +			#clock-cells = <0>;
> +			reg = <0xea0158 4>;

I believe you can use

			reg = <0xea0158 0x4>;

since you used an hex value in the previous node. Plus we tend to use
hex values elsewhere too.

> +		};
> +
> +		sdio1xinclk: sdio1xinclk@ea015c {
> +			compatible = "marvell,berlin-clk";
> +			clocks = <&syspll>;
> +			#clock-cells = <0>;
> +			reg = <0xea015c 4>;

Ditto. This also applies to BG2/BG2CD and the documentation patches.

Thanks!

Antoine

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
