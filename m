Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab3IYBRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:17:35 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37536 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154Ab3IYBRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:17:33 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/3] kthread: Add pointer to vmstat-avoidance patch
Date: Tue, 24 Sep 2013 18:17:22 -0700
Message-Id: <1380071843-30362-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380071843-30362-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130925011657.GA29958@linux.vnet.ibm.com>
 <1380071843-30362-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-0320-0000-0000-0000011D9A44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/kernel-per-CPU-kthreads.txt | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/Documentation/kernel-per-CPU-kthreads.txt b/Documentation/kernel-per-CPU-kthreads.txt
index 32351bf..827104f 100644
--- a/Documentation/kernel-per-CPU-kthreads.txt
+++ b/Documentation/kernel-per-CPU-kthreads.txt
@@ -181,12 +181,17 @@ To reduce its OS jitter, do any of the following:
 		make sure that this is safe on your particular system.
 	d.	It is not possible to entirely get rid of OS jitter
 		from vmstat_update() on CONFIG_SMP=y systems, but you
-		can decrease its frequency by writing a large value to
-		/proc/sys/vm/stat_interval.  The default value is HZ,
-		for an interval of one second.  Of course, larger values
-		will make your virtual-memory statistics update more
-		slowly.  Of course, you can also run your workload at
-		a real-time priority, thus preempting vmstat_update().
+		can decrease its frequency by writing a large value
+		to /proc/sys/vm/stat_interval.	The default value is
+		HZ, for an interval of one second.  Of course, larger
+		values will make your virtual-memory statistics update
+		more slowly.  Of course, you can also run your workload
+		at a real-time priority, thus preempting vmstat_update(),
+		but if your workload is CPU-bound, this is a bad idea.
+		However, there is an RFC patch from Christoph Lameter
+		(based on an earlier one from Gilad Ben-Yossef) that
+		reduces or even eliminates vmstat overhead for some
+		workloads at https://lkml.org/lkml/2013/9/4/379.
 	e.	If running on high-end powerpc servers, build with
 		CONFIG_PPC_RTAS_DAEMON=n.  This prevents the RTAS
 		daemon from running on each CPU every second or so.
-- 
1.8.1.5

