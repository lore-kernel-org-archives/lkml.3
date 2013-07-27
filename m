Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565Ab3G0DHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 23:07:20 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:42056 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758512Ab3G0DHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 23:07:15 -0400
MIME-Version: 1.0
In-Reply-To: <51F2DD90.2030405@linutronix.de>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
	<1374516607-2705-15-git-send-email-bigeasy@linutronix.de>
	<CADYTM3a5xzs+-VCTeKLGiRjo7JOqOJ5H4EWDACpTMovY5_ooRA@mail.gmail.com>
	<51EEBE05.2040000@linutronix.de>
	<CADYTM3ZfvDDKY6NyAv9xGSZ0angGYVOGf8uUDR2vU1jDwCGmzA@mail.gmail.com>
	<20130726163101.GB29819@linutronix.de>
	<CADYTM3bfkxEYgvk5v_0=BJFMb8izULpgc1uZVPDPnSs29UpYeA@mail.gmail.com>
	<CADYTM3b7-WHA73qMypUSd8VcTWuvooap_Ki65BcoJ7qKhejXZw@mail.gmail.com>
	<51F2BE6F.3010008@linutronix.de>
	<CADYTM3Y5p-ysgbcL4qZMWLiRVbcPgNQgtydpdhYQJLtd+r1hfw@mail.gmail.com>
	<51F2D427.7050106@linutronix.de>
	<CADYTM3ZAsBuFi2guX-j+0f837Uy4EkZ0_QEhKV+WWUOsaDfaDQ@mail.gmail.com>
	<51F2DD90.2030405@linutronix.de>
Date: Fri, 26 Jul 2013 22:07:14 -0500
Message-ID: <CADYTM3Y18yo7S6=k6rgFgpPdbZSH4-92q2FmEnWgjxmQ5g2jbA@mail.gmail.com>
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

On Fri, Jul 26, 2013 at 3:35 PM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>> My build server is down this afternoon. Once it comes back next week,
>> I will try 3.8 again, to see how I can help on this USB1 host mode
>> issue. its devctl register should stay on 0x19 even nothing is
>> connected.
>
> Your help is greatly appreciated. To hear what will happen :)
>
> Sebastian

I have not tested it yet, but I believe I found why host mode works on
TI 3.2 kernel but not on mainline. Please look at Line 786 in 3.2
kernel musb_core.c [1].

773         if ((int_usb & MUSB_INTR_DISCONNECT) && !musb->ignore_disconnect) {
......
785                                 if (musb->a_wait_bcon != 0 &&
786                                                 is_otg_enabled(musb))
787                                         musb_platform_try_idle(musb, jiffies
788                                         +
msecs_to_jiffies(musb->a_wait_bcon));

So when the device is unplugged, *_try_idle() is not called in host
mode, then the SESSION bit will stay set. But in mainline kernel,
*_try_idle() will be called regardless.

Please let me know your thoughts.

Regards,
-Bin.

[1] http://arago-project.org/git/projects/?p=linux-am33x.git;a=blob;f=drivers/usb/musb/musb_core.c;h=075aa5f9bec7cd041aa24eb534209fa756ed84fe;hb=refs/heads/v3.2-staging
