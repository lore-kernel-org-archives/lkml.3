Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964898Ab3DIUWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:22:25 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:39221 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935949Ab3DIUWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:22:23 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1304091428270.24675@M2420>
References: <alpine.DEB.2.02.1304091428270.24675@M2420>
Date: Tue, 9 Apr 2013 22:22:21 +0200
Message-ID: <CAMeQTsaZmM-AT3abcWhVRQAFOJfYFjeCMC22r5YXU0w0NZ-g9A@mail.gmail.com>
Subject: Re: [PATCH] drivers/gpu/drm/gma500:fix build failure for 3.9-rc5
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Xiong Zhou <jencce.kernel@gmail.com>
Cc: airlied@redhat.com, alan@linux.intel.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 8:35 AM, Xiong Zhou <jencce.kernel@gmail.com> wrote:
> From: Xiong Zhou <jencce.kernel@gmail.com>
>
> This patch fixes build failure of v3.9-rc5.
> When config ACPI_VIDEO as m, DRM_GMA500 as y, here comes the failure.
> gma5/600 needs acpi_video just like nouveau.
>
> Failure message:
> drivers/built-in.o: In function `psb_driver_load':
> kernel-3.9-rc5/drivers/gpu/drm/gma500/psb_drv.c:340: \
>         undefined reference to `acpi_video_register'
> make: *** [vmlinux] Error 1
>
> Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>
> ---
> drivers/gpu/drm/gma500/Kconfig |    1 +
> 1 file changed, 1 insertion(+)
>
> diff --git a/drivers/gpu/drm/gma500/Kconfig b/drivers/gpu/drm/gma500/Kconfig
> index 1188f0f..d64fc45 100644
> --- a/drivers/gpu/drm/gma500/Kconfig
> +++ b/drivers/gpu/drm/gma500/Kconfig
> @@ -6,6 +6,7 @@ config DRM_GMA500
>          select FB_CFB_IMAGEBLIT
>          select DRM_KMS_HELPER
>          select DRM_TTM
> +        select ACPI_VIDEO if ACPI && X86 && BACKLIGHT_CLASS_DEVICE && VIDEO_OUTPUT_CONTROL && INPUT
>         help
>           Say yes for an experimental 2D KMS framebuffer driver for the
>           Intel GMA500 ('Poulsbo') and other Intel IMG based graphics
> --

Hi

Thanks for catching this, but if I can be picky, I'd prefer if you wrote it
like i915 does. E.g.

	select ACPI_VIDEO if ACPI
	select BACKLIGHT_CLASS_DEVICE if ACPI
	...

And you can skip X86 since we already 'depend' on it.

Thanks
Patrik
