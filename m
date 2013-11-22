Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab3KVSNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 13:13:20 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:58240 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786Ab3KVSNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 13:13:19 -0500
Date: Fri, 22 Nov 2013 10:13:13 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH v2 RFC 1/3] documentation: Add needed ACCESS_ONCE() calls
 to memory-barriers.txt
Message-ID: <20131122181313.GU4138@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131121213055.GA6938@linux.vnet.ibm.com>
 <1385069489-7898-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20131122153908.GQ10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131122153908.GQ10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112218-0928-0000-0000-000003B1D521
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 04:39:08PM +0100, Peter Zijlstra wrote:
> On Thu, Nov 21, 2013 at 01:31:27PM -0800, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > The Documentation/memory-barriers.txt file was written before the need
> > for ACCESS_ONCE() was fully appreciated.  It therefore contains no
> > ACCESS_ONCE() calls, which can be a problem when people lift examples
> > from it.  This commit therefore adds ACCESS_ONCE() calls.
> > 
> 
> Under the 'COMPILER BARRIER' section we state that:
> 
> "This is a general barrier - lesser varieties of compiler barrier do not
> exist."
> 
> One could argue ACCESS_ONCE() is such a lesser barrier.

Fair point -- I should have updated this section when adding ACCESS_ONCE().

How about the following?

							Thanx, Paul

------------------------------------------------------------------------

COMPILER BARRIER
----------------

The Linux kernel has an explicit compiler barrier function that prevents the
compiler from moving the memory accesses either side of it to the other side:

        barrier();

This is a general barrier -- there are no read-read or write-write variants
of barrier().  Howevever, ACCESS_ONCE() can be thought of as a weak form
for barrier() that affects only the specific accesses flagged by the
ACCESS_ONCE().

The compiler barrier has no direct effect on the CPU, which may then reorder
things however it wishes.

