Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645Ab3APHvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 02:51:39 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49177 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758609Ab3APHvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 02:51:37 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        kgene.kim@samsung.com, grant.likely@secretlab.ca,
        dianders@chromium.org, jg1.han@samsung.com
Subject: Re: [PATCH v5 1/4] ARM: Exynos5250: Enabling ehci-s5p driver
Date: Wed, 16 Jan 2013 08:51:36 +0100
Message-ID: <2045700.EdOLCZiruB@flatron>
User-Agent: KMail/4.9.5 (Linux/3.7.2-gentoo; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1358315143-16620-1-git-send-email-gautam.vivek@samsung.com>
References: <CAFp+6iFgaT9D2hR0pX34jo2g+GHftmA0Mw3y96-oKe0KakZOxA@mail.gmail.com> <1358315143-16620-1-git-send-email-gautam.vivek@samsung.com>
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

On Wednesday 16 of January 2013 11:15:43 Vivek Gautam wrote:
> Adding EHCI device tree node for Exynos5250 along with
> the device base adress and gpio line for vbus.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Acked-by: Jingoo Han <jg1.han@samsung.com>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> ---
> 
> Changes from v4:
>  - Added gpio line for VBUS of USB2.0 on snow board.
> 
>  .../devicetree/bindings/usb/exynos-usb.txt         |   25
> ++++++++++++++++++++ arch/arm/boot/dts/exynos5250-smdk5250.dts         
> |    4 +++ arch/arm/boot/dts/exynos5250-snow.dts              |    4
> +++ arch/arm/boot/dts/exynos5250.dtsi                  |    6 ++++ 4
> files changed, 39 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/usb/exynos-usb.txt
> 
> diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt
> b/Documentation/devicetree/bindings/usb/exynos-usb.txt new file mode
> 100644
> index 0000000..e8bbb47
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
> @@ -0,0 +1,25 @@
> +Samsung Exynos SoC USB controller
> +
> +The USB devices interface with USB controllers on Exynos SOCs.
> +The device node has following properties.
> +
> +EHCI
> +Required properties:
> + - compatible: should be "samsung,exynos4210-ehci" for USB 2.0
> +   EHCI controller in host mode.
> + - reg: physical base address of the controller and length of memory
> mapped +   region.
> + - interrupts: interrupt number to the cpu.
> +
> +Optional properties:
> + - samsung,vbus-gpio:  if present, specifies the GPIO that
> +   needs to be pulled up for the bus to be powered.
> +
> +Example:
> +
> +	usb@12110000 {
> +		compatible = "samsung,exynos4210-ehci";
> +		reg = <0x12110000 0x100>;
> +		interrupts = <0 71 0>;
> +		samsung,vbus-gpio = <&gpx2 6 1 3 3>;
> +	};
> diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts
> b/arch/arm/boot/dts/exynos5250-smdk5250.dts index 942d576..7363e14
> 100644
> --- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
> +++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
> @@ -204,4 +204,8 @@
>  		samsung,mfc-r = <0x43000000 0x800000>;
>  		samsung,mfc-l = <0x51000000 0x800000>;
>  	};
> +
> +	usb@12110000 {
> +		samsung,vbus-gpio = <&gpx2 6 1 3 3>;
> +	};
>  };
> diff --git a/arch/arm/boot/dts/exynos5250-snow.dts
> b/arch/arm/boot/dts/exynos5250-snow.dts index 17dd951..47b6b84 100644
> --- a/arch/arm/boot/dts/exynos5250-snow.dts
> +++ b/arch/arm/boot/dts/exynos5250-snow.dts
> @@ -40,4 +40,8 @@
>  				<&gpc4 5 2 3 0>, <&gpc4 6 2 3 0>;
>  		};
>  	};
> +
> +	usb@12110000 {
> +		samsung,vbus-gpio = <&gpx1 1 1 3 3>;
> +	};
>  };
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi
> b/arch/arm/boot/dts/exynos5250.dtsi index 30485de..2cbe53e 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -275,6 +275,12 @@
>  		#size-cells = <0>;
>  	};
> 
> +	usb@12110000 {
> +		compatible = "samsung,exynos4210-ehci";
> +		reg = <0x12110000 0x100>;
> +		interrupts = <0 71 0>;
> +	};
> +
>  	amba {
>  		#address-cells = <1>;
>  		#size-cells = <1>;
