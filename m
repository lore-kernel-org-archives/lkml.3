Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935753Ab3FTDj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 23:39:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32169 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935661Ab3FTDgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 23:36:40 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=22EiQ5FInTMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=bzfvriLXiRUA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=ACiqJx0mWyVRsQkHO8IA:9 a=MSl-tDqOz04A:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=HoHcwx061DMkM95v:21 a=rD9T5Sjv4GvA7GZy:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130620033639.086221025@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Jun 2013 23:35:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        David Sharp <dhsharp@google.com>, Wang YanQing <udknight@gmail.com>
Subject: [for-next][PATCH 04/12] tracing: Fix file mode of free_buffer
References: <20130620033516.003166252@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Fix-file-mode-of-free_buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang YanQing <udknight@gmail.com>

Commit 4f271a2a60c748599b30bb4dafff30d770439b96
(tracing: Add a proc file to stop tracing and free buffer)
implement a method to free up ring buffer in kernel memory
in the release code path of free_buffer's fd.

Then we don't need read/write support for free_buffer,
indeed we just have a dummy write fop, and don't implement read fop.

So the 0200 is more reasonable file mode for free_buffer than
the current file mode 0644.

Link: http://lkml.kernel.org/r/20130526085201.GA3183@udknight

Acked-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Acked-by: David Sharp <dhsharp@google.com>
Signed-off-by: Wang YanQing <udknight@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 1a41023..5f4a09c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5935,7 +5935,7 @@ init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer)
 	trace_create_file("buffer_total_size_kb", 0444, d_tracer,
 			  tr, &tracing_total_entries_fops);
 
-	trace_create_file("free_buffer", 0644, d_tracer,
+	trace_create_file("free_buffer", 0200, d_tracer,
 			  tr, &tracing_free_buffer_fops);
 
 	trace_create_file("trace_marker", 0220, d_tracer,
-- 
1.7.10.4


