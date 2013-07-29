Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab3G2Slm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:41:42 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:52741 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab3G2Slj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:41:39 -0400
MIME-Version: 1.0
In-Reply-To: <51F6ABA2.7060102@linutronix.de>
References: <CADYTM3ZfvDDKY6NyAv9xGSZ0angGYVOGf8uUDR2vU1jDwCGmzA@mail.gmail.com>
	<20130726163101.GB29819@linutronix.de>
	<CADYTM3bfkxEYgvk5v_0=BJFMb8izULpgc1uZVPDPnSs29UpYeA@mail.gmail.com>
	<CADYTM3b7-WHA73qMypUSd8VcTWuvooap_Ki65BcoJ7qKhejXZw@mail.gmail.com>
	<51F2BE6F.3010008@linutronix.de>
	<CADYTM3Y5p-ysgbcL4qZMWLiRVbcPgNQgtydpdhYQJLtd+r1hfw@mail.gmail.com>
	<51F2D427.7050106@linutronix.de>
	<CADYTM3ZAsBuFi2guX-j+0f837Uy4EkZ0_QEhKV+WWUOsaDfaDQ@mail.gmail.com>
	<51F2DD90.2030405@linutronix.de>
	<CADYTM3Y18yo7S6=k6rgFgpPdbZSH4-92q2FmEnWgjxmQ5g2jbA@mail.gmail.com>
	<20130729165329.GA5773@linutronix.de>
	<CADYTM3b9MFPM4iDpe3H1uKC1ZCawrQCebqrZikXxS-s9VNDgpw@mail.gmail.com>
	<51F6ABA2.7060102@linutronix.de>
Date: Mon, 29 Jul 2013 13:41:38 -0500
Message-ID: <CADYTM3bcCoWKE9eR5Sd9MbaEUr4G=k=r6JKR+8KC=W_YrbMs3g@mail.gmail.com>
Subject: Re: [PATCH 14/16] usb: musb: dsps: add MUSB_DEVCTL_SESSION back after removal
From: Bin Liu <binmlist@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian,

On Mon, Jul 29, 2013 at 12:51 PM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> On 07/29/2013 07:26 PM, Bin Liu wrote:
>> Sebastian,
>
> Hi Bin,
>
>> I did not say AM335xEVM is not able to run OTG mode. The problem is in
>> OTG mode the SESSION bit will be cleared once the device is unplugged,
>> then there is no way the SESSION bit will come back in the current
>> mainline kernel.
>
> Yes, you did.

If I did, that was wrong statement.

>
>>
>> The TI 3.2 kernel works around this OTG issue by toggling the SESSION
>> bit in b_idle handling in otg_timer(). The workaround makes most users
>> happy but it causes VBUS voltage pulsing. That is why I said I don't
>> know an ideal solution without a ID pin interrupt support.
>
> Now I understand more pieces of the puzzle. And the missing ID pin
> support is Am335x-evm specific since other am335x board may wire up
> that pin.

No, it is not board wiring issue. The AM335x EVM DOES have ID pin
wired to the ID pin of the micro-AB receptacle. I said AM335x does not
have IP pin INTERRUPT support, by which the kernel does not know when
a device is plugged in without setting the SESSION bit.

> But you say there is no way that the phy or anything else could help to
> avoid that pulsing.
>
>> I think you looked at a wrong file, maybe a wrong branch. Please check
>> [1], which defines
>>
>> 2644          * mode[0:3] = USB0PORT's mode
>> 2645          * mode[4:7] = USB1PORT's mode
>> 2646          * AM335X beta EVM has USB0 in OTG mode and USB1 in host mode.
>> 2647          */
>> 2648         .mode           = (MUSB_HOST << 4) | MUSB_OTG,
>
> Oh it is a long way. So looked into the wrong branch.
>
>>> I agree that without that try_idle part things keep working but it
>>> seems, that it is also called in the other tree.
>>>
>>
>> Then because AM335xEVM USB1 port does not call *try_idle() in this 3.2
>> kernel, its SESSION bit is always set.
>>
>> But I don't have a clear idea how to solve this in the mainline kernel
>> since is_otg_enabled() has been cleaned.
>
> So now I think this is a board problem. What about switching port 1
> from OTG to HOST only and avoiding kicking the timer in
> dsps_musb_try_idle() in such a case? It seems we only need to do this
> in OTG mode.

I have not read the MUSB driver in the mainline kernel yet. If somehow
port 1 can could be set to HOST mode then the SESSION bit would stay,
then that should solve the issue.

>
>> Regards,
>> -Bin.
>
> Sebastian
