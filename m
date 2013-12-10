Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab3LJV2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 16:28:08 -0500
Received: from www.linutronix.de ([62.245.132.108]:51454 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab3LJV2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 16:28:06 -0500
Date: Tue, 10 Dec 2013 22:28:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhart@linux.intel.com>
cc: Dave Jones <davej@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: process 'stuck' at exit.
In-Reply-To: <1386710734.3685.85.camel@dvhart-mobl4.amr.corp.intel.com>
Message-ID: <alpine.DEB.2.02.1312102227200.28330@ionos.tec.linutronix.de>
References: <20131210154724.GA30020@redhat.com>  <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>  <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>  <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com> 
 <20131210202752.GA27373@redhat.com>  <alpine.DEB.2.02.1312102133400.28330@ionos.tec.linutronix.de>  <20131210205523.GC27373@redhat.com> <1386710734.3685.85.camel@dvhart-mobl4.amr.corp.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013, Darren Hart wrote:
> On Tue, 2013-12-10 at 15:55 -0500, Dave Jones wrote:
> > On Tue, Dec 10, 2013 at 09:34:24PM +0100, Thomas Gleixner wrote:
> >  
> >  > >  > PS: Oleg - the whole thread is on lkml. Ping me if you need more context.
> >  > > 
> >  > > btw, I've left the machine in that state, and will for as long as necesary
> >  > > in case someone has any ideas for further tracing experiments.
> >  > 
> >  > Can you gather a trace with the function tracer? That will tell us
> >  > what the thing is actually doing.
> > 
> > Feed me command lines, and I'll see what I can do.
> > 
> > 	Dave
> > 
> 
> So let's see if we can determine the call chain inside futex_requeue, if
> there is one. We want to see if we are calling the following functions:
> 
> futex.c: free_pi_state
> futex.c: get_futex_value_locked
> futex.c: futex_proxy_trylock_atomic
> futex.c: lookup_pi_state
> futex.c: fault_in_user_writeable
> 
> I'm hoping we can make use of ftrace here?
> 
> Consider:
> 
> $ trace-cmd record -P <PID> -p function -l '*futex*'
> 
> And to try outside of futex:
> 
> $ trace-cmd record -P <PID> -p function
> 
> Then ^C after a few seconds. The trace will be in trace.dat

We definitely want the latter. The futex code gets compiled into some
badly traceable mess.

Thanks,

	tglx
