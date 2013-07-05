Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab3GEMKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 08:10:38 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:59412 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757048Ab3GEMKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 08:10:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <matthew.garrett@nebula.com>, daniel.vetter@ffwll.ch
Cc: linux-acpi@vger.kernel.org, seth.forshee@canonical.com,
        joeyli.kernel@gmail.com, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        lenb@kernel.org
Subject: Re: [PATCH 3/3] i915: Don't provide ACPI backlight interface if firmware expects Windows 8
Date: Fri, 05 Jul 2013 14:20:14 +0200
Message-ID: <1877295.vRFvlWsoSZ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1370818899-8595-4-git-send-email-matthew.garrett@nebula.com>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com> <1370818899-8595-4-git-send-email-matthew.garrett@nebula.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 09, 2013 07:01:39 PM Matthew Garrett wrote:
> Windows 8 leaves backlight control up to individual graphics drivers rather
> than making ACPI calls itself. There's plenty of evidence to suggest that
> the Intel driver for Windows doesn't use the ACPI interface, including the
> fact that it's broken on a bunch of machines when the OS claims to support
> Windows 8. The simplest thing to do appears to be to disable the ACPI
> backlight interface on these systems.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> ---
>  drivers/gpu/drm/i915/i915_dma.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
> index 3b315ba..23b6292 100644
> --- a/drivers/gpu/drm/i915/i915_dma.c
> +++ b/drivers/gpu/drm/i915/i915_dma.c
> @@ -1661,6 +1661,9 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
>  		/* Must be done after probing outputs */
>  		intel_opregion_init(dev);
>  		acpi_video_register();
> +		/* Don't use ACPI backlight functions on Windows 8 platforms */
> +		if (acpi_osi_version() >= ACPI_OSI_WIN_8)
> +			acpi_video_backlight_unregister();
>  	}
>  
>  	if (IS_GEN5(dev))
> 

Well, this causes build failures to happen when the ACPI video driver is
modular and the graphics driver is not.

I'm not sure how to resolve that, so suggestions are welcome.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
