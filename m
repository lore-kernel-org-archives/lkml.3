Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967038AbaFTSeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 14:34:16 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:40017 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757272AbaFTSdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 14:33:32 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, Christoph Lameter <cl@gentwo.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH RFC tip/core/rcu 4/5] rcutorture: Suppress spurious RCU CPU stall warnings
Date: Fri, 20 Jun 2014 11:33:22 -0700
Message-Id: <1403289203-6371-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1403289203-6371-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140620183249.GA6325@linux.vnet.ibm.com>
 <1403289203-6371-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062018-3532-0000-0000-0000029C8147
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Because rcutorture runs CPU-bound in the kernel, it can prevent grace
periods from being reported.  In RCU_COND_RESCHED_QS=y builds, the
cond_resched() calls handle this reporting.  This commit therefore
forces RCU_COND_RESCHED_QS=y for the TREE01 rcutorture configuration,
which is otherwise prone to spurious RCU CPU stall warnings.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
---
 tools/testing/selftests/rcutorture/configs/rcu/TREE01 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE01 b/tools/testing/selftests/rcutorture/configs/rcu/TREE01
index 9c827ec59a97..82e70bc38125 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE01
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE01
@@ -4,6 +4,7 @@ CONFIG_PREEMPT_NONE=n
 CONFIG_PREEMPT_VOLUNTARY=n
 CONFIG_PREEMPT=y
 #CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_COND_RESCHED_QS=y
 CONFIG_HZ_PERIODIC=n
 CONFIG_NO_HZ_IDLE=y
 CONFIG_NO_HZ_FULL=n
-- 
1.8.1.5

