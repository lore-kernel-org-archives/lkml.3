Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237AbaGTV4r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 17:56:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbaGTV4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 17:56:45 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 09/19] perf tools: Make perf_session_deliver_event global
Date: Sun, 20 Jul 2014 23:55:53 +0200
Message-Id: <1405893363-21967-10-git-send-email-jolsa@kernel.org>
In-Reply-To: <1405893363-21967-1-git-send-email-jolsa@kernel.org>
References: <1405893363-21967-1-git-send-email-jolsa@kernel.org>
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
 tools/perf/util/session.c | 16 +++++-----------
 tools/perf/util/session.h |  6 ++++++
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 64c58e6f0923..a601f2aa8990 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -573,12 +573,6 @@ ordered_events_delete(struct ordered_events *oe, struct ordered_event *event)
 	oe->nr_events--;
 }
 
-static int perf_session_deliver_event(struct perf_session *session,
-				      union perf_event *event,
-				      struct perf_sample *sample,
-				      struct perf_tool *tool,
-				      u64 file_offset);
-
 static int __ordered_events_flush(struct perf_session *s,
 				  struct perf_tool *tool)
 {
@@ -1005,11 +999,11 @@ perf_session__deliver_sample(struct perf_session *session,
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
index a09e3c8d825a..07d1a6d94f67 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -72,6 +72,12 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 
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

