Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932898AbaESUEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:04:13 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:46019 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbaESUEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:04:09 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1405191543070.1538-100000@iolanthe.rowland.org>
References: <1400526693-29776-6-git-send-email-ricardo.ribalda@gmail.com> <Pine.LNX.4.44L0.1405191543070.1538-100000@iolanthe.rowland.org>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 19 May 2014 22:03:48 +0200
Message-ID: <CAPybu_1LLg4LEPdS2iN0qY=AYJmCiJOr6EhpR9Kn0Rn2H2dpOg@mail.gmail.com>
Subject: Re: [PATCH 5/5] usb: gadget: net2280: Use pr_* function
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "balbi@ti.com" <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Joe Perches <joe@perches.com>,
        Amit Uttamchandani <auttamchandani@logicube.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alan

I really think that setting/unsetting DEBUG and VERBOSE is not a good
idea, and the generic functions are there to be used.

What do you think that makes it more difficult to read? The GETDEV macro?

Cheers

On Mon, May 19, 2014 at 9:44 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 19 May 2014, Ricardo Ribalda Delgado wrote:
>
>> Driver was using custom functions WARNING, ERROR, DEBUG, instead of
>>  pr_err, pr_dgb...
>
> What's wrong with that, and why bother to change it?
>
>> diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
>> index e67ae96..11800bb 100644
>> --- a/drivers/usb/gadget/net2280.c
>> +++ b/drivers/usb/gadget/net2280.c
>> @@ -210,7 +210,7 @@ static int net2280_enable(struct usb_ep *_ep,
>>        * use it instead of troublesome (non-bulk) multi-packet DMA.
>>        */
>>       if (ep->dma && (max % 4) != 0 && use_dma_chaining) {
>> -             DEBUG(ep->dev, "%s, no dma for maxpacket %d\n",
>> +             dev_dbg(GETDEV(ep->dev), "%s, no dma for maxpacket %d\n",
>
> Don't you think that the new code is harder to read than the original?
> Why go to a lot of trouble just to make things worse?
>
> Alan Stern
>



-- 
Ricardo Ribalda
