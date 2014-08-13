Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaHMFTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:19:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45113 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbaHMFTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:19:08 -0400
Date: Tue, 12 Aug 2014 22:18:52 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-cf59002fdebc9c00ee29233e65bc39dd69e0eaf6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
In-Reply-To: <1406785662-5534-6-git-send-email-namhyung@kernel.org>
References: <1406785662-5534-6-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Add -w option for setting column width
Git-Commit-ID: cf59002fdebc9c00ee29233e65bc39dd69e0eaf6
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

Commit-ID:  cf59002fdebc9c00ee29233e65bc39dd69e0eaf6
Gitweb:     http://git.kernel.org/tip/cf59002fdebc9c00ee29233e65bc39dd69e0eaf6
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 31 Jul 2014 14:47:39 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Aug 2014 12:03:06 -0300

perf top: Add -w option for setting column width

Add -w/--column-widths option like perf report does so that users are
able to see symbols even with some very long C++ library/functions.

It can be a list separated by comma for each column.

  $ perf top -w 0,20,30

The value of 0 means there's no limit.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1406785662-5534-6-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-report.txt | 2 +-
 tools/perf/Documentation/perf-top.txt    | 6 ++++++
 tools/perf/builtin-top.c                 | 3 +++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index d2b59af..d561e02 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -147,7 +147,7 @@ OPTIONS
 -w::
 --column-widths=<width[,width...]>::
 	Force each column width to the provided list, for large terminal
-	readability.
+	readability.  0 means no limit (default behavior).
 
 -t::
 --field-separator=::
diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 180ae02..28fdee3 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -193,6 +193,12 @@ Default is to monitor all CPUS.
 	sum of shown entries will be always 100%. "absolute" means it retains
 	the original value before and after the filter is applied.
 
+-w::
+--column-widths=<width[,width...]>::
+	Force each column width to the provided list, for large terminal
+	readability.  0 means no limit (default behavior).
+
+
 INTERACTIVE PROMPTING KEYS
 --------------------------
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 377971d..bde216b 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1131,6 +1131,9 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		     "Don't show entries under that percent", parse_percent_limit),
 	OPT_CALLBACK(0, "percentage", NULL, "relative|absolute",
 		     "How to display percentage of filtered entries", parse_filter_percentage),
+	OPT_STRING('w', "column-widths", &symbol_conf.col_width_list_str,
+		   "width[,width...]",
+		   "don't try to adjust column width, use these fixed values"),
 	OPT_END()
 	};
 	const char * const top_usage[] = {
