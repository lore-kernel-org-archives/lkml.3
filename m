Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591AbaELOZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 10:25:48 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58732 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758165AbaELOZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 10:25:47 -0400
Message-ID: <5370D9E0.4000509@free-electrons.com>
Date: Mon, 12 May 2014 16:25:36 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] ARM: at91/dt: sam9261: Fix PLL output ranges and other
 clocks divisors
References: <1399904532-3688-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1399904532-3688-1-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/05/2014 16:22, Alexandre Belloni wrote:
> Argument 3 (OUT) and 4 (ICPLL) of the atmel,pll-clk-output-ranges were missing.
> Also, the at91sam9261 doesn't really have a by 3 divisor.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> ---
> Changed in v2:
> After getting feedback from the atmel HW engineers, it appears that PLLB is not
> the same as PLLA despite what the datasheet seems to imply. The patch is updated
> to reflect that.
>
>  arch/arm/boot/dts/at91sam9261.dtsi | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm/boot/dts/at91sam9261.dtsi b/arch/arm/boot/dts/at91sam9261.dtsi
> index 561addceb81e..44d9e5ab09c3 100644
> --- a/arch/arm/boot/dts/at91sam9261.dtsi
> +++ b/arch/arm/boot/dts/at91sam9261.dtsi
> @@ -564,7 +564,8 @@
>  					reg = <0>;
>  					atmel,clk-input-range = <1000000 32000000>;
>  					#atmel,pll-clk-output-range-cells = <4>;
> -					atmel,pll-clk-output-ranges = <80000000 200000000 190000000 240000000>;
> +					atmel,pll-clk-output-ranges = <80000000 200000000 0 1>,
> +								<190000000 240000000 2 1>;
>  				};
>  
>  				pllb: pllbck {
> @@ -573,9 +574,9 @@
>  					interrupts-extended = <&pmc AT91_PMC_LOCKB>;
>  					clocks = <&main>;
>  					reg = <1>;
> -					atmel,clk-input-range = <1000000 32000000>;
> +					atmel,clk-input-range = <1000000 5000000>;
>  					#atmel,pll-clk-output-range-cells = <4>;
> -					atmel,pll-clk-output-ranges = <80000000 200000000 190000000 240000000>;
> +					atmel,pll-clk-output-ranges = <70000000 130000000 1 1>;
>  				};
>  
>  				mck: masterck {
> @@ -584,13 +585,13 @@
>  					interrupts-extended = <&pmc AT91_PMC_MCKRDY>;
>  					clocks = <&clk32k>, <&main>, <&plla>, <&pllb>;
>  					atmel,clk-output-range = <0 94000000>;
> -					atmel,clk-divisors = <1 2 4 3>;
> +					atmel,clk-divisors = <1 2 4 0>;
>  				};
>  
>  				usb: usbck {
>  					compatible = "atmel,at91rm9200-clk-usb";
>  					#clock-cells = <0>;
> -					atmel,clk-divisors = <1 2 4 3>;
> +					atmel,clk-divisors = <1 2 4 0>;
>  					clocks = <&pllb>;
>  				};
>  

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

