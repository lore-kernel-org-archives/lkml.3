Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbaBQV1H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:27:07 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:41611 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbaBQV1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:27:03 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/6] Documentation/kernel-per-CPU-kthreads.txt: Workqueue affinity
Date: Mon, 17 Feb 2014 13:26:51 -0800
Message-Id: <1392672413-5114-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392672413-5114-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217212625.GA4083@linux.vnet.ibm.com>
 <1392672413-5114-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021721-7164-0000-0000-000006266566
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit documents the ability to apply CPU affinity to WQ_SYSFS
workqueues, thus offloading them from the desired worker CPUs.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 Documentation/kernel-per-CPU-kthreads.txt | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/Documentation/kernel-per-CPU-kthreads.txt b/Documentation/kernel-per-CPU-kthreads.txt
index 827104fb9364..f3cd299fcc41 100644
--- a/Documentation/kernel-per-CPU-kthreads.txt
+++ b/Documentation/kernel-per-CPU-kthreads.txt
@@ -162,7 +162,18 @@ Purpose: Execute workqueue requests
 To reduce its OS jitter, do any of the following:
 1.	Run your workload at a real-time priority, which will allow
 	preempting the kworker daemons.
-2.	Do any of the following needed to avoid jitter that your
+2.	A given workqueue can be made visible in the sysfs filesystem
+	by passing the WQ_SYSFS to that workqueue's alloc_workqueue().
+	Such a workqueue can be confined to a given subset of the
+	CPUs using the /sys/devices/virtual/workqueue/*/cpumask sysfs
+	files.	The set of WQ_SYSFS workqueues can be displayed using
+	"ls sys/devices/virtual/workqueue".  That said, the workqueues
+	maintainer would like to caution people against indiscriminately
+	sprinkling WQ_SYSFS across all the workqueues.	The reason for
+	caution is that it is easy to add WQ_SYSFS, but because sysfs is
+	part of the formal user/kernel API, it can be nearly impossible
+	to remove it, even if its addition was a mistake.
+3.	Do any of the following needed to avoid jitter that your
 	application cannot tolerate:
 	a.	Build your kernel with CONFIG_SLUB=y rather than
 		CONFIG_SLAB=y, thus avoiding the slab allocator's periodic
-- 
1.8.1.5

