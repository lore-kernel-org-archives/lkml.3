Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933794Ab3CUP6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 11:58:11 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:49204 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933620Ab3CUP6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 11:58:09 -0400
Message-ID: <514B21DA.1010901@atmel.com>
Date: Thu, 21 Mar 2013 16:06:02 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] DTS at91sam9x5cm: add 1-wire chip on CM board
References: <1363778620-5213-1-git-send-email-richard.genoud@gmail.com>
In-Reply-To: <1363778620-5213-1-git-send-email-richard.genoud@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 12:23 PM, Richard Genoud :
> This add the 1-wire chip present on the CM board to the DTS.
> As the pin is also used by leds, tt's disabled by default.
> If the board really wants it, it can be enabled in the board DTS.
> 
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

And pushed to at91-3.10-dt branch.

Thanks,

> ---
>  arch/arm/boot/dts/at91sam9x5cm.dtsi |   20 ++++++++++++++++++++
>  1 files changed, 20 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/at91sam9x5cm.dtsi b/arch/arm/boot/dts/at91sam9x5cm.dtsi
> index 4027ac7..347a74a 100644
> --- a/arch/arm/boot/dts/at91sam9x5cm.dtsi
> +++ b/arch/arm/boot/dts/at91sam9x5cm.dtsi
> @@ -24,6 +24,16 @@
>  	};
>  
>  	ahb {
> +		apb {
> +			pinctrl@fffff400 {
> +				1wire_cm {
> +					pinctrl_1wire_cm: 1wire_cm-0 {
> +						atmel,pins = <1 18 0x0 0x2>; /* PB18 multidrive, conflicts with led */
> +					};
> +				};
> +			};
> +		};
> +
>  		nand0: nand@40000000 {
>  			nand-bus-width = <8>;
>  			nand-ecc-mode = "hw";
> @@ -74,4 +84,14 @@
>  			gpios = <&pioD 21 0>;
>  		};
>  	};
> +
> +	1wire_cm {
> +		compatible = "w1-gpio";
> +		gpios = <&pioB 18 0>;
> +		linux,open-drain;
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&pinctrl_1wire_cm>;
> +		status = "okay";
> +	};
> +
>  };
> 


-- 
Nicolas Ferre
