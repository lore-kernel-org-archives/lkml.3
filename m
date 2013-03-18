Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448Ab3CRVQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:16:41 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:40723 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756820Ab3CRVQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:16:39 -0400
Date: Mon, 18 Mar 2013 14:16:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/7] Fixes for 3.9
Message-ID: <20130318211615.GA15814@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031821-2398-0000-0000-0000125123F3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series contains the following fixes for RCU:

1.	Whitespace fix courtesy of Jiang Fang.

2.	Avoid raising softirq from CPUs going offline.

3.	Remove obsolete CPU-hotplug comment, courtesy of Srivatsa Bhat.

4.	Delete unused "wakemask" field.

5.	Fix hlist_bl_set_first_rcu() lockdep annotation, courtesy of
	Steven Whitehouse.

6.	Add softirq-stall indications to stall-warning messages.

7.	Restrict self-torture random delays in RCU grace-period initialization
	to runtime.

							Thanx, Paul


 b/Documentation/RCU/stallwarn.txt |   33 ++++++++++++++++++++++++---------
 b/include/linux/list_bl.h         |    5 +++++
 b/include/linux/rculist_bl.h      |    2 +-
 b/kernel/rcutree.c                |   13 +++++--------
 b/kernel/rcutree.h                |    8 +++++---
 b/kernel/rcutree_plugin.h         |    4 +++-
 6 files changed, 43 insertions(+), 22 deletions(-)

