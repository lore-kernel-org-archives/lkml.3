Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbaIRPSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:18:50 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:63126 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059AbaIRPSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:18:49 -0400
Message-ID: <541AF7D2.7080106@atmel.com>
Date: Thu, 18 Sep 2014 17:18:42 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: at91/dt: declare sckc node on at91sam9g45
References: <1410257660-8590-1-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1410257660-8590-1-git-send-email-boris.brezillon@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 12:14, Boris BREZILLON :
> Declare the SCKC (Slow Clock Configuration) block and its clks.
> Make use of the clk32k clk instead of slow_osc where appropriate.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Stacked on top of at91-3.18-dt3.

Thanks, best regards,

> ---
>  arch/arm/boot/dts/at91sam9g45.dtsi | 30 ++++++++++++++++++++++++++++--
>  1 file changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
> index 9d4d0a1..68a457b 100644
> --- a/arch/arm/boot/dts/at91sam9g45.dtsi
> +++ b/arch/arm/boot/dts/at91sam9g45.dtsi
> @@ -159,7 +159,7 @@
>  					compatible = "atmel,at91rm9200-clk-master";
>  					#clock-cells = <0>;
>  					interrupts-extended = <&pmc AT91_PMC_MCKRDY>;
> -					clocks = <&slow_xtal>, <&main>, <&plladiv>, <&utmi>;
> +					clocks = <&clk32k>, <&main>, <&plladiv>, <&utmi>;
>  					atmel,clk-output-range = <0 133333333>;
>  					atmel,clk-divisors = <1 2 4 3>;
>  				};
> @@ -175,7 +175,7 @@
>  					#address-cells = <1>;
>  					#size-cells = <0>;
>  					interrupt-parent = <&pmc>;
> -					clocks = <&slow_xtal>, <&main>, <&plladiv>, <&utmi>, <&mck>;
> +					clocks = <&clk32k>, <&main>, <&plladiv>, <&utmi>, <&mck>;
>  
>  					prog0: prog0 {
>  						#clock-cells = <0>;
> @@ -1160,6 +1160,32 @@
>  				};
>  			};
>  
> +			sckc@fffffd50 {
> +				compatible = "atmel,at91sam9x5-sckc";
> +				reg = <0xfffffd50 0x4>;
> +
> +				slow_osc: slow_osc {
> +					compatible = "atmel,at91sam9x5-clk-slow-osc";
> +					#clock-cells = <0>;
> +					atmel,startup-time-usec = <1200000>;
> +					clocks = <&slow_xtal>;
> +				};
> +
> +				slow_rc_osc: slow_rc_osc {
> +					compatible = "atmel,at91sam9x5-clk-slow-rc-osc";
> +					#clock-cells = <0>;
> +					atmel,startup-time-usec = <75>;
> +					clock-frequency = <32768>;
> +					clock-accuracy = <50000000>;
> +				};
> +
> +				clk32k: slck {
> +					compatible = "atmel,at91sam9x5-clk-slow";
> +					#clock-cells = <0>;
> +					clocks = <&slow_rc_osc &slow_osc>;
> +				};
> +			};
> +
>  			rtc@fffffdb0 {
>  				compatible = "atmel,at91rm9200-rtc";
>  				reg = <0xfffffdb0 0x10>;
> 


-- 
Nicolas Ferre
