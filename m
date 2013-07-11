Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab3GKHZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 03:25:48 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:53803 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727Ab3GKHZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 03:25:18 -0400
MIME-Version: 1.0
In-Reply-To: <51DDD792.7000300@cogentembedded.com>
References: <1373492716-14684-1-git-send-email-geert@linux-m68k.org>
	<51DDD792.7000300@cogentembedded.com>
Date: Thu, 11 Jul 2013 09:25:15 +0200
X-Google-Sender-Auth: h4d1F6lw1u34Z2pqWeupgh3YQ2E
Message-ID: <CAMuHMdUxfaXV=npJCn90CGSFpdcPkmWGxbX+ej9NFKSWuKgGRA@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: fotg210-udc: Remove bogus __init/__exit annotations
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Yuan-Hsin Chen <yhchen@faraday-tech.com>, Felipe Balbi <balbi@ti.com>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 11:52 PM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> On 07/11/2013 01:45 AM, Geert Uytterhoeven wrote:
>
>> When builtin (CONFIG_USB_FOTG210_UDC=y):
>
>>    LD      drivers/usb/gadget/built-in.o
>> WARNING: drivers/usb/gadget/built-in.o(.data+0xbf8): Section mismatch in
>> reference from the variable fotg210_driver to the function
>> .init.text:fotg210_udc_probe()
>> The variable fotg210_driver references
>> the function __init fotg210_udc_probe()
>> If the reference is valid then annotate the
>> variable with __init* or __refdata (see linux/init.h) or name the
>> variable:
>> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

>> diff --git a/drivers/usb/gadget/fotg210-udc.c
>> b/drivers/usb/gadget/fotg210-udc.c
>> index cce5535..10cd18d 100644
>> --- a/drivers/usb/gadget/fotg210-udc.c
>> +++ b/drivers/usb/gadget/fotg210-udc.c
>> @@ -1074,7 +1074,7 @@ static struct usb_gadget_ops fotg210_gadget_ops = {
>>         .udc_stop               = fotg210_udc_stop,
>>   };
>>
>> -static int __exit fotg210_udc_remove(struct platform_device *pdev)
>> +static int fotg210_udc_remove(struct platform_device *pdev)
>
>
>    I think you can leave __exit annotation here, if you enclose the
> reference in the driver structure in __exit_p()...

The driver is using module_platform_driver(), not
module_platform_driver_probe(),
so it expects the platform device to show up or disappear anytime.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
