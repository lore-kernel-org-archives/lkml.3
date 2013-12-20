Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab3LTTKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:10:00 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38541 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab3LTTJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:09:32 -0500
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
Subject: [PATCH 30/35] perf scripting perl: Shorten function signatures
Date: Fri, 20 Dec 2013 16:09:05 -0300
Message-Id: <1387566550-3524-31-git-send-email-acme@infradead.org>
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
Link: http://lkml.kernel.org/n/tip-b7r7o80o2xwwtlzgqxv50foe@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/scripting-engines/trace-event-perl.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index d5e5969f6fea..b672ef0ae46d 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -257,12 +257,9 @@ static inline struct event_format *find_cache_event(struct perf_evsel *evsel)
 	return event;
 }
 
-static void perl_process_tracepoint(union perf_event *perf_event __maybe_unused,
-				    struct perf_sample *sample,
+static void perl_process_tracepoint(struct perf_sample *sample,
 				    struct perf_evsel *evsel,
-				    struct machine *machine __maybe_unused,
-				    struct thread *thread,
-					struct addr_location *al)
+				    struct thread *thread)
 {
 	struct format_field *field;
 	static char handler[256];
@@ -349,10 +346,7 @@ static void perl_process_tracepoint(union perf_event *perf_event __maybe_unused,
 
 static void perl_process_event_generic(union perf_event *event,
 				       struct perf_sample *sample,
-				       struct perf_evsel *evsel,
-				       struct machine *machine __maybe_unused,
-				       struct thread *thread __maybe_unused,
-					   struct addr_location *al __maybe_unused)
+				       struct perf_evsel *evsel)
 {
 	dSP;
 
@@ -377,12 +371,12 @@ static void perl_process_event_generic(union perf_event *event,
 static void perl_process_event(union perf_event *event,
 			       struct perf_sample *sample,
 			       struct perf_evsel *evsel,
-			       struct machine *machine,
+			       struct machine *machine __maybe_unused,
 			       struct thread *thread,
-				   struct addr_location *al)
+			       struct addr_location *al __maybe_unused)
 {
-	perl_process_tracepoint(event, sample, evsel, machine, thread, al);
-	perl_process_event_generic(event, sample, evsel, machine, thread, al);
+	perl_process_tracepoint(sample, evsel, thread);
+	perl_process_event_generic(event, sample, evsel);
 }
 
 static void run_start_sub(void)
-- 
1.8.1.4

