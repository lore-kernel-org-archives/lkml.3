Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbaCUVfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 17:35:33 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:39103 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaCUVfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 17:35:31 -0400
Message-ID: <532CB09E.5000408@gmail.com>
Date: Fri, 21 Mar 2014 22:35:26 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>
CC: Jimmy Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Subject: Re: [PATCH v2 4/5] ARM: berlin/dt: add cpupll and syspll support
 to BG2CD
References: <1395432521-11055-1-git-send-email-alexandre.belloni@free-electrons.com> <1395432521-11055-5-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1395432521-11055-5-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 09:08 PM, Alexandre Belloni wrote:
> The Berlin BG2CD has two supported PLLs: CPU PLL and System PLL, add those to
> the SoC device tree.
>
> This also moves the remaining clocks from the clocks container node to the root.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>   arch/arm/boot/dts/berlin2cd.dtsi | 48 ++++++++++++++++++++++++++--------------
>   1 file changed, 31 insertions(+), 17 deletions(-)
>
> diff --git a/arch/arm/boot/dts/berlin2cd.dtsi b/arch/arm/boot/dts/berlin2cd.dtsi
> index 094968c27533..bd4e9dd4867e 100644
> --- a/arch/arm/boot/dts/berlin2cd.dtsi
> +++ b/arch/arm/boot/dts/berlin2cd.dtsi
> @@ -30,24 +30,24 @@
[...]
> @@ -76,7 +76,21 @@
>   			compatible = "arm,cortex-a9-twd-timer";
>   			reg = <0xad0600 0x20>;
>   			interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
> -			clocks = <&sysclk>;
> +			clocks = <&twdclk>;
> +		};
> +
> +		syspll: syspll@ea0014 {
> +			compatible = "marvell,berlin2-pll";
> +			clocks = <&smclk>;
> +			#clock-cells = <0>;
> +			reg = <0xf7ea0014 8>;

nit: I prefer hex numbers all over for reg properties. berlin2q already
has them, and I'll fixup this and the one below myself.

> +		};
> +
> +		cpupll: cpupll@ea003c {
> +			compatible = "marvell,berlin2-pll";
> +			clocks = <&smclk>;
> +			#clock-cells = <0>;
> +			reg = <0xf7ea003c 8>;

ditto.

Sebastian

>   		};
>
>   		apb@e80000 {
>

