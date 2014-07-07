Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbaGHACK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:02:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56091 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbaGGXzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:55:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3.10 42/53] tracing: Remove ftrace_stop/start() from reading the trace file
Date: Mon,  7 Jul 2014 16:58:27 -0700
Message-Id: <20140707235830.559825904@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235829.281783607@linuxfoundation.org>
References: <20140707235829.281783607@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 099ed151675cd1d2dbeae1dac697975f6a68716d upstream.

Disabling reading and writing to the trace file should not be able to
disable all function tracing callbacks. There's other users today
(like kprobes and perf). Reading a trace file should not stop those
from happening.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c |    2 --
 1 file changed, 2 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1306,7 +1306,6 @@ void tracing_start(void)
 
 	arch_spin_unlock(&ftrace_max_lock);
 
-	ftrace_start();
  out:
 	raw_spin_unlock_irqrestore(&global_trace.start_lock, flags);
 }
@@ -1353,7 +1352,6 @@ void tracing_stop(void)
 	struct ring_buffer *buffer;
 	unsigned long flags;
 
-	ftrace_stop();
 	raw_spin_lock_irqsave(&global_trace.start_lock, flags);
 	if (global_trace.stop_count++)
 		goto out;


