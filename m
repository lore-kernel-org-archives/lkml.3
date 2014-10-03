Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231AbaJCX4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:56:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759301AbaJCXzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 19:55:16 -0400
Date: Sat, 4 Oct 2014 01:51:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [tip:x86/asm] x86: Speed up ___preempt_schedule*() by using
	THUNK helpers
Message-ID: <20141003235145.GA4548@redhat.com>
References: <20140921184153.GA23727@redhat.com> <tip-0ad6e3c5199be12c9745da8f8b9e3c9f8066c235@git.kernel.org> <542E2B05.5080607@oracle.com> <20141003083954.10a13a24@as> <20141003214124.GA31614@redhat.com> <CALCETrVVeuVc7JC7w3Z_2pCx0y_HAFtm4=FmEp_xNkn3tvnR+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVVeuVc7JC7w3Z_2pCx0y_HAFtm4=FmEp_xNkn3tvnR+A@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03, Andy Lutomirski wrote:
>
> Is this thing missing a flags or cc clobber:
>
> # define __preempt_schedule() asm ("call ___preempt_schedule")

Well, calling.h says "rflags is clobbered", so probably yes?


> Also, I'm at a loss as to wtf all this code is doing.
>
> There's preempt_schedule, which appears to be a normal C function.
>
> There's ___preempt_schedule, which is written in assembly and calls
> preempt_schedule.
>
> Then there's __preempt_schedule, which is an inline assembler function
> that calls ___preempt_schedule.
>
> Is this all just to make the call sequence for preempt_schedule shorter?

Yes, please look at 1a338ac32ca630f67df25b4a16436cccc314e997

    sched, x86: Optimize the preempt_schedule() call

    Remove the bloat of the C calling convention out of the
    preempt_enable() sites by creating an ASM wrapper which allows us to
    do an asm("call ___preempt_schedule") instead.

Oleg.

