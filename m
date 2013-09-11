Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab3IKQLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:11:34 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:47463 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab3IKQLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:11:30 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: [RFC PATCH v2 23/25] smp: cleanup unsued generic_smp_call_function_single_interrupt()
Date: Thu, 12 Sep 2013 00:07:27 +0800
Message-Id: <1378915649-16395-24-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378915649-16395-1-git-send-email-liuj97@gmail.com>
References: <1378915649-16395-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Now we have killed all usage of generic_smp_call_function_single_interrupt()
from arch code, so kill it.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
---
 include/linux/smp.h | 4 +---
 kernel/smp.c        | 2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index c181399..3b6226c 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -87,9 +87,7 @@ void kick_all_cpus_sync(void);
  */
 #ifdef CONFIG_USE_GENERIC_SMP_HELPERS
 void __init call_function_init(void);
-void generic_smp_call_function_single_interrupt(void);
-#define generic_smp_call_function_interrupt \
-	generic_smp_call_function_single_interrupt
+void generic_smp_call_function_interrupt(void);
 #else
 static inline void call_function_init(void) { }
 #endif
diff --git a/kernel/smp.c b/kernel/smp.c
index a034712..9fbf12a 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -165,7 +165,7 @@ void generic_exec_single(int cpu, struct call_single_data *csd, int wait)
  * Invoked by arch to handle an IPI for call function single. Must be
  * called from the arch with interrupts disabled.
  */
-void generic_smp_call_function_single_interrupt(void)
+void generic_smp_call_function_interrupt(void)
 {
 	struct call_single_queue *q = &__get_cpu_var(call_single_queue);
 	LIST_HEAD(list);
-- 
1.8.1.2

