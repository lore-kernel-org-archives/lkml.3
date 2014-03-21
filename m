Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760833AbaCUMHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 08:07:49 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58549 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760683AbaCUMHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 08:07:47 -0400
Message-ID: <532C2CE0.4000205@gmail.com>
Date: Fri, 21 Mar 2014 13:13:20 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Subject: Re: [PATCH 4/5] ARM: berlin/dt: add cpupll and syspll support to
 BG2CD
References: <1395402220-23503-1-git-send-email-alexandre.belloni@free-electrons.com> <1395402220-23503-5-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1395402220-23503-5-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 12:43 PM, Alexandre Belloni wrote:
> This also moves the clocks from the clocks container node to the root.

Please leave a word on the original intention of the patch here, too.

> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>   arch/arm/boot/dts/berlin2cd.dtsi | 56 ++++++++++++++++++++++++++++------------
>   1 file changed, 39 insertions(+), 17 deletions(-)
>
> diff --git a/arch/arm/boot/dts/berlin2cd.dtsi b/arch/arm/boot/dts/berlin2cd.dtsi
> index 094968c27533..c84013c1597c 100644
> --- a/arch/arm/boot/dts/berlin2cd.dtsi
> +++ b/arch/arm/boot/dts/berlin2cd.dtsi
> @@ -30,24 +30,46 @@
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
> -			clock-frequency = <75000000>;
> -		};
> +	cfgclk: cfg-clock {
> +		compatible = "fixed-clock";
> +		#clock-cells = <0>;
> +		clock-frequency = <75000000>;
> +	};
>
> -		sysclk: system-clock {
> -			compatible = "fixed-clock";
> -			#clock-cells = <0>;
> -			clock-frequency = <300000000>;
> -		};
> +	syspll: syspll {

syspll: pll@ea0014 and sort it in SoC nodes.

> +		compatible = "marvell,berlin2-pll";
> +		clocks = <&smclk>;
> +		#clock-cells = <0>;
> +		reg = <0xf7ea0014 8>;
> +	};
> +
> +	cpupll: cpupll {

ditto.

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

Same comment about cpuclk to cpupll relation.

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
> @@ -76,7 +98,7 @@
>   			compatible = "arm,cortex-a9-twd-timer";
>   			reg = <0xad0600 0x20>;
>   			interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
> -			clocks = <&sysclk>;
> +			clocks = <&twdclk>;
>   		};
>
>   		apb@e80000 {
>

