Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab3KWJEk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 04:04:40 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36813 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab3KWJEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 04:04:32 -0500
Date: Sat, 23 Nov 2013 10:04:06 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH v2 RFC 1/3] documentation: Add needed ACCESS_ONCE() calls
 to memory-barriers.txt
Message-ID: <20131123090406.GL4971@laptop.programming.kicks-ass.net>
References: <20131121213055.GA6938@linux.vnet.ibm.com>
 <1385069489-7898-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20131122153908.GQ10022@twins.programming.kicks-ass.net>
 <20131122181313.GU4138@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131122181313.GU4138@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 10:13:13AM -0800, Paul E. McKenney wrote:
> How about the following?
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> COMPILER BARRIER
> ----------------
> 
> The Linux kernel has an explicit compiler barrier function that prevents the
> compiler from moving the memory accesses either side of it to the other side:
> 
>         barrier();
> 
> This is a general barrier -- there are no read-read or write-write variants
> of barrier().  Howevever, ACCESS_ONCE() can be thought of as a weak form
> for barrier() that affects only the specific accesses flagged by the
> ACCESS_ONCE().
> 
> The compiler barrier has no direct effect on the CPU, which may then reorder
> things however it wishes.
> 

Seems ok, however this also seems like the natural spot to put that
chunk about how a compiler can mis-transform stuff without either
barrier or ACCESS_ONC(); that currently seems spread out over the
document in some notes.

The biggest of which seems to have ended up in the GUARANTEES chapter.
