Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaLSLDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 06:03:15 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47054 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbaLSLDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 06:03:13 -0500
Message-ID: <1418986984.3165.64.camel@pengutronix.de>
Subject: Re: [PATCH v2 3/7] drm_modes: add videomode_from_drm_display_mode
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, Denis Carikli <denis@eukrea.com>,
        Jiada Wang <jiada_wang@mentor.com>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Fri, 19 Dec 2014 12:03:04 +0100
In-Reply-To: <1418954426-21909-4-git-send-email-steve_longerbeam@mentor.com>
References: <1418954426-21909-1-git-send-email-steve_longerbeam@mentor.com>
	 <1418954426-21909-4-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 18.12.2014, 18:00 -0800 schrieb Steve Longerbeam:
> Add conversion from drm_display_mode to videomode.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/gpu/drm/drm_modes.c |   40 ++++++++++++++++++++++++++++++++++++++++
>  include/drm/drm_modes.h     |    2 ++
>  2 files changed, 42 insertions(+)
> 
> diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
> index 6d8b941..583a391 100644
> --- a/drivers/gpu/drm/drm_modes.c
> +++ b/drivers/gpu/drm/drm_modes.c
> @@ -615,6 +615,46 @@ void drm_display_mode_from_videomode(const struct videomode *vm,
>  }
>  EXPORT_SYMBOL_GPL(drm_display_mode_from_videomode);
>  
> +/**
> + * videomode_from_drm_display_mode - fill in @vm using @dmode,
> + * @dmode: drm_display_mode structure to use as source
> + * @vm: videomode structure to use as destination
> + *
> + * Fills out @vm using the display mode specified in @dmode.
> + */
> +void videomode_from_drm_display_mode(const struct drm_display_mode *dmode,
> +				     struct videomode *vm)
> +{
> +	vm->hactive = dmode->hdisplay;
> +	vm->hfront_porch = dmode->hsync_start - dmode->hdisplay;
> +	vm->hsync_len = dmode->hsync_end - dmode->hsync_start;
> +	vm->hback_porch = dmode->htotal - dmode->hsync_end;
> +
> +	vm->vactive = dmode->vdisplay;
> +	vm->vfront_porch = dmode->vsync_start - dmode->vdisplay;
> +	vm->vsync_len = dmode->vsync_end - dmode->vsync_start;
> +	vm->vback_porch = dmode->vtotal - dmode->vsync_end;
> +
> +	vm->pixelclock = dmode->clock * 1000;
> +
> +	vm->flags = 0;
> +	if (dmode->flags & DRM_MODE_FLAG_PHSYNC)
> +		vm->flags |= DISPLAY_FLAGS_HSYNC_HIGH;
> +	else if (dmode->flags & DRM_MODE_FLAG_NHSYNC)
> +		vm->flags |= DISPLAY_FLAGS_HSYNC_LOW;
> +	if (dmode->flags & DRM_MODE_FLAG_PVSYNC)
> +		vm->flags |= DISPLAY_FLAGS_VSYNC_HIGH;
> +	else if (dmode->flags & DRM_MODE_FLAG_NVSYNC)
> +		vm->flags |= DISPLAY_FLAGS_VSYNC_LOW;
> +	if (dmode->flags & DRM_MODE_FLAG_INTERLACE)
> +		vm->flags |= DISPLAY_FLAGS_INTERLACED;
> +	if (dmode->flags & DRM_MODE_FLAG_DBLSCAN)
> +		vm->flags |= DISPLAY_FLAGS_DOUBLESCAN;
> +	if (dmode->flags & DRM_MODE_FLAG_DBLCLK)
> +		vm->flags |= DISPLAY_FLAGS_DOUBLECLK;
> +}
> +EXPORT_SYMBOL_GPL(videomode_from_drm_display_mode);

Is it ok for drm_modes to export a function that doesn't start with
drm_ ? We could just rename this to drm_display_mode_to_videomode if
necessary. I can fix it up as I apply it, but I'd like to know which is
preferred.

regards
Philipp

