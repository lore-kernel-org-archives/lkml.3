Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab3J3QP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:15:28 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:62621 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab3J3QPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:15:16 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/2] perf list: Add usage
Date: Wed, 30 Oct 2013 10:15:07 -0600
Message-Id: <1383149707-1008-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1383149707-1008-1-git-send-email-dsahern@gmail.com>
References: <1383149707-1008-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently perf list is not very helpful if you forget the syntax:
  $ perf list -h

  List of pre-defined events (to be used in -e):

After:
  $ perf list -h

   usage: perf list [hw|sw|cache|tracepoint|pmu|event_glob]

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-list.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index 45000e7d4398..a5ad93206044 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -14,10 +14,21 @@
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
 
-- 
1.8.3.4 (Apple Git-47)

