Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759876AbaJCXOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:14:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42087 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759858AbaJCXOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 19:14:44 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CALCETrVw69Q+=BTQhPshmMj7Cs9Y=6Aei=RDz3U9-me1BzYx3Q@mail.gmail.com>
References: <20140921184153.GA23727@redhat.com> <tip-0ad6e3c5199be12c9745da8f8b9e3c9f8066c235@git.kernel.org> <542E2B05.5080607@oracle.com> <20141003083954.10a13a24@as> <20141003214124.GA31614@redhat.com> <20141003174814.6829cf26@as> <CALCETrVw69Q+=BTQhPshmMj7Cs9Y=6Aei=RDz3U9-me1BzYx3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [tip:x86/asm] x86: Speed up ___preempt_schedule*() by using THUNK helpers
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 03 Oct 2014 16:13:38 -0700
To: Andy Lutomirski <luto@amacapital.net>,
        Chuck Ebbert <cebbert.lkml@gmail.com>
CC: Oleg Nesterov <oleg@redhat.com>, Sasha Levin <sasha.levin@oracle.com>,
        Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Message-ID: <4F1460E2-2B1B-4587-8ACF-6709C63D1FC6@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, it is.

On October 3, 2014 3:53:08 PM PDT, Andy Lutomirski <luto@amacapital.net> wrote:
>On Fri, Oct 3, 2014 at 3:48 PM, Chuck Ebbert <cebbert.lkml@gmail.com>
>wrote:
>> On Fri, 3 Oct 2014 23:41:24 +0200
>> Oleg Nesterov <oleg@redhat.com> wrote:
>>
>>> On 10/03, Chuck Ebbert wrote:
>>> >
>>> > > [  921.917752] ? ___preempt_schedule_context
>(arch/x86/lib/thunk_64.S:44)
>>> > > [  921.917752] ? preempt_schedule_context
>(kernel/context_tracking.c:145)
>>> > > [  921.917752] ? ___preempt_schedule_context
>(arch/x86/lib/thunk_64.S:44)
>>> > > [  921.917752] ? preempt_schedule_context
>(kernel/context_tracking.c:145)
>>> > > [  921.917752] ? ___preempt_schedule_context
>(arch/x86/lib/thunk_64.S:44)
>>> > > [  921.917752] ? preempt_schedule_context
>(kernel/context_tracking.c:145)
>>> > > [  921.917752] ? ___preempt_schedule_context
>(arch/x86/lib/thunk_64.S:44)
>>> > > [  921.917752] ? preempt_schedule_context
>(kernel/context_tracking.c:145)
>>> > > [  921.917752] ? ___preempt_schedule_context
>(arch/x86/lib/thunk_64.S:44)
>>> > > [  921.917752] ? preempt_schedule_context
>(kernel/context_tracking.c:145)
>>> >
>>> > <snip lots of repeats of this>
>>> >
>>> > I *think* this is because RBP isn't being saved across task switch
>>> > anymore?
>>> >
>>> > Without CONFIG_FRAME_POINTERS that night not be a problem...
>>>
>>> Could you please spell?
>>>
>>> I don't even understand "RBP isn't being saved",
>SAVE_CONTEXT/RESTORE_CONTEXT
>>> do push/pop %rbp?
>>>
>>
>> SAVE_ARGS/RESTORE_ARGS, which is what THUNK uses, doesn't push/pop
>%rbp
>>
>> Before, SAVE_ALL/RESTORE_ALL were being used around the call to
>> preempt_schedule(). So from the symptoms I thought this was the
>problem.
>
>rbp is callee-saved no matter what, unless my memory of the ABI is
>*waaaaay* off.
>
>--Andy

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
