Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbaHAJQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 05:16:24 -0400
Received: from gloria.sntech.de ([95.129.55.99]:55140 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbaHAJQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 05:16:22 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>, olof@lixom.net
Cc: Paul Zimmerman <paulz@synopsys.com>, kever.yang@rock-chips.com,
        Sonny Rao <sonnyrao@chromium.org>,
        linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/5] ARM: dts: Fix the sort ordering of EHCI and HSIC in rk3288.dtsi
Date: Fri, 01 Aug 2014 11:17:27 +0200
Message-ID: <5965899.y405fxfhDg@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1406846976-23127-4-git-send-email-dianders@chromium.org>
References: <1406846976-23127-4-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 31. Juli 2014, 15:49:35 schrieb Doug Anderson:
> The EHCI and HSIC device tree nodes were added in the wrong place.
> Fix them.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>

hmm, not sure if this counts as fix ... aka material for 3.17-rc2 or should 
wait for 3.18. Simply because it's more a cosmetic thing.

If it is a fix, could base it on the appropriate dts revision, because here 
it's in the middle of the dwc2 series, including the
	usb_host1: usb@ff540000
nodes.


Heiko

> ---
> Changes in v4:
> - Based on the proper patch
> 
> Changes in v3:
> - EHCI and HSIC move new for version 3.
> 
>  arch/arm/boot/dts/rk3288.dtsi | 41
> ++++++++++++++++++++--------------------- 1 file changed, 20 insertions(+),
> 21 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index 9713054..49c99f2 100644
> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -156,6 +156,17 @@
>  		status = "disabled";
>  	};
> 
> +	usb_host0_ehci: usb@ff500000 {
> +		compatible = "generic-ehci";
> +		reg = <0xff500000 0x100>;
> +		interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&cru HCLK_USBHOST0>;
> +		clock-names = "usbhost";
> +		status = "disabled";
> +	};
> +
> +	/* NOTE: ohci@ff520000 doesn't actually work on hardware */
> +
>  	usb_host1: usb@ff540000 {
>  		compatible = "rockchip,rk3288-usb", "rockchip,rk3066-usb",
>  				"snps,dwc2";
> @@ -176,6 +187,15 @@
>  		status = "disabled";
>  	};
> 
> +	usb_hsic: usb@ff5c0000 {
> +		compatible = "generic-ehci";
> +		reg = <0xff5c0000 0x100>;
> +		interrupts = <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&cru HCLK_HSIC>;
> +		clock-names = "usbhost";
> +		status = "disabled";
> +	};
> +
>  	uart2: serial@ff690000 {
>  		compatible = "rockchip,rk3288-uart", "snps,dw-apb-uart";
>  		reg = <0xff690000 0x100>;
> @@ -270,27 +290,6 @@
>  		interrupts = <GIC_SPI 111 IRQ_TYPE_LEVEL_HIGH>;
>  		status = "disabled";
>  	};
> -
> -	usb_host0_ehci: usb@ff500000 {
> -		compatible = "generic-ehci";
> -		reg = <0xff500000 0x100>;
> -		interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>;
> -		clocks = <&cru HCLK_USBHOST0>;
> -		clock-names = "usbhost";
> -		status = "disabled";
> -	};
> -
> -	/* NOTE: ohci@ff520000 doesn't actually work on hardware */
> -
> -	usb_hsic: usb@ff5c0000 {
> -		compatible = "generic-ehci";
> -		reg = <0xff5c0000 0x100>;
> -		interrupts = <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
> -		clocks = <&cru HCLK_HSIC>;
> -		clock-names = "usbhost";
> -		status = "disabled";
> -	};
> -
>  	gic: interrupt-controller@ffc01000 {
>  		compatible = "arm,gic-400";
>  		interrupt-controller;

