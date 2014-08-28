Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbaH1TMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:12:38 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:45042 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbaH1TMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 15:12:31 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 01/11] rcutorture: Fix a sparse warning by marking boost_mutex static
Date: Thu, 28 Aug 2014 12:12:13 -0700
Message-Id: <1409253143-31466-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20140828191203.GA26955@linux.vnet.ibm.com>
References: <20140828191203.GA26955@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082819-1344-0000-0000-000003CABFB9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pranith Kumar <bobby.prani@gmail.com>

This commit fixes the following sparse warning by marking boost_mutex
static:

kernel/rcu/rcutorture.c:185:1: warning: symbol 'boost_mutex' was not declared. Should it be static?

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcu/rcutorture.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 948a7693748e..7e67711cbae8 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -182,7 +182,7 @@ static u64 notrace rcu_trace_clock_local(void)
 #endif /* #else #ifdef CONFIG_RCU_TRACE */
 
 static unsigned long boost_starttime;	/* jiffies of next boost test start. */
-DEFINE_MUTEX(boost_mutex);		/* protect setting boost_starttime */
+static DEFINE_MUTEX(boost_mutex);	/* protect setting boost_starttime */
 					/*  and boost task create/destroy. */
 static atomic_t barrier_cbs_count;	/* Barrier callbacks registered. */
 static bool barrier_phase;		/* Test phase. */
-- 
1.8.1.5

