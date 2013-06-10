Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab3FJJXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 05:23:52 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:46284 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab3FJJXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 05:23:49 -0400
Subject: Re: [PATCH 3/3] i915: Don't provide ACPI backlight interface if
 firmware expects Windows 8
From: joeyli <jlee@suse.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-acpi@vger.kernel.org, seth.forshee@canonical.com,
        daniel.vetter@ffwll.ch, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rjw@sisk.pl
In-Reply-To: <1370818899-8595-4-git-send-email-matthew.garrett@nebula.com>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
	 <1370818899-8595-4-git-send-email-matthew.garrett@nebula.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Jun 2013 17:22:23 +0800
Message-ID: <1370856143.6523.114.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 日，2013-06-09 於 19:01 -0400，Matthew Garrett 提到：
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

This patch set works to me on Acer Aspire V3 notebook for unregister the
backlight interface of acpi video driver when i915 loaded. Acer Aspire
V3 has the Windows8 support in DSDT.

Tested-by: Lee, Chun-Yi <jlee@suse.com>


Thanks a lot!
Joey Lee

