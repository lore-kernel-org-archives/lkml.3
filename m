Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbaKCRQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:16:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57101 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbaKCRQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:16:15 -0500
Message-ID: <5457B85C.4020105@suse.de>
Date: Mon, 03 Nov 2014 18:16:12 +0100
From: =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>
CC: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kgene.kim@samsung.com
Subject: Re: [PATCH] ARM: dts: Add pwm-fan node to the Odroid-U3 board
References: <1415025804-24274-1-git-send-email-k.debski@samsung.com>
In-Reply-To: <1415025804-24274-1-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 03.11.2014 um 15:43 schrieb Kamil Debski:
> Add pwm-fan node to the Odroid-U3 board file to enable PWM control of the
> cooling fan.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> ---
>  arch/arm/boot/dts/exynos4412-odroidu3.dts |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos4412-odroidu3.dts b/arch/arm/boot/dts/exynos4412-odroidu3.dts
> index c8a64be..764bda4 100644
> --- a/arch/arm/boot/dts/exynos4412-odroidu3.dts
> +++ b/arch/arm/boot/dts/exynos4412-odroidu3.dts
> @@ -31,6 +31,19 @@
>  			linux,default-trigger = "heartbeat";
>  		};
>  	};
> +
> +	pwm: pwm@139D0000 {
> +		pinctrl-0 = <&pwm0_out>;
> +		pinctrl-names = "default";
> +		samsung,pwm-outputs = <0>;
> +		status = "okay";
> +	};

Please add the pwm label in the .dtsi if necessary and then just do &pwm
{...}; before &usb3503 below.

> +
> +	pwm-fan {
> +		compatible = "pwm-fan";
> +		status = "okay";
> +		pwms = <&pwm 0 10000 0>;
> +	};
>  };
>  
>  &usb3503 {

Regards,
Andreas

-- 
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 21284 AG Nürnberg
