Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbaKSPvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:51:15 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:58600 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbaKSPvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:51:13 -0500
Message-ID: <546CBC6B.2040408@atmel.com>
Date: Wed, 19 Nov 2014 16:51:07 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Peter Korsgaard <jacmet@sunsite.dk>, Matt Mackall <mpm@selenic.com>,
        "Herbert Xu" <herbert@gondor.apana.org.au>
CC: <linux-arm-kernel@lists.infradead.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] ARM: at91/dt: add ISI node
References: <1412093987-30241-1-git-send-email-boris.brezillon@free-electrons.com> <1412093987-30241-7-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1412093987-30241-7-git-send-email-boris.brezillon@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/09/2014 18:19, Boris Brezillon :
> Add ISI (Image Sensor Interface) DT node.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>

I take this one for at91-3.19-dt2

Thanks, best regards.

> ---
>  arch/arm/boot/dts/at91sam9g45.dtsi | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
> index 790c890..5d8746a 100644
> --- a/arch/arm/boot/dts/at91sam9g45.dtsi
> +++ b/arch/arm/boot/dts/at91sam9g45.dtsi
> @@ -804,6 +804,27 @@
>  					};
>  				};
>  
> +				isi {
> +					pinctrl_isi: isi-0 {
> +						atmel,pins = <AT91_PIOB 8 AT91_PERIPH_B AT91_PINCTRL_NONE /* D8 */
> +							      AT91_PIOB 9 AT91_PERIPH_B AT91_PINCTRL_NONE /* D9 */
> +							      AT91_PIOB 10 AT91_PERIPH_B AT91_PINCTRL_NONE /* D10 */
> +							      AT91_PIOB 11 AT91_PERIPH_B AT91_PINCTRL_NONE /* D11 */
> +							      AT91_PIOB 20 AT91_PERIPH_A AT91_PINCTRL_NONE /* D0 */
> +							      AT91_PIOB 21 AT91_PERIPH_A AT91_PINCTRL_NONE /* D1 */
> +							      AT91_PIOB 22 AT91_PERIPH_A AT91_PINCTRL_NONE /* D2 */
> +							      AT91_PIOB 23 AT91_PERIPH_A AT91_PINCTRL_NONE /* D3 */
> +							      AT91_PIOB 24 AT91_PERIPH_A AT91_PINCTRL_NONE /* D4 */
> +							      AT91_PIOB 25 AT91_PERIPH_A AT91_PINCTRL_NONE /* D5 */
> +							      AT91_PIOB 26 AT91_PERIPH_A AT91_PINCTRL_NONE /* D6 */
> +							      AT91_PIOB 27 AT91_PERIPH_A AT91_PINCTRL_NONE /* D7 */
> +							      AT91_PIOB 28 AT91_PERIPH_A AT91_PINCTRL_NONE /* PCK */
> +							      AT91_PIOB 29 AT91_PERIPH_A AT91_PINCTRL_NONE /* VSYNC */
> +							      AT91_PIOB 30 AT91_PERIPH_A AT91_PINCTRL_NONE /* HSYNC */
> +							      AT91_PIOB 31 AT91_PERIPH_A AT91_PINCTRL_NONE /* MCK */>;
> +					};
> +				};
> +
>  				pioA: gpio@fffff200 {
>  					compatible = "atmel,at91rm9200-gpio";
>  					reg = <0xfffff200 0x200>;
> @@ -1029,6 +1050,17 @@
>  				};
>  			};
>  
> +			isi@fffb4000 {
> +				compatible = "atmel,at91sam9g45-isi";
> +				reg = <0xfffb4000 0x4000>;
> +				interrupts = <26 IRQ_TYPE_LEVEL_HIGH 5>;
> +				clocks = <&isi_clk>;
> +				clock-names = "isi_clk";
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_isi>;
> +				status = "disabled";
> +			};
> +
>  			pwm0: pwm@fffb8000 {
>  				compatible = "atmel,at91sam9rl-pwm";
>  				reg = <0xfffb8000 0x300>;
> 


-- 
Nicolas Ferre
