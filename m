Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab3LTTKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:10:46 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38542 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab3LTTJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:09:33 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 29/35] perf scripting python: Shorten function signatures
Date: Fri, 20 Dec 2013 16:09:04 -0300
Message-Id: <1387566550-3524-30-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387566550-3524-1-git-send-email-acme@infradead.org>
References: <1387566550-3524-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Removing unused parameters.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-fspmnjadohrik8uvhytyu8lp@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../util/scripting-engines/trace-event-python.c    | 26 ++++++++--------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 53c20e7fd900..fc007926eb1c 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -231,13 +231,10 @@ static inline struct event_format *find_cache_event(struct perf_evsel *evsel)
 	return event;
 }
 
-static void python_process_tracepoint(union perf_event *perf_event
-				      __maybe_unused,
-				 struct perf_sample *sample,
-				 struct perf_evsel *evsel,
-				 struct machine *machine __maybe_unused,
-				 struct thread *thread,
-				 struct addr_location *al)
+static void python_process_tracepoint(struct perf_sample *sample,
+				      struct perf_evsel *evsel,
+				      struct thread *thread,
+				      struct addr_location *al)
 {
 	PyObject *handler, *retval, *context, *t, *obj, *dict = NULL;
 	static char handler_name[256];
@@ -351,11 +348,8 @@ static void python_process_tracepoint(union perf_event *perf_event
 	Py_DECREF(t);
 }
 
-static void python_process_general_event(union perf_event *perf_event
-					 __maybe_unused,
-					 struct perf_sample *sample,
+static void python_process_general_event(struct perf_sample *sample,
 					 struct perf_evsel *evsel,
-					 struct machine *machine __maybe_unused,
 					 struct thread *thread,
 					 struct addr_location *al)
 {
@@ -411,22 +405,20 @@ exit:
 	Py_DECREF(t);
 }
 
-static void python_process_event(union perf_event *perf_event,
+static void python_process_event(union perf_event *event __maybe_unused,
 				 struct perf_sample *sample,
 				 struct perf_evsel *evsel,
-				 struct machine *machine,
+				 struct machine *machine __maybe_unused,
 				 struct thread *thread,
 				 struct addr_location *al)
 {
 	switch (evsel->attr.type) {
 	case PERF_TYPE_TRACEPOINT:
-		python_process_tracepoint(perf_event, sample, evsel,
-					  machine, thread, al);
+		python_process_tracepoint(sample, evsel, thread, al);
 		break;
 	/* Reserve for future process_hw/sw/raw APIs */
 	default:
-		python_process_general_event(perf_event, sample, evsel,
-					     machine, thread, al);
+		python_process_general_event(sample, evsel, thread, al);
 	}
 }
 
-- 
1.8.1.4

