Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751003Ab3F0EZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 00:25:24 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:48017 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab3F0EZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 00:25:23 -0400
X-AuditID: 9c93017e-b7cd1ae000002371-40-51cbbeb1730b
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] perf tools: Fixup for removing -f option in perf record
Date: Thu, 27 Jun 2013 13:25:20 +0900
Message-Id: <1372307120-737-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The commit bf3da4014a0c ("perf record: Remove -f/--force option") got
rid of -f option from perf record.  But this option was used
internally by various sub-commands so they wouldn't work anymore.
Also update the example document not to use -f option.

Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/examples.txt | 4 ++--
 tools/perf/builtin-kmem.c             | 2 +-
 tools/perf/builtin-lock.c             | 2 +-
 tools/perf/builtin-sched.c            | 1 -
 tools/perf/builtin-timechart.c        | 4 ++--
 5 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/tools/perf/Documentation/examples.txt b/tools/perf/Documentation/examples.txt
index 77f952762426..a4e392156488 100644
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
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 46878daca5cc..0259502638b4 100644
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
index 425830069749..76543a4a7a30 100644
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
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 2da2a6ca22bf..fed9ae432c16 100644
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
index ab4cf232b852..4536a92b18f3 100644
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
-- 
1.7.11.7

