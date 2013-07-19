Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935220Ab3GSHq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:46:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35324 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935048Ab3GSHqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:46:19 -0400
Date: Fri, 19 Jul 2013 00:46:00 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-6a48aec3a7179b0cdae2339d5a4072214ee6c6fe@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1370323231-14022-5-git-send-email-namhyung@kernel.org>
References: <1370323231-14022-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Add trace_seq_reset()
Git-Commit-ID: 6a48aec3a7179b0cdae2339d5a4072214ee6c6fe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:46:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6a48aec3a7179b0cdae2339d5a4072214ee6c6fe
Gitweb:     http://git.kernel.org/tip/6a48aec3a7179b0cdae2339d5a4072214ee6c6fe
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 4 Jun 2013 14:20:19 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:52:12 -0300

tools lib traceevent: Add trace_seq_reset()

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
