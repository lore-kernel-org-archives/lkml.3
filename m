Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbbAGSTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:19:25 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:55607 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbbAGSTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:19:24 -0500
Date: Wed, 7 Jan 2015 10:19:15 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: [PATCH tip/core/rcu 0/12] rcutorture changes for 3.20
Message-ID: <20150107181915.GA7803@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010718-0033-0000-0000-0000033D3AF1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series contains rcutorture updates for 3.20:

1.	Issue warnings on close calls due to Reader Batch blows.
	This diagnostic would have spotted the ugly preemptible-RCU
	CPU-hotplug bug some years back.

2.	Make _batches_completed() functions return unsigned long to
	avoid signed overflow issues.

3.	Make build-output parsing correctly flag RCU's warnings.
	These needed to be updated when the "rcu" directory was created
	in "kernel."

4.	Use unsigned long for Reader Batch computations, avoiding
	signed overflow.

5.	Provide rcu_batches_completed_sched() for TINY_RCU for new
	rcutorture compatibility.

6.	Drop rcu_torture_completed() and friends.  Now that the types
	match, the wrappers aren't needed.

7.	Remove redundant rcu_batches_completed() declaration.

8.	Check from beginning to end of grace period instead of from
	end of previous grace period to end of next one.  This makes
	rcutorture more sensitive to RCU bugs that make the grace
	period too short.

9.	Handle different mpstat versions -- new versions added fields.

10.	torture: Add "-enable-kvm -soundhw pcspk" to qemu command line,
	as newer versions of qemu complain if they are missing.

11.	Flag console.log file to prevent holdovers from earlier runs,
	which could make a run look successful when it didn't even get
	to the point of starting qemu.

12.	Add more diagnostics in rcu_barrier() test failure case.

							Thanx, Paul

------------------------------------------------------------------------

 b/include/linux/rcutiny.h                                   |   42 ++++++
 b/include/linux/rcutree.h                                   |    9 -
 b/kernel/rcu/rcutorture.c                                   |   74 ++++++------
 b/kernel/rcu/tree.c                                         |   44 ++++++-
 b/kernel/rcu/tree.h                                         |    3 
 b/kernel/rcu/tree_plugin.h                                  |   34 -----
 b/tools/testing/selftests/rcutorture/bin/cpus2use.sh        |    2 
 b/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh |   18 ++
 b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh  |    9 -
 b/tools/testing/selftests/rcutorture/bin/parse-build.sh     |   20 ++-
 10 files changed, 166 insertions(+), 89 deletions(-)

