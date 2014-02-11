Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbaBKVE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:04:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39536 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbaBKTFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:05:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3.13 003/120] tracing: Have trace buffer point back to trace_array
Date: Tue, 11 Feb 2014 11:04:04 -0800
Message-Id: <20140211184823.602284779@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
References: <20140211184823.492407127@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5883,6 +5883,8 @@ allocate_trace_buffer(struct trace_array
 
 	rb_flags = trace_flags & TRACE_ITER_OVERWRITE ? RB_FL_OVERWRITE : 0;
 
+	buf->tr = tr;
+
 	buf->buffer = ring_buffer_alloc(size, rb_flags);
 	if (!buf->buffer)
 		return -ENOMEM;


