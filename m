Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbaFYLJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:09:53 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41088 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754251AbaFYLHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:07:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        akpm@linux-foundation.org, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, pavel@ucw.cz, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH -repost 08/21] kgr: sched.h, introduce kgr_task_safe helper
Date: Wed, 25 Jun 2014 13:07:02 +0200
Message-Id: <1403694435-3180-8-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403694435-3180-1-git-send-email-jslaby@suse.cz>
References: <1403694435-3180-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be used from some kthreads.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 include/linux/sched.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 306f4f0c987a..6bc2d63a59c4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2974,6 +2974,15 @@ static inline void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
 }
 #endif /* CONFIG_MEMCG */
 
+#if IS_ENABLED(CONFIG_KGRAFT)
+static inline void kgr_task_safe(struct task_struct *p)
+{
+	clear_bit(0, &task_thread_info(p)->kgr_in_progress);
+}
+#else
+static inline void kgr_task_safe(struct task_struct *p) { }
+#endif /* IS_ENABLED(CONFIG_KGRAFT) */
+
 static inline unsigned long task_rlimit(const struct task_struct *tsk,
 		unsigned int limit)
 {
-- 
2.0.0

