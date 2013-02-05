Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab3BEOwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 09:52:37 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45272 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754355Ab3BEOwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 09:52:35 -0500
Date: Tue, 5 Feb 2013 15:52:32 +0100
From: Borislav Petkov <bp@alien8.de>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm/nouveau: always select ACPI_VIDEO if ACPI is enabled.
Message-ID: <20130205145232.GI4827@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	dri-devel@lists.freedesktop.org,
	lkml <linux-kernel@vger.kernel.org>
References: <20130204152344.GG13909@pd.tnic>
 <510FD6A2.80101@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <510FD6A2.80101@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 04:41:22PM +0100, Maarten Lankhorst wrote:
> Hey,
> 
> Op 04-02-13 16:23, Borislav Petkov schreef:
> > Hi,
> >
> > I'm guessing someone has already triggered this on latest Linus' tree
> > and has a fix?
> >
> > drivers/built-in.o: In function `nouveau_acpi_edid':
> > /w/kernel/linux/drivers/gpu/drm/nouveau/nouveau_acpi.c:420: undefined reference to `acpi_video_get_edid'
> > make: *** [vmlinux] Error 1
> >
> > Btw, I got CONFIG_ACPI_VIDEO=m while CONFIG_DRM_NOUVEAU=y and this is
> > probably the reason for the vmlinux link error.
> >
> > Thanks.
> >
> Does this fix things?
> 
> -->8
> Having nouveau builtin would still allow ACPI_VIDEO to be used as external module if some of the deps for acpi_video
> have not been met, which would result in a linking failure. Solve this by only requiring ACPI && X86 to select ACPI_VIDEO.
> 
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> 
> ---
> diff --git a/drivers/gpu/drm/nouveau/Kconfig b/drivers/gpu/drm/nouveau/Kconfig
> index 8a55bee..f08b9b6 100644
> --- a/drivers/gpu/drm/nouveau/Kconfig
> +++ b/drivers/gpu/drm/nouveau/Kconfig
> @@ -10,7 +10,7 @@ config DRM_NOUVEAU
>  	select FB
>  	select FRAMEBUFFER_CONSOLE if !EXPERT
>  	select FB_BACKLIGHT if DRM_NOUVEAU_BACKLIGHT
> -	select ACPI_VIDEO if ACPI && X86 && BACKLIGHT_CLASS_DEVICE && VIDEO_OUTPUT_CONTROL && INPUT
> +	select ACPI_VIDEO if ACPI && X86
>  	select ACPI_WMI if ACPI
>  	select MXM_WMI if ACPI
>  	select POWER_SUPPLY

Not really.

drivers/built-in.o: In function `acpi_video_bus_put_one_device':
/root/kernel/linux/drivers/acpi/video.c:1407: undefined reference to `thermal_cooling_device_unregister'
drivers/built-in.o: In function `acpi_video_device_find_cap':
/root/kernel/linux/drivers/acpi/video.c:842: undefined reference to `thermal_cooling_device_register'
make: *** [vmlinux] Error 1

It is CONFIG_THERMAL=m this time.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
