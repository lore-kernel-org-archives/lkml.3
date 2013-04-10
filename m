Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937198Ab3DJRqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:46:38 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:36568 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935157Ab3DJRqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:46:35 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1304102035250.15970@M2420>
References: <alpine.DEB.2.02.1304102035250.15970@M2420>
Date: Wed, 10 Apr 2013 19:46:33 +0200
Message-ID: <CAMeQTsap-ZbP9e-nqfu8GDLBLZ9a8H6RYYnxkuV1e1AUkXW-RQ@mail.gmail.com>
Subject: Re: [PATCH v2] gma500:fix build failure for 3.9-rc5
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Xiong Zhou <jencce.kernel@gmail.com>
Cc: airlied@redhat.com, alan@linux.intel.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 2:37 PM, Xiong Zhou <jencce.kernel@gmail.com> wrote:
> From: Xiong Zhou <jencce.kernel@gmail.com>
>
> Last version of this patch is not clear enough and X86 duplicated.
>
> This patch fixes build failure of v3.9-rc5 and rc6.
> When config ACPI_VIDEO as m, DRM_GMA500 as y, here comes the failure.
> GMA5/600 needs acpi_video just like nouveau.
> And some tab type fix by the way.
>
> Failure message:
> drivers/built-in.o: In function `psb_driver_load':
> kernel-3.9-rc5/drivers/gpu/drm/gma500/psb_drv.c:340: \
>         undefined reference to `acpi_video_register'
> make: *** [vmlinux] Error 1
>
> Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>
> ---
> drivers/gpu/drm/gma500/Kconfig |   13 +++++++++----
> 1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpu/drm/gma500/Kconfig b/drivers/gpu/drm/gma500/Kconfig
> index 1188f0f..1f6e2df 100644
> --- a/drivers/gpu/drm/gma500/Kconfig
> +++ b/drivers/gpu/drm/gma500/Kconfig
> @@ -2,10 +2,15 @@ config DRM_GMA500
>         tristate "Intel GMA5/600 KMS Framebuffer"
>         depends on DRM && PCI && X86
>         select FB_CFB_COPYAREA
> -        select FB_CFB_FILLRECT
> -        select FB_CFB_IMAGEBLIT
> -        select DRM_KMS_HELPER
> -        select DRM_TTM
> +       select FB_CFB_FILLRECT
> +       select FB_CFB_IMAGEBLIT
> +       select DRM_KMS_HELPER
> +       select DRM_TTM
> +       # GMA500 depends on ACPI_VIDEO when ACPI is enabled, just like i915
> +       select ACPI_VIDEO if ACPI
> +       select BACKLIGHT_CLASS_DEVICE if ACPI
> +       select VIDEO_OUTPUT_CONTROL if ACPI
> +       select INPUT if ACPI
>         help
>           Say yes for an experimental 2D KMS framebuffer driver for the
>           Intel GMA500 ('Poulsbo') and other Intel IMG based graphics

Your patch has been applied to:
https://github.com/patjak/drm-gma500.git gma500-next

I didn't have c97fc5f regarding the experimental dep in my tree so I had to fix
that. Will sort out the missing patch later.

Thanks
Patrik
