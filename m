Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaKCWhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 17:37:33 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:46356 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbaKCWha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 17:37:30 -0500
MIME-Version: 1.0
In-Reply-To: <20141103215837.GB8711@redhat.com>
References: <bf6fb790787eb95b922157838f52712c25dda157.1412187233.git.luto@amacapital.net>
 <tip-2c7577a7583747c9b71f26dced7f696b739da745@git.kernel.org>
 <CALCETrWM2wVynp1rrip9AWtNYDzjC4M8JqKR82ew5dpyrTWMgA@mail.gmail.com>
 <20141103214712.GA8711@redhat.com> <20141103215837.GB8711@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 3 Nov 2014 14:37:07 -0800
Message-ID: <CALCETrUMLaz_McO=f-v6JmPY7pJSU4M4g1+p1un1UiVcNf+4XQ@mail.gmail.com>
Subject: Re: [tip:x86/asm] sched/x86_64: Don't save flags on context switch
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jan Beulich <jbeulich@suse.com>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sebastian Lackner <sebastian@fds-team.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>, Anish Bhatt <anish@chelsio.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 1:58 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 11/03, Oleg Nesterov wrote:
>>
>> On 11/03, Andy Lutomirski wrote:
>> >
>> > And do we ever have TF set during a context switch?  I hope not.
>>
>> I too hope.
>>
>> > Also, what's with 'jmp exit_intr' at the end of retint_kernel?  Why
>> > isn't that 'jmp retint_kernel'?
>>
>> Even better, why not "jmp retint_restore_args" ?
>>
>> preempt_schedule_irq() checks need_resched() and returns with irqs
>> disabled, not need to to recheck test_preempt_need_resched() ?

Seems reasonable to me.  Want to write the patch?

>
> Btw, why retint_kernel() checks "interrupts on" ? It seems to me that
> that "interrupts off" is not possible, no? And this will be more clear
> when we remove the "exit_intr" label.

We might get there from #MC or from any of a number of synchronous
errors (#GP from xyz_safe, #PF from some atomic uaccess thing or a
vmap fault, etc), and all of those have interrupts off.

--Andy

>
> Oleg.
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
