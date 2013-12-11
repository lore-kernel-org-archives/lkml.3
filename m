Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab3LKLHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:07:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60328 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab3LKLHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:07:15 -0500
Date: Wed, 11 Dec 2013 03:06:43 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-5cfe2c82f3eb6876cf4b55e99decea0bd015d6b8@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1386583370-1699-2-git-send-email-jolsa@redhat.com>
References: <1386583370-1699-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Add --header/--header-only options
Git-Commit-ID: 5cfe2c82f3eb6876cf4b55e99decea0bd015d6b8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 11 Dec 2013 03:06:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5cfe2c82f3eb6876cf4b55e99decea0bd015d6b8
Gitweb:     http://git.kernel.org/tip/5cfe2c82f3eb6876cf4b55e99decea0bd015d6b8
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 9 Dec 2013 11:02:49 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 10 Dec 2013 16:49:02 -0300

perf report: Add --header/--header-only options

Currently the perf.data header is always displayed for stdio output,
which is no always useful.

Disabling header information by default and adding following options to
control header output:

  --header      - display header information (old default)
  --header-only - display header information only w/o further
                  processing, forces stdio output

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1386583370-1699-2-git-send-email-jolsa@redhat.com
[ Added single line explaining talking about the new --header* options,
  to address David Ahern comment; better man page entry for the new options,
  from Namhyung Kim ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-report.txt |  9 +++++++++
 tools/perf/builtin-report.c              | 22 +++++++++++++++++++---
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 10a2798..8eab8a4 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -237,6 +237,15 @@ OPTIONS
 	Do not show entries which have an overhead under that percent.
 	(Default: 0).
 
+--header::
+	Show header information in the perf.data file.  This includes
+	various information like hostname, OS and perf version, cpu/mem
+	info, perf command line, event list and so on.  Currently only
+	--stdio output supports this feature.
+
+--header-only::
+	Show only perf.data header (forces --stdio).
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-annotate[1]
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8cf8e66..3a14dbe 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -49,6 +49,8 @@ struct perf_report {
 	bool			show_threads;
 	bool			inverted_callchain;
 	bool			mem_mode;
+	bool			header;
+	bool			header_only;
 	int			max_stack;
 	struct perf_read_values	show_threads_values;
 	const char		*pretty_printing_style;
@@ -514,9 +516,6 @@ static int __cmd_report(struct perf_report *rep)
 			return ret;
 	}
 
-	if (use_browser <= 0)
-		perf_session__fprintf_info(session, stdout, rep->show_full_info);
-
 	if (rep->show_threads)
 		perf_read_values_init(&rep->show_threads_values);
 
@@ -820,6 +819,9 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN(0, "gtk", &report.use_gtk, "Use the GTK2 interface"),
 	OPT_BOOLEAN(0, "stdio", &report.use_stdio,
 		    "Use the stdio interface"),
+	OPT_BOOLEAN(0, "header", &report.header, "Show data header."),
+	OPT_BOOLEAN(0, "header-only", &report.header_only,
+		    "Show only data header."),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline,"
 		   " dso_to, dso_from, symbol_to, symbol_from, mispredict,"
@@ -963,6 +965,10 @@ repeat:
 			goto error;
 	}
 
+	/* Force tty output for header output. */
+	if (report.header || report.header_only)
+		use_browser = 0;
+
 	if (strcmp(input_name, "-") != 0)
 		setup_browser(true);
 	else {
@@ -970,6 +976,16 @@ repeat:
 		perf_hpp__init();
 	}
 
+	if (report.header || report.header_only) {
+		perf_session__fprintf_info(session, stdout,
+					   report.show_full_info);
+		if (report.header_only)
+			return 0;
+	} else if (use_browser == 0) {
+		fputs("# To display the perf.data header info, please use --header/--header-only options.\n#\n",
+		      stdout);
+	}
+
 	/*
 	 * Only in the TUI browser we are doing integrated annotation,
 	 * so don't allocate extra space that won't be used in the stdio
