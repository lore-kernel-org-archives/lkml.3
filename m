Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbaALSgY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:36:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45749 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaALSgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:36:19 -0500
Date: Sun, 12 Jan 2014 10:35:45 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-b7r7o80o2xwwtlzgqxv50foe@git.kernel.org>
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
Subject: [tip:perf/core] perf scripting perl: Shorten function signatures
Git-Commit-ID: 8853a1b76288d79aa1a6c5b8fe623d892aa9958b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:35:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8853a1b76288d79aa1a6c5b8fe623d892aa9958b
Gitweb:     http://git.kernel.org/tip/8853a1b76288d79aa1a6c5b8fe623d892aa9958b
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 19 Dec 2013 16:39:31 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Dec 2013 16:39:31 -0300

perf scripting perl: Shorten function signatures

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
index d5e5969..b672ef0 100644
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
