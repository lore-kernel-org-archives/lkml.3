Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273AbaCUVdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 17:33:42 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:63791 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbaCUVdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 17:33:39 -0400
Message-ID: <532CB02E.90209@gmail.com>
Date: Fri, 21 Mar 2014 22:33:34 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>
CC: Jimmy Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Subject: Re: [PATCH v2 3/5] ARM: berlin/dt: add cpupll and syspll support
 to BG2Q
References: <1395432521-11055-1-git-send-email-alexandre.belloni@free-electrons.com> <1395432521-11055-4-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1395432521-11055-4-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 09:08 PM, Alexandre Belloni wrote:
> The Berlin BG2Q has two supported PLLs: CPU PLL and System PLL, add those to the
> SoC device tree.
>
> Note that support for the AVPLL is not yet available.

Above should not be part of the commit message, no need to resend.
I can fix it up.

Sebastian

> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>   arch/arm/boot/dts/berlin2q.dtsi | 22 +++++++++++++++-------
>   1 file changed, 15 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
> index 07452a7483fa..5925e6a16749 100644
> --- a/arch/arm/boot/dts/berlin2q.dtsi
> +++ b/arch/arm/boot/dts/berlin2q.dtsi
> @@ -59,16 +59,10 @@
>   		clock-frequency = <100000000>;
>   	};
>
> -	cpuclk: cpu-clock {
> -		compatible = "fixed-clock";
> -		#clock-cells = <0>;
> -		clock-frequency = <1200000000>;
> -	};
> -
>   	twdclk: twdclk {
>   		compatible = "fixed-factor-clock";
>   		#clock-cells = <0>;
> -		clocks = <&cpuclk>;
> +		clocks = <&cpupll>;
>   		clock-mult = <1>;
>   		clock-div = <3>;
>   	};
> @@ -101,6 +95,20 @@
>   			#interrupt-cells = <3>;
>   		};
>
> +		cpupll: cpupll@dd0170 {
> +			compatible = "marvell,berlin2q-pll";
> +			clocks = <&smclk>;
> +			#clock-cells = <0>;
> +			reg = <0xdd0170 0x8>;
> +		};
> +
> +		syspll: syspll@ea0030 {
> +			compatible = "marvell,berlin2q-pll";
> +			clocks = <&smclk>;
> +			#clock-cells = <0>;
> +			reg = <0xea0030 0x8>;
> +		};
> +
>   		apb@e80000 {
>   			compatible = "simple-bus";
>   			#address-cells = <1>;
>

