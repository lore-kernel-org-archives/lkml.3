Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbaETOiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:38:23 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39151 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaETOiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:38:22 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1405201020060.1176-100000@iolanthe.rowland.org>
References: <1400534436-10913-3-git-send-email-ricardo.ribalda@gmail.com> <Pine.LNX.4.44L0.1405201020060.1176-100000@iolanthe.rowland.org>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 20 May 2014 16:38:01 +0200
Message-ID: <CAPybu_2KztdWmExKXO8uEebpQPouN7wqQww5ZzknmC5-hXvDJA@mail.gmail.com>
Subject: Re: [PATCH 2/9] usb: gadget: net2280: Dont use magic numbers
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

In this case, there are only two family of devices supported by the
driver. Maybe quirks are too much.

At the end:

ep->dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY

is not much bigger than

ep->dev->quirk_flag & PLX_NET2280_QUIRK

But if you prefer the quirk I dont mind implementing it, but please as
a follow-up patch, since there are 8 patches depending on this :)

Regards!


On Tue, May 20, 2014 at 4:21 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 19 May 2014, Ricardo Ribalda Delgado wrote:
>
>> Instead of using magic numbers use #defines
>>
>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>> ---
>>  drivers/usb/gadget/net2280.c | 68 +++++++++++++++++++++++---------------------
>>  drivers/usb/gadget/net2280.h |  1 +
>>  2 files changed, 36 insertions(+), 33 deletions(-)
>>
>> diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
>> index 8112d91..ba1fdd8 100644
>> --- a/drivers/usb/gadget/net2280.c
>> +++ b/drivers/usb/gadget/net2280.c
>> @@ -152,7 +152,7 @@ static inline void enable_pciirqenb(struct net2280_ep *ep)
>>  {
>>       u32 tmp = readl(&ep->dev->regs->pciirqenb0);
>>
>> -     if (ep->dev->pdev->vendor == 0x17cc)
>> +     if (ep->dev->pdev->vendor == PCI_VENDOR_ID_PLX_LEGACY)
>
> You ought to be able to make this considerably smaller by using a
> quirk flag in ep->dev.  The flag can indicate whether or not the
> controller uses the LEGACY interface.
>
> Alan Stern
>



-- 
Ricardo Ribalda
