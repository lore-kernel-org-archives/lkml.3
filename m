Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab3KYRQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 12:16:22 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:43781 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854Ab3KYRQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 12:16:20 -0500
Date: Sat, 23 Nov 2013 09:17:19 -0800
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
Message-ID: <20131123171719.GN4138@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131121213055.GA6938@linux.vnet.ibm.com>
 <1385069489-7898-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20131122153908.GQ10022@twins.programming.kicks-ass.net>
 <20131122181313.GU4138@linux.vnet.ibm.com>
 <20131123090406.GL4971@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131123090406.GL4971@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112517-0928-0000-0000-000003C4619D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 23, 2013 at 10:04:06AM +0100, Peter Zijlstra wrote:
> On Fri, Nov 22, 2013 at 10:13:13AM -0800, Paul E. McKenney wrote:
> > How about the following?
> > 
> > 							Thanx, Paul
> > 
> > ------------------------------------------------------------------------
> > 
> > COMPILER BARRIER
> > ----------------
> > 
> > The Linux kernel has an explicit compiler barrier function that prevents the
> > compiler from moving the memory accesses either side of it to the other side:
> > 
> >         barrier();
> > 
> > This is a general barrier -- there are no read-read or write-write variants
> > of barrier().  Howevever, ACCESS_ONCE() can be thought of as a weak form
> > for barrier() that affects only the specific accesses flagged by the
> > ACCESS_ONCE().
> > 
> > The compiler barrier has no direct effect on the CPU, which may then reorder
> > things however it wishes.
> > 
> 
> Seems ok, however this also seems like the natural spot to put that
> chunk about how a compiler can mis-transform stuff without either
> barrier or ACCESS_ONC(); that currently seems spread out over the
> document in some notes.
> 
> The biggest of which seems to have ended up in the GUARANTEES chapter.

Good point!  I believe that the spread-out stuff is still needed, so I
will add a summary of that information here, perhaps based in part on
Jon Corbet's ACCESS_ONCE() article (http://lwn.net/Articles/508991/).

Seem reasonable?

							Thanx, Paul

