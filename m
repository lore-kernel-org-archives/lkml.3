Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909Ab3HMGyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:54:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60507 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab3HMGdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Z Lam <azl@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        David Sharp <dhsharp@google.com>,
        Alexander Z Lam <lambchop468@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 23/60] tracing: Make TRACE_ITER_STOP_ON_FREE stop the correct buffer
Date: Mon, 12 Aug 2013 23:33:50 -0700
Message-Id: <20130813063335.133666440@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
References: <20130813063331.950321483@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Z Lam <azl@google.com>

commit 711e124379e0f889e40e2f01d7f5d61936d3cd23 upstream.

Releasing the free_buffer file in an instance causes the global buffer
to be stopped when TRACE_ITER_STOP_ON_FREE is enabled. Operate on the
correct buffer.

Link: http://lkml.kernel.org/r/1375493777-17261-1-git-send-email-azl@google.com

Signed-off-by: Alexander Z Lam <azl@google.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: David Sharp <dhsharp@google.com>
Cc: Alexander Z Lam <lambchop468@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4438,7 +4438,7 @@ tracing_free_buffer_release(struct inode
 
 	/* disable tracing ? */
 	if (trace_flags & TRACE_ITER_STOP_ON_FREE)
-		tracing_off();
+		tracer_tracing_off(tr);
 	/* resize the ring buffer to 0 */
 	tracing_resize_ring_buffer(tr, 0, RING_BUFFER_ALL_CPUS);
 


