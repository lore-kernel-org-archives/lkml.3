Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbaJPQgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 12:36:37 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:40531 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaJPQgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 12:36:36 -0400
MIME-Version: 1.0
In-Reply-To: <543F9182.9000004@gaast.net>
References: <54347520.3050109@gaast.net>
	<543AA2FE.20105@gaast.net>
	<20141012204032.GA11171@amd>
	<9751497.0fL0kvsyX7@vostro.rjw.lan>
	<20141015111641.GC7792@gaast.net>
	<CAErSpo5A+nHTu2Y6KrXowBBCBsNw_hO0SRsnc6YRdJChCUmO6w@mail.gmail.com>
	<CAE9FiQV9t0bCfUy5Fichdk=04ruEVxGv-LUK1xxZjCrasAOACg@mail.gmail.com>
	<543F049F.5090605@gaast.net>
	<CAE9FiQWDHq5esSt4UvE5AkHR-=XMvrzaNFwLg+0xKisTNOtcsQ@mail.gmail.com>
	<543F9182.9000004@gaast.net>
Date: Thu, 16 Oct 2014 09:36:35 -0700
X-Google-Sender-Auth: pLNbqEE7oB_eKoUAdkxwBNrq1Tc
Message-ID: <CAE9FiQVNZHTxpNCnn+YPtqjWrQjFmtTh06sbBawqFonMFwSZ-w@mail.gmail.com>
Subject: Re: Machine crashes right *after* ~successful resume
From: Yinghai Lu <yinghai@kernel.org>
To: Wilmer van der Gaast <wilmer@gaast.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 2:36 AM, Wilmer van der Gaast <wilmer@gaast.net> wrote:
> Hello,
>
> On 16-10-14 05:32, Yinghai Lu wrote:
>>
>>
>> Can you please try attached patch? that should workaround the problem.
>>
> Sadly, no luck. (I do assume you meant me to use the patch against a clean
> 3.17 tree *without* yesterday's revert patch applied.) Back to a crash
> at/after the third resume:
>
> [  372.502897] usb 3-1.1: reset high-speed USB device number 3 using
> ehci-pci
> [  372.678765] usb 2-1.5: reset low-speed USB device number 3 using ehci-pci
> [  373.398437] Clocksource tsc unstable (delta = -136457848 ns)
> [  373.897503] Switched to clocksource hpet
> [  373.897536] PM: resume of devices complete after 2143.535 msecs
> [  373.898225] r8169 0000:07:00.0 eth0: link up
> [  374.319311] Restarting tasks ... done.
> (And then nothing.)
>
> Interestingly I did see the "resume of devices" time grow on each resume
> again this time. I'll put the full dmesg dump in the same place like before:
> http://gaast.net/~wilmer/.lkml/

Checked that dmesg and console output, looks ok from last resume.

Can you put "debug ignore_loglevel" in boot command line?
So we can compare output from serial console between good one and bad
one directly.

Also did you try to remove r8169 every time before suspend?

Thanks

Yinghai
