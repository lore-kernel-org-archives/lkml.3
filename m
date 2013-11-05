Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab3KEUKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 15:10:11 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38801 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab3KEUKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 15:10:09 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/10] perf list: Add usage
Date: Tue,  5 Nov 2013 17:09:56 -0300
Message-Id: <1383682201-19399-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383682201-19399-1-git-send-email-acme@infradead.org>
References: <1383682201-19399-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Currently 'perf list' is not very helpful if you forget the syntax:

  $ perf list -h

  List of pre-defined events (to be used in -e):

After:
  $ perf list -h

   usage: perf list [hw|sw|cache|tracepoint|pmu|event_glob]

Signed-off-by: David Ahern <dsahern@gmail.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/527133AD.4030003@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-list.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index 45000e7d4398..011195e38f21 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -14,20 +14,31 @@
 #include "util/parse-events.h"
 #include "util/cache.h"
 #include "util/pmu.h"
+#include "util/parse-options.h"
 
 int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	int i;
+	const struct option list_options[] = {
+		OPT_END()
+	};
+	const char * const list_usage[] = {
+		"perf list [hw|sw|cache|tracepoint|pmu|event_glob]",
+		NULL
+	};
+
+	argc = parse_options(argc, argv, list_options, list_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
 
 	setup_pager();
 
-	if (argc == 1) {
+	if (argc == 0) {
 		print_events(NULL, false);
 		return 0;
 	}
 
-	for (i = 1; i < argc; ++i) {
-		if (i > 2)
+	for (i = 0; i < argc; ++i) {
+		if (i)
 			putchar('\n');
 		if (strncmp(argv[i], "tracepoint", 10) == 0)
 			print_tracepoint_events(NULL, NULL, false);
-- 
1.8.1.4

