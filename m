Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbaJCV5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:57:49 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:60971 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390AbaJCV5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:57:18 -0400
MIME-Version: 1.0
In-Reply-To: <20141003214124.GA31614@redhat.com>
References: <20140921184153.GA23727@redhat.com> <tip-0ad6e3c5199be12c9745da8f8b9e3c9f8066c235@git.kernel.org>
 <542E2B05.5080607@oracle.com> <20141003083954.10a13a24@as> <20141003214124.GA31614@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 3 Oct 2014 14:56:56 -0700
Message-ID: <CALCETrVVeuVc7JC7w3Z_2pCx0y_HAFtm4=FmEp_xNkn3tvnR+A@mail.gmail.com>
Subject: Re: [tip:x86/asm] x86: Speed up ___preempt_schedule*() by using THUNK helpers
To: Oleg Nesterov <oleg@redhat.com>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 3, 2014 at 2:41 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 10/03, Chuck Ebbert wrote:
>>
>> > [  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
>> > [  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
>> > [  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
>> > [  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
>> > [  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
>> > [  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
>> > [  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
>> > [  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
>> > [  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
>> > [  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
>>
>> <snip lots of repeats of this>
>>
>> I *think* this is because RBP isn't being saved across task switch
>> anymore?
>>
>> Without CONFIG_FRAME_POINTERS that night not be a problem...
>
> Could you please spell?
>
> I don't even understand "RBP isn't being saved", SAVE_CONTEXT/RESTORE_CONTEXT
> do push/pop %rbp?
>

Is this thing missing a flags or cc clobber:

# define __preempt_schedule() asm ("call ___preempt_schedule")

Also, I'm at a loss as to wtf all this code is doing.

There's preempt_schedule, which appears to be a normal C function.

There's ___preempt_schedule, which is written in assembly and calls
preempt_schedule.

Then there's __preempt_schedule, which is an inline assembler function
that calls ___preempt_schedule.

Is this all just to make the call sequence for preempt_schedule shorter?

--Andy


> Thanks,
>
> Oleg.
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
