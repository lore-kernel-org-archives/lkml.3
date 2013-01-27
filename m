Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab3A0A35 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 19:29:57 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:40650 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab3A0A34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 19:29:56 -0500
Date: Sat, 26 Jan 2013 16:14:54 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/10] v2 RCU fixes for 3.9
Message-ID: <20130127001454.GA2682@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012700-7606-0000-0000-000007C878F1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

The following fixes are intended for 3.9:

1.	Fix int/long type confusion in trace_rcu_start_batch().
2.	Declare rcu_is_cpu_rrupt_from_idle() static, courtesy of
	Josh Triplett.
3.	Make rcu_eqs_enter_common() trace the new nesting value instead
	of zero, courtesy of Li Zhong.
4.	Silence a gcc array-out-of-bounds false positive in rcu_init_one().
5.	Code style fix in rcu_torture_barrier_init(), courtesy of Sasha Levin.
6.	Grammar fix to rcu_scheduler_active comment, courtesy of Cody
	Schafer.
7.	Consolidate RCU's debugging Kconfig options, courtesy of Dave Hansen.
8.	Remove unused context-tracker functions, courtesy of Li Zhong.
9.	Remove obsolete Kconfig option from header comment.
10.	Add comments to new context-tracking functions and internals,
	courtesy of Frederic Weisbecker.

Changes since v1:

o	Added #7-#10.

							Thanx, Paul


 b/include/linux/rcupdate.h   |    2 
 b/include/trace/events/rcu.h |    6 +-
 b/kernel/context_tracking.c  |   75 ++++++++++++++++++++++++----
 b/kernel/rcutiny.c           |    2 
 b/kernel/rcutorture.c        |    2 
 b/kernel/rcutree.c           |   13 ++--
 b/kernel/rcutree.h           |    4 -
 b/lib/Kconfig.debug          |  114 ++++++++++++++++++++++---------------------
 8 files changed, 137 insertions(+), 81 deletions(-)

