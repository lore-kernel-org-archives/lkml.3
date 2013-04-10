Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964855Ab3DJASV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 20:18:21 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46928 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765447Ab3DJASU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 20:18:20 -0400
X-AuditID: 9c93016f-b7b3fae0000004d3-f9-5164afcac3af
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 2/3] tracing: Check return value of tracing_init_dentry()
Date: Wed, 10 Apr 2013 09:18:12 +0900
Message-Id: <1365553093-10180-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1365553093-10180-1-git-send-email-namhyung@kernel.org>
References: <1365553093-10180-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Check return value and bail out if it's NULL.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace.c       | 2 ++
 kernel/trace/trace_stack.c | 2 ++
 kernel/trace/trace_stat.c  | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 829b2bee24e8..7270460cfe3c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5953,6 +5953,8 @@ static __init int tracer_init_debugfs(void)
 	trace_access_lock_init();
 
 	d_tracer = tracing_init_dentry();
+	if (!d_tracer)
+		return 0;
 
 	init_tracer_debugfs(&global_trace, d_tracer);
 
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index aab277b67fa9..8c3f37e2dc43 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -431,6 +431,8 @@ static __init int stack_trace_init(void)
 	struct dentry *d_tracer;
 
 	d_tracer = tracing_init_dentry();
+	if (!d_tracer)
+		return 0;
 
 	trace_create_file("stack_max_size", 0644, d_tracer,
 			&max_stack_size, &stack_max_size_fops);
diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index 96cffb269e73..847f88a6194b 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -307,6 +307,8 @@ static int tracing_stat_init(void)
 	struct dentry *d_tracing;
 
 	d_tracing = tracing_init_dentry();
+	if (!d_tracing)
+		return 0;
 
 	stat_dir = debugfs_create_dir("trace_stat", d_tracing);
 	if (!stat_dir)
-- 
1.7.11.7

