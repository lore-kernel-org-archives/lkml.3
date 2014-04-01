Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbaDASE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 14:04:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbaDASEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 14:04:24 -0400
Date: Tue, 1 Apr 2014 14:04:14 -0400
From: Dave Jones <davej@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: rcu_prempt stalls / lockup
Message-ID: <20140401180414.GA12326@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20140331230241.GA30019@redhat.com>
 <20140331232220.GP4284@linux.vnet.ibm.com>
 <20140331233552.GB30019@redhat.com>
 <20140401004801.GQ4284@linux.vnet.ibm.com>
 <20140401150849.GA14757@redhat.com>
 <20140401153032.GT4284@linux.vnet.ibm.com>
 <20140401172244.GA10363@redhat.com>
 <20140401175545.GV4284@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140401175545.GV4284@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 10:55:45AM -0700, Paul E. McKenney wrote:
 > >  > > so kernel space still works like before, but userspace is locked up.
 > >  > 
 > >  > Interesting.  I suspect that if you reverted the rest of this merge
 > >  > window's RCU patches, you would get the same result.
 
Something that occurred to me is that this might be something in the x86 merge
that's just changing timings enough to expose this problem.
At some point this evening, I'll try bisecting it if we don't get any closer.

 > > [ 1953.672735] INFO: Stall ended before state dump start, gp_kthread state: 0x2
 > > [ 2148.608132] INFO: rcu_preempt detected stalls on CPUs/tasks:
 > > [ 2148.609140] 	(detected by 0, t=104027 jiffies, g=47728, c=47727, q=0)
 > > etc etc.
 > 
 > Waiting uninterruptibly.  Presumably blocked on mutex_lock().  But
 > you have CONFIG_PROVE_LOCKING(), so any deadlocks should have been
 > reported.

Lockdep had reported something a little earlier (timestamped at 1108.xxxxxx)
but that's a known false-positive in xfs.

 > Given that you have CONFIG_RCU_TRACE=y, could you please enable the
 > following trace events and dump the trace before things hang?
 > 
 > 	trace_event=rcu:rcu_grace_period,rcu:rcu_grace_period_init
 > 
 > If it is not feasible to dump the trace before things hang, let me
 > know, and I will work out some other diagnostic regime.

I'll give that a shot when I get back in a few hours.

	Dave
