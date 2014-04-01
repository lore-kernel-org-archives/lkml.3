Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaDAPak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 11:30:40 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:56186 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaDAPai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 11:30:38 -0400
Date: Tue, 1 Apr 2014 08:30:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: rcu_prempt stalls / lockup
Message-ID: <20140401153032.GT4284@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140331230241.GA30019@redhat.com>
 <20140331232220.GP4284@linux.vnet.ibm.com>
 <20140331233552.GB30019@redhat.com>
 <20140401004801.GQ4284@linux.vnet.ibm.com>
 <20140401150849.GA14757@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140401150849.GA14757@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040115-1344-0000-0000-000000A2E181
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 11:08:49AM -0400, Dave Jones wrote:
> On Mon, Mar 31, 2014 at 05:48:01PM -0700, Paul E. McKenney wrote:
> 
>  > Alternatively, I suppose a wakeup could be getting lost.  The main change
>  > related to that this merge window was ffa83fb565fb, which eliminated
>  > idle wakeups from RCU in the CONFIG_RCU_NOCB_CPU_ALL=y case.
>  > 
>  > So, could you please try reverting ffa83fb565fb?
> 
> Did a run overnight with that reverted, no luck..
> 
> [11869.580161] INFO: rcu_preempt detected stalls on CPUs/tasks:
> [11869.581245]  (detected by 0, t=6502 jiffies, g=449892, c=449891, q=0)
> [11869.582047] INFO: Stall ended before state dump start
> [12064.517461] INFO: rcu_preempt detected stalls on CPUs/tasks:
> [12064.518539]  (detected by 0, t=26007 jiffies, g=449892, c=449891, q=0)
> [12064.519347] INFO: Stall ended before state dump start
> [12259.454767] INFO: rcu_preempt detected stalls on CPUs/tasks:
> [12259.455818]  (detected by 0, t=45512 jiffies, g=449892, c=449891, q=0)
> [12259.456602] INFO: Stall ended before state dump start
> [12454.392112] INFO: rcu_preempt detected stalls on CPUs/tasks:
> [12454.393131]  (detected by 0, t=65017 jiffies, g=449892, c=449891, q=0)
> [12454.393942] INFO: Stall ended before state dump start
> [12649.329446] INFO: rcu_preempt detected stalls on CPUs/tasks:
> [12649.330446]  (detected by 0, t=84522 jiffies, g=449892, c=449891, q=0)
> [12649.331267] INFO: Stall ended before state dump start
> [12844.266776] INFO: rcu_preempt detected stalls on CPUs/tasks:
> [12844.267695]  (detected by 0, t=104027 jiffies, g=449892, c=449891, q=0)
> [12844.268571] INFO: Stall ended before state dump start
> [13039.204102] INFO: rcu_preempt detected stalls on CPUs/tasks:
> [13039.205119]  (detected by 0, t=123532 jiffies, g=449892, c=449891, q=0)
> [13039.205871] INFO: Stall ended before state dump start
> [13234.141424] INFO: rcu_preempt detected stalls on CPUs/tasks:
> [13234.141424] INFO: rcu_preempt detected stalls on CPUs/tasks:
> [13234.142448]  (detected by 0, t=143037 jiffies, g=449892, c=449891, q=0)
> [13234.143339] INFO: Stall ended before state dump start
> [13429.078730] INFO: rcu_preempt detected stalls on CPUs/tasks:
> [13429.079771]  (detected by 0, t=162542 jiffies, g=449892, c=449891, q=0)
> [13429.080591] INFO: Stall ended before state dump start
> [13624.016058] INFO: rcu_preempt detected stalls on CPUs/tasks:
> [13624.017116]  (detected by 0, t=182047 jiffies, g=449892, c=449891, q=0)
> [13624.018033] INFO: Stall ended before state dump start
> [13818.953370] INFO: rcu_preempt detected stalls on CPUs/tasks:
> [13818.954437]  (detected by 0, t=201552 jiffies, g=449892, c=449891, q=0)
> [13818.955334] INFO: Stall ended before state dump start
> [14013.890682] INFO: rcu_preempt detected stalls on CPUs/tasks:
> [14013.891761]  (detected by 0, t=221057 jiffies, g=449892, c=449891, q=0)
> [14013.892691] INFO: Stall ended before state dump start
> [14208.827993] INFO: rcu_preempt detected stalls on CPUs/tasks:
> [14208.829088]  (detected by 0, t=240562 jiffies, g=449892, c=449891, q=0)
> [14208.829977] INFO: Stall ended before state dump start
> [14403.765300] INFO: rcu_preempt detected stalls on CPUs/tasks:
> [14403.766405]  (detected by 0, t=260067 jiffies, g=449892, c=449891, q=0)
> and on and on..
> 
> so kernel space still works like before, but userspace is locked up.

Interesting.  I suspect that if you reverted the rest of this merge
window's RCU patches, you would get the same result.

>  > If that doesn't work, I will need to put together some diagnostic patches.
>  > Starting with the one below.
> 
> bugger, I forgot to apply this last night. I'll do it on the next run.

But let's see what this shows first.

							Thanx, Paul

