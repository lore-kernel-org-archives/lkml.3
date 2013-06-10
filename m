Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab3FJHkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 03:40:39 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:55752 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab3FJHkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 03:40:37 -0400
Date: Mon, 10 Jun 2013 09:40:31 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-acpi@vger.kernel.org, seth.forshee@canonical.com,
        joeyli.kernel@gmail.com, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, lenb@kernel.org, rjw@sisk.pl
Subject: Re: [PATCH 3/3] i915: Don't provide ACPI backlight interface if
 firmware expects Windows 8
Message-ID: <20130610074031.GG22870@phenom.ffwll.local>
Mail-Followup-To: Matthew Garrett <matthew.garrett@nebula.com>,
	linux-acpi@vger.kernel.org, seth.forshee@canonical.com,
	joeyli.kernel@gmail.com, intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	lenb@kernel.org, rjw@sisk.pl
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
 <1370818899-8595-4-git-send-email-matthew.garrett@nebula.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370818899-8595-4-git-send-email-matthew.garrett@nebula.com>
X-Operating-System: Linux phenom 3.9.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 09, 2013 at 07:01:39PM -0400, Matthew Garrett wrote:
> Windows 8 leaves backlight control up to individual graphics drivers rather
> than making ACPI calls itself. There's plenty of evidence to suggest that
> the Intel driver for Windows doesn't use the ACPI interface, including the
> fact that it's broken on a bunch of machines when the OS claims to support
> Windows 8. The simplest thing to do appears to be to disable the ACPI
> backlight interface on these systems.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>

Make sense and I guess it's easier to merge this all through the acpi
tree. So

Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>

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
> -- 
> 1.8.2.1
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
