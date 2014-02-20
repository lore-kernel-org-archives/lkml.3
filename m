Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbaBTKdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:33:16 -0500
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:49170 "EHLO
	anemoi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752168AbaBTKdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:33:11 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: rostedt@goodmis.org
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 6/6] ftrace: fix compilation warning about control_ops_free
Date: Thu, 20 Feb 2014 11:33:07 +0100
Message-Id: <1392892387-26826-6-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1392892387-26826-1-git-send-email-jslaby@suse.cz>
References: <1392892387-26826-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_DYNAMIC_FTRACE=n, I see a warning:
kernel/trace/ftrace.c:240:13: warning: 'control_ops_free' defined but not used
 static void control_ops_free(struct ftrace_ops *ops)
             ^
Add an ifdef block with CONFIG_DYNAMIC_FTRACE around that function as
it is used solely from the dynamic function tracing functions.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/ftrace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 6e30412a5902..cf97b56b986c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -237,10 +237,12 @@ static int control_ops_alloc(struct ftrace_ops *ops)
 	return 0;
 }
 
+#ifdef CONFIG_DYNAMIC_FTRACE
 static void control_ops_free(struct ftrace_ops *ops)
 {
 	free_percpu(ops->disabled);
 }
+#endif
 
 static void update_global_ops(void)
 {
-- 
1.8.5.2

