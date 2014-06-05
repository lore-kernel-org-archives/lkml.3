Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaFESX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 14:23:28 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:63849 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751761AbaFESX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 14:23:27 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsENAOS0kFNXQDfT/2dsb2JhbABZgwesCQUBmCeBDxd0gwIjgRo3iEYB0zsXhVWIfR2EKgSPTopFiyCIGYM6Ow
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] kernel/trace/ring_buffer.c: kernel-doc warning fixes
Date: Thu,  5 Jun 2014 20:22:05 +0200
Message-Id: <1401992525-10417-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also fixes some typo.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/trace/ring_buffer.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index c634868..7c778e7 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1261,6 +1261,7 @@ static int rb_cpu_notify(struct notifier_block *self,
  * __ring_buffer_alloc - allocate a new ring_buffer
  * @size: the size in bytes per cpu that is needed.
  * @flags: attributes to set for the ring buffer.
+ * @key: ring buffer reader_lock_key.
  *
  * Currently the only flag that is available is the RB_FL_OVERWRITE
  * flag. This flag means that the buffer will overwrite old data
@@ -1985,9 +1986,11 @@ rb_add_time_stamp(struct ring_buffer_event *event, u64 delta)
 
 /**
  * rb_update_event - update event type and data
- * @event: the even to update
- * @type: the type of event
+ * @cpu_buffer: ring buffer for one cpu
+ * @event: the event to update
  * @length: the size of the event field in the ring buffer
+ * @add_timestamp: bool to indicate whether to call rb_add_time_stamp
+ * @delta: event delta time
  *
  * Update the type and data fields of the event. The length
  * is the actual size that is written to the ring buffer,
@@ -2005,7 +2008,7 @@ rb_update_event(struct ring_buffer_per_cpu *cpu_buffer,
 
 	/*
 	 * If we need to add a timestamp, then we
-	 * add it to the start of the resevered space.
+	 * add it to the start of the reserved space.
 	 */
 	if (unlikely(add_timestamp)) {
 		event = rb_add_time_stamp(event, delta);
@@ -4104,6 +4107,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_read);
 /**
  * ring_buffer_size - return the size of the ring buffer (in bytes)
  * @buffer: The ring buffer.
+ * @cpu: The CPU to get ring buffer size from.
  */
 unsigned long ring_buffer_size(struct ring_buffer *buffer, int cpu)
 {
@@ -4281,6 +4285,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_empty_cpu);
  * ring_buffer_swap_cpu - swap a CPU buffer between two ring buffers
  * @buffer_a: One buffer to swap with
  * @buffer_b: The other buffer to swap with
+ * @cpu: the CPU of the buffers to swap
  *
  * This function is useful for tracers that want to take a "snapshot"
  * of a CPU buffer and has another back up buffer lying around.
-- 
1.8.4.5

