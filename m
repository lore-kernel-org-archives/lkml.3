Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760635Ab3HOH55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 03:57:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54008 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242Ab3HOH5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 03:57:54 -0400
Date: Thu, 15 Aug 2013 00:57:12 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-e44baa3ea1eaa09d7d247a9b245fcff06561bf96@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1375961547-30267-7-git-send-email-adrian.hunter@intel.com>
References: <1375961547-30267-7-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Remove filter parameter of perf_event__preprocess_sample()
Git-Commit-ID: e44baa3ea1eaa09d7d247a9b245fcff06561bf96
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 15 Aug 2013 00:57:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e44baa3ea1eaa09d7d247a9b245fcff06561bf96
Gitweb:     http://git.kernel.org/tip/e44baa3ea1eaa09d7d247a9b245fcff06561bf96
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Thu, 8 Aug 2013 14:32:25 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 12 Aug 2013 10:31:11 -0300

perf tools: Remove filter parameter of perf_event__preprocess_sample()

Now that the symbol filter is recorded on the machine there is no need
to pass it to perf_event__preprocess_sample().  So remove it.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1375961547-30267-7-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c | 3 +--
 tools/perf/builtin-diff.c     | 2 +-
 tools/perf/builtin-mem.c      | 3 +--
 tools/perf/builtin-report.c   | 3 +--
 tools/perf/builtin-script.c   | 2 +-
 tools/perf/builtin-top.c      | 3 +--
 tools/perf/tests/hists_link.c | 4 ++--
 tools/perf/util/event.c       | 8 ++++----
 tools/perf/util/event.h       | 3 +--
 tools/perf/util/session.c     | 3 +--
 10 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 9754cb1..f988d38 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -90,8 +90,7 @@ static int process_sample_event(struct perf_tool *tool,
 	struct perf_annotate *ann = container_of(tool, struct perf_annotate, tool);
 	struct addr_location al;
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample,
-					  machine->symbol_filter) < 0) {
+	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
 		pr_warning("problem processing %d event, skipping it.\n",
 			   event->header.type);
 		return -1;
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 93de3ac..f28799e 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -319,7 +319,7 @@ static int diff__process_sample_event(struct perf_tool *tool __maybe_unused,
 {
 	struct addr_location al;
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample, NULL) < 0) {
+	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
 		pr_warning("problem processing %d event, skipping it.\n",
 			   event->header.type);
 		return -1;
diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
index f96168c..706a1fa 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -68,8 +68,7 @@ dump_raw_samples(struct perf_tool *tool,
 	struct addr_location al;
 	const char *fmt;
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample,
-				NULL) < 0) {
+	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
 		fprintf(stderr, "problem processing %d event, skipping it.\n",
 				event->header.type);
 		return -1;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f06a5a2..958a56a 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -304,8 +304,7 @@ static int process_sample_event(struct perf_tool *tool,
 	struct addr_location al;
 	int ret;
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample,
-					  machine->symbol_filter) < 0) {
+	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
 		fprintf(stderr, "problem processing %d event, skipping it.\n",
 			event->header.type);
 		return -1;
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 33b2d83..a7d623f 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -520,7 +520,7 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 		return 0;
 	}
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample, 0) < 0) {
+	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
 		pr_err("problem processing %d event, skipping it.\n",
 		       event->header.type);
 		return -1;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index a63ade2..e37521f 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -716,8 +716,7 @@ static void perf_event__process_sample(struct perf_tool *tool,
 	if (event->header.misc & PERF_RECORD_MISC_EXACT_IP)
 		top->exact_samples++;
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample,
-					  machine->symbol_filter) < 0 ||
+	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0 ||
 	    al.filtered)
 		return;
 
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 89085a9..50bfb01 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -220,7 +220,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 			};
 
 			if (perf_event__preprocess_sample(&event, machine, &al,
-							  &sample, 0) < 0)
+							  &sample) < 0)
 				goto out;
 
 			he = __hists__add_entry(&evsel->hists, &al, NULL, 1, 1);
@@ -244,7 +244,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 			};
 
 			if (perf_event__preprocess_sample(&event, machine, &al,
-							  &sample, 0) < 0)
+							  &sample) < 0)
 				goto out;
 
 			he = __hists__add_entry(&evsel->hists, &al, NULL, 1, 1);
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index cc7c0c9..f3cf771 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -683,8 +683,7 @@ void thread__find_addr_location(struct thread *thread, struct machine *machine,
 int perf_event__preprocess_sample(const union perf_event *event,
 				  struct machine *machine,
 				  struct addr_location *al,
-				  struct perf_sample *sample,
-				  symbol_filter_t filter)
+				  struct perf_sample *sample)
 {
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 	struct thread *thread = machine__findnew_thread(machine, event->ip.pid);
@@ -709,7 +708,7 @@ int perf_event__preprocess_sample(const union perf_event *event,
 		machine__create_kernel_maps(machine);
 
 	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
-			      event->ip.ip, al, filter);
+			      event->ip.ip, al, machine->symbol_filter);
 	dump_printf(" ...... dso: %s\n",
 		    al->map ? al->map->dso->long_name :
 			al->level == 'H' ? "[hypervisor]" : "<not found>");
@@ -727,7 +726,8 @@ int perf_event__preprocess_sample(const union perf_event *event,
 						   dso->long_name)))))
 			goto out_filtered;
 
-		al->sym = map__find_symbol(al->map, al->addr, filter);
+		al->sym = map__find_symbol(al->map, al->addr,
+					   machine->symbol_filter);
 	}
 
 	if (symbol_conf.sym_list &&
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 6119a64..15db071 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -234,8 +234,7 @@ struct addr_location;
 int perf_event__preprocess_sample(const union perf_event *self,
 				  struct machine *machine,
 				  struct addr_location *al,
-				  struct perf_sample *sample,
-				  symbol_filter_t filter);
+				  struct perf_sample *sample);
 
 const char *perf_event__name(unsigned int id);
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 4d9028e..de16a77 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1503,8 +1503,7 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 	int print_oneline = print_opts & PRINT_IP_OPT_ONELINE;
 	char s = print_oneline ? ' ' : '\t';
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample,
-					  NULL) < 0) {
+	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
 		error("problem processing %d event, skipping it.\n",
 			event->header.type);
 		return;
