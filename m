Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403AbaELNEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 09:04:41 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:4630 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758229AbaELNEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 09:04:39 -0400
Message-ID: <5370C6E4.3020509@atmel.com>
Date: Mon, 12 May 2014 15:04:36 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] ARM: at91/dt: sam9261: Fix PLL output ranges and
 other clocks divisors
References: <1398243220-20874-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1398243220-20874-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

To the whole series:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

and pushed on at91-3.16-dt2

Thanks, bye,

On 23/04/2014 10:53, Alexandre Belloni :
> Argument 3 (OUT) and 4 (ICPLL) of the atmel,pll-clk-output-ranges were missing.
> Also, the at91sam9261 doesn't really have a by 3 divisor.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  arch/arm/boot/dts/at91sam9261.dtsi | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/at91sam9261.dtsi b/arch/arm/boot/dts/at91sam9261.dtsi
> index 561addceb81e..3ff239b26d72 100644
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
> @@ -575,7 +576,8 @@
>  					reg = <1>;
>  					atmel,clk-input-range = <1000000 32000000>;
>  					#atmel,pll-clk-output-range-cells = <4>;
> -					atmel,pll-clk-output-ranges = <80000000 200000000 190000000 240000000>;
> +					atmel,pll-clk-output-ranges = <80000000 200000000 0 1>,
> +								<190000000 240000000 2 1>;
>  				};
>  
>  				mck: masterck {
> @@ -584,13 +586,13 @@
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
> 


-- 
Nicolas Ferre
