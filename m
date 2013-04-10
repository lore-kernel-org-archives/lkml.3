Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934078Ab3DJL4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 07:56:17 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:58314 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab3DJL4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 07:56:15 -0400
Date: Wed, 10 Apr 2013 19:56:06 +0800 (CST)
From: Xiong Zhou <jencce.kernel@gmail.com>
X-X-Sender: zx@M2420
To: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
cc: Xiong Zhou <jencce.kernel@gmail.com>, airlied@redhat.com,
        alan@linux.intel.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/gpu/drm/gma500:fix build failure for 3.9-rc5
In-Reply-To: <CAMeQTsaZmM-AT3abcWhVRQAFOJfYFjeCMC22r5YXU0w0NZ-g9A@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1304101949460.15970@M2420>
References: <alpine.DEB.2.02.1304091428270.24675@M2420> <CAMeQTsaZmM-AT3abcWhVRQAFOJfYFjeCMC22r5YXU0w0NZ-g9A@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 9 Apr 2013, Patrik Jakobsson wrote:

> On Tue, Apr 9, 2013 at 8:35 AM, Xiong Zhou <jencce.kernel@gmail.com> wrote:
> > From: Xiong Zhou <jencce.kernel@gmail.com>
> >
> > This patch fixes build failure of v3.9-rc5.
> > When config ACPI_VIDEO as m, DRM_GMA500 as y, here comes the failure.
> > gma5/600 needs acpi_video just like nouveau.
> >
> > Failure message:
> > drivers/built-in.o: In function `psb_driver_load':
> > kernel-3.9-rc5/drivers/gpu/drm/gma500/psb_drv.c:340: \
> >         undefined reference to `acpi_video_register'
> > make: *** [vmlinux] Error 1
> >
> > Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>
> > ---
> > drivers/gpu/drm/gma500/Kconfig |    1 +
> > 1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/gpu/drm/gma500/Kconfig b/drivers/gpu/drm/gma500/Kconfig
> > index 1188f0f..d64fc45 100644
> > --- a/drivers/gpu/drm/gma500/Kconfig
> > +++ b/drivers/gpu/drm/gma500/Kconfig
> > @@ -6,6 +6,7 @@ config DRM_GMA500
> >          select FB_CFB_IMAGEBLIT
> >          select DRM_KMS_HELPER
> >          select DRM_TTM
> > +        select ACPI_VIDEO if ACPI && X86 && BACKLIGHT_CLASS_DEVICE && VIDEO_OUTPUT_CONTROL && INPUT
> >         help
> >           Say yes for an experimental 2D KMS framebuffer driver for the
> >           Intel GMA500 ('Poulsbo') and other Intel IMG based graphics
> > --
> 
> Hi
> 
> Thanks for catching this, but if I can be picky, I'd prefer if you wrote it
> like i915 does. E.g.
> 
> 	select ACPI_VIDEO if ACPI
> 	select BACKLIGHT_CLASS_DEVICE if ACPI
> 	...
> 
> And you can skip X86 since we already 'depend' on it.
> 
> Thanks
> Patrik
> 

Nice advices, Thanks!


Xiong
