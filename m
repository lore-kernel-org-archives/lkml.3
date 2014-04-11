Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777AbaDKNZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:25:28 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:43374 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754022AbaDKNZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:25:27 -0400
Date: Fri, 11 Apr 2014 09:25:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Carsten Emde <C.Emde@osadl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC PATCH RT V3] rwsem: The return of multi-reader PI rwsems
Message-ID: <20140411092524.1f242e25@gandalf.local.home>
In-Reply-To: <5347E475.4020009@osadl.org>
References: <20140409151922.5fa5d999@gandalf.local.home>
	<20140410134217.38cd6db7@gandalf.local.home>
	<20140410223508.6d0fc135@gandalf.local.home>
	<5347E475.4020009@osadl.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2014 14:47:49 +0200
Carsten Emde <C.Emde@osadl.org> wrote:

> Hi Steven,
> 
> > [..] I added Carsten to the Cc, so I'll post the entire change log
> > of v1 here again.
> I've been listening and testing boxes all the time ...
> 

I figured but still wanted to add you to the Cc.

> > [..] If you have any benchmark on large machines I would be very
> > happy if you could test this patch against the unpatched version of
> > -rt.
> Three machines
> - an X32 x86_64 (AMD Opteron 6272 @2100 MHz) at rack #1/slot #1,
> - an X4x2 x86_64 (Intel i7-2600K @3400 MHz) at rack #4/slot #6, and
> - an X4 ARM (i.MX6 Quad @996 MHz) at rack #8/slot #7
> are running a v3-patched 3.12.15-rt25 kernel now. I'll equip more
> machines later.
> 
> What I can say so far is:
> - No evidence for any regression, no crashes

That's good to hear.

> - Performance certainly at least as good as unpatched, probably better

That's even better.

> 
> I'll do more tests and come back with more precise performance
> comparison data.

Do you also have any threaded tests? That is, something like a java
benchmark that kicks off lots of threads. That's where the performance
should show up the most. Clark's whack_mmap_sem test is specific to
this, and has shown an 10x increase in performance with my patch. But
that's a micro benchmark. A better test would be a real java
application.

Thanks,

-- Steve
