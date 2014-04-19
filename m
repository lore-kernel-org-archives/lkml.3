Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaDSN7N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 09:59:13 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:40304 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbaDSN7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 09:59:10 -0400
From: Lin Yongting <linyongting@gmail.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, linyongting@gmail.com,
        linyongting@huawei.com
Subject: [PATCH] tracing: Correct braces usage in if-else statement
Date: Sat, 19 Apr 2014 21:58:23 +0800
Message-Id: <1397915903-21326-1-git-send-email-linyongting@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some incorrect braces usages in kernerl/trace/trace.c, including:
1. Missing braces in 'if' or 'else' branch.
2. Unnecessary braces in 'if' statement.

Fix them according to kernel CodeStyle.

Signed-off-by: Lin Yongting <linyongting@gmail.com>
---
 kernel/trace/trace.c |   39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 737b0ef..1028f68 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -488,8 +488,9 @@ int __trace_puts(unsigned long ip, const char *str, int size)
 	if (entry->buf[size - 1] != '\n') {
 		entry->buf[size] = '\n';
 		entry->buf[size + 1] = '\0';
-	} else
+	} else {
 		entry->buf[size] = '\0';
+	}
 
 	__buffer_unlock_commit(buffer, event);
 
@@ -891,9 +892,9 @@ int trace_get_user(struct trace_parser *parser, const char __user *ubuf,
 
 	/* read the non-space input */
 	while (cnt && !isspace(ch)) {
-		if (parser->idx < parser->size - 1)
+		if (parser->idx < parser->size - 1) {
 			parser->buffer[parser->idx++] = ch;
-		else {
+		} else {
 			ret = -EINVAL;
 			goto out;
 		}
@@ -1756,9 +1757,10 @@ static void __ftrace_trace_stack(struct ring_buffer *buffer,
 
 		if (trace.nr_entries > size)
 			size = trace.nr_entries;
-	} else
+	} else {
 		/* From now on, use_stack is a boolean */
 		use_stack = 0;
+	}
 
 	size *= sizeof(unsigned long);
 
@@ -1770,10 +1772,10 @@ static void __ftrace_trace_stack(struct ring_buffer *buffer,
 
 	memset(&entry->caller, 0, size);
 
-	if (use_stack)
+	if (use_stack) {
 		memcpy(&entry->caller, trace.entries,
 		       trace.nr_entries * sizeof(unsigned long));
-	else {
+	} else {
 		trace.max_entries	= FTRACE_STACK_ENTRIES;
 		trace.entries		= entry->caller;
 		if (regs)
@@ -2398,8 +2400,9 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 		if (cpu_file == RING_BUFFER_ALL_CPUS) {
 			for_each_tracing_cpu(cpu)
 				tracing_iter_reset(iter, cpu);
-		} else
+		} else {
 			tracing_iter_reset(iter, cpu_file);
+		}
 
 		iter->leftover = 0;
 		for (p = iter; p && l < *pos; p = s_next(m, p, &l))
@@ -2410,9 +2413,9 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 		 * If we overflowed the seq_file before, then we want
 		 * to just reuse the trace_seq buffer again.
 		 */
-		if (iter->leftover)
+		if (iter->leftover) {
 			p = iter;
-		else {
+		} else {
 			l = *pos - 1;
 			p = s_next(m, p, &l);
 		}
@@ -2460,9 +2463,10 @@ get_total_entries(struct trace_buffer *buf,
 			count -= per_cpu_ptr(buf->data, cpu)->skipped_entries;
 			/* total is the same as the entries */
 			*total += count;
-		} else
+		} else {
 			*total += count +
 				ring_buffer_overrun_cpu(buf->buffer, cpu);
+		}
 		*entries += count;
 	}
 }
@@ -4251,9 +4255,8 @@ static int tracing_wait_pipe(struct file *filp)
 
 	while (trace_empty(iter)) {
 
-		if ((filp->f_flags & O_NONBLOCK)) {
+		if ((filp->f_flags & O_NONBLOCK))
 			return -EAGAIN;
-		}
 
 		mutex_unlock(&iter->mutex);
 
@@ -4560,10 +4563,12 @@ tracing_entries_read(struct file *filp, char __user *ubuf,
 					    trace_buf_size >> 10);
 			else
 				r = sprintf(buf, "%lu\n", size >> 10);
-		} else
+		} else {
 			r = sprintf(buf, "X\n");
-	} else
+		}
+	} else {
 		r = sprintf(buf, "%lu\n", per_cpu_ptr(tr->trace_buffer.data, cpu)->entries >> 10);
+	}
 
 	mutex_unlock(&trace_types_lock);
 
@@ -4734,14 +4739,16 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 		len = PAGE_SIZE - offset;
 		memcpy(&entry->buf, map_page[0] + offset, len);
 		memcpy(&entry->buf[len], map_page[1], cnt - len);
-	} else
+	} else {
 		memcpy(&entry->buf, map_page[0] + offset, cnt);
+	}
 
 	if (entry->buf[cnt - 1] != '\n') {
 		entry->buf[cnt] = '\n';
 		entry->buf[cnt + 1] = '\0';
-	} else
+	} else {
 		entry->buf[cnt] = '\0';
+	}
 
 	__buffer_unlock_commit(buffer, event);
 
-- 
1.7.9.5

