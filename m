Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbaK1SYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:24:37 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:35163 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaK1SYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:24:34 -0500
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
Subject: [RFC PATCH 13/30] alpha: Convert obsolete cputime_t to nsecs
Date: Fri, 28 Nov 2014 19:23:43 +0100
Message-Id: <1417199040-21044-14-git-send-email-fweisbec@gmail.com>
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
 arch/alpha/kernel/osf_sys.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index a6e4491..03ebb5f 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -1137,7 +1137,7 @@ struct rusage32 {
 SYSCALL_DEFINE2(osf_getrusage, int, who, struct rusage32 __user *, ru)
 {
 	struct rusage32 r;
-	cputime_t utime, stime;
+	u64 utime, stime;
 	unsigned int utime_jiffies, stime_jiffies;
 
 	if (who != RUSAGE_SELF && who != RUSAGE_CHILDREN)
@@ -1146,9 +1146,9 @@ SYSCALL_DEFINE2(osf_getrusage, int, who, struct rusage32 __user *, ru)
 	memset(&r, 0, sizeof(r));
 	switch (who) {
 	case RUSAGE_SELF:
-		task_cputime_t(current, &utime, &stime);
-		utime_jiffies = cputime_to_jiffies(utime);
-		stime_jiffies = cputime_to_jiffies(stime);
+		task_cputime(current, &utime, &stime);
+		utime_jiffies = nsecs_to_jiffies(utime);
+		stime_jiffies = nsecs_to_jiffies(stime);
 		jiffies_to_timeval32(utime_jiffies, &r.ru_utime);
 		jiffies_to_timeval32(stime_jiffies, &r.ru_stime);
 		r.ru_minflt = current->min_flt;
-- 
2.1.3

