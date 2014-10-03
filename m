Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760500AbaJCXkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:40:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755649AbaJCXkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 19:40:32 -0400
Date: Sat, 4 Oct 2014 01:37:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, luto@amacapital.net, dvlasenk@redhat.com,
        tglx@linutronix.de
Subject: Re: [tip:x86/asm] x86: Speed up ___preempt_schedule*() by using
	THUNK helpers
Message-ID: <20141003233708.GA4019@redhat.com>
References: <20140921184153.GA23727@redhat.com> <tip-0ad6e3c5199be12c9745da8f8b9e3c9f8066c235@git.kernel.org> <542E2B05.5080607@oracle.com> <20141003083954.10a13a24@as> <20141003214124.GA31614@redhat.com> <20141003174814.6829cf26@as>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141003174814.6829cf26@as>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03, Chuck Ebbert wrote:
>
> On Fri, 3 Oct 2014 23:41:24 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > On 10/03, Chuck Ebbert wrote:
> > >
> > > > [  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
> > > > [  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
> > > > [  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
> > > > [  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
> > > > [  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
> > > > [  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
> > > > [  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
> > > > [  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
> > > > [  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
> > > > [  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
> > >
> > > <snip lots of repeats of this>
> > >
> > > I *think* this is because RBP isn't being saved across task switch
> > > anymore?
> > >
> > > Without CONFIG_FRAME_POINTERS that night not be a problem...
> >
> > Could you please spell?
> >
> > I don't even understand "RBP isn't being saved", SAVE_CONTEXT/RESTORE_CONTEXT
> > do push/pop %rbp?
> >
>
> SAVE_ARGS/RESTORE_ARGS, which is what THUNK uses, doesn't push/pop %rbp
>
> Before, SAVE_ALL/RESTORE_ALL were being used around the call to
> preempt_schedule(). So from the symptoms I thought this was the problem.

Ah, thanks, now I understand what you meant. I thought you meant
switch_to().

Yes, I thought about this difference too, but so far I fail to understand
how this can make a difference, according to calling.h it is callee-saved.

Oleg.

