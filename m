Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbaFXN7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 09:59:07 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:56445 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbaFXN7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 09:59:02 -0400
Date: Tue, 24 Jun 2014 06:58:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, tglx@linutronix.de,
        cl@linux.com, dave.hansen@intel.com, ak@linux.intel.com,
        umgwanakikbuti@gmail.com, eric.dumazet@gmail.com,
        josh@joshtriplett.org, oleg@redhat.com
Subject: [GIT PULL rcu/urgent] Fixes for 3.16
Message-ID: <20140624135857.GA3203@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062413-0928-0000-0000-000002E22828
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

This series includes the following:

1.	Export a pair of debug-object interfaces for RCU that will
	allow the slab allocators to avoid a recursion bug located
	by Sasha Levin.  Strictly speaking, this is not a regression,
	but it would be good to enable the fix.

2.	Address a serious performance regression on an open/close
	micro-benchmark located by Dave Hansen.  The offending commit
	is ac1bea85781e (Make cond_resched() report RCU quiescent states).

Both have been exposed to -next testing, and are available in the git
repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git urgent.2014.06.23a

for you to fetch changes up to 4a81e8328d3791a4f99bf5b436d050f6dc5ffea3:

  rcu: Reduce overhead of cond_resched() checks for RCU (2014-06-23 11:19:32 -0700)

----------------------------------------------------------------
Paul E. McKenney (2):
      rcu: Export debug_init_rcu_head() and and debug_init_rcu_head()
      rcu: Reduce overhead of cond_resched() checks for RCU

 Documentation/kernel-parameters.txt |   6 ++
 include/linux/rcupdate.h            |  46 +++---------
 kernel/rcu/tree.c                   | 140 ++++++++++++++++++++++++++++--------
 kernel/rcu/tree.h                   |   6 +-
 kernel/rcu/tree_plugin.h            |   2 +-
 kernel/rcu/update.c                 |  22 +-----
 kernel/sched/core.c                 |   7 +-
 7 files changed, 137 insertions(+), 92 deletions(-)

