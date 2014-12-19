Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaLSTDH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 14:03:07 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:56742 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaLSTDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 14:03:04 -0500
Message-ID: <54947695.3020108@gmail.com>
Date: Fri, 19 Dec 2014 19:03:49 +0000
From: Emil Velikov <emil.l.velikov@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>
CC: emil.l.velikov@gmail.com, Fabio Estevam <fabio.estevam@freescale.com>,
        linux-fbdev@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Denis Carikli <denis@eukrea.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: Re: [PATCH v2 3/7] drm_modes: add videomode_from_drm_display_mode
References: <1418954426-21909-1-git-send-email-steve_longerbeam@mentor.com> <1418954426-21909-4-git-send-email-steve_longerbeam@mentor.com> <1418986984.3165.64.camel@pengutronix.de>
In-Reply-To: <1418986984.3165.64.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/12/14 11:03, Philipp Zabel wrote:
> Am Donnerstag, den 18.12.2014, 18:00 -0800 schrieb Steve Longerbeam:
>> Add conversion from drm_display_mode to videomode.
>>
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>> ---
>>  drivers/gpu/drm/drm_modes.c |   40 ++++++++++++++++++++++++++++++++++++++++
>>  include/drm/drm_modes.h     |    2 ++
>>  2 files changed, 42 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
>> index 6d8b941..583a391 100644
>> --- a/drivers/gpu/drm/drm_modes.c
>> +++ b/drivers/gpu/drm/drm_modes.c
>> @@ -615,6 +615,46 @@ void drm_display_mode_from_videomode(const struct videomode *vm,
>>  }
>>  EXPORT_SYMBOL_GPL(drm_display_mode_from_videomode);
>>  
>> +/**
>> + * videomode_from_drm_display_mode - fill in @vm using @dmode,
>> + * @dmode: drm_display_mode structure to use as source
>> + * @vm: videomode structure to use as destination
>> + *
>> + * Fills out @vm using the display mode specified in @dmode.
>> + */
>> +void videomode_from_drm_display_mode(const struct drm_display_mode *dmode,
>> +				     struct videomode *vm)
>> +{
>> +	vm->hactive = dmode->hdisplay;
>> +	vm->hfront_porch = dmode->hsync_start - dmode->hdisplay;
>> +	vm->hsync_len = dmode->hsync_end - dmode->hsync_start;
>> +	vm->hback_porch = dmode->htotal - dmode->hsync_end;
>> +
>> +	vm->vactive = dmode->vdisplay;
>> +	vm->vfront_porch = dmode->vsync_start - dmode->vdisplay;
>> +	vm->vsync_len = dmode->vsync_end - dmode->vsync_start;
>> +	vm->vback_porch = dmode->vtotal - dmode->vsync_end;
>> +
>> +	vm->pixelclock = dmode->clock * 1000;
>> +
>> +	vm->flags = 0;
>> +	if (dmode->flags & DRM_MODE_FLAG_PHSYNC)
>> +		vm->flags |= DISPLAY_FLAGS_HSYNC_HIGH;
>> +	else if (dmode->flags & DRM_MODE_FLAG_NHSYNC)
>> +		vm->flags |= DISPLAY_FLAGS_HSYNC_LOW;
>> +	if (dmode->flags & DRM_MODE_FLAG_PVSYNC)
>> +		vm->flags |= DISPLAY_FLAGS_VSYNC_HIGH;
>> +	else if (dmode->flags & DRM_MODE_FLAG_NVSYNC)
>> +		vm->flags |= DISPLAY_FLAGS_VSYNC_LOW;
>> +	if (dmode->flags & DRM_MODE_FLAG_INTERLACE)
>> +		vm->flags |= DISPLAY_FLAGS_INTERLACED;
>> +	if (dmode->flags & DRM_MODE_FLAG_DBLSCAN)
>> +		vm->flags |= DISPLAY_FLAGS_DOUBLESCAN;
>> +	if (dmode->flags & DRM_MODE_FLAG_DBLCLK)
>> +		vm->flags |= DISPLAY_FLAGS_DOUBLECLK;
>> +}
>> +EXPORT_SYMBOL_GPL(videomode_from_drm_display_mode);
> 
> Is it ok for drm_modes to export a function that doesn't start with
> drm_ ? We could just rename this to drm_display_mode_to_videomode if
> necessary. I can fix it up as I apply it, but I'd like to know which is
> preferred.
> 
Non-native English speaker here, and drm_display_mode_to_videomode
sounds better. Plus I think that *to* functions are more common than
*from* ones.

I'm not a drm dev, so just my 2c :)

Cheers,
Emil

