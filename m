Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbaGVPkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:40:35 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:45471 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793AbaGVPkd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:40:33 -0400
MIME-Version: 1.0
In-Reply-To: <68B811F07A63BA48BF0F49F7D822D4190101283EC6C9@SAFEX1MAIL2.st.com>
References: <1404218442-10980-1-git-send-email-fabien.dessenne@st.com>
	<68B811F07A63BA48BF0F49F7D822D4190101283EC6C9@SAFEX1MAIL2.st.com>
Date: Tue, 22 Jul 2014 17:40:32 +0200
Message-ID: <CA+M3ks4cOvo9MyXaX+F=U6anGEV_mu2grRLyP6p=vhLt_Z_cMQ@mail.gmail.com>
Subject: Re: [PATCH] drm/crtc-helper: use drm_framebuffer flags
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: Fabien DESSENNE <fabien.dessenne@st.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Vincent ABRIOU <vincent.abriou@st.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding LKML and David in diffusion list to get an opinion on this patch

2014-07-10 10:01 GMT+02:00 Fabien DESSENNE <fabien.dessenne@st.com>:
> Hi,
> Can anyone review this patch ?
> Thanks for your time.
> Fabien
>
>> -----Original Message-----
>> From: Fabien DESSENNE [mailto:fabien.dessenne@st.com]
>> Sent: mardi 1 juillet 2014 14:41
>> To: dri-devel@lists.freedesktop.org
>> Cc: Benjamin Gaignard; Vincent ABRIOU; Fabien DESSENNE
>> Subject: [PATCH] drm/crtc-helper: use drm_framebuffer flags
>>
>> The "flags" parameter of the DRM_IOCTL_MODE_ADDFB2 ioctl must be
>> propagated and used by the driver.
>> The only possible value of flags is DRM_MODE_FB_INTERLACED.
>>
>> Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>
>> Reviewed-by: Benjamin GAIGNARD <benjamin.gaignard@st.com>
>> ---
>>  drivers/gpu/drm/drm_crtc_helper.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/gpu/drm/drm_crtc_helper.c
>> b/drivers/gpu/drm/drm_crtc_helper.c
>> index 23500c0..5974489 100644
>> --- a/drivers/gpu/drm/drm_crtc_helper.c
>> +++ b/drivers/gpu/drm/drm_crtc_helper.c
>> @@ -966,6 +966,7 @@ int drm_helper_mode_fill_fb_struct(struct
>> drm_framebuffer *fb,
>>       drm_fb_get_bpp_depth(mode_cmd->pixel_format, &fb->depth,
>>                                   &fb->bits_per_pixel);
>>       fb->pixel_format = mode_cmd->pixel_format;
>> +     fb->flags = mode_cmd->flags;
>>
>>       return 0;
>>  }
>> --
>> 1.9.1
>



-- 
Benjamin Gaignard

Graphic Working Group

Linaro.org │ Open source software for ARM SoCs

Follow Linaro: Facebook | Twitter | Blog
