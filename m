Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402Ab3APHvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 02:51:15 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:65102 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab3APHvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 02:51:14 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        kgene.kim@samsung.com, grant.likely@secretlab.ca,
        dianders@chromium.org, jg1.han@samsung.com
Subject: Re: [PATCH v4 4/4] ARM: Exynos5250: Enabling dwc3-exynos driver
Date: Wed, 16 Jan 2013 08:51:13 +0100
Message-ID: <3906336.fGNjD6f9X5@flatron>
User-Agent: KMail/4.9.5 (Linux/3.7.2-gentoo; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1358257112-19595-5-git-send-email-gautam.vivek@samsung.com>
References: <1358257112-19595-1-git-send-email-gautam.vivek@samsung.com> <1358257112-19595-5-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

Same comment as for patch 2.

Best regards,
Tomasz

On Tuesday 15 of January 2013 19:08:32 Vivek Gautam wrote:
> Adding DWC3 device tree node for Exynos5250 needed to
> parse device tree data.
> Also enabling XHCI support on exynos5250.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  .../devicetree/bindings/usb/exynos-usb.txt         |   14
> ++++++++++++++ arch/arm/boot/dts/exynos5250.dtsi                  |   
> 6 ++++++ arch/arm/mach-exynos/Kconfig                       |    1 +
>  3 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt
> b/Documentation/devicetree/bindings/usb/exynos-usb.txt index
> f66fcdd..d660410 100644
> --- a/Documentation/devicetree/bindings/usb/exynos-usb.txt
> +++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
> @@ -38,3 +38,17 @@ Example:
>  		reg = <0x12120000 0x100>;
>  		interrupts = <0 71 0>;
>  	};
> +
> +DWC3
> +Required properties:
> + - compatible: should be "samsung,exynos5250-dwc3" for USB 3.0 DWC3
> controller. + - reg: physical base address of the controller and length
> of memory mapped +   region.
> + - interrupts: interrupt number to the cpu.
> +
> +Example:
> +	usb@12000000 {
> +		compatible = "samsung,exynos5250-dwc3";
> +		reg = <0x12000000 0x10000>;
> +		interrupts = <0 72 0>;
> +	};
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi
> b/arch/arm/boot/dts/exynos5250.dtsi index ebb0907..a747524 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -275,6 +275,12 @@
>  		#size-cells = <0>;
>  	};
> 
> +	usb@12000000 {
> +		compatible = "samsung,exynos5250-dwc3";
> +		reg = <0x12000000 0x10000>;
> +		interrupts = <0 72 0>;
> +	};
> +
>  	usb@12110000 {
>  		compatible = "samsung,exynos4210-ehci";
>  		reg = <0x12110000 0x100>;
> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
> index d26c9f9..e62fd20 100644
> --- a/arch/arm/mach-exynos/Kconfig
> +++ b/arch/arm/mach-exynos/Kconfig
> @@ -428,6 +428,7 @@ config MACH_EXYNOS5_DT
>  	depends on ARCH_EXYNOS5
>  	select ARM_AMBA
>  	select USE_OF
> +	select USB_ARCH_HAS_XHCI
>  	help
>  	  Machine support for Samsung EXYNOS5 machine with device tree
> enabled. Select this if a fdt blob is available for the EXYNOS5 SoC
> based board.
