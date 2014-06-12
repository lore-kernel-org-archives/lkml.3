Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbaFLWJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 18:09:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbaFLWJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 18:09:30 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 09/17] perf tools: Make perf_session_deliver_event global
Date: Fri, 13 Jun 2014 00:08:25 +0200
Message-Id: <1402610913-19059-10-git-send-email-jolsa@kernel.org>
In-Reply-To: <1402610913-19059-1-git-send-email-jolsa@kernel.org>
References: <1402610913-19059-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making perf_session_deliver_event global function, as it will
be called from another object in following patch.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/session.c | 17 +++++------------
 tools/perf/util/session.h |  6 ++++++
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index fc085c3..08aa245 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -571,13 +571,6 @@ ordered_event_put(struct ordered_events_queue *q, struct ordered_event *iter)
 	q->nr_events--;
 }
 
-
-static int perf_session_deliver_event(struct perf_session *session,
-				      union perf_event *event,
-				      struct perf_sample *sample,
-				      struct perf_tool *tool,
-				      u64 file_offset);
-
 static int __ordered_events_flush(struct perf_session *s,
 				  struct perf_tool *tool)
 {
@@ -1003,11 +996,11 @@ perf_session__deliver_sample(struct perf_session *session,
 					    &sample->read.one, machine);
 }
 
-static int perf_session_deliver_event(struct perf_session *session,
-				      union perf_event *event,
-				      struct perf_sample *sample,
-				      struct perf_tool *tool,
-				      u64 file_offset)
+int perf_session_deliver_event(struct perf_session *session,
+			       union perf_event *event,
+			       struct perf_sample *sample,
+			       struct perf_tool *tool,
+			       u64 file_offset)
 {
 	struct perf_evsel *evsel;
 	struct machine *machine;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index af38954..58acad4 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -69,6 +69,12 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 
 void perf_tool__fill_defaults(struct perf_tool *tool);
 
+int perf_session_deliver_event(struct perf_session *session,
+			       union perf_event *event,
+			       struct perf_sample *sample,
+			       struct perf_tool *tool,
+			       u64 file_offset);
+
 int perf_session__resolve_callchain(struct perf_session *session,
 				    struct perf_evsel *evsel,
 				    struct thread *thread,
-- 
1.8.3.1

