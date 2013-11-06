Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab3KFFoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 00:44:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44263 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab3KFFoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 00:44:20 -0500
Date: Tue, 5 Nov 2013 21:43:43 -0800
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-44d742e01e6d3dd544ee1873b660a3c8bc1413bb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <527133AD.4030003@gmail.com>
References: <527133AD.4030003@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf list: Add usage
Git-Commit-ID: 44d742e01e6d3dd544ee1873b660a3c8bc1413bb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 05 Nov 2013 21:43:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  44d742e01e6d3dd544ee1873b660a3c8bc1413bb
Gitweb:     http://git.kernel.org/tip/44d742e01e6d3dd544ee1873b660a3c8bc1413bb
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Wed, 30 Oct 2013 10:28:29 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 5 Nov 2013 14:26:41 -0300

perf list: Add usage

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
index 45000e7..011195e 100644
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
