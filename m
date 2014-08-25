Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbaHYLni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 07:43:38 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35807 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151AbaHYLng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 07:43:36 -0400
X-AuditID: cbfee61b-f79f86d00000144c-d6-53fb21667879
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>, Kevin Hilman <khilman@linaro.org>,
        afaerber@suse.de, Ajay Kumar <ajaykumar.rs@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] ARM: exynos_defconfig: Enable options for display
 panel support
Date: Mon, 25 Aug 2014 13:43:30 +0200
Message-id: <5825205.70RuHaSG5p@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1408956336-17376-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1408956336-17376-1-git-send-email-javier.martinez@collabora.co.uk>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t9jAd00xd/BBt1X1CyaNxVbHHh/kMXi
	7LKDbBZHfxdY9C64ymbx9fAKRotNj6+xWlzeNYfNYsb5fUwWp65/ZnPg8pjdcJHF4+/z6ywe
	d67tYfPYvKTe48qJJlaPvi2rGD02n672+LxJLoAjissmJTUnsyy1SN8ugSvj2AT5gi2CFQeW
	XGRrYDzJ18XIySEhYCJxaeo/NghbTOLCvfVANheHkMAiRolPGzayQDgtTBJf3+9gAaliE7CS
	mNi+ihHEFhGwk7ix+iEzSBGzwE4miZVPvrN2MXJwCAvESnzZUQZisgioSqy+qAxi8gpoSlxZ
	Ig/SKSrgKbFj+0qwvZwCARLbl+9nBrGFBPwljr29zQ5i8woISvyYfA9sK7OAvMS+/VNZIWwd
	if2t09gmMArMQlI2C0nZLCRlCxiZVzGKphYkFxQnpeca6RUn5haX5qXrJefnbmIER8Uz6R2M
	qxosDjEKcDAq8fCu5PwVLMSaWFZcmXuIUYKDWUmEl1f0d7AQb0piZVVqUX58UWlOavEhRmkO
	FiVx3oOt1oFCAumJJanZqakFqUUwWSYOTqkGxu4jlwKPtRqJvXcLSPOok21zvLwweX/ffeYF
	N96bvmUS3X299vPqJxVZimJSK51+Pdu3MvzCxK+zitYfve8TPcHyVeck3eq5vgWvzgTpsdsd
	EhOfdPJcv/iDBxFr3hSJZ0qFns1zM9j03JBjrd5cJvnwrWrrpS5bs0aEeO1ZufLOexbrhsiz
	ZUosxRmJhlrMRcWJAE5QRW6GAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday, August 25, 2014 10:45:36 AM Javier Martinez Canillas wrote:
> Many Exynos devices have a display panel. Most of them just have
> a simple panel while others have more complex configurations that
> requires an embedded DisplayPort (eDP) to LVDS bridges.
> 
> This patch enables the following features to be built in the kernel
> image to suport both setups:
> 
> - Direct Rendering Manager (DRM)
> - DRM bridge registration and lookup framework
> - Parade ps8622/ps8625 eDP/LVDS bridge
> - NXP ptn3460 eDP/LVDS bridge
> - Exynos Fully Interactive Mobile Display controller (FIMD)
> - Panel registration and lookup framework
> - Simple panels
> - Backlight & LCD device support
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Tested-by: Kevin Hilman <khilman@linaro.org>

Could you please also do corresponding update to multi_v7_defconfig?

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> ---
> 
> Changes since v1:
>  - Forgot to enable ptn3460 eDP/LVDS bridge config option
>    which is used for some boards (e.g: Exynos5250 Snow).
> 
>  arch/arm/configs/exynos_defconfig | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
> index 676c744..d6d1f7c 100644
> --- a/arch/arm/configs/exynos_defconfig
> +++ b/arch/arm/configs/exynos_defconfig
> @@ -101,11 +101,26 @@ CONFIG_REGULATOR_S2MPA01=y
>  CONFIG_REGULATOR_S2MPS11=y
>  CONFIG_REGULATOR_S5M8767=y
>  CONFIG_REGULATOR_TPS65090=y
> +CONFIG_DRM=y
> +CONFIG_DRM_BRIDGE=y
> +CONFIG_DRM_PTN3460=y
> +CONFIG_DRM_PS8622=y
> +CONFIG_DRM_EXYNOS=y
> +CONFIG_DRM_EXYNOS_FIMD=y
> +CONFIG_DRM_EXYNOS_DP=y
> +CONFIG_DRM_PANEL=y
> +CONFIG_DRM_PANEL_SIMPLE=y
>  CONFIG_FB=y
>  CONFIG_FB_MODE_HELPERS=y
>  CONFIG_FB_SIMPLE=y
>  CONFIG_EXYNOS_VIDEO=y
>  CONFIG_EXYNOS_MIPI_DSI=y
> +CONFIG_BACKLIGHT_LCD_SUPPORT=y
> +CONFIG_LCD_CLASS_DEVICE=y
> +CONFIG_LCD_PLATFORM=y
> +CONFIG_BACKLIGHT_CLASS_DEVICE=y
> +CONFIG_BACKLIGHT_GENERIC=y
> +CONFIG_BACKLIGHT_PWM=y
>  CONFIG_FRAMEBUFFER_CONSOLE=y
>  CONFIG_FONTS=y
>  CONFIG_FONT_7x14=y

