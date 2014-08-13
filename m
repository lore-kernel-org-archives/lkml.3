Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbaHMQnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 12:43:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:65006 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbaHMQnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 12:43:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,857,1400050800"; 
   d="scan'208";a="587632049"
Date: Wed, 13 Aug 2014 09:43:05 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v5 tip/core/rcu 15/16] rcu: Make RCU-tasks wait for idle
 tasks
Message-ID: <20140813094305.225a4e1c@ultegra>
In-Reply-To: <20140813163015.GT9918@twins.programming.kicks-ass.net>
References: <20140811224840.GA25594@linux.vnet.ibm.com>
	<1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
	<1407797345-28227-15-git-send-email-paulmck@linux.vnet.ibm.com>
	<20140813081215.GB9918@twins.programming.kicks-ass.net>
	<20140813124818.GQ4752@linux.vnet.ibm.com>
	<20140813134025.GN9918@twins.programming.kicks-ass.net>
	<20140813095132.56d288f2@gandalf.local.home>
	<20140813140705.GO9918@twins.programming.kicks-ass.net>
	<20140813101301.08019895@gandalf.local.home>
	<20140813144332.GW4752@linux.vnet.ibm.com>
	<20140813163015.GT9918@twins.programming.kicks-ass.net>
Organization: OTC
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2014 18:30:15 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Aug 13, 2014 at 07:43:32AM -0700, Paul E. McKenney wrote:
> > o	drivers/acpi/acpi_pad.c, power_saving_thread().
> > 
> > 	Looks like a kthread that does idle injection.  Currently,
> > RCU sees it as not a quiescent state.  Would it kill these guys to
> > 	put in a comment or two about what this is for???
> > 
> > 	So adding rcu_idle_enter() and rcu_idle_exit() here might
> > 	actually fix a bug, though it is not clear how long this
> > thing actually runs.  If only for a few milliseconds, no harm done.
> > 
> 
> > o	drivers/thermal/intel_powerclamp.c, clamp_thread().
> > 
> > 	Looks similar to power_saving_thread(), but for thermal
> > control. Probably short term, shouldn't be a problem either way.
> > 
> 
> There's patches somewhere that make that go-away
> 
>   https://lkml.org/lkml/2014/6/4/56
> 
> Jacob was going to look at that.

yes, it is on my plate, plan to submit for 3.18. the idle period is
only for a few miliseconds, default to 6ms.

Thanks,

Jacob
