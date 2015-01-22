Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbbAVVty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 16:49:54 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:60528 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbbAVVtv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 16:49:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?= <niso@kth.se>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        magnus.damm@gmail.com
Subject: Re: [PATCH v2 3/4] ARM: shmobile: emev2: Add PFC information to emev2.dtsi
Date: Thu, 22 Jan 2015 23:50:20 +0200
Message-ID: <2620818.4JADgt3ejj@avalon>
User-Agent: KMail/4.14.3 (Linux/3.17.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1421583604-27256-4-git-send-email-niso@kth.se>
References: <1421583604-27256-1-git-send-email-niso@kth.se> <1421583604-27256-4-git-send-email-niso@kth.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Niklas,

Thank you for the patch.

On Sunday 18 January 2015 13:20:03 Niklas Söderlund wrote:
> With this information all GPIOs can make use of the PFC functionality.
> 
> Signed-off-by: Niklas Söderlund <niso@kth.se>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  arch/arm/boot/dts/emev2.dtsi | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/emev2.dtsi b/arch/arm/boot/dts/emev2.dtsi
> index cc7bfe0..bb45694 100644
> --- a/arch/arm/boot/dts/emev2.dtsi
> +++ b/arch/arm/boot/dts/emev2.dtsi
> @@ -169,12 +169,18 @@
>  		clock-names = "sclk";
>  	};
> 
> +	pfc: pfc@e0140200 {
> +		compatible = "renesas,pfc-emev2";
> +		reg = <0xe0140200 0x100>;
> +	};
> +
>  	gpio0: gpio@e0050000 {
>  		compatible = "renesas,em-gio";
>  		reg = <0xe0050000 0x2c>, <0xe0050040 0x20>;
>  		interrupts = <0 67 IRQ_TYPE_LEVEL_HIGH>,
>  			     <0 68 IRQ_TYPE_LEVEL_HIGH>;
>  		gpio-controller;
> +		gpio-ranges = <&pfc 0 0 32>;
>  		#gpio-cells = <2>;
>  		ngpios = <32>;
>  		interrupt-controller;
> @@ -186,6 +192,7 @@
>  		interrupts = <0 69 IRQ_TYPE_LEVEL_HIGH>,
>  			     <0 70 IRQ_TYPE_LEVEL_HIGH>;
>  		gpio-controller;
> +		gpio-ranges = <&pfc 0 32 32>;
>  		#gpio-cells = <2>;
>  		ngpios = <32>;
>  		interrupt-controller;
> @@ -197,6 +204,7 @@
>  		interrupts = <0 71 IRQ_TYPE_LEVEL_HIGH>,
>  			     <0 72 IRQ_TYPE_LEVEL_HIGH>;
>  		gpio-controller;
> +		gpio-ranges = <&pfc 0 64 32>;
>  		#gpio-cells = <2>;
>  		ngpios = <32>;
>  		interrupt-controller;
> @@ -208,6 +216,7 @@
>  		interrupts = <0 73 IRQ_TYPE_LEVEL_HIGH>,
>  			     <0 74 IRQ_TYPE_LEVEL_HIGH>;
>  		gpio-controller;
> +		gpio-ranges = <&pfc 0 96 32>;
>  		#gpio-cells = <2>;
>  		ngpios = <32>;
>  		interrupt-controller;
> @@ -219,6 +228,7 @@
>  		interrupts = <0 75 IRQ_TYPE_LEVEL_HIGH>,
>  			     <0 76 IRQ_TYPE_LEVEL_HIGH>;
>  		gpio-controller;
> +		gpio-ranges = <&pfc 0 128 31>;
>  		#gpio-cells = <2>;
>  		ngpios = <31>;
>  		interrupt-controller;

-- 
Regards,

Laurent Pinchart

