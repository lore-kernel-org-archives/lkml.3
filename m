Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934958Ab3GWW2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:28:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41917 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934342Ab3GWW2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:28:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Z Lam <azl@google.com>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Alexander Z Lam <lambchop468@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 098/103] tracing: Make trace_marker use the correct per-instance buffer
Date: Tue, 23 Jul 2013 15:26:49 -0700
Message-Id: <20130723220432.931683311@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Z Lam <azl@google.com>

commit 2d71619c59fac95a5415a326162fa046161b938c upstream.

The trace_marker file was present for each new instance created, but it
added the trace mark to the global trace buffer instead of to
the instance's buffer.

Link: http://lkml.kernel.org/r/1372717885-4543-2-git-send-email-azl@google.com

Signed-off-by: Alexander Z Lam <azl@google.com>
Cc: David Sharp <dhsharp@google.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Alexander Z Lam <lambchop468@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4328,6 +4328,7 @@ tracing_mark_write(struct file *filp, co
 					size_t cnt, loff_t *fpos)
 {
 	unsigned long addr = (unsigned long)ubuf;
+	struct trace_array *tr = filp->private_data;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
 	struct print_entry *entry;
@@ -4387,7 +4388,7 @@ tracing_mark_write(struct file *filp, co
 
 	local_save_flags(irq_flags);
 	size = sizeof(*entry) + cnt + 2; /* possible \n added */
-	buffer = global_trace.trace_buffer.buffer;
+	buffer = tr->trace_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer, TRACE_PRINT, size,
 					  irq_flags, preempt_count());
 	if (!event) {


