Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965517Ab3GLVoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 17:44:20 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:58546 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964787Ab3GLVoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 17:44:18 -0400
Message-ID: <51E078AD.1050508@cogentembedded.com>
Date: Sat, 13 Jul 2013 01:44:13 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Yuan-Hsin Chen <yhchen@faraday-tech.com>, Felipe Balbi <balbi@ti.com>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: fotg210-udc: Remove bogus __init/__exit
 annotations
References: <1373492716-14684-1-git-send-email-geert@linux-m68k.org> <51DDD792.7000300@cogentembedded.com> <CAMuHMdUxfaXV=npJCn90CGSFpdcPkmWGxbX+ej9NFKSWuKgGRA@mail.gmail.com>
In-Reply-To: <CAMuHMdUxfaXV=npJCn90CGSFpdcPkmWGxbX+ej9NFKSWuKgGRA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/11/2013 11:25 AM, Geert Uytterhoeven wrote:

>>> When builtin (CONFIG_USB_FOTG210_UDC=y):

>>>     LD      drivers/usb/gadget/built-in.o
>>> WARNING: drivers/usb/gadget/built-in.o(.data+0xbf8): Section mismatch in
>>> reference from the variable fotg210_driver to the function
>>> .init.text:fotg210_udc_probe()
>>> The variable fotg210_driver references
>>> the function __init fotg210_udc_probe()
>>> If the reference is valid then annotate the
>>> variable with __init* or __refdata (see linux/init.h) or name the
>>> variable:
>>> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

>>> diff --git a/drivers/usb/gadget/fotg210-udc.c
>>> b/drivers/usb/gadget/fotg210-udc.c
>>> index cce5535..10cd18d 100644
>>> --- a/drivers/usb/gadget/fotg210-udc.c
>>> +++ b/drivers/usb/gadget/fotg210-udc.c
>>> @@ -1074,7 +1074,7 @@ static struct usb_gadget_ops fotg210_gadget_ops = {
>>>          .udc_stop               = fotg210_udc_stop,
>>>    };
>>>
>>> -static int __exit fotg210_udc_remove(struct platform_device *pdev)
>>> +static int fotg210_udc_remove(struct platform_device *pdev)

>>     I think you can leave __exit annotation here, if you enclose the
>> reference in the driver structure in __exit_p()...

> The driver is using module_platform_driver(), not
> module_platform_driver_probe(),
> so it expects the platform device to show up or disappear anytime.

    Well, I don't think it actually does. Perhaps the reason was that 
the latter function wasn't available yet at the time of conversion to 
the former (IIRC it appeared later).

WBR, Sergei

