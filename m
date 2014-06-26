Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbaFZQ64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 12:58:56 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:25973 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757250AbaFZQ6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:58:50 -0400
Message-Id: <20140626165848.347125039@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 26 Jun 2014 12:52:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>
Subject: [RFA][PATCH 03/27] tracing: Remove ftrace_stop/start() from reading the trace file
References: <20140626165221.736847419@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-tracing-Remove-ftrace_stop-start-from-reading-the-tr.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Disabling reading and writing to the trace file should not be able to
disable all function tracing callbacks. There's other users today
(like kprobes and perf). Reading a trace file should not stop those
from happening.

Cc: stable@vger.kernel.org # 3.0+
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index eeb233cbac4f..433a50ffc73e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1372,7 +1372,6 @@ void tracing_start(void)
 
 	arch_spin_unlock(&global_trace.max_lock);
 
-	ftrace_start();
  out:
 	raw_spin_unlock_irqrestore(&global_trace.start_lock, flags);
 }
@@ -1419,7 +1418,6 @@ void tracing_stop(void)
 	struct ring_buffer *buffer;
 	unsigned long flags;
 
-	ftrace_stop();
 	raw_spin_lock_irqsave(&global_trace.start_lock, flags);
 	if (global_trace.stop_count++)
 		goto out;
-- 
2.0.0


