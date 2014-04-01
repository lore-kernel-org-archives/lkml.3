Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbaDAXbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 19:31:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbaDAXbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 19:31:39 -0400
Date: Tue, 1 Apr 2014 19:31:30 -0400
From: Dave Jones <davej@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: rcu_prempt stalls / lockup
Message-ID: <20140401233130.GA25030@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20140331233552.GB30019@redhat.com>
 <20140401004801.GQ4284@linux.vnet.ibm.com>
 <20140401150849.GA14757@redhat.com>
 <20140401153032.GT4284@linux.vnet.ibm.com>
 <20140401172244.GA10363@redhat.com>
 <20140401175545.GV4284@linux.vnet.ibm.com>
 <20140401180414.GA12326@redhat.com>
 <20140401183245.GA12473@linux.vnet.ibm.com>
 <20140401221616.GA961@redhat.com>
 <20140401231822.GC4284@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140401231822.GC4284@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 04:18:22PM -0700, Paul E. McKenney wrote:
 
 > > # entries-in-buffer/entries-written: 7/7   #P:4
 > > #
 > > #                              _-----=> irqs-off
 > > #                             / _----=> need-resched
 > > #                            | / _---=> hardirq/softirq
 > > #                            || / _--=> preempt-depth
 > > #                            ||| /     delay
 > > #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
 > > #              | |       |   ||||       |         |
 > >           <idle>-0     [000] dNs3   851.748475: rcu_grace_period: rcu_preempt 21342 cpuend
 > >           <idle>-0     [000] dNs3   851.748477: rcu_grace_period: rcu_preempt 21343 cpustart
 > >           <idle>-0     [000] dNs3   851.748477: rcu_grace_period: rcu_sched 20080 cpuend
 > >           <idle>-0     [000] dN.2   851.748480: rcu_grace_period: rcu_preempt 21343 cpuqs
 > >      rcu_preempt-9     [000] ...1   851.748485: rcu_grace_period: rcu_preempt 21343 fqsstart
 > >      rcu_preempt-9     [000] ...1   851.748487: rcu_grace_period: rcu_preempt 21343 fqsend
 > >      rcu_preempt-9     [000] ...1   851.748487: rcu_grace_period: rcu_preempt 21343 fqswait
 > > # tracer: nop
 > > #
 > > # entries-in-buffer/entries-written: 13/13   #P:4
 > > #
 > > #                              _-----=> irqs-off
 > > #                             / _----=> need-resched
 > > #                            | / _---=> hardirq/softirq
 > > #                            || / _--=> preempt-depth
 > > #                            ||| /     delay
 > > #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
 > > #              | |       |   ||||       |         |
 > >      rcu_preempt-9     [003] d..2   851.878457: rcu_grace_period: rcu_preempt 21349 end
 > >      rcu_preempt-9     [003] d..2   851.878459: rcu_grace_period: rcu_preempt 21349 newreq
 > >      rcu_preempt-9     [003] ...1   851.878459: rcu_grace_period: rcu_preempt 21349 reqwait
 > >      rcu_preempt-9     [003] d..2   851.878460: rcu_grace_period: rcu_preempt 21350 start
 > >      rcu_preempt-9     [003] d..2   851.878461: rcu_grace_period: rcu_preempt 21350 cpustart
 > >      rcu_preempt-9     [003] d..2   851.878462: rcu_grace_period_init: rcu_preempt 21350 0 0 7 f
 > >      rcu_preempt-9     [003] ...1   851.878463: rcu_grace_period: rcu_preempt 21350 fqswait
 > >      rcu_preempt-9     [003] d..2   851.878464: rcu_grace_period: rcu_preempt 21350 cpuqs
 > >           <idle>-0     [000] dNs3   851.878482: rcu_grace_period: rcu_preempt 21349 cpuend
 > >           <idle>-0     [000] dNs3   851.878483: rcu_grace_period: rcu_preempt 21350 cpustart
 > >           <idle>-0     [000] dNs3   851.878484: rcu_grace_period: rcu_sched 20086 cpuend
 > >           <idle>-0     [000] .N.2   851.878486: rcu_grace_period: rcu_sched 20086 cpuqs
 > >           <idle>-0     [000] dN.2   851.878487: rcu_grace_period: rcu_preempt 21350 cpuqs
 > > 
 > > 
 > > followed by a half dozen 'empty' traces before it totally locked up.
 > 
 > Cool, thank you!
 > 
 > Could you please also send the RCU CPU stall warning messages?

>From that run they were..

[  917.790265] INFO: rcu_preempt detected stalls on CPUs/tasks:
[  917.791189] 	(detected by 0, t=6502 jiffies, g=21390, c=21389, q=0)
[  917.792058] INFO: Stall ended before state dump start, gp_kthread state: 0x2
[  917.792799] INFO: rcu_sched detected stalls on CPUs/tasks:
[  917.793534] 	(detected by 0, t=6502 jiffies, g=20128, c=20127, q=0)
[  917.794265] INFO: Stall ended before state dump start, gp_kthread state: 0x2
[ 1112.727480] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 1112.728425] 	(detected by 0, t=26007 jiffies, g=21390, c=21389, q=0)
[ 1112.729300] INFO: Stall ended before state dump start, gp_kthread state: 0x2
[ 1112.730035] INFO: rcu_sched detected stalls on CPUs/tasks:
[ 1112.730744] 	(detected by 0, t=26007 jiffies, g=20128, c=20127, q=0)
[ 1112.731459] INFO: Stall ended before state dump start, gp_kthread state: 0x2
[ 1307.664710] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 1307.665623] 	(detected by 0, t=45512 jiffies, g=21390, c=21389, q=0)
[ 1307.666386] INFO: Stall ended before state dump start, gp_kthread state: 0x2
[ 1307.667113] INFO: rcu_sched detected stalls on CPUs/tasks:
[ 1307.667839] 	(detected by 0, t=45512 jiffies, g=20128, c=20127, q=0)
[ 1307.668572] INFO: Stall ended before state dump start, gp_kthread state: 0x2
[ 1502.601961] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 1502.602905] 	(detected by 0, t=65017 jiffies, g=21390, c=21389, q=0)
[ 1502.603765] INFO: Stall ended before state dump start, gp_kthread state: 0x2
[ 1502.604550] INFO: rcu_sched detected stalls on CPUs/tasks:
[ 1502.605305] 	(detected by 0, t=65017 jiffies, g=20128, c=20127, q=0)
[ 1502.606061] INFO: Stall ended before state dump start, gp_kthread state: 0x2
[ 1697.539217] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 1697.540189] 	(detected by 0, t=84522 jiffies, g=21390, c=21389, q=0)
[ 1697.541052] INFO: Stall ended before state dump start, gp_kthread state: 0x2
[ 1697.541826] INFO: rcu_sched detected stalls on CPUs/tasks:
[ 1697.542600] 	(detected by 0, t=84522 jiffies, g=20128, c=20127, q=0)
[ 1697.543378] INFO: Stall ended before state dump start, gp_kthread state: 0x2
[ 1892.476433] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 1892.477545] 	(detected by 0, t=104027 jiffies, g=21390, c=21389, q=0)
[ 1892.478402] INFO: Stall ended before state dump start, gp_kthread state: 0x2
[ 1892.479208] INFO: rcu_sched detected stalls on CPUs/tasks:
[ 1892.480010] 	(detected by 0, t=104027 jiffies, g=20128, c=20127, q=0)
[ 1892.480831] INFO: Stall ended before state dump start, gp_kthread state: 0x2
[ 2087.413694] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 2087.414748] 	(detected by 0, t=123532 jiffies, g=21390, c=21389, q=0)
[ 2087.415722] INFO: Stall ended before state dump start, gp_kthread state: 0x2
[ 2087.416558] INFO: rcu_sched detected stalls on CPUs/tasks:
[ 2087.417392] 	(detected by 0, t=123532 jiffies, g=20128, c=20127, q=0)
[ 2087.418231] INFO: Stall ended before state dump start, gp_kthread state: 0x2



