Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbaGHETw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 00:19:52 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:39058 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaGHETv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 00:19:51 -0400
MIME-Version: 1.0
In-Reply-To: <1404118582-21993-1-git-send-email-sachin.kamat@samsung.com>
References: <1404118582-21993-1-git-send-email-sachin.kamat@samsung.com>
Date: Tue, 8 Jul 2014 09:49:48 +0530
Message-ID: <CAK5sBcFmyhpTravnUhGnraB-UtQYFx-f=iaNEhUpqTchRag0eQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] phy: Kconfig: Re-organize Exynos USB 2.0 PHY configs
From: Sachin Kamat <spk.linux@gmail.com>
To: open list <linux-kernel@vger.kernel.org>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Doug Anderson <dianders@chromium.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Sachin Kamat <spk.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 2:26 PM, Sachin Kamat <sachin.kamat@samsung.com> wrote:
> Since the USB 2.0 PHYs are required only with EHCI/OHCI USB drivers,
> make it depend on them and default to ARCH_EXYNOS as they are meant
> for Exynos platforms. Also, make the sub-drivers silent options enabling
> them based on the SoC platforms that they are meant to work with. This
> will make life easier for end users who do not have any way knowing the
> dependencies.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
> ---
>  drivers/phy/Kconfig |   35 +++++++++++------------------------
>  1 file changed, 11 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 16a2f067c242..9aab5dfb0adf 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -122,43 +122,30 @@ config PHY_SUN4I_USB
>
>  config PHY_SAMSUNG_USB2
>         tristate "Samsung USB 2.0 PHY driver"
> +       depends on USB_EHCI_EXYNOS || USB_OHCI_EXYNOS
>         select GENERIC_PHY
>         select MFD_SYSCON
> +       default ARCH_EXYNOS
>         help
>           Enable this to support the Samsung USB 2.0 PHY driver for Samsung
> -         SoCs. This driver provides the interface for USB 2.0 PHY. Support for
> -         particular SoCs has to be enabled in addition to this driver. Number
> -         and type of supported phys depends on the SoC.
> +         SoCs. This driver provides the interface for USB 2.0 PHY. Support
> +         for particular PHYs will be enabled based on the SoC type in addition
> +         to this driver.
>
>  config PHY_EXYNOS4210_USB2
> -       bool "Support for Exynos 4210"
> +       bool
>         depends on PHY_SAMSUNG_USB2
> -       depends on CPU_EXYNOS4210
> -       help
> -         Enable USB PHY support for Exynos 4210. This option requires that
> -         Samsung USB 2.0 PHY driver is enabled and means that support for this
> -         particular SoC is compiled in the driver. In case of Exynos 4210 four
> -         phys are available - device, host, HSIC0 and HSIC1.
> +       default CPU_EXYNOS4210
>
>  config PHY_EXYNOS4X12_USB2
> -       bool "Support for Exynos 4x12"
> +       bool
>         depends on PHY_SAMSUNG_USB2
> -       depends on (SOC_EXYNOS4212 || SOC_EXYNOS4412)
> -       help
> -         Enable USB PHY support for Exynos 4x12. This option requires that
> -         Samsung USB 2.0 PHY driver is enabled and means that support for this
> -         particular SoC is compiled in the driver. In case of Exynos 4x12 four
> -         phys are available - device, host, HSIC0 and HSIC1.
> +       default SOC_EXYNOS4212 || SOC_EXYNOS4412
>
>  config PHY_EXYNOS5250_USB2
> -       bool "Support for Exynos 5250"
> +       bool
>         depends on PHY_SAMSUNG_USB2
> -       depends on SOC_EXYNOS5250
> -       help
> -         Enable USB PHY support for Exynos 5250. This option requires that
> -         Samsung USB 2.0 PHY driver is enabled and means that support for this
> -         particular SoC is compiled in the driver. In case of Exynos 5250 four
> -         phys are available - device, host, HSIC0 and HSIC.
> +       default SOC_EXYNOS5250 || SOC_EXYNOS5420
>
>  config PHY_EXYNOS5_USBDRD
>         tristate "Exynos5 SoC series USB DRD PHY driver"
> --
> 1.7.9.5

Kishon,

Any comments on these patches?

-- 
Regards,
Sachin.
