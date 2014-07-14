Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbaGNNxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:53:42 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:56266 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754228AbaGNNxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:53:34 -0400
Date: Mon, 14 Jul 2014 08:53:31 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, oleg@redhat.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 11/17] rcu: Bind grace-period kthreads to
 non-NO_HZ_FULL CPUs
In-Reply-To: <20140711201507.GZ20603@laptop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.11.1407140853010.24790@gentwo.org>
References: <20140707223756.GA7187@linux.vnet.ibm.com> <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com> <1404772701-8804-11-git-send-email-paulmck@linux.vnet.ibm.com> <20140708152358.GF6571@localhost.localdomain> <20140708154723.GN4603@linux.vnet.ibm.com>
 <20140708183846.GJ6571@localhost.localdomain> <alpine.DEB.2.11.1407111309150.4777@gentwo.org> <20140711182541.GF26045@localhost.localdomain> <alpine.DEB.2.11.1407111403090.5070@gentwo.org> <20140711201507.GZ20603@laptop.programming.kicks-ass.net>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014, Peter Zijlstra wrote:

> On Fri, Jul 11, 2014 at 02:05:08PM -0500, Christoph Lameter wrote:
> > The use case is pretty straightforward because we are trying to keep as
> > much OS noise as possible off most processors. Processor 0 is the
> > sacrificial lamb that will be used for all OS processing and hopefully all
> > high latency operations will occur there. Processors 1-X have a tick but
> > we still try to keep latencies sane. And then there is X-Y where tick is
> > off.
>
> So the problem is -- and this isn't too hard to create -- when we
> saturate/overload cpu0 with just the housekeeping. At that point it
> would be good if we could scale and use multiple housekeepers.

Well we would simply add another machine at that point but there are
certainly configurations in which we would also want multiple housekeeping
cpus.

