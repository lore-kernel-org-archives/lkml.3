Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbbAGRc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:32:28 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:50236 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117AbbAGRcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:32:25 -0500
Date: Wed, 7 Jan 2015 09:32:15 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: [PATCH tip/core/rcu 0/14] Preemptible-RCU updates for 3.20
Message-ID: <20150107173215.GA897@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0017-0000-0000-000007BD7B61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series fixes some problems in preemptible RCU.

1.	Protect rcu_boost() lockless accesses with ACCESS_ONCE().

2-11.	Fix a low-probability long-standing bug in preemptible RCU that
	could occur in systems with more than 16 CPUs, but only if a full
	bank of 16 CPUs (as in 0-15, 16-31, 32-47, ...) was taken offline.
	See http://paulmck.livejournal.com/37782.html for more details.

12.	Revert old commit that worked around an rt_mutex bug.  This old
	commit could cause priority inversion, and the rt_mutex bug has
	long since been fixed.  Courtesy of Lai Jiangshan.

13.	Simplify grace-period code, enabled by 2-11 above.

14.	Remove redundant RCU callback list initialization.

							Thanx, Paul

------------------------------------------------------------------------

 b/kernel/rcu/tree.c        |  115 +++++++++++++-------------
 b/kernel/rcu/tree.h        |   24 -----
 b/kernel/rcu/tree_plugin.h |  196 ++++++++++-----------------------------------
 3 files changed, 102 insertions(+), 233 deletions(-)

