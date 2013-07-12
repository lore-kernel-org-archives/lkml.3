Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523Ab3GLIvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 04:51:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54778 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757397Ab3GLIvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 04:51:04 -0400
Date: Fri, 12 Jul 2013 01:50:37 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-tvwyspiqr4getzfib2lw06ty@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        ak@linux.intel.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, ak@linux.intel.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1372307120-737-1-git-send-email-namhyung@kernel.org>
References: <1372307120-737-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf record: Remove -f/--force option
Git-Commit-ID: 4a4d371a4dfbd3b84a7eab8d535d4c7c3647b09e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 12 Jul 2013 01:50:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4a4d371a4dfbd3b84a7eab8d535d4c7c3647b09e
Gitweb:     http://git.kernel.org/tip/4a4d371a4dfbd3b84a7eab8d535d4c7c3647b09e
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 5 Jun 2013 13:37:21 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 8 Jul 2013 17:37:25 -0300

perf record: Remove -f/--force option

It no longer have any affect on the processing and is marked as obsolete
anyway.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-tvwyspiqr4getzfib2lw06ty@git.kernel.org
Link: http://lkml.kernel.org/r/1372307120-737-1-git-send-email-namhyung@kernel.org
[ combined patch removing the -f usage in various sub-commands, such as 'perf sched', etc, by Namhyung Kim ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/examples.txt    | 4 ++--
 tools/perf/Documentation/perf-record.txt | 4 ----
 tools/perf/builtin-kmem.c                | 2 +-
 tools/perf/builtin-lock.c                | 2 +-
 tools/perf/builtin-record.c              | 3 ---
 tools/perf/builtin-sched.c               | 1 -
 tools/perf/builtin-timechart.c           | 4 ++--
 7 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/tools/perf/Documentation/examples.txt b/tools/perf/Documentation/examples.txt
index 77f9527..a4e3921 100644
--- a/tools/perf/Documentation/examples.txt
+++ b/tools/perf/Documentation/examples.txt
@@ -66,7 +66,7 @@ Furthermore, these tracepoints can be used to sample the workload as
 well. For example the page allocations done by a 'git gc' can be
 captured the following way:
 
- titan:~/git> perf record -f -e kmem:mm_page_alloc -c 1 ./git gc
+ titan:~/git> perf record -e kmem:mm_page_alloc -c 1 ./git gc
  Counting objects: 1148, done.
  Delta compression using up to 2 threads.
  Compressing objects: 100% (450/450), done.
@@ -120,7 +120,7 @@ Furthermore, call-graph sampling can be done too, of page
 allocations - to see precisely what kind of page allocations there
 are:
 
- titan:~/git> perf record -f -g -e kmem:mm_page_alloc -c 1 ./git gc
+ titan:~/git> perf record -g -e kmem:mm_page_alloc -c 1 ./git gc
  Counting objects: 1148, done.
  Delta compression using up to 2 threads.
  Compressing objects: 100% (450/450), done.
diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 7e32580..e297b74 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -70,10 +70,6 @@ OPTIONS
 --no-delay::
 	Collect data without buffering.
 
--f::
---force::
-	Overwrite existing data file. (deprecated)
-
 -c::
 --count=::
 	Event period to sample.
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 46878da..0259502 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -708,7 +708,7 @@ static int parse_line_opt(const struct option *opt __maybe_unused,
 static int __cmd_record(int argc, const char **argv)
 {
 	const char * const record_args[] = {
-	"record", "-a", "-R", "-f", "-c", "1",
+	"record", "-a", "-R", "-c", "1",
 	"-e", "kmem:kmalloc",
 	"-e", "kmem:kmalloc_node",
 	"-e", "kmem:kfree",
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 4258300..76543a4 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -878,7 +878,7 @@ static int __cmd_report(void)
 static int __cmd_record(int argc, const char **argv)
 {
 	const char *record_args[] = {
-		"record", "-R", "-f", "-m", "1024", "-c", "1",
+		"record", "-R", "-m", "1024", "-c", "1",
 	};
 	unsigned int rec_argc, i, j;
 	const char **rec_argv;
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 2990570..ecca62e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -74,7 +74,6 @@ struct perf_record {
 	int			realtime_prio;
 	bool			no_buildid;
 	bool			no_buildid_cache;
-	bool			force;
 	long			samples;
 	off_t			post_processing_offset;
 };
@@ -856,8 +855,6 @@ const struct option record_options[] = {
 			    "system-wide collection from all CPUs"),
 	OPT_STRING('C', "cpu", &record.opts.target.cpu_list, "cpu",
 		    "list of cpus to monitor"),
-	OPT_BOOLEAN('f', "force", &record.force,
-			"overwrite existing data file (deprecated)"),
 	OPT_U64('c', "count", &record.opts.user_interval, "event period to sample"),
 	OPT_STRING('o', "output", &record.output_name, "file",
 		    "output file name"),
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 2da2a6c..fed9ae4 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1632,7 +1632,6 @@ static int __cmd_record(int argc, const char **argv)
 		"record",
 		"-a",
 		"-R",
-		"-f",
 		"-m", "1024",
 		"-c", "1",
 		"-e", "sched:sched_switch",
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index ab4cf232..4536a92 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1005,7 +1005,7 @@ static int __cmd_record(int argc, const char **argv)
 {
 #ifdef SUPPORT_OLD_POWER_EVENTS
 	const char * const record_old_args[] = {
-		"record", "-a", "-R", "-f", "-c", "1",
+		"record", "-a", "-R", "-c", "1",
 		"-e", "power:power_start",
 		"-e", "power:power_end",
 		"-e", "power:power_frequency",
@@ -1014,7 +1014,7 @@ static int __cmd_record(int argc, const char **argv)
 	};
 #endif
 	const char * const record_new_args[] = {
-		"record", "-a", "-R", "-f", "-c", "1",
+		"record", "-a", "-R", "-c", "1",
 		"-e", "power:cpu_frequency",
 		"-e", "power:cpu_idle",
 		"-e", "sched:sched_wakeup",
