Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab3AaIm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 03:42:28 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:37796 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab3AaImZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 03:42:25 -0500
MIME-Version: 1.0
In-Reply-To: <1359127711-19070-6-git-send-email-arnd@arndb.de>
References: <1359127711-19070-1-git-send-email-arnd@arndb.de>
	<1359127711-19070-6-git-send-email-arnd@arndb.de>
Date: Thu, 31 Jan 2013 14:12:24 +0530
Message-ID: <CAPdUM4MbFN6htJ9Xa_OtdfgpxNH=7JD6-eUAkVM5_O5SZYv2+w@mail.gmail.com>
Subject: Re: [PATCH 5/5] drm/exynos: don't include plat/gpio-cfg.h
From: Rahul Sharma <r.sh.open@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Inki Dae <inki.dae@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, Rob Clark <rob@ti.com>,
        Rahul Sharma <rahul.sharma@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd Bergmann,

It looks good to me. My patch caused this issue.
Thanks for the fix.

regards,
Rahul Sharma.

On Fri, Jan 25, 2013 at 8:58 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> Patch  9eb3e9e6f3 "drm/exynos: add support for ARCH_MULTIPLATFORM"
> allowed building the exynos hdmi driver on non-samsung platforms,
> which unfortunately broke compilation in combination with 22c4f42897
> "drm: exynos: hdmi: add support for exynos5 hdmi", which added
> an inclusion of the samsung-specific plat/gpio-cfg.h header file.
>
> Fortunately, that header file is not required any more here, so
> we can simply revert the inclusion in order to build the ARM
> allyesconfig again without getting this error:
>
> drivers/gpu/drm/exynos/exynos_hdmi.c:37:27: fatal error: plat/gpio-cfg.h: No such file or directory
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Rob Clark <rob@ti.com>
> Cc: Inki Dae <inki.dae@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Rahul Sharma <rahul.sharma@samsung.com>
> ---
>  drivers/gpu/drm/exynos/exynos_hdmi.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
> index 41ff79d..b5f5119 100644
> --- a/drivers/gpu/drm/exynos/exynos_hdmi.c
> +++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
> @@ -34,7 +34,6 @@
>  #include <linux/regulator/consumer.h>
>  #include <linux/io.h>
>  #include <linux/of_gpio.h>
> -#include <plat/gpio-cfg.h>
>
>  #include <drm/exynos_drm.h>
>
> --
> 1.8.0
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
