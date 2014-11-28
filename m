Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbaK1SYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:24:46 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45428 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaK1SYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:24:43 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC PATCH 18/30] delaycct: Convert obsolete cputime type to nsecs
Date: Fri, 28 Nov 2014 19:23:48 +0100
Message-Id: <1417199040-21044-19-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/delayacct.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/delayacct.c b/kernel/delayacct.c
index 8cf2179..7719063 100644
--- a/kernel/delayacct.c
+++ b/kernel/delayacct.c
@@ -82,19 +82,19 @@ void __delayacct_blkio_end(void)
 
 int __delayacct_add_tsk(struct taskstats *d, struct task_struct *tsk)
 {
-	cputime_t utime, stime, stimescaled, utimescaled;
+	u64 utime, stime, stimescaled, utimescaled;
 	unsigned long long t2, t3;
 	unsigned long flags, t1;
 	s64 tmp;
 
-	task_cputime_t(tsk, &utime, &stime);
+	task_cputime(tsk, &utime, &stime);
 	tmp = (s64)d->cpu_run_real_total;
-	tmp += cputime_to_nsecs(utime + stime);
+	tmp += utime + stime;
 	d->cpu_run_real_total = (tmp < (s64)d->cpu_run_real_total) ? 0 : tmp;
 
-	task_cputime_t_scaled(tsk, &utimescaled, &stimescaled);
+	task_cputime_scaled(tsk, &utimescaled, &stimescaled);
 	tmp = (s64)d->cpu_scaled_run_real_total;
-	tmp += cputime_to_nsecs(utimescaled + stimescaled);
+	tmp += utimescaled + stimescaled;
 	d->cpu_scaled_run_real_total =
 		(tmp < (s64)d->cpu_scaled_run_real_total) ? 0 : tmp;
 
-- 
2.1.3

