Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab3LJVZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 16:25:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:13486 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280Ab3LJVZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 16:25:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,866,1378882800"; 
   d="scan'208";a="422531063"
Message-ID: <1386710734.3685.85.camel@dvhart-mobl4.amr.corp.intel.com>
Subject: Re: process 'stuck' at exit.
From: Darren Hart <dvhart@linux.intel.com>
To: Dave Jones <davej@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Oleg Nesterov <oleg@redhat.com>
Date: Tue, 10 Dec 2013 13:25:34 -0800
In-Reply-To: <20131210205523.GC27373@redhat.com>
References: <20131210154724.GA30020@redhat.com>
	 <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
	 <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
	 <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
	 <20131210202752.GA27373@redhat.com>
	 <alpine.DEB.2.02.1312102133400.28330@ionos.tec.linutronix.de>
	 <20131210205523.GC27373@redhat.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 15:55 -0500, Dave Jones wrote:
> On Tue, Dec 10, 2013 at 09:34:24PM +0100, Thomas Gleixner wrote:
>  
>  > >  > PS: Oleg - the whole thread is on lkml. Ping me if you need more context.
>  > > 
>  > > btw, I've left the machine in that state, and will for as long as necesary
>  > > in case someone has any ideas for further tracing experiments.
>  > 
>  > Can you gather a trace with the function tracer? That will tell us
>  > what the thing is actually doing.
> 
> Feed me command lines, and I'll see what I can do.
> 
> 	Dave
> 

So let's see if we can determine the call chain inside futex_requeue, if
there is one. We want to see if we are calling the following functions:

futex.c: free_pi_state
futex.c: get_futex_value_locked
futex.c: futex_proxy_trylock_atomic
futex.c: lookup_pi_state
futex.c: fault_in_user_writeable

I'm hoping we can make use of ftrace here?

Consider:

$ trace-cmd record -P <PID> -p function -l '*futex*'

And to try outside of futex:

$ trace-cmd record -P <PID> -p function

Then ^C after a few seconds. The trace will be in trace.dat



-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


