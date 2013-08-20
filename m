Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab3HTCl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:41:57 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:39494 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab3HTClz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:41:55 -0400
Date: Mon, 19 Aug 2013 19:41:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/9] v2 Fixes for 3.12
Message-ID: <20130820024148.GA30283@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082002-2398-0000-0000-000001A46E7E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series contains a number of miscellaneous fixes:

1.	Switch to expedited grace periods during hibernation and
	suspend/resume operations (courtesy of Borislav Petkov and
	Bjørn Mork).

2.	Make RCU debugobjects fixup actions leak callbacks rather than
	risking corrupting the callback lists.

3.	Propagate above callback leaking to debugobjects's callers.

4.	Make call_rcu() leak callbacks when debugobjects indicates an error.

5.	Avoid needless self-wakeups from the grace-period kthreads.

6.	Make list_first_or_null_rcu() use list_entry_rcu() (courtesy of
	Tejun Heo).

7.	Fix irq_work_queue() build error for TREE_PREEMPT_RCU for some
	configurations (courtesy of James Hogan).

8.	Simplify _rcu_barrier() processing per Linus Torvalds feedback.

9.	Avoid signed-overflow undefined behavior in time_after() and friends.

Changes since v1 (https://lkml.org/lkml/2013/8/17/106):

o	Merge v1 patches 1, 2, and 6 into the new patch 1.

o	Apply other review comments from Josh Triplett.

							Thanx, Paul


 b/include/linux/debugobjects.h |    6 +-
 b/include/linux/jiffies.h      |    8 +--
 b/include/linux/rculist.h      |    5 +-
 b/init/Kconfig                 |    1 
 b/kernel/rcu.h                 |   10 ++--
 b/kernel/rcupdate.c            |  100 -----------------------------------------
 b/kernel/rcutree.c             |   58 +++++++++++++++++++++--
 b/lib/debugobjects.c           |   20 +++++---
 8 files changed, 84 insertions(+), 124 deletions(-)

