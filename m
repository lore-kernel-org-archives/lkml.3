Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab3KTT7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 14:59:47 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:49536 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab3KTT7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 14:59:43 -0500
MIME-Version: 1.0
In-Reply-To: <20130917183628.857145384@linutronix.de>
References: <20130917082838.218329307@infradead.org>
	<20130917182350.449685712@linutronix.de>
	<20130917183628.857145384@linutronix.de>
Date: Wed, 20 Nov 2013 11:59:42 -0800
Message-ID: <CA+8MBbKq1idWt1OSpRM3mWMDAQaEoewrU=h=m_pFoidVy6OA-Q@mail.gmail.com>
Subject: Re: [patch 4/6] ia64: Use preempt_schedule_irq
From: Tony Luck <tony.luck@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 11:53 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Use the proper core function instead of fiddling with PREEMPT_ACTIVE
> and enable/disable interrupts in the low level code.
>
> Index: linux-2.6/arch/ia64/kernel/entry.S
> ===================================================================
> --- linux-2.6.orig/arch/ia64/kernel/entry.S
> +++ linux-2.6/arch/ia64/kernel/entry.S
...
> -       br.call.spnt.many rp=schedule
> +       br.call.spnt.many rp=preempt_schedule_irq

This just hit mainline ... and I'm getting

arch/ia64/kernel/built-in.o: In function `skip_rbs_switch':
(.text+0xef2): undefined reference to `preempt_schedule_irq'
make: *** [vmlinux] Error 1

Probably because I have CONFIG_PREEMPT=n, and there seems only
to be a definition for this function in kernel/sched/core.c when it is =y.

Do we need a stub for the =n case:

asmlinkage void __sched preempt_schedule_irq(void)
{
           schedule();
}

Or is life more complicated than that?

-Tony
