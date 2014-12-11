Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964901AbaLKPTr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 10:19:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964785AbaLKPTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 10:19:45 -0500
Date: Thu, 11 Dec 2014 10:19:33 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Peter Wu <peter@lekensteyn.nl>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew de los Reyes <adlr@chromium.org>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: About "HID: logitech-hidpp: add support of the first Logitech
 Wireless Touchpad"
Message-ID: <20141211151933.GB29747@mail.corp.redhat.com>
References: <1659058.m7A8Z3l7lH@al>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1659058.m7A8Z3l7lH@al>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Dec 11 2014 or thereabouts, Peter Wu wrote:
> Hi Benjamin,
> 
> In commit 57ac86cf52e903d9e3e0f12b34c814cce6b65550 ("HID:
> logitech-hidpp: add support of the first Logitech Wireless Touchpad")
> which is in jikos/hid, you made this change to wtp_raw_event:
> 
>         switch (data[0]) {
>         case 0x02:
> -               if (size < 21)
> -                       return 1;
> -               return wtp_mouse_raw_xy_event(hidpp, &data[7]);
> +               if (hidpp->quirks & HIDPP_QUIRK_WTP_PHYSICAL_BUTTONS) {
> +                       input_event(wd->input, EV_KEY, BTN_LEFT,
> +                                       !!(data[1] & 0x01));
> +                       input_event(wd->input, EV_KEY, BTN_RIGHT,
> +                                       !!(data[1] & 0x02));
> +                       input_sync(wd->input);
> +               } else {
> +                       if (size < 21)
> +                               return 1;
> +                       return wtp_mouse_raw_xy_event(hidpp, &data[7]);
> +               }
>         case REPORT_ID_HIDPP_LONG:
>                 if ((report->fap.feature_index != wd->mt_feature_index) ||
>                     (report->fap.funcindex_clientid != EVENT_TOUCHPAD_RAW_XY))
>                         return 1;
>                 hidpp_touchpad_raw_xy_event(hidpp, data + 4, &raw);
>  
>                 wtp_send_raw_xy_event(hidpp, &raw);
>                 return 0;
>         }
> 
> Report ID 2 is the mouse descriptor, so it seems correct in that it
> falls-through to the next case, but I wanted to check with you that this
> is indeed your intention. If so, could you explicitly mark it with a
> comment, /* fallthrough */ ?

Yep, it is indeed a bug. I see what happened:
The old code contained a return at the end of the case, and I completely
forget to prevent the fall through with a break. Gosh, I should have
been more careful. Thanks for spotting that!

Cheers,
Benjamin

> -- 
> Kind regards,
> Peter
> https://lekensteyn.nl
> 
