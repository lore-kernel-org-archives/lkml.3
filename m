Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbaBQWat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:30:49 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:52110 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbaBQWNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:12 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 06/55] rcutorture: Reduce SRCU-N number of CPUs
Date: Mon, 17 Feb 2014 14:12:10 -0800
Message-Id: <1392675179-11560-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-1542-0000-0000-00000652D9CC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Both SRCU-P and SRCU-N specify eight CPUs, which results in four
iterations for a parallel run on 32 CPUs.  This commit reduces SRCU-N
to four CPUs (but leaving SRCU-P at eight) to speed up parallel runs,
while maintaining essentially the same test coverage.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/configs/SRCU-N | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/rcutorture/configs/SRCU-N b/tools/testing/selftests/rcutorture/configs/SRCU-N
index 10a0e27f4c75..b4c6340d920a 100644
--- a/tools/testing/selftests/rcutorture/configs/SRCU-N
+++ b/tools/testing/selftests/rcutorture/configs/SRCU-N
@@ -1,6 +1,6 @@
 CONFIG_RCU_TRACE=n
 CONFIG_SMP=y
-CONFIG_NR_CPUS=8
+CONFIG_NR_CPUS=4
 CONFIG_HOTPLUG_CPU=y
 CONFIG_PREEMPT_NONE=y
 CONFIG_PREEMPT_VOLUNTARY=n
-- 
1.8.1.5

