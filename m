Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab3ERCWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:22:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14848 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756282Ab3ERCQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:53 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=jPzcQIAsqpkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=-zyTm3uoH7wA:10 a=57SyGIRnAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=96YRe1ugZkpV7VPq8I4A:9 a=lSinr4eg3GwA:10 a=TIV7c6GJmisA:10 a=LI9Vle30uBYA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=oLwyzbZlm0ePq8Nh:21 a=UglAtHElMSXebxWA:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021647.037483563@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [ 033/136 ] tracing: Check return value of tracing_init_dentry()
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0033-tracing-Check-return-value-of-tracing_init_dentry.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung.kim@lge.com>

[ Upstream commit ed6f1c996bfe4b6e520cf7a74b51cd6988d84420 ]

Check return value and bail out if it's NULL.

Link: http://lkml.kernel.org/r/1365553093-10180-2-git-send-email-namhyung@kernel.org

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: stable@vger.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c       |    2 ++
 kernel/trace/trace_stack.c |    2 ++
 kernel/trace/trace_stat.c  |    2 ++
 3 files changed, 6 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index bf2c50b..4a568ba 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4848,6 +4848,8 @@ static __init int tracer_init_debugfs(void)
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
1.7.10.4


