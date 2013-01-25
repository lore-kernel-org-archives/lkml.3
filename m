Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146Ab3AYLqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:46:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41976 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab3AYLqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:46:16 -0500
Date: Fri, 25 Jan 2013 03:45:53 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-9811360ec8b76a68599cb0629cebca026c93cfce@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1356599507-14226-11-git-send-email-namhyung@kernel.org>
References: <1356599507-14226-11-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Update documentation for sort keys
Git-Commit-ID: 9811360ec8b76a68599cb0629cebca026c93cfce
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:46:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9811360ec8b76a68599cb0629cebca026c93cfce
Gitweb:     http://git.kernel.org/tip/9811360ec8b76a68599cb0629cebca026c93cfce
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 27 Dec 2012 18:11:47 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:28 -0300

perf report: Update documentation for sort keys

Add description of sort keys to the perf-report document and also add
missing cpu and srcline keys to the command line help string.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1356599507-14226-11-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-report.txt | 38 +++++++++++++++++++++++++++++---
 tools/perf/builtin-report.c              |  4 ++--
 2 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index f4d91be..848a0dc 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -57,11 +57,44 @@ OPTIONS
 
 -s::
 --sort=::
-	Sort by key(s): pid, comm, dso, symbol, parent, srcline.
+	Sort histogram entries by given key(s) - multiple keys can be specified
+	in CSV format.  Following sort keys are available:
+	pid, comm, dso, symbol, parent, cpu, srcline.
+
+	Each key has following meaning:
+
+	- comm: command (name) of the task which can be read via /proc/<pid>/comm
+	- pid: command and tid of the task
+	- dso: name of library or module executed at the time of sample
+	- symbol: name of function executed at the time of sample
+	- parent: name of function matched to the parent regex filter. Unmatched
+	entries are displayed as "[other]".
+	- cpu: cpu number the task ran at the time of sample
+	- srcline: filename and line number executed at the time of sample.  The
+	DWARF debuggin info must be provided.
+
+	By default, comm, dso and symbol keys are used.
+	(i.e. --sort comm,dso,symbol)
+
+	If --branch-stack option is used, following sort keys are also
+	available:
+	dso_from, dso_to, symbol_from, symbol_to, mispredict.
+
+	- dso_from: name of library or module branched from
+	- dso_to: name of library or module branched to
+	- symbol_from: name of function branched from
+	- symbol_to: name of function branched to
+	- mispredict: "N" for predicted branch, "Y" for mispredicted branch
+
+	And default sort keys are changed to comm, dso_from, symbol_from, dso_to
+	and symbol_to, see '--branch-stack'.
 
 -p::
 --parent=<regex>::
-        regex filter to identify parent, see: '--sort parent'
+        A regex filter to identify parent. The parent is a caller of this
+	function and searched through the callchain, thus it requires callchain
+	information recorded. The pattern is in the exteneded regex format and
+	defaults to "\^sys_|^do_page_fault", see '--sort parent'.
 
 -x::
 --exclude-other::
@@ -74,7 +107,6 @@ OPTIONS
 
 -t::
 --field-separator=::
-
 	Use a special separator character and don't pad with spaces, replacing
 	all occurrences of this separator in symbol names (and other output)
 	with a '.' character, that thus it's the only non valid separator.
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 13cdf61..47a8644 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -595,8 +595,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN(0, "stdio", &report.use_stdio,
 		    "Use the stdio interface"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
-		   "sort by key(s): pid, comm, dso, symbol, parent, dso_to,"
-		   " dso_from, symbol_to, symbol_from, mispredict"),
+		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline,"
+		   " dso_to, dso_from, symbol_to, symbol_from, mispredict"),
 	OPT_BOOLEAN(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
 		    "Show sample percentage for different cpu modes"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
