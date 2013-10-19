Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab3JSAoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 20:44:04 -0400
Received: from mail-gg0-f170.google.com ([209.85.161.170]:60847 "EHLO
	mail-gg0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab3JSAoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 20:44:03 -0400
X-Greylist: delayed 1415 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Oct 2013 20:44:03 EDT
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: kernel-br@googlegroups.com
Cc: "Geyslan G. Bem" <geyslan@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3] tracing: creates 'tracing_is_disabled()'
Date: Fri, 18 Oct 2013 21:15:54 -0300
Message-Id: <1382141754-12155-1-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates the function 'tracing_is_disabled', which
can be used outside trace.c.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 kernel/trace/trace.c | 5 +++++
 kernel/trace/trace.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7974ba2..d7ceaf6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2964,6 +2964,11 @@ int tracing_open_generic(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+bool tracing_is_disabled(void)
+{
+	return (tracing_disabled) ? true: false;
+}
+
 /*
  * Open and update trace_array ref count.
  * Must have the current trace_array passed to it.
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 10c86fb..5deaa3b 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -514,6 +514,7 @@ void tracing_reset_online_cpus(struct trace_buffer *buf);
 void tracing_reset_current(int cpu);
 void tracing_reset_all_online_cpus(void);
 int tracing_open_generic(struct inode *inode, struct file *filp);
+bool tracing_is_disabled(void);
 struct dentry *trace_create_file(const char *name,
 				 umode_t mode,
 				 struct dentry *parent,
-- 
1.8.4

