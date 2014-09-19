Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbaISQBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 12:01:19 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:48170 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848AbaISQBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 12:01:18 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: 7bit
Date: Fri, 19 Sep 2014 18:00:47 +0200
From: Stefan Agner <stefan@agner.ch>
To: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Cc: shawn.guo@freescale.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] ARM: dts: vf610-colibri: Add PWM support
In-Reply-To: <d28bb6c5aeee7b5b4b7b20484fbaf0ba4eeb4ad4.1411130205.git.bhuvanchandra.dv@toradex.com>
References: <cover.1411130205.git.bhuvanchandra.dv@toradex.com>
 <d28bb6c5aeee7b5b4b7b20484fbaf0ba4eeb4ad4.1411130205.git.bhuvanchandra.dv@toradex.com>
Message-ID: <e63381e2dd14625e5395f892928b38f2@agner.ch>
User-Agent: Roundcube Webmail/1.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-09-19 15:38, schrieb Bhuvanchandra DV:
> The Colibri standard defines four pins as PWM outputs, two of them (PWM
> A and C) are routed to FTM instance 0 and the other two (PWM B and D)
> are routed to FTM instance 1. Hence enable both FTM instances for the
> Colibri module and mux the four pins accordingly.
> 
> Signed-off-by: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
> ---
>  arch/arm/boot/dts/vf610-colibri-eval-v3.dts |    8 +++++++
>  arch/arm/boot/dts/vf610-colibri.dtsi        |   31 +++++++++++++++++++++++----
>  2 files changed, 35 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
> b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
> index 7fb3066..00f63d9 100644
> --- a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
> +++ b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
> @@ -33,6 +33,14 @@
>  	status = "okay";
>  };
>  
> +&pwm0 {
> +	status = "okay";
> +};
> +
> +&pwm1 {
> +	status = "okay";
> +};
> +
>  &uart0 {
>  	status = "okay";
>  };
> diff --git a/arch/arm/boot/dts/vf610-colibri.dtsi
> b/arch/arm/boot/dts/vf610-colibri.dtsi
> index 0cd8343..560cd69 100644
> --- a/arch/arm/boot/dts/vf610-colibri.dtsi
> +++ b/arch/arm/boot/dts/vf610-colibri.dtsi
> @@ -13,10 +13,6 @@
>  	model = "Toradex Colibri VF61 COM";
>  	compatible = "toradex,vf610-colibri_vf61", "fsl,vf610";
>  
> -	memory {
> -		reg = <0x80000000 0x10000000>;
> -	};
> -
>  	clocks {
>  		enet_ext {
>  			compatible = "fixed-clock";
> @@ -25,6 +21,9 @@
>  		};
>  	};
>  
> +	memory {
> +		reg = <0x80000000 0x10000000>;
> +	};

Memory is a bit an exception here: In almost all device tree this is the
first node after model/compatible. Also, it's generally not allowed to
make changes outside of the topic (PWM in this case)... Hence I would
drop this change.

The rest
Acked-By: Stefan Agner <stefan@agner.ch>



>  };
>  
>  &esdhc1 {
> @@ -44,6 +43,16 @@
>  	arm,tag-latency = <3 2 3>;
>  };
>  
> +&pwm0 {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_pwm0>;
> +};
> +
> +&pwm1 {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_pwm1>;
> +};
> +
>  &uart0 {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&pinctrl_uart0>;
> @@ -97,6 +106,20 @@
>  			>;
>  		};
>  
> +		pinctrl_pwm0: pwm0grp {
> +			fsl,pins = <
> +				VF610_PAD_PTB0__FTM0_CH0		0x1182
> +				VF610_PAD_PTB1__FTM0_CH1		0x1182
> +			>;
> +		};
> +
> +		pinctrl_pwm1: pwm1grp {
> +			fsl,pins = <
> +				VF610_PAD_PTB8__FTM1_CH0		0x1182
> +				VF610_PAD_PTB9__FTM1_CH1		0x1182
> +			>;
> +		};
> +
>  		pinctrl_uart0: uart0grp {
>  			fsl,pins = <
>  				VF610_PAD_PTB10__UART0_TX		0x21a2
