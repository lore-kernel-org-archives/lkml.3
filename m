Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422764AbaD3OcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:32:15 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52346 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759229AbaD3Oav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:30:51 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Michael Matz <matz@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [RFC 08/16] kgr: sched.h, introduce kgr_task_safe helper
Date: Wed, 30 Apr 2014 16:30:41 +0200
Message-Id: <1398868249-26169-9-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
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
index 25f54c79f757..afd5747bc7ff 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2969,6 +2969,15 @@ static inline void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
 }
 #endif /* CONFIG_MM_OWNER */
 
+#ifdef CONFIG_KGR
+static inline void kgr_task_safe(struct task_struct *p)
+{
+	task_thread_info(p)->kgr_in_progress = false;
+}
+#else
+static inline void kgr_task_safe(struct task_struct *p) { }
+#endif /* CONFIG_KGR */
+
 static inline unsigned long task_rlimit(const struct task_struct *tsk,
 		unsigned int limit)
 {
-- 
1.9.2

