Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106AbaISQEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 12:04:14 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:48266 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232AbaISQEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 12:04:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: 7bit
Date: Fri, 19 Sep 2014 18:03:42 +0200
From: Stefan Agner <stefan@agner.ch>
To: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Cc: shawn.guo@freescale.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ARM: dts: vf610-colibri: Add backlight support
In-Reply-To: <bae435d33cac93fd5f0c763fbe7bb302b52a6f0f.1411130205.git.bhuvanchandra.dv@toradex.com>
References: <cover.1411130205.git.bhuvanchandra.dv@toradex.com>
 <bae435d33cac93fd5f0c763fbe7bb302b52a6f0f.1411130205.git.bhuvanchandra.dv@toradex.com>
Message-ID: <6548345144e6eb9f252bfa35e9783079@agner.ch>
User-Agent: Roundcube Webmail/1.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-09-19 15:38, schrieb Bhuvanchandra DV:
> Signed-off-by: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
> ---
>  arch/arm/boot/dts/vf610-colibri-eval-v3.dts |    6 ++++++
>  arch/arm/boot/dts/vf610-colibri.dtsi        |    6 ++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
> b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
> index 00f63d9..711cf82 100644
> --- a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
> +++ b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
> @@ -19,6 +19,12 @@
>  	};
>  };
>  
> +&bl {
> +	brightness-levels = <0 4 8 16 32 64 128 255>;
> +	default-brightness-level = <6>;
> +	status  = "okay";
> +};
> +
>  &esdhc1 {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&pinctrl_esdhc1>;
> diff --git a/arch/arm/boot/dts/vf610-colibri.dtsi
> b/arch/arm/boot/dts/vf610-colibri.dtsi
> index 560cd69..20b1c15 100644
> --- a/arch/arm/boot/dts/vf610-colibri.dtsi
> +++ b/arch/arm/boot/dts/vf610-colibri.dtsi
> @@ -13,6 +13,12 @@
>  	model = "Toradex Colibri VF61 COM";
>  	compatible = "toradex,vf610-colibri_vf61", "fsl,vf610";
>  
> +	bl: backlight {
> +		compitable = "pwm-backlight";
> +		pwms = <&pwm0 0 5000000 0>;
> +		status = "disabled";
> +	};
> +

Typo, "compitable" is not a valid property...

When this is fixed,
Acked-By: Stefan Agner <stefan@agner.ch>

>  	clocks {
>  		enet_ext {
>  			compatible = "fixed-clock";
