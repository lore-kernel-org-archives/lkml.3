Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaKDXJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 18:09:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037AbaKDXJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 18:09:42 -0500
Date: Wed, 5 Nov 2014 00:09:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jan Beulich <jbeulich@suse.com>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sebastian Lackner <sebastian@fds-team.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>, Anish Bhatt <anish@chelsio.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/asm] sched/x86_64: Don't save flags on context switch
Message-ID: <20141104230941.GA30569@redhat.com>
References: <bf6fb790787eb95b922157838f52712c25dda157.1412187233.git.luto@amacapital.net> <tip-2c7577a7583747c9b71f26dced7f696b739da745@git.kernel.org> <CALCETrWM2wVynp1rrip9AWtNYDzjC4M8JqKR82ew5dpyrTWMgA@mail.gmail.com> <20141103214712.GA8711@redhat.com> <20141103215837.GB8711@redhat.com> <CALCETrUMLaz_McO=f-v6JmPY7pJSU4M4g1+p1un1UiVcNf+4XQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUMLaz_McO=f-v6JmPY7pJSU4M4g1+p1un1UiVcNf+4XQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Didn't notice this part yesterday...

On 11/03, Andy Lutomirski wrote:
>
> On Mon, Nov 3, 2014 at 1:58 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > On 11/03, Oleg Nesterov wrote:
> >>
> >> On 11/03, Andy Lutomirski wrote:
> >> >
> >> > Also, what's with 'jmp exit_intr' at the end of retint_kernel?  Why
> >> > isn't that 'jmp retint_kernel'?
> >>
> >> Even better, why not "jmp retint_restore_args" ?
> >>
> >> preempt_schedule_irq() checks need_resched() and returns with irqs
> >> disabled, not need to to recheck test_preempt_need_resched() ?
>
> Seems reasonable to me.  Want to write the patch?

OK, will try to do tomorrow.

And it seems that we can do a bit more, although I need to recheck.


retint_kernel() no longer needs rcx == threadinfo, it doesn't check
TIF_NEED_RESCHED. This means we can shift/remove some GET_THREAD_INFO()'s
under retint_check.

Oleg.

