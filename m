Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab3BUQNW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 11:13:22 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:43148 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab3BUQNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 11:13:20 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1302210013070.22263@ionos>
References: <1361373336-11337-1-git-send-email-fweisbec@gmail.com>
	<alpine.LFD.2.02.1302202155320.22263@ionos>
	<CAFTL4hx_uXfY=bH9nnEsN6AJFTcwqdAWTxcR0jc=hL1FBrwk0w@mail.gmail.com>
	<alpine.LFD.2.02.1302210013070.22263@ionos>
Date: Thu, 21 Feb 2013 17:13:18 +0100
Message-ID: <CAFTL4hz7xmi910Gv0uXAM2AReC4iZzAo3gfMtPk1Yh6wRi1OOg@mail.gmail.com>
Subject: Re: [PATCH] nohz: Make tick_nohz_irq_exit() irq safe
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/21 Thomas Gleixner <tglx@linutronix.de>:
> On Wed, 20 Feb 2013, Frederic Weisbecker wrote:
>> 2013/2/20 Thomas Gleixner <tglx@linutronix.de>:
>> > That's not a fix. That's an hack.
>>
>> I know it looks that way. That's because it's a pure regression fix,
>> minimal for backportability.
>>
>> I'm distinguishing two different things here: the fact that some archs
>> can call irq_exit() with interrupts enabled which is a global design
>> problem, and the fact that tick_nohz_irq_exit() was safe against that
>> until 3.2 when I broke it with a commit of mine.
>>
>> My goal was basically to restore that protection in a minimal commit
>> such that we can backport the regression fix, then deal with
>> __ARCH_IRQ_EXIT_IRQS_DISABLED afterward, since it requires some more
>> invasive changes.
>>
>> >> A saner long term solution will be to remove
>> >> __ARCH_IRQ_EXIT_IRQS_DISABLED.
>> >
>> > We really want to enforce that interrupt disabled condition for
>> > calling irq_exit(). So why make this exclusive to tick_nohz_irq_exit()?
>>
>> I need a fix that I can backport. Is the below fine with a stable tag?
>> It looks a bit too invasive for the single regression involved.
>
> I think that's fine as it's obviously correct and not diluting the
> real underlying issue of the __ARCH_IRQ_EXIT_IRQS_DISABLED insanity.

Ok fine. Do you plan to commit your proposed change then?
