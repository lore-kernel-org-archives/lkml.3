Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965421AbaCUMIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 08:08:19 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:62213 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760098AbaCUMIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 08:08:17 -0400
Message-ID: <532C2D00.2080508@gmail.com>
Date: Fri, 21 Mar 2014 13:13:52 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Subject: Re: [PATCH 5/5] ARM: berlin/dt: add cpupll and syspll support to
 BG2
References: <1395402220-23503-1-git-send-email-alexandre.belloni@free-electrons.com> <1395402220-23503-6-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1395402220-23503-6-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 12:43 PM, Alexandre Belloni wrote:
> This also moves the clocks from the clocks container node to the root.

Same comments as for patch 4/5.

> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>   arch/arm/boot/dts/berlin2.dtsi | 56 +++++++++++++++++++++++++++++-------------
>   1 file changed, 39 insertions(+), 17 deletions(-)
>
> diff --git a/arch/arm/boot/dts/berlin2.dtsi b/arch/arm/boot/dts/berlin2.dtsi
> index 56a1af2f1052..4b82076ef1ed 100644
> --- a/arch/arm/boot/dts/berlin2.dtsi
> +++ b/arch/arm/boot/dts/berlin2.dtsi
> @@ -37,24 +37,46 @@
>   		};
>   	};
>
> -	clocks {
> -		smclk: sysmgr-clock {
> -			compatible = "fixed-clock";
> -			#clock-cells = <0>;
> -			clock-frequency = <25000000>;
> -		};
> +	smclk: sysmgr-clock {
> +		compatible = "fixed-clock";
> +		#clock-cells = <0>;
> +		clock-frequency = <25000000>;
> +	};
>
> -		cfgclk: cfg-clock {
> -			compatible = "fixed-clock";
> -			#clock-cells = <0>;
> -			clock-frequency = <100000000>;
> -		};
> +	cfgclk: cfg-clock {
> +		compatible = "fixed-clock";
> +		#clock-cells = <0>;
> +		clock-frequency = <100000000>;
> +	};
>
> -		sysclk: system-clock {
> -			compatible = "fixed-clock";
> -			#clock-cells = <0>;
> -			clock-frequency = <400000000>;
> -		};
> +	syspll: syspll {
> +		compatible = "marvell,berlin2-pll";
> +		clocks = <&smclk>;
> +		#clock-cells = <0>;
> +		reg = <0xf7ea0014 8>;
> +	};
> +
> +	cpupll: cpupll {
> +		compatible = "marvell,berlin2-pll";
> +		clocks = <&smclk>;
> +		#clock-cells = <0>;
> +		reg = <0xf7ea003c 8>;
> +	};
> +
> +	cpuclk: cpu-clock {
> +		compatible = "fixed-factor-clock";
> +		clocks = <&cpupll>;
> +		#clock-cells = <0>;
> +		clock-div = <1>;
> +		clock-mult = <1>;
> +	};
> +
> +	twdclk: twdclk {
> +		compatible = "fixed-factor-clock";
> +		#clock-cells = <0>;
> +		clocks = <&cpuclk>;
> +		clock-mult = <1>;
> +		clock-div = <3>;
>   	};
>
>   	soc {
> @@ -83,7 +105,7 @@
>   			compatible = "arm,cortex-a9-twd-timer";
>   			reg = <0xad0600 0x20>;
>   			interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
> -			clocks = <&sysclk>;
> +			clocks = <&twdclk>;
>   		};
>
>   		apb@e80000 {
>

