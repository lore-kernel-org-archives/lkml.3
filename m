Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab3JIGIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 02:08:13 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:62444 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab3JIGIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 02:08:10 -0400
Date: Wed, 9 Oct 2013 08:08:06 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo.kernel.org@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] sched/wait: Collapse __wait_event macros -v5
Message-ID: <20131009060806.GC7664@gmail.com>
References: <20131004204405.GU3081@twins.programming.kicks-ass.net>
 <20131004204438.GR26785@twins.programming.kicks-ass.net>
 <20131005080416.GA25193@gmail.com>
 <20131008095927.GS3081@twins.programming.kicks-ass.net>
 <20131008102331.GB8852@gmail.com>
 <20131008141657.GW5790@linux.vnet.ibm.com>
 <20131008194718.GD7315@gmail.com>
 <20131008204056.GR5790@linux.vnet.ibm.com>
 <20131009032843.GA12970@linux.vnet.ibm.com>
 <20131009033502.GA14017@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009033502.GA14017@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Tue, Oct 08, 2013 at 08:28:43PM -0700, Paul E. McKenney wrote:
> > On Tue, Oct 08, 2013 at 01:40:56PM -0700, Paul E. McKenney wrote:
> > > On Tue, Oct 08, 2013 at 09:47:18PM +0200, Ingo Molnar wrote:
> 
> [ . . . ]
> 
> > > > > Should I be thinking about making a kernel/rcu?
> > > > 
> > > > I wanted to raise it with you at the KS :-)
> > > 
> > > Sorry for jumping the gun.  ;-)
> > > 
> > > > To me it would sure look nice to have kernel/rcu/tree.c, 
> > > > kernel/rcu/tiny.c, kernel/rcu/core.c, etc.
> > > > 
> > > > [ ... and we would certainly also break new ground by introducing a
> > > >   "torture.c" file, for the first time in Linux kernel history! ;-) ]
> > > 
> > > Ooh...  I had better act fast!  ;-)
> > > 
> > > > But it's really your call, this is something you should only do if you are 
> > > > comfortable with it.
> > > 
> > > I have actually been thinking about it off and on for some time.
> > 
> > And here is a first cut.  Just the renaming and needed adjustments,
> > no splitting or merging of files.
> > 
> > Thoughts?
> 
> Wow!  I rebased my commits destined for 3.14 on top of this, and "git 
> rebase" did it with several protests, but with no manual intervention 
> required.

Git is cool!

> Now if it actually still builds, boots, and runs...  ;-)

Booting is overrated! ;-)

Seriously, this is good stuff.

   Reviewed-by: Ingo Molnar <mingo@kernel.org>

I'd definitely argue in favor of doing a mechanical move first, then any 
further reorganization separately.

(One minor detail I noticed: you'll probably need to update the RCU file 
patterns in MAINTAINERS as well.)

Thanks,

	Ingo
