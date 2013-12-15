Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab3LOQqu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 11:46:50 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:46124 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab3LOQqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 11:46:48 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>,
        David Daney <david.daney@cavium.com>, Michal Hocko <mhocko@suse.cz>,
        liguang <lig.fnst@cn.fujitsu.com>, Christoph Hellwig <hch@lst.de>,
        Ingo Molnar <mingo@kernel.org>, Wang YanQing <udknight@gmail.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        linux-arch@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v3 [resend] 16/18] smp: cleanup unsued generic_smp_call_function_single_interrupt()
Date: Mon, 16 Dec 2013 00:36:38 +0800
Message-Id: <1387125400-28849-17-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1387125400-28849-1-git-send-email-liuj97@gmail.com>
References: <1387125400-28849-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Now we have killed all usage of generic_smp_call_function_single_interrupt()
from arch code, so kill it.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Shaohua Li <shli@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Kosina <trivial@kernel.org>
Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 include/linux/smp.h | 7 ++++---
 kernel/smp.c        | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 5da22ee..5261608 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -107,9 +107,10 @@ void kick_all_cpus_sync(void);
  * Generic and arch helpers
  */
 void __init call_function_init(void);
-void generic_smp_call_function_single_interrupt(void);
-#define generic_smp_call_function_interrupt \
-	generic_smp_call_function_single_interrupt
+void smp_call_function_interrupt(void);
+#define generic_smp_call_function_interrupt	smp_call_function_interrupt
+#define generic_smp_call_function_single_interrupt \
+	smp_call_function_interrupt
 
 /*
  * Mark the boot cpu "online" so that it can call console drivers in
diff --git a/kernel/smp.c b/kernel/smp.c
index 25c19af..144a427 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -167,7 +167,7 @@ static void generic_exec_single(int cpu, struct call_single_data *csd, int wait)
  * Invoked by arch to handle an IPI for call function single. Must be
  * called from the arch with interrupts disabled.
  */
-void generic_smp_call_function_single_interrupt(void)
+void smp_call_function_interrupt(void)
 {
 	struct call_single_queue *q = &__get_cpu_var(call_single_queue);
 	LIST_HEAD(list);
-- 
1.8.1.2

