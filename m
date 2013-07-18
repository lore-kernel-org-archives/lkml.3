Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430Ab3GRTuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:50:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41451 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759396Ab3GRTuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:20 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 21/76] tools lib traceevent: Add trace_seq_reset()
Date: Thu, 18 Jul 2013 16:49:08 -0300
Message-Id: <1374177003-3706-22-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Sometimes it'd be useful if existing trace_seq can be reused.  But
currently it's impossible since there's no API to reset the trace_seq.
Let's add trace_seq_reset() for this case.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1370323231-14022-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.h |  1 +
 tools/lib/traceevent/trace-seq.c   | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index bfceab9..39f0c1d 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -69,6 +69,7 @@ struct trace_seq {
 };
 
 void trace_seq_init(struct trace_seq *s);
+void trace_seq_reset(struct trace_seq *s);
 void trace_seq_destroy(struct trace_seq *s);
 
 extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
diff --git a/tools/lib/traceevent/trace-seq.c b/tools/lib/traceevent/trace-seq.c
index a57db80..d7f2e68 100644
--- a/tools/lib/traceevent/trace-seq.c
+++ b/tools/lib/traceevent/trace-seq.c
@@ -49,6 +49,19 @@ void trace_seq_init(struct trace_seq *s)
 }
 
 /**
+ * trace_seq_reset - re-initialize the trace_seq structure
+ * @s: a pointer to the trace_seq structure to reset
+ */
+void trace_seq_reset(struct trace_seq *s)
+{
+	if (!s)
+		return;
+	TRACE_SEQ_CHECK(s);
+	s->len = 0;
+	s->readpos = 0;
+}
+
+/**
  * trace_seq_destroy - free up memory of a trace_seq
  * @s: a pointer to the trace_seq to free the buffer
  *
-- 
1.8.1.4

