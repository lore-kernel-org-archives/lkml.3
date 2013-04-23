Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab3DWIc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 04:32:29 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:46785 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052Ab3DWIb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 04:31:26 -0400
X-AuditID: 9c930197-b7bb3ae000000fa9-a3-517646d3c2a0
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 12/14] perf ftrace: Use pager for displaying result
Date: Tue, 23 Apr 2013 17:31:10 +0900
Message-Id: <1366705872-12132-13-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It's convenient to use pager when seeing many lines of result.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-ftrace.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index 97293cee5597..f4efa1475cf9 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -188,6 +188,7 @@ static int do_ftrace_live(struct perf_ftrace *ftrace)
 	signal(SIGINT, sig_handler);
 	signal(SIGUSR1, sig_handler);
 	signal(SIGCHLD, sig_handler);
+	signal(SIGPIPE, sig_handler);
 
 	if (setup_tracing_files(ftrace) < 0)
 		goto out_reset;
@@ -1461,6 +1462,8 @@ __cmd_ftrace_live(struct perf_ftrace *ftrace, int argc, const char **argv)
 						  argv, false, true) < 0)
 		goto out_maps;
 
+	setup_pager();
+
 	ret = do_ftrace_live(ftrace);
 
 out_maps:
@@ -1582,6 +1585,8 @@ __cmd_ftrace_show(struct perf_ftrace *ftrace, int argc, const char **argv)
 	if (ftrace->dirname == NULL)
 		ftrace->dirname = DEFAULT_DIRNAME;
 
+	setup_pager();
+
 	ret = do_ftrace_show(ftrace);
 
 	perf_evlist__delete_maps(ftrace->evlist);
@@ -1643,6 +1648,7 @@ __cmd_ftrace_report(struct perf_ftrace *ftrace, int argc, const char **argv)
 	perf_hpp__column_enable(PERF_HPP__OVERHEAD);
 	perf_hpp__init();
 
+	setup_pager();
 	setup_sorting();
 
 	symbol_conf.exclude_other = false;
-- 
1.7.11.7

