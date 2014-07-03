Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbaGCBhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 21:37:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:12834 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751424AbaGCBhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 21:37:12 -0400
Date: Wed, 2 Jul 2014 21:37:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [for-next][PATCH] tracing: Remove ftrace_stop/start() from reading
 the trace file
Message-ID: <20140702213710.41f89563@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 099ed151675cd1d2dbeae1dac697975f6a68716d


Steven Rostedt (Red Hat) (1):
      tracing: Remove ftrace_stop/start() from reading the trace file

----
 kernel/trace/trace.c | 2 --
 1 file changed, 2 deletions(-)
---------------------------
commit 099ed151675cd1d2dbeae1dac697975f6a68716d
Author: Steven Rostedt (Red Hat) <rostedt@goodmis.org>
Date:   Tue Jun 24 23:50:09 2014 -0400

    tracing: Remove ftrace_stop/start() from reading the trace file
    
    Disabling reading and writing to the trace file should not be able to
    disable all function tracing callbacks. There's other users today
    (like kprobes and perf). Reading a trace file should not stop those
    from happening.
    
    Cc: stable@vger.kernel.org # 3.0+
    Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 384ede311717..f243444a3772 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1396,7 +1396,6 @@ void tracing_start(void)
 
 	arch_spin_unlock(&global_trace.max_lock);
 
-	ftrace_start();
  out:
 	raw_spin_unlock_irqrestore(&global_trace.start_lock, flags);
 }
@@ -1443,7 +1442,6 @@ void tracing_stop(void)
 	struct ring_buffer *buffer;
 	unsigned long flags;
 
-	ftrace_stop();
 	raw_spin_lock_irqsave(&global_trace.start_lock, flags);
 	if (global_trace.stop_count++)
 		goto out;
