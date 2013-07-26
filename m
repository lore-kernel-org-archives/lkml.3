Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab3GZS32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 14:29:28 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:45792 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab3GZS3Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 14:29:25 -0400
MIME-Version: 1.0
In-Reply-To: <51F2BE6F.3010008@linutronix.de>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
	<1374516607-2705-15-git-send-email-bigeasy@linutronix.de>
	<CADYTM3a5xzs+-VCTeKLGiRjo7JOqOJ5H4EWDACpTMovY5_ooRA@mail.gmail.com>
	<51EEBE05.2040000@linutronix.de>
	<CADYTM3ZfvDDKY6NyAv9xGSZ0angGYVOGf8uUDR2vU1jDwCGmzA@mail.gmail.com>
	<20130726163101.GB29819@linutronix.de>
	<CADYTM3bfkxEYgvk5v_0=BJFMb8izULpgc1uZVPDPnSs29UpYeA@mail.gmail.com>
	<CADYTM3b7-WHA73qMypUSd8VcTWuvooap_Ki65BcoJ7qKhejXZw@mail.gmail.com>
	<51F2BE6F.3010008@linutronix.de>
Date: Fri, 26 Jul 2013 13:29:25 -0500
Message-ID: <CADYTM3Y5p-ysgbcL4qZMWLiRVbcPgNQgtydpdhYQJLtd+r1hfw@mail.gmail.com>
Subject: Re: [PATCH 14/16] usb: musb: dsps: add MUSB_DEVCTL_SESSION back after removal
From: Bin Liu <binmlist@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian,

On Fri, Jul 26, 2013 at 1:22 PM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> On 07/26/2013 08:17 PM, Bin Liu wrote:
>
> Hi Bin.
>
>>> In TI 3.2 kernel, the otg_timer() toggles the SESSION bit in
>>> OTG_STATE_B_IDLE state. So whenever the ID pin is grounded by
>>> connecting a device, the controller will try go into host mode.
>>> But I have no idea why your board is in a_idle not b_idle. The toggle
>>> does not handle a_idle.
>>>
>>> Do you use the AM335x GP EVM, not the smaller StarterKit EVM, right?
>>> the USB0 port on SK EVM is device only.
>>>
>>> But anyway, I have not seen any use case which uses micro-AB
>>> receptacle and requires such dynamic role switching. So I kind of
>>
>> I meant the real customer use cases, not the EVMs ;)
>>
> I am using the about the second port on am335x evm which is used as
> host (not OTG mode (3) but HOST (1)). If I start the timer OTG after
> disconnect I see that it gets back to A mode:
>
> [   97.570852] musb-hdrc musb-hdrc.1.auto: Poll devctl 19 (a_wait_bcon)
I don't think you are testing with the 3.2 kernel you referred from
the ti.com link you mentioned above.
3.2 kernel should have no '.auto' at the end of the device name.

If it is 3.8 or later, it seems the driver does something wrong,
SESSION bit should not be cleared after the device is unplugged.

> [   99.570306] musb-hdrc musb-hdrc.1.auto: Poll devctl 98 (a_idle)
> …
> [  209.570259] musb-hdrc musb-hdrc.1.auto: Poll devctl 80 (a_idle)
>
> and now the session bit is missing and never gets back so I can not
> plug any other device. I really have no idea what is missing here…
>
> Sebastian
