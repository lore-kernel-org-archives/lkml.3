Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934330Ab3GRT4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:56:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41947 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934166Ab3GRT4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:56:21 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 52/76] perf tools: Centralize default columns init in perf_hpp__init
Date: Thu, 18 Jul 2013 16:49:39 -0300
Message-Id: <1374177003-3706-53-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Now when diff command is separated from other standard outputs,
we can use perf_hpp__init to initialize all standard columns.

Moving PERF_HPP__OVERHEAD column init back to perf_hpp__init,
and removing extra enable calls.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-nj2xk89tj972tbqswfs498ex@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c    | 1 -
 tools/perf/ui/browsers/hists.c | 2 --
 tools/perf/ui/hist.c           | 2 ++
 tools/perf/ui/setup.c          | 1 -
 4 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 9a7e54d..188c265 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -861,7 +861,6 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		setup_browser(true);
 	else {
 		use_browser = 0;
-		perf_hpp__column_enable(PERF_HPP__OVERHEAD);
 		perf_hpp__init();
 	}
 
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 2cb3916..7ef36c3 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -703,8 +703,6 @@ __HPP_COLOR_PERCENT_FN(overhead_guest_us, period_guest_us, NULL)
 
 void hist_browser__init_hpp(void)
 {
-	perf_hpp__column_enable(PERF_HPP__OVERHEAD);
-
 	perf_hpp__init();
 
 	perf_hpp__format[PERF_HPP__OVERHEAD].color =
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 5440d56..f45c97f 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -421,6 +421,8 @@ LIST_HEAD(perf_hpp__list);
 
 void perf_hpp__init(void)
 {
+	perf_hpp__column_enable(PERF_HPP__OVERHEAD);
+
 	if (symbol_conf.show_cpu_utilization) {
 		perf_hpp__column_enable(PERF_HPP__OVERHEAD_SYS);
 		perf_hpp__column_enable(PERF_HPP__OVERHEAD_US);
diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index ae6a789..47d9a57 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -30,7 +30,6 @@ void setup_browser(bool fallback_to_pager)
 		if (fallback_to_pager)
 			setup_pager();
 
-		perf_hpp__column_enable(PERF_HPP__OVERHEAD);
 		perf_hpp__init();
 		break;
 	}
-- 
1.8.1.4

