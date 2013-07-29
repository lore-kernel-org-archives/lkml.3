Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484Ab3G2Rvf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 13:51:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:48358 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab3G2Rve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 13:51:34 -0400
Message-ID: <51F6ABA2.7060102@linutronix.de>
Date: Mon, 29 Jul 2013 19:51:30 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Bin Liu <binmlist@gmail.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com
Subject: Re: [PATCH 14/16] usb: musb: dsps: add MUSB_DEVCTL_SESSION back after
 removal
References: <CADYTM3ZfvDDKY6NyAv9xGSZ0angGYVOGf8uUDR2vU1jDwCGmzA@mail.gmail.com> <20130726163101.GB29819@linutronix.de> <CADYTM3bfkxEYgvk5v_0=BJFMb8izULpgc1uZVPDPnSs29UpYeA@mail.gmail.com> <CADYTM3b7-WHA73qMypUSd8VcTWuvooap_Ki65BcoJ7qKhejXZw@mail.gmail.com> <51F2BE6F.3010008@linutronix.de> <CADYTM3Y5p-ysgbcL4qZMWLiRVbcPgNQgtydpdhYQJLtd+r1hfw@mail.gmail.com> <51F2D427.7050106@linutronix.de> <CADYTM3ZAsBuFi2guX-j+0f837Uy4EkZ0_QEhKV+WWUOsaDfaDQ@mail.gmail.com> <51F2DD90.2030405@linutronix.de> <CADYTM3Y18yo7S6=k6rgFgpPdbZSH4-92q2FmEnWgjxmQ5g2jbA@mail.gmail.com> <20130729165329.GA5773@linutronix.de> <CADYTM3b9MFPM4iDpe3H1uKC1ZCawrQCebqrZikXxS-s9VNDgpw@mail.gmail.com>
In-Reply-To: <CADYTM3b9MFPM4iDpe3H1uKC1ZCawrQCebqrZikXxS-s9VNDgpw@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 07:26 PM, Bin Liu wrote:
> Sebastian,

Hi Bin,

> I did not say AM335xEVM is not able to run OTG mode. The problem is in
> OTG mode the SESSION bit will be cleared once the device is unplugged,
> then there is no way the SESSION bit will come back in the current
> mainline kernel.

Yes, you did.

> 
> The TI 3.2 kernel works around this OTG issue by toggling the SESSION
> bit in b_idle handling in otg_timer(). The workaround makes most users
> happy but it causes VBUS voltage pulsing. That is why I said I don't
> know an ideal solution without a ID pin interrupt support.

Now I understand more pieces of the puzzle. And the missing ID pin
support is Am335x-evm specific since other am335x board may wire up
that pin.
But you say there is no way that the phy or anything else could help to
avoid that pulsing.

> I think you looked at a wrong file, maybe a wrong branch. Please check
> [1], which defines
> 
> 2644          * mode[0:3] = USB0PORT's mode
> 2645          * mode[4:7] = USB1PORT's mode
> 2646          * AM335X beta EVM has USB0 in OTG mode and USB1 in host mode.
> 2647          */
> 2648         .mode           = (MUSB_HOST << 4) | MUSB_OTG,

Oh it is a long way. So looked into the wrong branch.

>> I agree that without that try_idle part things keep working but it
>> seems, that it is also called in the other tree.
>>
> 
> Then because AM335xEVM USB1 port does not call *try_idle() in this 3.2
> kernel, its SESSION bit is always set.
> 
> But I don't have a clear idea how to solve this in the mainline kernel
> since is_otg_enabled() has been cleaned.

So now I think this is a board problem. What about switching port 1
from OTG to HOST only and avoiding kicking the timer in
dsps_musb_try_idle() in such a case? It seems we only need to do this
in OTG mode.

> Regards,
> -Bin.

Sebastian
