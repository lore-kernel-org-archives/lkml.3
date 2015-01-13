Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbbAMOpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 09:45:41 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:49036 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbbAMOph convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 09:45:37 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?= <niso@kth.se>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        magnus.damm@gmail.com
Subject: Re: [PATCH 3/4] ARM: shmobile: emev2: Add PFC information to emev2.dtsi
Date: Tue, 13 Jan 2015 16:45:59 +0200
Message-ID: <1701639.rHDfQqXMRy@avalon>
User-Agent: KMail/4.14.3 (Linux/3.17.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1418414497-23741-4-git-send-email-niso@kth.se>
References: <1418414497-23741-1-git-send-email-niso@kth.se> <1418414497-23741-4-git-send-email-niso@kth.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Niklas,

Thank you for the patch.

On Friday 12 December 2014 21:01:36 Niklas Söderlund wrote:
> With this information all GPIOs can make use of the PFC functionality.
> 
> Signed-off-by: Niklas Söderlund <niso@kth.se>
> ---
>  arch/arm/boot/dts/emev2.dtsi | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/emev2.dtsi b/arch/arm/boot/dts/emev2.dtsi
> index cc7bfe0..518b7fa 100644
> --- a/arch/arm/boot/dts/emev2.dtsi
> +++ b/arch/arm/boot/dts/emev2.dtsi
> @@ -169,12 +169,19 @@
>  		clock-names = "sclk";
>  	};
> 
> +	pfc: pfc@e0140200 {
> +		compatible = "renesas,pfc-emev2";
> +		reg = <0xe0140200 0x14>, <0xe0140284 0xc>,
> +			<0xe0140294 0x8>, <0xe01402a8 0x4>;

I think a single reg entry set to <0xe0140200 0x100> should be enough.

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
> @@ -186,6 +193,7 @@
>  		interrupts = <0 69 IRQ_TYPE_LEVEL_HIGH>,
>  			     <0 70 IRQ_TYPE_LEVEL_HIGH>;
>  		gpio-controller;
> +		gpio-ranges = <&pfc 0 32 32>;
>  		#gpio-cells = <2>;
>  		ngpios = <32>;
>  		interrupt-controller;
> @@ -197,6 +205,7 @@
>  		interrupts = <0 71 IRQ_TYPE_LEVEL_HIGH>,
>  			     <0 72 IRQ_TYPE_LEVEL_HIGH>;
>  		gpio-controller;
> +		gpio-ranges = <&pfc 0 64 32>;
>  		#gpio-cells = <2>;
>  		ngpios = <32>;
>  		interrupt-controller;
> @@ -208,6 +217,7 @@
>  		interrupts = <0 73 IRQ_TYPE_LEVEL_HIGH>,
>  			     <0 74 IRQ_TYPE_LEVEL_HIGH>;
>  		gpio-controller;
> +		gpio-ranges = <&pfc 0 96 32>;
>  		#gpio-cells = <2>;
>  		ngpios = <32>;
>  		interrupt-controller;
> @@ -219,6 +229,7 @@
>  		interrupts = <0 75 IRQ_TYPE_LEVEL_HIGH>,
>  			     <0 76 IRQ_TYPE_LEVEL_HIGH>;
>  		gpio-controller;
> +		gpio-ranges = <&pfc 0 128 32>;

Shouldn't this be <&pfc 0 128 31>; ?

>  		#gpio-cells = <2>;
>  		ngpios = <31>;
>  		interrupt-controller;

-- 
Regards,

Laurent Pinchart

