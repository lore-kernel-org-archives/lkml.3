Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200Ab3HMNdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:33:40 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:60606 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758085Ab3HMNdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:33:36 -0400
MIME-Version: 1.0
In-Reply-To: <520A3206.5080505@linutronix.de>
References: <51F2BE6F.3010008@linutronix.de>
	<CADYTM3Y5p-ysgbcL4qZMWLiRVbcPgNQgtydpdhYQJLtd+r1hfw@mail.gmail.com>
	<51F2D427.7050106@linutronix.de>
	<CADYTM3ZAsBuFi2guX-j+0f837Uy4EkZ0_QEhKV+WWUOsaDfaDQ@mail.gmail.com>
	<51F2DD90.2030405@linutronix.de>
	<CADYTM3Y18yo7S6=k6rgFgpPdbZSH4-92q2FmEnWgjxmQ5g2jbA@mail.gmail.com>
	<20130729165329.GA5773@linutronix.de>
	<CADYTM3b9MFPM4iDpe3H1uKC1ZCawrQCebqrZikXxS-s9VNDgpw@mail.gmail.com>
	<51F6ABA2.7060102@linutronix.de>
	<CADYTM3bcCoWKE9eR5Sd9MbaEUr4G=k=r6JKR+8KC=W_YrbMs3g@mail.gmail.com>
	<20130809160339.GA14829@linutronix.de>
	<5205516D.1030707@cogentembedded.com>
	<5209DCB9.8020705@linutronix.de>
	<CADYTM3a2M-X=eqz0LmSq4T9UF9khsTGB5TTYWWMRZWwkpRuRTQ@mail.gmail.com>
	<520A3206.5080505@linutronix.de>
Date: Tue, 13 Aug 2013 08:33:34 -0500
Message-ID: <CADYTM3YU=xt-YDaoOqothjAv_rdnzRmop10Rf7PSA7POaE5DBQ@mail.gmail.com>
Subject: Re: [PATCH] usb: musb: am335x: Do not remove the session bin
 HOST-only mode
From: Bin Liu <binmlist@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian,

On Tue, Aug 13, 2013 at 8:17 AM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> On 08/13/2013 03:03 PM, Bin Liu wrote:
>> Sebastian,
>
> Hi Bin,
>
>>>>> +    if (musb->port_mode == MUSB_PORT_MODE_HOST) {
>>>>> +        val = USBMODE_IDDIG_A;
>>>>> +        val |= USBMODE_ID_MUX_REG;
>>>>
>> I am going to so some tests today for this. I don't object to use the
>> mode register, but am wondering why we have to play with it for
>> host-only mode. The ID pin is grounded for host-only mode, which
>> should cause the same as setting mode register.
>
> I've been looking at the wiki page and it did not mention the ID pin
> for the second port. If it is grounded then this piece can be removed
I thought you have already tried that without setting the mode
register the session bit cannot stay set.
I am not sure if anywhere mentioned about the ID pin, but ASAIK all
the different boards using am335x have ID pin grounded for host port.

> and the magic trick is just to skip the try_idle() call.
Agreed.

>
> I haven't found anything saying that it is required to clear the
> session bin in host mode, only in OTG. And then, I would assume to
Agreed.

> receive a session interrupt once we have the proper VBUS level which
> does not happen.
The TI 3.2 kernel for am335x sets the session bit in musb_start() for
host-only mode. Maybe we can do something similar in here? (I noticed
mush_start() has gone in mainline, but have not got a chance to check
the details...)

>
>> -Bin.
>
> Sebastian
