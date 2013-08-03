Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab3HCMwS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 08:52:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33677 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab3HCMvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 08:51:19 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=TPv2m8cUTs4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=BxbpTROx1iAA:10 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=NGQO8fUsbffoyszA4oYA:9 a=T_MzRWcqBuIA:10 a=UTB_XpHje0EA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130803125117.549439473@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 03 Aug 2013 08:49:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        David Sharp <dhsharp@google.com>,
        Alexander Z Lam <lambchop468@gmail.com>, <stable@vger.kernel.org>,
        Alexander Z Lam <azl@google.com>
Subject: [for-next-3.11][PATCH 3/4] tracing: Make TRACE_ITER_STOP_ON_FREE stop the correct buffer
References: <20130803124926.157378122@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Make-TRACE_ITER_STOP_ON_FREE-stop-the-correc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Z Lam <azl@google.com>

Releasing the free_buffer file in an instance causes the global buffer
to be stopped when TRACE_ITER_STOP_ON_FREE is enabled. Operate on the
correct buffer.

Link: http://lkml.kernel.org/r/1375493777-17261-1-git-send-email-azl@google.com

Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: David Sharp <dhsharp@google.com>
Cc: Alexander Z Lam <lambchop468@gmail.com>
Cc: stable@vger.kernel.org # 3.10
Signed-off-by: Alexander Z Lam <azl@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f5b35a5..531c9e6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4469,7 +4469,7 @@ tracing_free_buffer_release(struct inode *inode, struct file *filp)
 
 	/* disable tracing ? */
 	if (trace_flags & TRACE_ITER_STOP_ON_FREE)
-		tracing_off();
+		tracer_tracing_off(tr);
 	/* resize the ring buffer to 0 */
 	tracing_resize_ring_buffer(tr, 0, RING_BUFFER_ALL_CPUS);
 
-- 
1.7.10.4


