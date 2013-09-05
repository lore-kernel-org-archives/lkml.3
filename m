Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763595Ab3IEI4O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 04:56:14 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:55194 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757468Ab3IEI4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 04:56:12 -0400
MIME-Version: 1.0
In-Reply-To: <1378369230-7786-1-git-send-email-geert@linux-m68k.org>
References: <1378369230-7786-1-git-send-email-geert@linux-m68k.org>
Date: Thu, 5 Sep 2013 10:56:11 +0200
Message-ID: <CANq1E4TZ5KirXQi3rWpA3adnNYtf5r1Aq6Br-7dzViaHcRX67Q@mail.gmail.com>
Subject: Re: [PATCH] video/drm: Drop superfluous "select VT_HW_CONSOLE_BINDING"
From: David Herrmann <dh.herrmann@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Inki Dae <inki.dae@samsung.com>,
        David Airlie <airlied@linux.ie>, Geoff Levand <geoff@infradead.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Sep 5, 2013 at 10:20 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> commit 765d5b9c2b72f5b99722cdfcf4bf8f88c556cf92 ("fbdev: fbcon: select
> VT_HW_CONSOLE_BINDING") made FRAMEBUFFER_CONSOLE always select
> VT_HW_CONSOLE_BINDING, but forgot to remove
>
>         select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE
>
> from the individual drivers' sections that already did this before.

Yepp, looks good. Maybe we should just drop it entirely. It's 200
lines of code and no additional dependencies. Anyway, nice catch:

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks
David

> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/gpu/drm/exynos/Kconfig |    1 -
>  drivers/video/Kconfig          |    1 -
>  2 files changed, 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/exynos/Kconfig b/drivers/gpu/drm/exynos/Kconfig
> index 772c62a..1344d34 100644
> --- a/drivers/gpu/drm/exynos/Kconfig
> +++ b/drivers/gpu/drm/exynos/Kconfig
> @@ -5,7 +5,6 @@ config DRM_EXYNOS
>         select FB_CFB_FILLRECT
>         select FB_CFB_COPYAREA
>         select FB_CFB_IMAGEBLIT
> -       select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE
>         help
>           Choose this option if you have a Samsung SoC EXYNOS chipset.
>           If M is selected the module will be called exynosdrm.
> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index 9788340..f60e3fa 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -2174,7 +2174,6 @@ config FB_PS3
>         select FB_SYS_COPYAREA
>         select FB_SYS_IMAGEBLIT
>         select FB_SYS_FOPS
> -       select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE
>         ---help---
>           Include support for the virtual frame buffer in the PS3 platform.
>
> --
> 1.7.9.5
>
