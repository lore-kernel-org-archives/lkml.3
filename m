Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaJRHIR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 03:08:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51690 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbaJRHIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 03:08:09 -0400
Date: Sat, 18 Oct 2014 00:07:26 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-535aeaae7de821ba5d43ee2a204ee667ca95aae4@git.kernel.org>
Cc: hpa@zytor.com, tglx@linutronix.de, fweisbec@gmail.com, jolsa@kernel.org,
        andi@firstfloor.org, mingo@kernel.org, acme@redhat.com,
        tommy24@gatech.edu, paulus@samba.org, namhyung@kernel.org,
        cjashfor@linux.vnet.ibm.com, eranian@google.com,
        a.p.zijlstra@chello.nl, dsahern@gmail.com,
        linux-kernel@vger.kernel.org
Reply-To: linux-kernel@vger.kernel.org, dsahern@gmail.com, eranian@google.com,
        a.p.zijlstra@chello.nl, cjashfor@linux.vnet.ibm.com,
        tommy24@gatech.edu, namhyung@kernel.org, paulus@samba.org,
        mingo@kernel.org, andi@firstfloor.org, acme@redhat.com,
        jolsa@kernel.org, fweisbec@gmail.com, tglx@linutronix.de,
        hpa@zytor.com
In-Reply-To: <1408977943-16594-9-git-send-email-jolsa@kernel.org>
References: <1408977943-16594-9-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf script: Add period data column
Git-Commit-ID: 535aeaae7de821ba5d43ee2a204ee667ca95aae4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  535aeaae7de821ba5d43ee2a204ee667ca95aae4
Gitweb:     http://git.kernel.org/tip/535aeaae7de821ba5d43ee2a204ee667ca95aae4
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Mon, 25 Aug 2014 16:45:42 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 17 Oct 2014 15:21:30 -0300

perf script: Add period data column

Adding period data column to be displayed in perf script.  It's possible
to get period values using -f option, like:

  $ perf script -f comm,tid,time,period,ip,sym,dso
          :26019 26019 52414.329088:       3707  ffffffff8105443a native_write_msr_safe ([kernel.kallsyms])
          :26019 26019 52414.329088:         44  ffffffff8105443a native_write_msr_safe ([kernel.kallsyms])
          :26019 26019 52414.329093:       1987  ffffffff8105443a native_write_msr_safe ([kernel.kallsyms])
          :26019 26019 52414.329093:          6  ffffffff8105443a native_write_msr_safe ([kernel.kallsyms])
              ls 26019 52414.329442:     537558        3407c0639c _dl_map_object_from_fd (/usr/lib64/ld-2.17.so)
              ls 26019 52414.329442:       2099        3407c0639c _dl_map_object_from_fd (/usr/lib64/ld-2.17.so)
              ls 26019 52414.330181:    1242100        34080917bb get_next_seq (/usr/lib64/libc-2.17.so)
              ls 26019 52414.330181:       3774        34080917bb get_next_seq (/usr/lib64/libc-2.17.so)
              ls 26019 52414.331427:    1083662  ffffffff810c7dc2 update_curr ([kernel.kallsyms])
              ls 26019 52414.331427:        360  ffffffff810c7dc2 update_curr ([kernel.kallsyms])

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: "Jen-Cheng(Tommy) Huang" <tommy24@gatech.edu>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jen-Cheng(Tommy) Huang <tommy24@gatech.edu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1408977943-16594-9-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-script.txt |  2 +-
 tools/perf/builtin-script.c              | 12 +++++++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index 5a0160d..2149480 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -115,7 +115,7 @@ OPTIONS
 -f::
 --fields::
         Comma separated list of fields to print. Options are:
-        comm, tid, pid, time, cpu, event, trace, ip, sym, dso, addr, symoff, srcline.
+        comm, tid, pid, time, cpu, event, trace, ip, sym, dso, addr, symoff, srcline, period.
         Field list can be prepended with the type, trace, sw or hw,
         to indicate to which event type the field list applies.
         e.g., -f sw:comm,tid,time,ip,sym  and -f trace:time,cpu,trace
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 6b4925f..0659dff 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -44,6 +44,7 @@ enum perf_output_field {
 	PERF_OUTPUT_ADDR            = 1U << 10,
 	PERF_OUTPUT_SYMOFFSET       = 1U << 11,
 	PERF_OUTPUT_SRCLINE         = 1U << 12,
+	PERF_OUTPUT_PERIOD          = 1U << 13,
 };
 
 struct output_option {
@@ -63,6 +64,7 @@ struct output_option {
 	{.str = "addr",  .field = PERF_OUTPUT_ADDR},
 	{.str = "symoff", .field = PERF_OUTPUT_SYMOFFSET},
 	{.str = "srcline", .field = PERF_OUTPUT_SRCLINE},
+	{.str = "period", .field = PERF_OUTPUT_PERIOD},
 };
 
 /* default set to maintain compatibility with current format */
@@ -229,6 +231,11 @@ static int perf_evsel__check_attr(struct perf_evsel *evsel,
 					PERF_OUTPUT_CPU))
 		return -EINVAL;
 
+	if (PRINT_FIELD(PERIOD) &&
+		perf_evsel__check_stype(evsel, PERF_SAMPLE_PERIOD, "PERIOD",
+					PERF_OUTPUT_PERIOD))
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -448,6 +455,9 @@ static void process_event(union perf_event *event, struct perf_sample *sample,
 
 	print_sample_start(sample, thread, evsel);
 
+	if (PRINT_FIELD(PERIOD))
+		printf("%10" PRIu64 " ", sample->period);
+
 	if (PRINT_FIELD(EVNAME)) {
 		const char *evname = perf_evsel__name(evsel);
 		printf("%s: ", evname ? evname : "[unknown]");
@@ -1543,7 +1553,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 		     "comma separated output fields prepend with 'type:'. "
 		     "Valid types: hw,sw,trace,raw. "
 		     "Fields: comm,tid,pid,time,cpu,event,trace,ip,sym,dso,"
-		     "addr,symoff", parse_output_fields),
+		     "addr,symoff,period", parse_output_fields),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
 		    "system-wide collection from all CPUs"),
 	OPT_STRING('S', "symbols", &symbol_conf.sym_list_str, "symbol[,symbol...]",
