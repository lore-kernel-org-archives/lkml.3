Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759009Ab3EFXbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:31:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36742 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760496Ab3EFXNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:13:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 042/104] tracing: Check return value of tracing_init_dentry()
Date: Mon,  6 May 2013 16:12:01 -0700
Message-Id: <20130506230047.951953260@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506230043.526528358@linuxfoundation.org>
References: <20130506230043.526528358@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung.kim@lge.com>

commit ed6f1c996bfe4b6e520cf7a74b51cd6988d84420 upstream.

Check return value and bail out if it's NULL.

Link: http://lkml.kernel.org/r/1365553093-10180-2-git-send-email-namhyung@kernel.org

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c       |    2 ++
 kernel/trace/trace_stack.c |    2 ++
 kernel/trace/trace_stat.c  |    2 ++
 3 files changed, 6 insertions(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4885,6 +4885,8 @@ static __init int tracer_init_debugfs(vo
 	trace_access_lock_init();
 
 	d_tracer = tracing_init_dentry();
+	if (!d_tracer)
+		return 0;
 
 	trace_create_file("trace_options", 0644, d_tracer,
 			NULL, &tracing_iter_fops);
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -431,6 +431,8 @@ static __init int stack_trace_init(void)
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


