Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab3ENKPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 06:15:39 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:46368 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894Ab3ENKOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 06:14:06 -0400
X-AuditID: 9c930197-b7b76ae000003523-3f-51920e6a26f8
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 12/15] perf ftrace: Use pager for displaying result
Date: Tue, 14 May 2013 19:13:56 +0900
Message-Id: <1368526439-31966-13-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1368526439-31966-1-git-send-email-namhyung@kernel.org>
References: <1368526439-31966-1-git-send-email-namhyung@kernel.org>
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
index de6afd50cff2..588d61de1c89 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -227,6 +227,7 @@ static int do_ftrace_live(struct perf_ftrace *ftrace)
 	signal(SIGINT, sig_handler);
 	signal(SIGUSR1, sig_handler);
 	signal(SIGCHLD, sig_handler);
+	signal(SIGPIPE, sig_handler);
 
 	if (setup_tracing_files(ftrace) < 0)
 		goto out_reset;
@@ -1472,6 +1473,8 @@ __cmd_ftrace_live(struct perf_ftrace *ftrace, int argc, const char **argv)
 	if (!argc && perf_target__none(&ftrace->target))
 		usage_with_options(live_usage, live_options);
 
+	setup_pager();
+
 	ret = perf_target__validate(&ftrace->target);
 	if (ret) {
 		char errbuf[512];
@@ -1618,6 +1621,8 @@ __cmd_ftrace_show(struct perf_ftrace *ftrace, int argc, const char **argv)
 	if (ftrace->dirname == NULL)
 		ftrace->dirname = DEFAULT_DIRNAME;
 
+	setup_pager();
+
 	ret = do_ftrace_show(ftrace);
 
 	perf_evlist__delete_maps(ftrace->evlist);
@@ -1679,6 +1684,7 @@ __cmd_ftrace_report(struct perf_ftrace *ftrace, int argc, const char **argv)
 	perf_hpp__column_enable(PERF_HPP__OVERHEAD);
 	perf_hpp__init();
 
+	setup_pager();
 	setup_sorting();
 
 	symbol_conf.exclude_other = false;
-- 
1.7.11.7

