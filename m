Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab3EZIwT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 04:52:19 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:39613 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab3EZIwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 04:52:17 -0400
Date: Sun, 26 May 2013 16:52:01 +0800
From: Wang YanQing <udknight@gmail.com>
To: rostedt@goodmis.org
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        vnagarnaik@google.com
Subject: [PATCH] tracing: Fix file mode of free_buffer
Message-ID: <20130526085201.GA3183@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, rostedt@goodmis.org,
	fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
	vnagarnaik@google.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4f271a2a60c748599b30bb4dafff30d770439b96
(tracing: Add a proc file to stop tracing and free buffer)
implement a method to free up ring buffer in kernel memory
in the release code path of free_buffer's fd.

Then we don't need read/write support for free_buffer,
indeed we just have a dummy write fop, and don't implement read fop.

So the 0200 is more reasonable file mode for free_buffer than
the current file mode 0644.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 kernel/trace/trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ae6fa2d..02d9875 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5927,7 +5927,7 @@ init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer)
 	trace_create_file("buffer_total_size_kb", 0444, d_tracer,
 			  tr, &tracing_total_entries_fops);
 
-	trace_create_file("free_buffer", 0644, d_tracer,
+	trace_create_file("free_buffer", 0200, d_tracer,
 			  tr, &tracing_free_buffer_fops);
 
 	trace_create_file("trace_marker", 0220, d_tracer,
-- 
1.7.12.4.dirty
