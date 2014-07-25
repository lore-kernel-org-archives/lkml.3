Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526AbaGYBTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 21:19:19 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46422 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757759AbaGYBTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 21:19:17 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 5/7] perf top: Add -w option for setting column width
Date: Fri, 25 Jul 2014 10:18:56 +0900
Message-Id: <1406251138-6574-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406251138-6574-1-git-send-email-namhyung@kernel.org>
References: <1406251138-6574-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add -w/--column-widths option like perf report does so that users are
able to see symbols even with some very long C++ library/functions.
It can be a list separated by comma for each column.

  $ perf top -w 0,20,30

The value of 0 means there's no limit.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
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
2.0.0

