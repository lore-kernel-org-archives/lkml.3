Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486Ab3GZSRD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 14:17:03 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:63280 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab3GZSRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 14:17:00 -0400
MIME-Version: 1.0
In-Reply-To: <CADYTM3bfkxEYgvk5v_0=BJFMb8izULpgc1uZVPDPnSs29UpYeA@mail.gmail.com>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
	<1374516607-2705-15-git-send-email-bigeasy@linutronix.de>
	<CADYTM3a5xzs+-VCTeKLGiRjo7JOqOJ5H4EWDACpTMovY5_ooRA@mail.gmail.com>
	<51EEBE05.2040000@linutronix.de>
	<CADYTM3ZfvDDKY6NyAv9xGSZ0angGYVOGf8uUDR2vU1jDwCGmzA@mail.gmail.com>
	<20130726163101.GB29819@linutronix.de>
	<CADYTM3bfkxEYgvk5v_0=BJFMb8izULpgc1uZVPDPnSs29UpYeA@mail.gmail.com>
Date: Fri, 26 Jul 2013 13:17:00 -0500
Message-ID: <CADYTM3b7-WHA73qMypUSd8VcTWuvooap_Ki65BcoJ7qKhejXZw@mail.gmail.com>
Subject: Re: [PATCH 14/16] usb: musb: dsps: add MUSB_DEVCTL_SESSION back after removal
From: Bin Liu <binmlist@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 12:53 PM, Bin Liu <binmlist@gmail.com> wrote:
> Sebastian,
>
> On Fri, Jul 26, 2013 at 11:31 AM, Sebastian Andrzej Siewior
> <bigeasy@linutronix.de> wrote:
>> * Bin Liu | 2013-07-23 13:55:27 [-0500]:
>>
>>>Hi Sebastian,
>> Hi Bin,
>>
>>>either by SRP or HNP, or something else. In TI 3.2 kernel, there is
>>>workaround in otg_timer() to _toggle_ the SESSION bit to detect if ID
>>>pin is grounded, which means a USB device is connected.
>>
>> I've been looking at
>>   http://downloads.ti.com/sitara_linux/esd/AM335xSDK/latest/index_FDS.html
>>
>> and I can't find what you are talking about. My MUSB_DEVCTL doesn't
>> change after I connect a device and the SESSION bit is not set. Also I
>> remain in a_idle state. Do you have maybe a hint for me? :)
>
> In TI 3.2 kernel, the otg_timer() toggles the SESSION bit in
> OTG_STATE_B_IDLE state. So whenever the ID pin is grounded by
> connecting a device, the controller will try go into host mode.
> But I have no idea why your board is in a_idle not b_idle. The toggle
> does not handle a_idle.
>
> Do you use the AM335x GP EVM, not the smaller StarterKit EVM, right?
> the USB0 port on SK EVM is device only.
>
> But anyway, I have not seen any use case which uses micro-AB
> receptacle and requires such dynamic role switching. So I kind of

I meant the real customer use cases, not the EVMs ;)
