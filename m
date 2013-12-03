Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab3LCMgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 07:36:16 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:48396 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab3LCMgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 07:36:10 -0500
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        fweisbec@gmail.com, linux@arm.linux.org.uk, tony.luck@intel.com,
        fenghua.yu@intel.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, pjt@google.com, fengguang.wu@intel.com
Cc: james.hogan@imgtec.com, alex.shi@linaro.org, jason.low2@hp.com,
        viresh.kumar@linaro.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] nohz_full: unify nohz_full funcs
Date: Tue,  3 Dec 2013 20:35:11 +0800
Message-Id: <1386074112-30754-3-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1386074112-30754-1-git-send-email-alex.shi@linaro.org>
References: <1386074112-30754-1-git-send-email-alex.shi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All other nohz_full funcs named like xxx_nohz_full_xxx.
So renaming wake_up_full_nohz_cpu to wake_up_nohz_full_cpu to unify
funs.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 kernel/sched/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c180860..6c9f9b0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -616,7 +616,7 @@ static void wake_up_idle_cpu(int cpu)
 		smp_send_reschedule(cpu);
 }
 
-static bool wake_up_full_nohz_cpu(int cpu)
+static bool wake_up_nohz_full_cpu(int cpu)
 {
 	if (tick_nohz_full_cpu(cpu)) {
 		if (cpu != smp_processor_id() ||
@@ -630,7 +630,7 @@ static bool wake_up_full_nohz_cpu(int cpu)
 
 void wake_up_nohz_cpu(int cpu)
 {
-	if (!wake_up_full_nohz_cpu(cpu))
+	if (!wake_up_nohz_full_cpu(cpu))
 		wake_up_idle_cpu(cpu);
 }
 
-- 
1.8.1.2

