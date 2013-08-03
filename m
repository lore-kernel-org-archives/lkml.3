Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab3HCBgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 21:36:42 -0400
Received: from mail-qe0-f73.google.com ([209.85.128.73]:34810 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab3HCBgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 21:36:41 -0400
From: Alexander Z Lam <azl@google.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: Alexander Z Lam <azl@google.com>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Alexander Z Lam <lambchop468@gmail.com>
Subject: [PATCH 1/3] tracing: Make TRACE_ITER_STOP_ON_FREE stop the correct buffer
Date: Fri,  2 Aug 2013 18:36:15 -0700
Message-Id: <1375493777-17261-1-git-send-email-azl@google.com>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Releasing the free_buffer file in an instance causes the global buffer
to be stopped when TRACE_ITER_STOP_ON_FREE is enabled. Operate on the
correct buffer.

Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: David Sharp <dhsharp@google.com>
Cc: Alexander Z Lam <lambchop468@gmail.com>
Signed-off-by: Alexander Z Lam <azl@google.com>
---
 kernel/trace/trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 882ec1d..9bfb889 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4468,7 +4468,7 @@ tracing_free_buffer_release(struct inode *inode, struct file *filp)
 
 	/* disable tracing ? */
 	if (trace_flags & TRACE_ITER_STOP_ON_FREE)
-		tracing_off();
+		tracer_tracing_off(tr);
 	/* resize the ring buffer to 0 */
 	tracing_resize_ring_buffer(tr, 0, RING_BUFFER_ALL_CPUS);
 
-- 
1.8.3

