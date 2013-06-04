Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662Ab3FDFUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 01:20:44 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:62012 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145Ab3FDFUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 01:20:35 -0400
X-AuditID: 9c930179-b7c07ae000000e33-2d-51ad7921149c
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 04/16] tools lib traceevent: Add trace_seq_reset()
Date: Tue,  4 Jun 2013 14:20:19 +0900
Message-Id: <1370323231-14022-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370323231-14022-1-git-send-email-namhyung@kernel.org>
References: <1370323231-14022-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Sometimes it'd be useful if existing trace_seq can be reused.  But
currently it's impossible since there's no API to reset the trace_seq.
Let's add trace_seq_reset() for this case.

Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.h |  1 +
 tools/lib/traceevent/trace-seq.c   | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index bfceab948f22..39f0c1dca915 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -69,6 +69,7 @@ struct trace_seq {
 };
 
 void trace_seq_init(struct trace_seq *s);
+void trace_seq_reset(struct trace_seq *s);
 void trace_seq_destroy(struct trace_seq *s);
 
 extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
diff --git a/tools/lib/traceevent/trace-seq.c b/tools/lib/traceevent/trace-seq.c
index a57db805136a..d7f2e68bc5b9 100644
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
1.7.11.7

