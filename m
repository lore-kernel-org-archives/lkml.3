Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab3KAJ3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 05:29:32 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:38152 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab3KAJ3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 05:29:30 -0400
From: Chenggang Qin <chenggang.qin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Chenggang Qin <chenggang.qin@gmail.com>, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chenggang Qin <chenggang.qcg@taobao.com>
Subject: [PATCH 1/4] perf report: add parameter 'start' & 'end' to perf report
Date: Fri,  1 Nov 2013 17:29:03 +0800
Message-Id: <1383298146-3860-2-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383298146-3860-1-git-send-email-chenggang.qin@gmail.com>
References: <1383298146-3860-1-git-send-email-chenggang.qin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf report --start time1 --end time2
The unit of time1 & time2 are millsecond.

Cc: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Yanmin Zhang <yanmin.zhang@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>

---
 tools/perf/builtin-report.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 72eae74..e9e9d0a 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -733,6 +733,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	struct perf_session *session;
 	struct stat st;
+	u64 tstart = 0, tend = 0;
 	bool has_br_stack = false;
 	int branch_mode = -1;
 	int ret = -1;
@@ -843,6 +844,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN(0, "mem-mode", &report.mem_mode, "mem access profile"),
 	OPT_CALLBACK(0, "percent-limit", &report, "percent",
 		     "Don't show entries under that percent", parse_percent_limit),
+	OPT_U64(0, "start", &tstart, "Start time of analysis interval. (Unit: ms)"),
+	OPT_U64(0, "end", &tend, "End time of analysis interval. (Unit: ms)"),
 	OPT_END()
 	};
 
@@ -850,6 +853,12 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	argc = parse_options(argc, argv, options, report_usage, 0);
 
+	if (tend && tstart >= tend) {
+		fprintf(stderr, "start [%" PRIu64 "] is greater than end [%"
+			PRIu64 "].\n", tstart, tend);
+		return -1;
+	}
+
 	if (report.use_stdio)
 		use_browser = 0;
 	else if (report.use_tui)
-- 
1.7.8.rc2.5.g815b

