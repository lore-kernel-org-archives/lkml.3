Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbaATPBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 10:01:09 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:47631 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752179AbaATPBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 10:01:07 -0500
Message-Id: <20140120150105.317964292@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 20 Jan 2014 10:00:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 1/2] tracing: Have trace buffer point back to trace_array
References: <20140120150042.470689818@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Have-trace-buffer-point-back-to-trace_array.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The trace buffer has a descriptor pointer that goes back to the trace
array. But it was never assigned. Luckily, nothing uses it (yet), but
it will in the future.

Although nothing currently uses this, if any of the new features get
backported to older kernels, and because this is such a simple change,
I'm marking it for stable too.

Cc: stable@vger.kernel.org # v3.10+
Fixes: 12883efb670c "tracing: Consolidate max_tr into main trace_array structure"
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e32a2f4..cee9c1a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5914,6 +5914,8 @@ allocate_trace_buffer(struct trace_array *tr, struct trace_buffer *buf, int size
 
 	rb_flags = trace_flags & TRACE_ITER_OVERWRITE ? RB_FL_OVERWRITE : 0;
 
+	buf->tr = tr;
+
 	buf->buffer = ring_buffer_alloc(size, rb_flags);
 	if (!buf->buffer)
 		return -ENOMEM;
-- 
1.8.4.3


