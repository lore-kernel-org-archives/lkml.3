Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbaGKUf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 16:35:26 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:42242 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbaGKUfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 16:35:22 -0400
Date: Fri, 11 Jul 2014 13:35:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Lameter <cl@gentwo.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, oleg@redhat.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 11/17] rcu: Bind grace-period kthreads to
 non-NO_HZ_FULL CPUs
Message-ID: <20140711203513.GA10652@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140707223756.GA7187@linux.vnet.ibm.com>
 <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1404772701-8804-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140708152358.GF6571@localhost.localdomain>
 <20140708154723.GN4603@linux.vnet.ibm.com>
 <20140708183846.GJ6571@localhost.localdomain>
 <alpine.DEB.2.11.1407111309150.4777@gentwo.org>
 <20140711182541.GF26045@localhost.localdomain>
 <alpine.DEB.2.11.1407111403090.5070@gentwo.org>
 <20140711191113.GI26045@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140711191113.GI26045@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071120-1542-0000-0000-0000033885AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 09:11:15PM +0200, Frederic Weisbecker wrote:
> On Fri, Jul 11, 2014 at 02:05:08PM -0500, Christoph Lameter wrote:
> > On Fri, 11 Jul 2014, Frederic Weisbecker wrote:
> > 
> > > > That would imply that all no-nohz processors are housekeeping? So all
> > > > processors with a tick are housekeeping?
> > >
> > > Well, now that I think about it again, I would really like to keep housekeeping
> > > to CPU 0 when nohz_full= is passed.
> > 
> > Yeah.
> > 
> > > > Could we make that set configurable? Ideally I'd like to have the ability
> > > > restrict the housekeeping to one processor.
> > >
> > > Ah, I'm curious about your usecase. But I think we can do that. And we should.
> > 
> > The use case is pretty straightforward because we are trying to keep as
> > much OS noise as possible off most processors. Processor 0 is the
> > sacrificial lamb that will be used for all OS processing and hopefully all
> > high latency operations will occur there. Processors 1-X have a tick but
> > we still try to keep latencies sane. And then there is X-Y where tick is
> > off.
> 
> Ok. I don't entirely get why you need 1-X but I can easily imagine some non-latency-critical
> stuff running there.
> 
> Paul proposed "housekeeping=". If we ever go there, I'd rather vote for "sacrifical_lamb="

Given Christoph's desire for only one housekeeping CPU, I guess the
counting version makes the most sense, so that "housekeeping=N" designates
the first N non-nohz CPUs in numerical order as housekeeping CPUs.
If there are fewer than N non-nohz CPUs, you get a splat at boot time
and your request is capped at the number of non-nohz CPUs.

Seem reasonable?

							Thanx, Paul

