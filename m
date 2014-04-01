Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbaDAKBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 06:01:52 -0400
Received: from [208.91.2.12] ([208.91.2.12]:53156 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751089AbaDAKBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 06:01:49 -0400
Message-ID: <533A8E52.5050304@vmware.com>
Date: Tue, 01 Apr 2014 12:00:50 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Christopher Friedt <chrisfriedt@gmail.com>
CC: Dave Airlie <airlied@gmail.com>, Thomas Hellstrom <thellstrom@vmware.com>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH 1/1] drm/vmwgfx: correct fb_fix_screeninfo.line_length
References: <1395967502-71219-1-git-send-email-chrisfriedt@gmail.com> <CAPM=9tx4hdU0PZqdZcCd-x3HMu+6ZsGibeOHZPLe3OpW9Wsa0g@mail.gmail.com>
In-Reply-To: <CAPM=9tx4hdU0PZqdZcCd-x3HMu+6ZsGibeOHZPLe3OpW9Wsa0g@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2014 02:45 AM, Dave Airlie wrote:
> On Fri, Mar 28, 2014 at 10:45 AM, Christopher Friedt
> <chrisfriedt@gmail.com> wrote:
>> Previously, the vmwgfx_fb driver would allow users to call FBIOSET_VINFO, but it would not adjust
>> the FINFO properly, resulting in distorted screen rendering. The patch corrects that behaviour.
>>
>> See https://bugs.gentoo.org/show_bug.cgi?id=494794 for examples.
>>
> Just adding cc's of maintainer list.
Looks correct to me.
Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>

Will add it to vmgfx-next and cc stable.

Thanks,
Thomas



>> Signed-off-by: Christopher Friedt <chrisfriedt@gmail.com>
>> ---
>>  drivers/gpu/drm/vmwgfx/vmwgfx_fb.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
>> index ed5ce2a..021b522 100644
>> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
>> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
>> @@ -147,7 +147,7 @@ static int vmw_fb_check_var(struct fb_var_screeninfo *var,
>>         }
>>
>>         if (!vmw_kms_validate_mode_vram(vmw_priv,
>> -                                       info->fix.line_length,
>> +                                       var->xres * var->bits_per_pixel/8,
>>                                         var->yoffset + var->yres)) {
>>                 DRM_ERROR("Requested geom can not fit in framebuffer\n");
>>                 return -EINVAL;
>> @@ -162,6 +162,8 @@ static int vmw_fb_set_par(struct fb_info *info)
>>         struct vmw_private *vmw_priv = par->vmw_priv;
>>         int ret;
>>
>> +       info->fix.line_length = info->var.xres * info->var.bits_per_pixel/8;
>> +
>>         ret = vmw_kms_write_svga(vmw_priv, info->var.xres, info->var.yres,
>>                                  info->fix.line_length,
>>                                  par->bpp, par->depth);
>> @@ -177,6 +179,7 @@ static int vmw_fb_set_par(struct fb_info *info)
>>                 vmw_write(vmw_priv, SVGA_REG_DISPLAY_POSITION_Y, info->var.yoffset);
>>                 vmw_write(vmw_priv, SVGA_REG_DISPLAY_WIDTH, info->var.xres);
>>                 vmw_write(vmw_priv, SVGA_REG_DISPLAY_HEIGHT, info->var.yres);
>> +               vmw_write(vmw_priv, SVGA_REG_BYTES_PER_LINE, info->fix.line_length);
>>                 vmw_write(vmw_priv, SVGA_REG_DISPLAY_ID, SVGA_ID_INVALID);
>>         }
>>
>> --
>> 1.8.3.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
