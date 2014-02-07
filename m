Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbaBGLuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:50:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42000 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858AbaBGLuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:50:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 127/233] tracing: Have trace buffer point back to trace_array
Date: Fri,  7 Feb 2014 11:45:46 +0000
Message-Id: <1391773652-25214-128-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit dced341b2d4f06668efaab33f88de5d287c0f45b upstream.

The trace buffer has a descriptor pointer that goes back to the trace
array. But it was never assigned. Luckily, nothing uses it (yet), but
it will in the future.

Although nothing currently uses this, if any of the new features get
backported to older kernels, and because this is such a simple change,
I'm marking it for stable too.

Fixes: 12883efb670c "tracing: Consolidate max_tr into main trace_array structure"
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/trace/trace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 207f5fc..878785b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5875,6 +5875,8 @@ allocate_trace_buffer(struct trace_array *tr, struct trace_buffer *buf, int size
 
 	rb_flags = trace_flags & TRACE_ITER_OVERWRITE ? RB_FL_OVERWRITE : 0;
 
+	buf->tr = tr;
+
 	buf->buffer = ring_buffer_alloc(size, rb_flags);
 	if (!buf->buffer)
 		return -ENOMEM;
-- 
1.8.3.2

