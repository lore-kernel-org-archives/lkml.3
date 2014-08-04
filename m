Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbaHDQV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:21:29 -0400
Received: from mail.kernel.org ([198.145.19.201]:39656 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbaHDQV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:21:26 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 29/33] perf top: Add -w option for setting column width
Date: Mon,  4 Aug 2014 13:17:40 -0300
Message-Id: <1407169064-25625-30-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407169064-25625-1-git-send-email-acme@kernel.org>
References: <1407169064-25625-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

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
index d2b59af62bc0..d561e0214f52 100644
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
index 180ae02137a5..28fdee394880 100644
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
index 377971dc89a3..bde216b2071c 100644
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
-- 
1.9.3

