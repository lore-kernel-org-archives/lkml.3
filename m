Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab3LJRR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 12:17:28 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:39332 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab3LJRRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 12:17:25 -0500
Date: Tue, 10 Dec 2013 09:17:18 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, Linux-Arch <linux-arch@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        benh@kernel.crashing.org
Subject: Re: [PATCH v5 tip/core/locking 6/7] locking: Add an
 smp_mb__after_unlock_lock() for UNLOCK+LOCK barrier
Message-ID: <20131210171718.GS4208@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131210012738.GA24317@linux.vnet.ibm.com>
 <1386638883-25379-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1386638883-25379-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <20131210123726.GE13532@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210123726.GE13532@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121017-1344-0000-0000-000003FE64BF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 01:37:26PM +0100, Peter Zijlstra wrote:
> On Mon, Dec 09, 2013 at 05:28:02PM -0800, Paul E. McKenney wrote:
> > diff --git a/arch/powerpc/include/asm/barrier.h b/arch/powerpc/include/asm/barrier.h
> > index f89da808ce31..abf645799991 100644
> > --- a/arch/powerpc/include/asm/barrier.h
> > +++ b/arch/powerpc/include/asm/barrier.h
> > @@ -84,4 +84,6 @@ do {									\
> >  	___p1;								\
> >  })
> >  
> > +#define smp_mb__after_unlock_lock()	do { } while (0)
> > +
> >  #endif /* _ASM_POWERPC_BARRIER_H */
> 
> Didn't ben said ppc actually violates the current unlock+lock assumtion
> and therefore this barrier woulnd't actually be a nop on ppc

Last I knew, I was saying that it did in theory, but wasn't able to
demonstrate it in practice.  But yes, I would be more comfortable with
it being smp_mb().

Ben?

							Thanx, Paul

