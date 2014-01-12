Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaALSgM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:36:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45735 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaALSgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:36:09 -0500
Date: Sun, 12 Jan 2014 10:35:35 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-fspmnjadohrik8uvhytyu8lp@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf scripting python:
  Shorten function signatures
Git-Commit-ID: b7fff6b5f977115be1757f18b1aca928803b1e17
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:35:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b7fff6b5f977115be1757f18b1aca928803b1e17
Gitweb:     http://git.kernel.org/tip/b7fff6b5f977115be1757f18b1aca928803b1e17
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 19 Dec 2013 16:34:52 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Dec 2013 16:34:52 -0300

perf scripting python: Shorten function signatures

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
index 53c20e7..fc00792 100644
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
 
