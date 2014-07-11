Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbaGKTFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 15:05:14 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:53868 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751441AbaGKTFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 15:05:12 -0400
Date: Fri, 11 Jul 2014 14:05:08 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 11/17] rcu: Bind grace-period kthreads to
 non-NO_HZ_FULL CPUs
In-Reply-To: <20140711182541.GF26045@localhost.localdomain>
Message-ID: <alpine.DEB.2.11.1407111403090.5070@gentwo.org>
References: <20140707223756.GA7187@linux.vnet.ibm.com> <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com> <1404772701-8804-11-git-send-email-paulmck@linux.vnet.ibm.com> <20140708152358.GF6571@localhost.localdomain> <20140708154723.GN4603@linux.vnet.ibm.com>
 <20140708183846.GJ6571@localhost.localdomain> <alpine.DEB.2.11.1407111309150.4777@gentwo.org> <20140711182541.GF26045@localhost.localdomain>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014, Frederic Weisbecker wrote:

> > That would imply that all no-nohz processors are housekeeping? So all
> > processors with a tick are housekeeping?
>
> Well, now that I think about it again, I would really like to keep housekeeping
> to CPU 0 when nohz_full= is passed.

Yeah.

> > Could we make that set configurable? Ideally I'd like to have the ability
> > restrict the housekeeping to one processor.
>
> Ah, I'm curious about your usecase. But I think we can do that. And we should.

The use case is pretty straightforward because we are trying to keep as
much OS noise as possible off most processors. Processor 0 is the
sacrificial lamb that will be used for all OS processing and hopefully all
high latency operations will occur there. Processors 1-X have a tick but
we still try to keep latencies sane. And then there is X-Y where tick is
off.
