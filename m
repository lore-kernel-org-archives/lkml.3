Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab3HBCz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 22:55:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11299 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab3HBCzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 22:55:54 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=pLRrZGBxcl0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=yIoR4pxNN6gA:10 a=X1UelijY-h7xnH-9RKwA:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130802025553.476238847@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 01 Aug 2013 22:49:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next-3.11][PATCH 3/5] tracing: Add comment to describe special break case in
 probe_remove_event_call()
References: <20130802024924.999067099@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Add-comment-to-describe-special-break-case-i.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The "break" used in the do_for_each_event_file() is used as an optimization
as the loop is really a double loop. The loop searches all event files
for each trace_array. There's only one matching event file per trace_array
and after we find the event file for the trace_array, the break is used
to jump to the next trace_array and start the search there.

As this is not a standard way of using "break" in C code, it requires
a comment right before the break to let people know what is going on.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index ec04836..29a7ebc 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1732,6 +1732,12 @@ static int probe_remove_event_call(struct ftrace_event_call *call)
 		 */
 		if (file->flags & FTRACE_EVENT_FL_ENABLED)
 			return -EBUSY;
+		/*
+		 * The do_for_each_event_file_safe() is
+		 * a double loop. After finding the call for this
+		 * trace_array, we use break to jump to the next
+		 * trace_array.
+		 */
 		break;
 	} while_for_each_event_file();
 
-- 
1.7.10.4


