Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935679Ab3DKMGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 08:06:34 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48784 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935359Ab3DKMFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 08:05:40 -0400
X-AuditID: 9c93016f-b7b3fae0000004d3-d8-5166a711f319
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/6] tools lib traceevent: Add trace_seq_reset()
Date: Thu, 11 Apr 2013 21:04:56 +0900
Message-Id: <1365681898-19897-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1365681898-19897-1-git-send-email-namhyung@kernel.org>
References: <1365681898-19897-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Sometimes it'd be useful if existing trace_seq can be reused.  But
currently it's impossible since there's no API to reset the trace_seq.
Let's add trace_seq_reset() for this case.

Cc: Steven Rostedt <rostedt@goodmis.org>
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

