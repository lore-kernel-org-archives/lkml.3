Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311Ab3EGNmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:42:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42493 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933281Ab3EGNmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:42:02 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 086/118] tracing: Check return value of tracing_init_dentry()
Date: Tue,  7 May 2013 14:38:52 +0100
Message-Id: <1367933964-1564-87-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung.kim@lge.com>

commit ed6f1c996bfe4b6e520cf7a74b51cd6988d84420 upstream.

Check return value and bail out if it's NULL.

Link: http://lkml.kernel.org/r/1365553093-10180-2-git-send-email-namhyung@kernel.org

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/trace/trace.c       | 2 ++
 kernel/trace/trace_stack.c | 2 ++
 kernel/trace/trace_stat.c  | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 28e2b14..0ae8b32 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4832,6 +4832,8 @@ static __init int tracer_init_debugfs(void)
 	trace_access_lock_init();
 
 	d_tracer = tracing_init_dentry();
+	if (!d_tracer)
+		return 0;
 
 	trace_create_file("tracing_enabled", 0644, d_tracer,
 			&global_trace, &tracing_ctrl_fops);
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 0cdcba3..8298997 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -433,6 +433,8 @@ static __init int stack_trace_init(void)
 	struct dentry *d_tracer;
 
 	d_tracer = tracing_init_dentry();
+	if (!d_tracer)
+		return 0;
 
 	trace_create_file("stack_max_size", 0644, d_tracer,
 			&max_stack_size, &stack_max_size_fops);
diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index 96cffb2..847f88a 100644
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
1.8.1.2

