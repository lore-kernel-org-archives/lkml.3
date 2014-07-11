Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353AbaGKTL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 15:11:26 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:35142 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309AbaGKTLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 15:11:23 -0400
Date: Fri, 11 Jul 2014 21:11:15 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 11/17] rcu: Bind grace-period kthreads to
 non-NO_HZ_FULL CPUs
Message-ID: <20140711191113.GI26045@localhost.localdomain>
References: <20140707223756.GA7187@linux.vnet.ibm.com>
 <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1404772701-8804-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140708152358.GF6571@localhost.localdomain>
 <20140708154723.GN4603@linux.vnet.ibm.com>
 <20140708183846.GJ6571@localhost.localdomain>
 <alpine.DEB.2.11.1407111309150.4777@gentwo.org>
 <20140711182541.GF26045@localhost.localdomain>
 <alpine.DEB.2.11.1407111403090.5070@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1407111403090.5070@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 02:05:08PM -0500, Christoph Lameter wrote:
> On Fri, 11 Jul 2014, Frederic Weisbecker wrote:
> 
> > > That would imply that all no-nohz processors are housekeeping? So all
> > > processors with a tick are housekeeping?
> >
> > Well, now that I think about it again, I would really like to keep housekeeping
> > to CPU 0 when nohz_full= is passed.
> 
> Yeah.
> 
> > > Could we make that set configurable? Ideally I'd like to have the ability
> > > restrict the housekeeping to one processor.
> >
> > Ah, I'm curious about your usecase. But I think we can do that. And we should.
> 
> The use case is pretty straightforward because we are trying to keep as
> much OS noise as possible off most processors. Processor 0 is the
> sacrificial lamb that will be used for all OS processing and hopefully all
> high latency operations will occur there. Processors 1-X have a tick but
> we still try to keep latencies sane. And then there is X-Y where tick is
> off.

Ok. I don't entirely get why you need 1-X but I can easily imagine some non-latency-critical
stuff running there.

Paul proposed "housekeeping=". If we ever go there, I'd rather vote for "sacrifical_lamb="
