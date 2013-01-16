Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175Ab3APHpD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 02:45:03 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:32938 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab3APHpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 02:45:00 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        kgene.kim@samsung.com, grant.likely@secretlab.ca,
        dianders@chromium.org, jg1.han@samsung.com
Subject: Re: [PATCH v4 2/4] ARM: Exynos5250: Enabling ohci-exynos driver
Date: Wed, 16 Jan 2013 08:44:54 +0100
Message-ID: <2542030.a14I18dBkO@flatron>
User-Agent: KMail/4.9.5 (Linux/3.7.2-gentoo; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1358257112-19595-3-git-send-email-gautam.vivek@samsung.com>
References: <1358257112-19595-1-git-send-email-gautam.vivek@samsung.com> <1358257112-19595-3-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

On Tuesday 15 of January 2013 19:08:30 Vivek Gautam wrote:
> Adding OHCI device tree node for Exynos5250 along with
> the device base address.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Acked-by: Jingoo Han <jg1.han@samsung.com>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  .../devicetree/bindings/usb/exynos-usb.txt         |   15
> +++++++++++++++ arch/arm/boot/dts/exynos5250.dtsi                  |   
> 6 ++++++ 2 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt
> b/Documentation/devicetree/bindings/usb/exynos-usb.txt index
> e8bbb47..f66fcdd 100644
> --- a/Documentation/devicetree/bindings/usb/exynos-usb.txt
> +++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
> @@ -23,3 +23,18 @@ Example:
>  		interrupts = <0 71 0>;
>  		samsung,vbus-gpio = <&gpx2 6 1 3 3>;
>  	};
> +
> +OHCI
> +Required properties:
> + - compatible: should be "samsung,exynos4210-ohci" for USB 2.0
> +   OHCI companion controller in host mode.
> + - reg: physical base address of the controller and length of memory
> mapped +   region.
> + - interrupts: interrupt number to the cpu.
> +
> +Example:
> +	usb@12120000 {
> +		compatible = "samsung,exynos4210-ohci";
> +		reg = <0x12120000 0x100>;
> +		interrupts = <0 71 0>;
> +	};
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi
> b/arch/arm/boot/dts/exynos5250.dtsi index 2cbe53e..ebb0907 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -281,6 +281,12 @@
>  		interrupts = <0 71 0>;
>  	};
> 
> +	usb@12120000 {
> +		compatible = "samsung,exynos4210-ohci";
> +		reg = <0x12120000 0x100>;
> +		interrupts = <0 71 0>;

For Samsung platforms we decided per board enabling of nodes and so this 
node should also contain:

		status = "disabled";

while in dts file of board using ohci there would be an overriding entry:

	usb@12120000 {
		status = "okay";
	};

I know that Exynos5250 has not been yet converted into this convention, 
but using it when adding new devices will simplify the process.

Best regards,
Tomasz

