Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbaD2DYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 23:24:04 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:55354 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbaD2DYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 23:24:00 -0400
X-Originating-IP: 50.43.32.211
Date: Mon, 28 Apr 2014 20:23:45 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 0/3] Miscellaneous fixes for 3.16
Message-ID: <20140429032345.GA8793@thin>
References: <20140428235600.GA12200@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140428235600.GA12200@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 04:56:00PM -0700, Paul E. McKenney wrote:
> Hello!
> 
> This series provides miscellaneous fixes:
> 
> 1.	Apply ACCESS_ONCE() to unprotected ->gp_flags accesses.
> 
> 2.	Fix typo in comment, courtesy of Liu Ping Fan.
> 
> 3.	Make RCU CPU stall warnings print grace-period numbers in
> 	signed format to improve readability of stall-warning output.
> 
> 4.	Make cpu_needs_another_gp() take future grace-period needs
> 	into account.
> 
> 5.	Remove unused ->preemptible field from the rcu_data structure,
> 	courtesty of Iulia Manda.
> 
> 6.	Apply ACCESS_ONCE() to unprotected ->jiffies_stall accesses,
> 	courtesty of Iulia Manda.
> 
> 7.	Make callers responsible for grace-period kthread wakeup in
> 	order to avoid potential silent grace-period stalls.
> 
> 8.	Remove "extern" from RCU function declarations, courtesy of
> 	Iulia Manda.
> 
> 9.	Apply ACCESS_ONCE() to additional ->jiffies_stall accesses,
> 	courtesy of Himangi Saraogi.
> 
> 10.	Add event tracing to dyntick_save_progress_counter(), courtesy
> 	of Andreea-Cristina Bernat.
> 
> 11.	Make rcu_init_one() use nr_cpu_ids instead of NR_CPUS for
> 	data-structure setup limit check, courtesy of Himangi Saraogi.
> 
> 12.	Remove redundant kfree_call_rcu() definition by using the
> 	rcu_state pointer, courtesy of Andreea-Cristina Bernat.
> 
> 13.	Merge rcu_sched_force_quiescent_state() definition with
> 	rcu_force_quiescent_state() by using the rcu_state pointer,
> 	courtesy of Andreea-Cristina Bernat.
> 
> 14.	Document RCU_INIT_POINTER()'s lack of ordering guarantees.
> 
> 15.	Automatically bind RCU's grace-period kthreads to timekeeping
> 	CPU for NO_HZ_FULL builds.
> 
> 16.	Make large and small sysidle systems use equivalent state machine.
> 
> 17.	Remove duplicate resched_cpu() declaration, courtesy of
> 	Pranith Kumar.
> 
> 18.	Replace deprecated __this_cpu_ptr() uses with raw_cpu_ptr(),
> 	courtesy of Christoph Lameter.
> 
> 19.	Make softirq processing provide a quiescent state only once
> 	per full pass over all softirqs rather than once per action,
> 	courtesy of Eric Dumazet.

For all 19:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
