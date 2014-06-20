Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbaFTTEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:04:55 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:34232 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbaFTTEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:04:42 -0400
Date: Fri, 20 Jun 2014 12:04:34 -0700
From: josh@joshtriplett.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 0/5] Fix for cond_resched performance
 regression
Message-ID: <20140620190434.GA22178@cloud>
References: <20140620183249.GA6325@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620183249.GA6325@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 11:32:49AM -0700, Paul E. McKenney wrote:
> Hello!
> 
> This series contains changes to address the performance regressions
> introduced by commit ac1bea85781e (Make cond_resched() report RCU
> quiescent states), which was in turn fixing a problem where tasks looping
> in the kernel could delay RCU grace periods.  The changes in this series
> are as follows:
> 
> 1.	Reduce the overhead of checking added to cond_resched() and friends.
> 
> 2.	Add a new cond_resched_rcu_qs() to provide RCU quiescent states
> 	even if cond_resched() should stop doing so.
> 
> 3.	Add a new RCU_COND_RESCHED_QS to prevent cond_resched() from
> 	reporting RCU quiescent states.
> 
> 4.	Prevent rcutorture testing from reporting spurious RCU CPU stall
> 	warnings, and also to test RCU_COND_RESCHED_QS.
> 
> 5.	Provides a boot/sysfs rcutree.jiffies_till_cond_resched_qs
> 	parameter to replace the magic "7".

For all five patches:

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Glad to see this doesn't add any overhead to rcutiny.

- Josh Triplett
