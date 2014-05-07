Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaEGWdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 18:33:12 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:56543 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaEGWdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 18:33:11 -0400
X-Originating-IP: 173.246.103.110
Date: Wed, 7 May 2014 15:32:58 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 0/44] Torture-test changes for 3.16
Message-ID: <20140507222043.GA9256@jtriplet-mobl1>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140429002455.GA15461@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 05:24:55PM -0700, Paul E. McKenney wrote:
> Hello!
> 
> This series provides torture-test updates:
> 
> 1.	Add forward-progress checking to distinguish between stalls in
> 	the RCU implementation and in the torture test itself.
> 
> 2.	Remove the --builddir and --relbuilddir options, which have been
> 	obsoleted by the parallel testing facility.
> 
> 3.	Make "--dryrun sched" output more readable by clearly indicating
> 	where each batch of concurrent runs starts.
> 
> 4.	Make torture-test errors less RCU-specific.  ("Hey, why did
> 	my locktorture run complain about RCU???")
> 
> 5,8-14.	Rename variables to reflect the new RCU-independence of a number
> 	of the torture-test scripts.
> 
> 6.	Reduce locktorture sleeping to increase intensity.
> 
> 7.	Add a --defconfig argument to allow other default configs to
> 	be specified.
> 
> 15.	Make config-fragment filtering RCU-independent.
> 
> 16.	Mark private functions as static in kernel/rcu/torture.c,
> 	courtesy of Rashika Kheria.
> 
> 17-18.	Make the output of "--dryrun script" independently runnable.
> 
> 19.	Print negative numbers when SRCU counters wrap instead of
> 	huge 64-bit integers.
> 
> 20.	Fix "Stopping" torture messages.
> 
> 21.	Report any diagnostics issued by qemu.
> 
> 22.	Make kthreads spin during the last jiffy of a stutter period
> 	to increase the intensity of torture stop-start events.
> 
> 23.	Permit multiple qemu and boot arguments to be specified on
> 	the command line.
> 
> 24.	Choose bzImage location based on architecture.
> 
> 25.	Add tracing-enabled variant of TREE02 to aid debugging.
> 
> 26.	Dump the ftrace buffer when the RCU grace period stalls.
> 
> 27.	Export the RCU grace-period kthread wait state to rcutorture
> 	to ease diagnosis of RCU grace-period stalls.
> 
> 28.	Fix bug in raw_cpu_inc_return().
> 
> 29.	Make cond_resched() report RCU quiescent states.
> 
> 30.	Make rcu_torture_reader() use cond_resched() instead of
> 	unconditionally invoking schedule().
> 
> 31.	Complain if an all-zero cpumask is specified during a torture
> 	shuffle operation, courtesy of Iulia Manda.
> 
> 32.	Make build failures more evident.
> 
> 33.	Capture and report the torture_create_kthread() return value when
> 	creating the rcu_torture_fqs kthread.
> 
> 34.	Use elapsed time to detect hangs rather than counting "sleep 1"
> 	commands.
> 
> 35.	Rearrange config fragments to ensure that RCU-sched primitives are
> 	tested in TREE_PREEMPT_RCU kernels.
> 
> 36.	Add rcutorture tests for get_state_synchronize_rcu() and
> 	cond_synchronize_rcu().
> 
> 37.	Add explicit tests for synchronous grace-period primitives.
> 
> 38.	Add missing destroy_timer_on_stack(), courtesy of Thomas Gleixner.
> 
> 39.	Make scripts record "git diff HEAD" to ease reproduction of
> 	an unexpected torture-test result.
> 
> 40.	Run rcu_torture_writer() at normal priority.
> 
> 41.	Put the qemu process into the background to better handle
> 	kernel hangs.
> 
> 42.	Remove reference to a non-existent Kconfig parameter.
> 
> 43.	Refuse to run multiple concurrent torture tests.
> 
> 44.	Remove __init from torture_init_begin() and torture_init_end()
> 	to allow rcutorture to once again work as a loadable module.
> 
> 45.	Remove unused torture_parm() macro.

I responded with feedback on patches 1, 6, 7, 8, 10, 11, 12, 15, 18, 19,
20, 21, 24, 27, 32, 39, and 41.

For the remaining patches:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
