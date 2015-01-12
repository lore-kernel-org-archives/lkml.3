Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbbALWrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 17:47:51 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:47126 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbbALWrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 17:47:49 -0500
MIME-Version: 1.0
X-Originating-IP: [130.216.30.134]
In-Reply-To: <1421093413-26336-1-git-send-email-geert@linux-m68k.org>
References: <1421093413-26336-1-git-send-email-geert@linux-m68k.org>
Date: Mon, 12 Jan 2015 23:47:48 +0100
X-Google-Sender-Auth: OMzZeCUO97BcaGkOauvKA0l6Er0
Message-ID: <CAKMK7uEmzoZBfbErfc9r2CWq9Uyvw9aZtvYSjwA8Ou5PFcyUCw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] drm: Drop superfluous "select VT_HW_CONSOLE_BINDING"
From: Daniel Vetter <daniel@ffwll.ch>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Airlie <airlied@linux.ie>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 09:10:12PM +0100, Geert Uytterhoeven wrote:
> commit 765d5b9c2b72f5b9 ("fbdev: fbcon: select VT_HW_CONSOLE_BINDING")
> made FRAMEBUFFER_CONSOLE always select VT_HW_CONSOLE_BINDING, but forgot
> to remove
>
> select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE
>
> from the individual drivers' sections that already did this before.
>
> Remove it, also from new drivers.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Merged into my drm misc branch, thanks.
-Daniel

> ---
> v2:
>   - Split in two (drm and video) patches,
>   - Fix recently added rockchip.
> ---
>  drivers/gpu/drm/exynos/Kconfig   | 1 -
>  drivers/gpu/drm/rockchip/Kconfig | 1 -
>  2 files changed, 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/exynos/Kconfig b/drivers/gpu/drm/exynos/Kconfig
> index 7f9f6f9e9b7e7992..c072999b7e0345c6 100644
> --- a/drivers/gpu/drm/exynos/Kconfig
> +++ b/drivers/gpu/drm/exynos/Kconfig
> @@ -6,7 +6,6 @@ config DRM_EXYNOS
>   select FB_CFB_FILLRECT
>   select FB_CFB_COPYAREA
>   select FB_CFB_IMAGEBLIT
> - select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE
>   select VIDEOMODE_HELPERS
>   help
>    Choose this option if you have a Samsung SoC EXYNOS chipset.
> diff --git a/drivers/gpu/drm/rockchip/Kconfig b/drivers/gpu/drm/rockchip/Kconfig
> index ca9f085efa922982..8652dad82009e3ce 100644
> --- a/drivers/gpu/drm/rockchip/Kconfig
> +++ b/drivers/gpu/drm/rockchip/Kconfig
> @@ -7,7 +7,6 @@ config DRM_ROCKCHIP
>   select FB_CFB_FILLRECT
>   select FB_CFB_COPYAREA
>   select FB_CFB_IMAGEBLIT
> - select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE
>   select VIDEOMODE_HELPERS
>   help
>    Choose this option if you have a Rockchip soc chipset.
> --
> 1.9.1
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
