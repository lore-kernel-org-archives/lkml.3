Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbaHMSZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 14:25:35 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:49217 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbaHMSZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 14:25:33 -0400
Date: Wed, 13 Aug 2014 11:25:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v5 tip/core/rcu 15/16] rcu: Make RCU-tasks wait for idle
 tasks
Message-ID: <20140813182528.GF4752@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1407797345-28227-15-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140813081215.GB9918@twins.programming.kicks-ass.net>
 <20140813124818.GQ4752@linux.vnet.ibm.com>
 <20140813134025.GN9918@twins.programming.kicks-ass.net>
 <20140813095132.56d288f2@gandalf.local.home>
 <20140813140705.GO9918@twins.programming.kicks-ass.net>
 <20140813101301.08019895@gandalf.local.home>
 <20140813144332.GW4752@linux.vnet.ibm.com>
 <20140813163522.GU9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813163522.GU9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081318-1542-0000-0000-000003FAE903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 06:35:22PM +0200, Peter Zijlstra wrote:
> On Wed, Aug 13, 2014 at 07:43:32AM -0700, Paul E. McKenney wrote:
> > So the first three look OK to hook rcu_idle_enter() and rcu_idle_exit()
> > into, but the last two don't look so good.
> > 
> > That said, if you are OK not tracing the stuff under stop_critical_timings(),
> > then I can use the RCU dyntick-idle state and not wake anything up.
> 
> Either way, Steve could easily whip up a debug thing that could validate
> that. Simply WARN whenever an __mcount happens when under rcu_idle.
> 
> And if we make these idle functions small enough that should not be a
> problem at all.

Right now, the CPU-idle drivers look quite hairy and error-prone.

							Thanx, Paul

