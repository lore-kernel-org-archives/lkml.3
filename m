Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605AbaESTn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:43:26 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:54880 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932494AbaESTnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:43:25 -0400
MIME-Version: 1.0
In-Reply-To: <1400528527.14238.20.camel@joe-AO725>
References: <1400526693-29776-1-git-send-email-ricardo.ribalda@gmail.com>
 <1400526693-29776-6-git-send-email-ricardo.ribalda@gmail.com>
 <1400526979.14238.16.camel@joe-AO725> <CAPybu_0T3GmyTQfPuG3YofkWO_px0fYAyofz2OAab6=9PqsKLQ@mail.gmail.com>
 <1400528527.14238.20.camel@joe-AO725>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 19 May 2014 21:43:04 +0200
Message-ID: <CAPybu_2RA90txoSC6qQZ=3JY8U9UCE_BVZQxfnjEKAEO9imi5w@mail.gmail.com>
Subject: Re: [PATCH 5/5] usb: gadget: net2280: Use pr_* function
To: Joe Perches <joe@perches.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Amit Uttamchandani <auttamchandani@logicube.com>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Joe


OK, then I will use dev_vdbg. Thanks!



On Mon, May 19, 2014 at 9:42 PM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2014-05-19 at 21:33 +0200, Ricardo Ribalda Delgado wrote:
>> I think dev_vdg cannot be controlled with DYNAMIC_DEBUG, therefore I
>> replaced it with dev_dbg.
>>
>> But if you prefer to use dev_dbg, I will modify it to use dev_dbg
>
> s/VDEBUG/dev_vdbg/
>
> dev_vdbg can be controlled by DYNAMIC_DEBUG.
>
> dev_vdbg is dev_dbg when VERBOSE_DEBUG is set.
>
> include/linux/device.h-#ifdef VERBOSE_DEBUG
> include/linux/device.h:#define dev_vdbg dev_dbg
> include/linux/device.h-#else
> include/linux/device.h:#define dev_vdbg(dev, format, arg...)                            \
> include/linux/device.h-({                                                               \
> include/linux/device.h- if (0)                                                  \
> include/linux/device.h-         dev_printk(KERN_DEBUG, dev, format, ##arg);     \
> include/linux/device.h- 0;                                                      \
> include/linux/device.h-})
>
>



-- 
Ricardo Ribalda
