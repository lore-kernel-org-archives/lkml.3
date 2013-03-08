Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933589Ab3CHDHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 22:07:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24181 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759548Ab3CHDGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 22:06:54 -0500
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=uDYApKD6tegA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=DeNa8rmPTecA:10 a=20KFwNOVAAAA:8 a=9z8n9I-v10junTpXZj8A:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130308030652.139891944@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 07 Mar 2013 22:00:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [for-next][PATCH 02/17] tracing: Add comment for trace event flag IGNORE_ENABLE
References: <20130308025958.501479677@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Add-comment-for-trace-event-flag-IGNORE_ENAB.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <srostedt@redhat.com>

All the trace event flags have comments but the IGNORE_ENABLE flag
which is set for ftrace internal events that should not be enabled
via the debugfs "enable" file. That is, if the top level enable file
is set, it will enable all events. It use to just check the ftrace
event call descriptor "reg" field and skip those whithout it, but now
some ftrace internal events have a reg field but still need to be
skipped. The flag was created to ignore those events.

Now document it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 4d79d2d..0b0814d 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -204,6 +204,7 @@ enum {
  *  FILTERED	  - The event has a filter attached
  *  CAP_ANY	  - Any user can enable for perf
  *  NO_SET_FILTER - Set when filter has error and is to be ignored
+ *  IGNORE_ENABLE - For ftrace internal events, do not enable with debugfs file
  */
 enum {
 	TRACE_EVENT_FL_FILTERED		= (1 << TRACE_EVENT_FL_FILTERED_BIT),
-- 
1.7.10.4


