Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab3LBKWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 05:22:35 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:56904 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab3LBKWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 05:22:31 -0500
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] sched: use __weak for arch_update_cpu_topology/sched_clock
Date: Mon,  2 Dec 2013 15:52:14 +0530
Message-Id: <1385979734-495-1-git-send-email-kamalesh@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120210-0260-0000-0000-0000040859B8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use __weak macro instead of __attribute__((weak)).

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
 kernel/sched/clock.c | 2 +-
 kernel/sched/core.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index c3ae1446461c..08c4ea45fbfd 100644
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -72,7 +72,7 @@
  * This is default implementation.
  * Architectures and sub-architectures can override this.
  */
-unsigned long long __attribute__((weak)) sched_clock(void)
+unsigned long long __weak sched_clock(void)
 {
 	return (unsigned long long)(jiffies - INITIAL_JIFFIES)
 					* (NSEC_PER_SEC / HZ);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 87c3bc47d99d..1b051b0f8d93 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5885,7 +5885,7 @@ static cpumask_var_t fallback_doms;
  * cpu core maps. It is supposed to return 1 if the topology changed
  * or 0 if it stayed the same.
  */
-int __attribute__((weak)) arch_update_cpu_topology(void)
+int __weak arch_update_cpu_topology(void)
 {
 	return 0;
 }
-- 
1.8.4.474.g128a96c

