Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab3AVB0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 20:26:18 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:42988 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab3AVB0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 20:26:17 -0500
MIME-Version: 1.0
In-Reply-To: <1358788568-11137-9-git-send-email-arnd@arndb.de>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
	<1358788568-11137-9-git-send-email-arnd@arndb.de>
Date: Tue, 22 Jan 2013 10:26:16 +0900
X-Google-Sender-Auth: MC0sE807yvYuqtPJfGCKb4N-zcs
Message-ID: <CAAQKjZPh_bAAXoA91hLGygmCFpbtWyOq4GYP-PQvBf6Rk806ig@mail.gmail.com>
Subject: Re: [PATCH 08/15] drm/exynos: fimd and ipp are broken on multiplatform
From: Inki Dae <inki.dae@samsung.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Seung-Woo Kim <sw0312.kim@samsung.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Kyungmin Park <kyungmin.park@samsung.com>, arm@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checked it out and applied. For ARCH_MULTIPLATFORM support, Such
header files shouldn't be included. And for this, we are planning on
supporting device tree for ipp driver.

Thanks,
Inki Dae

2013/1/22 Arnd Bergmann <arnd@arndb.de>:
> While the exynos DRM support in principle can work on
> multiplatform, the FIMD and IPP sections of it both
> include the plat/map-base.h header file, which is
> not available on multiplatform. Rather than disabling
> the entire driver, we can just conditionally build
> these two parts.
>
> Without this patch, building allyesconfig results in:
>
> drivers/gpu/drm/exynos/exynos_drm_fimc.c:19:27: fatal error: plat/map-base.h: No such file or directory
> drivers/gpu/drm/exynos/exynos_drm_ipp.c:20:27: fatal error: plat/map-base.h: No such file or directory
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Joonyoung Shim <jy0922.shim@samsung.com>
> Cc: Inki Dae <inki.dae@samsung.com>
> Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: David Airlie <airlied@linux.ie>
> Cc: dri-devel@lists.freedesktop.org
> ---
>  drivers/gpu/drm/exynos/Kconfig |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/exynos/Kconfig b/drivers/gpu/drm/exynos/Kconfig
> index 1d1f1e5..046bcda 100644
> --- a/drivers/gpu/drm/exynos/Kconfig
> +++ b/drivers/gpu/drm/exynos/Kconfig
> @@ -24,7 +24,7 @@ config DRM_EXYNOS_DMABUF
>
>  config DRM_EXYNOS_FIMD
>         bool "Exynos DRM FIMD"
> -       depends on DRM_EXYNOS && !FB_S3C
> +       depends on DRM_EXYNOS && !FB_S3C && !ARCH_MULTIPLATFORM
>         help
>           Choose this option if you want to use Exynos FIMD for DRM.
>
> @@ -48,7 +48,7 @@ config DRM_EXYNOS_G2D
>
>  config DRM_EXYNOS_IPP
>         bool "Exynos DRM IPP"
> -       depends on DRM_EXYNOS
> +       depends on DRM_EXYNOS && !ARCH_MULTIPLATFORM
>         help
>           Choose this option if you want to use IPP feature for DRM.
>
> --
> 1.7.10.4
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
