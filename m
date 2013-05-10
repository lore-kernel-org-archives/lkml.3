Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab3EJOWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:22:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57311 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756065Ab3EJOWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:22:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        "Namhyung Kim" <namhyung.kim@lge.com>,
        "Namhyung Kim" <namhyung@kernel.org>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.252602522@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [027/118] tracing: Check return value of tracing_init_dentry()
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung.kim@lge.com>

commit ed6f1c996bfe4b6e520cf7a74b51cd6988d84420 upstream.

Check return value and bail out if it's NULL.

Link: http://lkml.kernel.org/r/1365553093-10180-2-git-send-email-namhyung@kernel.org

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/trace/trace.c       |    2 ++
 kernel/trace/trace_stack.c |    2 ++
 kernel/trace/trace_stat.c  |    2 ++
 3 files changed, 6 insertions(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4563,6 +4563,8 @@ static __init int tracer_init_debugfs(vo
 	trace_access_lock_init();
 
 	d_tracer = tracing_init_dentry();
+	if (!d_tracer)
+		return 0;
 
 	trace_create_file("tracing_enabled", 0644, d_tracer,
 			&global_trace, &tracing_ctrl_fops);
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -411,6 +411,8 @@ static __init int stack_trace_init(void)
 	struct dentry *d_tracer;
 
 	d_tracer = tracing_init_dentry();
+	if (!d_tracer)
+		return 0;
 
 	trace_create_file("stack_max_size", 0644, d_tracer,
 			&max_stack_size, &stack_max_size_fops);
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -307,6 +307,8 @@ static int tracing_stat_init(void)
 	struct dentry *d_tracing;
 
 	d_tracing = tracing_init_dentry();
+	if (!d_tracing)
+		return 0;
 
 	stat_dir = debugfs_create_dir("trace_stat", d_tracing);
 	if (!stat_dir)

