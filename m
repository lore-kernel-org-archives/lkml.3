Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbaCUVgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 17:36:38 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:49225 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbaCUVgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 17:36:35 -0400
Message-ID: <532CB0DF.3080003@gmail.com>
Date: Fri, 21 Mar 2014 22:36:31 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>
CC: Jimmy Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Subject: Re: [PATCH v2 5/5] ARM: berlin/dt: add cpupll and syspll support
 to BG2
References: <1395432521-11055-1-git-send-email-alexandre.belloni@free-electrons.com> <1395432521-11055-6-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1395432521-11055-6-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 09:08 PM, Alexandre Belloni wrote:
> The Berlin BG2 has two supported PLLs: CPU PLL and System PLL, add those to the
> SoC device tree.
>
> This also moves the remaining clocks from the clocks container node to the root.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>   arch/arm/boot/dts/berlin2.dtsi | 48 +++++++++++++++++++++++++++---------------
>   1 file changed, 31 insertions(+), 17 deletions(-)
>
> diff --git a/arch/arm/boot/dts/berlin2.dtsi b/arch/arm/boot/dts/berlin2.dtsi
> index 56a1af2f1052..6c080eb6242a 100644
> --- a/arch/arm/boot/dts/berlin2.dtsi
> +++ b/arch/arm/boot/dts/berlin2.dtsi
[...]
> @@ -83,7 +83,21 @@
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
> +			reg = <0xea0014 8>;
> +		};
> +
> +		cpupll: cpupll@ea003c {
> +			compatible = "marvell,berlin2-pll";
> +			clocks = <&smclk>;
> +			#clock-cells = <0>;
> +			reg = <0xea003c 8>;

Same comment about hex numbers and I'll also fix it up.

Sebastian

>   		};
>
>   		apb@e80000 {
>

