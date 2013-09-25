Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab3IYNsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 09:48:13 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:59965 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415Ab3IYNsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 09:48:12 -0400
Date: Wed, 25 Sep 2013 06:48:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH tip/core/rcu 01/11] mm: Place preemption point in
 do_mlockall() loop
Message-ID: <20130925134803.GQ9093@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130925012750.GA30601@linux.vnet.ibm.com>
 <1380072561-31134-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130924211047.57f9d9c8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130924211047.57f9d9c8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092513-1542-0000-0000-000001BC58B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 09:10:47PM -0700, Andrew Morton wrote:
> On Tue, 24 Sep 2013 18:29:11 -0700 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > --- a/mm/mlock.c
> > +++ b/mm/mlock.c
> > @@ -736,6 +736,7 @@ static int do_mlockall(int flags)
> >  
> >  		/* Ignore errors */
> >  		mlock_fixup(vma, &prev, vma->vm_start, vma->vm_end, newflags);
> > +		cond_resched();
> >  	}
> >  out:
> >  	return 0;
> 
> Might need one in munlock_vma_pages_range() as well - it's a matter of
> finding the right test case.  This will be neverending :(

Indeed...  I suspect that Trinity running on big-memory systems will
eventually find most of them via RCU CPU stall warnings, but as you say...

Would you like the corresponding change to munlock_vma_pages_range()
beforehand?

							Thanx, Paul

