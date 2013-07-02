Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab3GBUZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 16:25:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27520 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab3GBUY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 16:24:29 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=XrtkpNR1l9oA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=4BDUDByp_24A:10 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=apwOGbc3lYfst3biVFkA:9 a=f18MsngyTacA:10 a=UTB_XpHje0EA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130702202426.964214759@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 02 Jul 2013 16:22:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Alexander Z Lam <lambchop468@gmail.com>, <stable@vger.kernel.org>,
        Alexander Z Lam <azl@google.com>
Subject: [for-next][PATCH 11/14] tracing: Make trace_marker use the correct per-instance buffer
References: <20130702202216.623562799@goodmis.org>
Content-Disposition: inline; filename=0011-tracing-Make-trace_marker-use-the-correct-per-instan.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Z Lam <azl@google.com>

The trace_marker file was present for each new instance created, but it
added the trace mark to the global trace buffer instead of to
the instance's buffer.

Link: http://lkml.kernel.org/r/1372717885-4543-2-git-send-email-azl@google.com

Cc: David Sharp <dhsharp@google.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Alexander Z Lam <lambchop468@gmail.com>
Cc: stable@vger.kernel.org # 3.10
Signed-off-by: Alexander Z Lam <azl@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0dc5071..e04e711 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4391,6 +4391,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 					size_t cnt, loff_t *fpos)
 {
 	unsigned long addr = (unsigned long)ubuf;
+	struct trace_array *tr = filp->private_data;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
 	struct print_entry *entry;
@@ -4450,7 +4451,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 
 	local_save_flags(irq_flags);
 	size = sizeof(*entry) + cnt + 2; /* possible \n added */
-	buffer = global_trace.trace_buffer.buffer;
+	buffer = tr->trace_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer, TRACE_PRINT, size,
 					  irq_flags, preempt_count());
 	if (!event) {
-- 
1.7.10.4


