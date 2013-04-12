Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab3DLXS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 19:18:57 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52389 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306Ab3DLXSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 19:18:55 -0400
Date: Fri, 12 Apr 2013 16:18:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, sasha.levin@oracle.com,
        paul.gortmaker@windriver.com, paulus@au1.ibm.com
Subject: [PATCH tip/core/rcu 0/7] RCU fixes for 3.11
Message-ID: <20130412231846.GA20038@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041223-5806-0000-0000-000020B62100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series contains the following fixes for RCU:

1-2.	Convert remaining printk() calls to pr_*().

3.	Kick adaptive-ticks CPUs that are holding up RCU grace periods.

4.	Don't allocate bootmem from rcu_init(), courtesy of Sasha Levin.

5.	Remove "Experimental" flags from old RCU Kconfig options.

6.	Automatically tune defaults for delays between attempts to
	force quiescent states.

7.	Merge adjacent identical #ifdefs.

							Thanx, Paul

 b/init/Kconfig            |    2 -
 b/kernel/rcupdate.c       |    3 -
 b/kernel/rcutree.c        |   34 ++++++++++++++++++---
 b/kernel/rcutree.h        |   13 +++++++-
 b/kernel/rcutree_plugin.h |   74 +++++++++++++++++++++++++++-------------------
 5 files changed, 87 insertions(+), 39 deletions(-)

