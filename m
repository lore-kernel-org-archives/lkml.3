Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbaEHQHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:07:17 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:33568 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbaEHQHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:07:14 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-f5-536babaf7249
Message-id: <536BABAD.5030605@samsung.com>
Date: Thu, 08 May 2014 18:07:09 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        arunkk.samsung@gmail.com
Subject: Re: [PATCH 1/2] ARM: dts: Enable USB 3503 hub on exynos5250-snow
References: <1399293056-17143-1-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1399293056-17143-1-git-send-email-gautam.vivek@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsVy+t/xa7rrV2cHGyz7b2DxYuMtdov5R86x
	WrRdOchu0bvgKpvFpsfXWC0u75rDZjHj/D4mi0XLWpkdODx2zrrL7rF5Sb1H35ZVjB6fN8kF
	sERx2aSk5mSWpRbp2yVwZZz9f461oF+o4um9OawNjMv5uhg5OSQETCT2zfvNDGGLSVy4t56t
	i5GLQ0hgKaPE+2XLmSGcz4wSt98eZQSp4hXQknh7fxpYB4uAqsSHXY/AbDYBNYnPDY/YQGx+
	oJo1TddZQGxRgQiJe42HWSF6BSV+TL4HFhcRyJb4tb2NBWQBs8B0RolZV7+DDRIW8JTofPuB
	HcQWEvCQ+L5+L1icEyg+fSNEnFlAR2J/6zQ2CFteYvOat8wTGAVnIdkxC0nZLCRlCxiZVzGK
	ppYmFxQnpeca6RUn5haX5qXrJefnbmKEhP/XHYxLj1kdYhTgYFTi4V0gkxEsxJpYVlyZe4hR
	goNZSYT3xbLsYCHelMTKqtSi/Pii0pzU4kOMTBycUg2MPDu8H10W4+B/dfHu/GLnpmc/+pQa
	2dsnL5J0m2j18toirt0x3z3/3dvw86jrujPq0wuveyv94du1cdvXB8ZrTvkdW9uUruGxtH3X
	xNyGz5F2jkF/LQOtdpgvlSte5R8z62+H3OlKiZXHZYtXV7h/v/do5+QtR2sv10TkPDfQ2335
	t32035GltUosxRmJhlrMRcWJAAtVqK5dAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

On 05.05.2014 14:30, Vivek Gautam wrote:
> The exynos5250-snow has a SMSC USB3503 connected in
> hardware only mode like a PHY. Enable support for it,
> and add necessary 'reset-gpio' for it.
> 
> This is in correspondance to similar patch by Mark Brown
> 7c1b0ec ARM: dts: Enable USB hub on Arndale
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
> 
> Based on 'for-next' branch of kgene's linux-samsung tree.
> 
>  arch/arm/boot/dts/exynos5250-pinctrl.dtsi |    7 +++++++
>  arch/arm/boot/dts/exynos5250-snow.dts     |   14 ++++++++++++++
>  2 files changed, 21 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
> index 9a49e68..bd8c8f1 100644
> --- a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
> +++ b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
> @@ -706,6 +706,13 @@
>  			samsung,pin-pud = <0>;
>  			samsung,pin-drv = <0>;
>  		};
> +
> +		usb_hub_reset: usb-hub-reset {
> +			samsung,pins = "gpe1-0";
> +			samsung,pin-function = <1>;
> +			samsung,pin-pud = <0>;
> +			samsung,pin-drv = <0>;
> +		};

This is not a generic pin config group and should not be added to this
file. Btw. it just sets the pin to output, which is what the consumer
driver can do as well by calling gpio_direction_output. Do you really
need this?

>  	};
>  
>  	pinctrl@10d10000 {
> diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
> index 1ce1088..2e48f27 100644
> --- a/arch/arm/boot/dts/exynos5250-snow.dts
> +++ b/arch/arm/boot/dts/exynos5250-snow.dts
> @@ -200,6 +200,20 @@
>  		samsung,vbus-gpio = <&gpx1 1 0>;
>  	};
>  
> +	usb_hub_bus {
> +		compatible = "simple-bus";
> +		#address-cells = <1>;
> +		#size-cells = <0>;

Why do you need this bus?

> +
> +		// SMSC USB3503 connected in hardware only mode as a PHY

Wrong comment style. Also basically the comment says exactly the same as
could be inferred from the node below.

> +		usb_hub {
> +			compatible = "smsc,usb3503a";
> +			reset-gpios = <&gpe1 0 1>;
> +			pinctrl-0 = <&usb_hub_reset>;
> +			pinctrl-names = "default";

As above, do you really need to use pinctrl here?

I believe the same comments apply for patch 2/2 as well.

Best regards,
Tomasz
