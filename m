Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab3CaNow (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 09:44:52 -0400
Received: from [207.46.163.24] ([207.46.163.24]:26287 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754450Ab3CaNov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 09:44:51 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z494bkz98dI1432Izz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Sun, 31 Mar 2013 21:43:51 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: <jimwall@q.com>, <brian@crystalfontz.com>,
        Maxime Rpard <maxime.ripard@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: cfa10036: add one wire bitbanging to the cfa10049
Message-ID: <20130331134350.GC17773@S2101-09.ap.freescale.net>
References: <1364582801-15087-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1364582801-15087-1-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 07:46:41PM +0100, Alexandre Belloni wrote:
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Applied, thanks.

> ---
>  arch/arm/boot/dts/imx28-cfa10049.dts |   20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/imx28-cfa10049.dts b/arch/arm/boot/dts/imx28-cfa10049.dts
> index ded7784..b9dad4e 100644
> --- a/arch/arm/boot/dts/imx28-cfa10049.dts
> +++ b/arch/arm/boot/dts/imx28-cfa10049.dts
> @@ -30,7 +30,6 @@
>  					reg = <0>;
>  					fsl,pinmux-ids = <
>  						0x0073 /* MX28_PAD_GPMI_D7__GPIO_0_7 */
> -						0x1153 /* MX28_PAD_LCD_D22__GPIO_1_21 */
>  						0x1163 /* MX28_PAD_LCD_D22__GPIO_1_22 */
>  						0x1173 /* MX28_PAD_LCD_D22__GPIO_1_23 */
>  						0x2153 /* MX28_PAD_SSP2_D5__GPIO_2_21 */
> @@ -120,6 +119,16 @@
>  					fsl,voltage = <1>;
>  					fsl,pull-up = <0>;
>  				};
> +
> +				w1_gpio_pins: w1-gpio@0 {
> +					reg = <0>;
> +					fsl,pinmux-ids = <
> +						0x1153 /* MX28_PAD_LCD_D21__GPIO_1_21 */
> +					>;
> +					fsl,drive-strength = <1>;
> +					fsl,voltage = <1>;
> +					fsl,pull-up = <0>; /* 0 will enable the keeper */
> +				};
>  			};
>  
>  			lcdif@80030000 {
> @@ -304,5 +313,14 @@
>  		pwms = <&pwm 3 5000000>;
>  		brightness-levels = <0 4 8 16 32 64 128 255>;
>  		default-brightness-level = <6>;
> +
> +	};
> +
> +	onewire@0 {
> +		compatible = "w1-gpio";
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&w1_gpio_pins>;
> +		status = "okay";
> +		gpios = <&gpio1 21 0>;
>  	};
>  };
> -- 
> 1.7.10.4
> 

