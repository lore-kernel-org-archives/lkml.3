Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbaH0KBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 06:01:01 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:39900 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602AbaH0KA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 06:00:58 -0400
MIME-Version: 1.0
In-Reply-To: <53FC629A.2050101@ti.com>
References: <20140516093123.GA17245@devel.8.8.4.4>
	<53FC629A.2050101@ti.com>
Date: Wed, 27 Aug 2014 19:00:58 +0900
Message-ID: <CAHb8M2C4FygA5k9bPbuoJTv1EWZ-iGZrD7X7jrHoVqH=_L-_+Q@mail.gmail.com>
Subject: Re: [PATCH V2] video : remove redundant error check
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Antonino Daplas <adaplas@gmail.com>, jg1.han@samsung.com,
        laurent.pinchart@ideasonboard.com, Rob Clark <robdclark@gmail.com>,
        daniel.vetter@ffwll.ch, Julia Lawall <Julia.Lawall@lip6.fr>,
        linux-fbdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-08-26 19:34 GMT+09:00 Tomi Valkeinen <tomi.valkeinen@ti.com>:
> On 16/05/14 12:31, Daeseok Youn wrote:
>> It doesn't need to check "err" for printing info.
>> And also use pr_info instead of printk.
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>> V2: removes unneeded lines for sending a patch
>>
>>  drivers/video/fbdev/i810/i810_main.c |    7 +++----
>>  1 files changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/video/fbdev/i810/i810_main.c b/drivers/video/fbdev/i810/i810_main.c
>> index bb674e4..15cb397 100644
>> --- a/drivers/video/fbdev/i810/i810_main.c
>> +++ b/drivers/video/fbdev/i810/i810_main.c
>> @@ -1910,13 +1910,12 @@ static void i810fb_find_init_mode(struct fb_info *info)
>>
>>       for (i = 0; i < par->ddc_num + 1; i++) {
>>               err = i810_probe_i2c_connector(info, &par->edid, i);
>> -             if (!err)
>> +             if (!err) {
>> +                     pr_info("i810fb_init_pci: DDC probe successful\n");
>>                       break;
>> +             }
>>       }
>>
>> -     if (!err)
>> -             printk("i810fb_init_pci: DDC probe successful\n");
>> -
>>       fb_edid_to_monspecs(par->edid, specs);
>>
>>       if (specs->modedb == NULL)
>>
>
> I don't know... I think I personally like more the original version. In
> fact, the whole print looks quite useless to me, or at least it should
> be a debug print.
Yes. this patch doesn't need.

Thanks for review.

regards,
Daeseok Youn.
>
>  Tomi
>
>
