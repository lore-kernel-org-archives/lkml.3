Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaBONDe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 08:03:34 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:52677 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753050AbaBONDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 08:03:33 -0500
Date: Sat, 15 Feb 2014 08:03:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Juri Lelli <juri.lelli@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sched/deadline: Fix bad accounting of nr_running
Message-ID: <20140215080331.209f349a@gandalf.local.home>
In-Reply-To: <20140215095207.GI14089@laptop.programming.kicks-ass.net>
References: <20140214235946.60a89b65@gandalf.local.home>
	<20140215095207.GI14089@laptop.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Feb 2014 10:52:07 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, Feb 14, 2014 at 11:59:46PM -0500, Steven Rostedt wrote:
> > diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> > index 0dd5e09..84c2454 100644
> > --- a/kernel/sched/deadline.c
> > +++ b/kernel/sched/deadline.c
> > @@ -844,14 +844,14 @@ static void __dequeue_task_dl(struct rq *rq,
> > struct task_struct *p, int flags) {
> >  	dequeue_dl_entity(&p->dl);
> >  	dequeue_pushable_dl_task(rq, p);
> > +
> > +	dec_nr_running(rq);
> >  }
> >  
> >  static void dequeue_task_dl(struct rq *rq, struct task_struct *p, int
> > flags) {
> >  	update_curr_dl(rq);
> >  	__dequeue_task_dl(rq, p, flags);
> > -
> > -	dec_nr_running(rq);
> >  }
> >  
> >  /*
> 
> That patch is so line-wrapped... tskk!

Damn it, That's claws mail. It inserts files (patches) fine, but if you
go and modify something, it decides to "autowrap" the entire file.
That's one of the things I need to fix when I get the time (I've
downloaded the source as this frustrates the hell out of me). The
autowrapping is the thing that I hate most about this client.

I'll send out a new patch later :-/

-- Steve
