Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaGMMgX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 08:36:23 -0400
Received: from gloria.sntech.de ([95.129.55.99]:52030 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbaGMMgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 08:36:15 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: rk3188-radxarock: add GPIO IR receiver node
Date: Sun, 13 Jul 2014 14:37:40 +0200
Message-ID: <2390327.HZxnbJmfOO@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1405253401-15534-1-git-send-email-b.galvani@gmail.com>
References: <1405253401-15534-1-git-send-email-b.galvani@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 13. Juli 2014, 14:10:01 schrieb Beniamino Galvani:
> This adds a device tree node for the infrared receiver connected to a
> GPIO pin on the Radxa Rock.
> 
> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
> ---
>  arch/arm/boot/dts/rk3188-radxarock.dts |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/rk3188-radxarock.dts
> b/arch/arm/boot/dts/rk3188-radxarock.dts index 19d45b4..1d87bcb 100644
> --- a/arch/arm/boot/dts/rk3188-radxarock.dts
> +++ b/arch/arm/boot/dts/rk3188-radxarock.dts
> @@ -23,6 +23,13 @@
>  		reg = <0x60000000 0x80000000>;
>  	};
> 
> +	ir_recv: ir-receiver {
> +		compatible = "gpio-ir-receiver";
> +		gpios = <&gpio0 10 1>;
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&ir_recv_pin>;
> +	};
> +

hmm, on second glance, I'm actually not sure if this shouldn't belong in the 
soc subnode, like the gpio-keys and leds.


Heiko

>  	soc {
>  		uart0: serial@10124000 {
>  			status = "okay";
> @@ -117,6 +124,12 @@
>  					rockchip,pins = <RK_GPIO3 27 RK_FUNC_GPIO 
&pcfg_output_low>;
>  				};
>  			};
> +
> +			ir-receiver {
> +				ir_recv_pin: ir-recv-pin {
> +					rockchip,pins = <RK_GPIO0 10 RK_FUNC_GPIO 
&pcfg_pull_none>;
> +				};
> +			};
>  		};
> 
>  	};

