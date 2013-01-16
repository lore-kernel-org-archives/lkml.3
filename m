Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab3APFVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 00:21:20 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:52565 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab3APFVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 00:21:19 -0500
MIME-Version: 1.0
In-Reply-To: <1358257112-19595-2-git-send-email-gautam.vivek@samsung.com>
References: <1358257112-19595-1-git-send-email-gautam.vivek@samsung.com>
	<1358257112-19595-2-git-send-email-gautam.vivek@samsung.com>
Date: Wed, 16 Jan 2013 10:51:17 +0530
Message-ID: <CAFp+6iFgaT9D2hR0pX34jo2g+GHftmA0Mw3y96-oKe0KakZOxA@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] ARM: Exynos5250: Enabling ehci-s5p driver
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, jg1.han@samsung.com,
        kgene.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 7:08 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> Adding EHCI device tree node for Exynos5250 along with
> the device base adress and gpio line for vbus.
>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Acked-by: Jingoo Han <jg1.han@samsung.com>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  .../devicetree/bindings/usb/exynos-usb.txt         |   25 ++++++++++++++++++++
>  arch/arm/boot/dts/exynos5250-smdk5250.dts          |    4 +++
>  arch/arm/boot/dts/exynos5250.dtsi                  |    6 ++++
>  3 files changed, 35 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/usb/exynos-usb.txt
>
> diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt b/Documentation/devicetree/bindings/usb/exynos-usb.txt
> new file mode 100644
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
> + - reg: physical base address of the controller and length of memory mapped
> +   region.
> + - interrupts: interrupt number to the cpu.
> +
> +Optional properties:
> + - samsung,vbus-gpio:  if present, specifies the GPIO that
> +   needs to be pulled up for the bus to be powered.
> +
> +Example:
> +
> +       usb@12110000 {
> +               compatible = "samsung,exynos4210-ehci";
> +               reg = <0x12110000 0x100>;
> +               interrupts = <0 71 0>;
> +               samsung,vbus-gpio = <&gpx2 6 1 3 3>;
> +       };
> diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
> index 942d576..7363e14 100644
> --- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
> +++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
> @@ -204,4 +204,8 @@
>                 samsung,mfc-r = <0x43000000 0x800000>;
>                 samsung,mfc-l = <0x51000000 0x800000>;
>         };
> +
> +       usb@12110000 {
> +               samsung,vbus-gpio = <&gpx2 6 1 3 3>;
> +       };

Add required vbus gpio for snow board also here.

>  };


-- 
Thanks & Regards
Vivek
