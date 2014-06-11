Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbaFKCBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 22:01:50 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:11842 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752718AbaFKCBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 22:01:12 -0400
Message-Id: <20140611020108.600070226@goodmis.org>
User-Agent: quilt/0.63-1
Date: Tue, 10 Jun 2014 21:59:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@gmail.com>
Subject: [for-next][PATCH 4/4] tracing: Fix check of ftrace_trace_arrays list_empty() check
References: <20140611015948.013451560@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-tracing-Fix-check-of-ftrace_trace_arrays-list_empty-.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The check that tests if ftrace_trace_arrays is empty in
top_trace_array(), uses the .prev pointer:

  if (list_empty(ftrace_trace_arrays.prev))

instead of testing the variable itself:

  if (list_empty(&ftrace_trace_arrays))

Although it is technically correct, it is awkward and confusing.
Use the proper method.

Link: http://lkml.kernel.org/r/87oay1bas8.fsf@sejong.aot.lge.com

Reported-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 9e82551dd566..9258f5a815db 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -252,7 +252,7 @@ static inline struct trace_array *top_trace_array(void)
 {
 	struct trace_array *tr;
 
-	if (list_empty(ftrace_trace_arrays.prev))
+	if (list_empty(&ftrace_trace_arrays))
 		return NULL;
 
 	tr = list_entry(ftrace_trace_arrays.prev,
-- 
2.0.0.rc2


