Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966050Ab3GSHvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:51:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35712 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965772Ab3GSHvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:51:18 -0400
Date: Fri, 19 Jul 2013 00:51:00 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-nj2xk89tj972tbqswfs498ex@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Centralize default columns init in perf_hpp__init
Git-Commit-ID: 2b8bfa6bb8a7d26935207710397386759b42125c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:51:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2b8bfa6bb8a7d26935207710397386759b42125c
Gitweb:     http://git.kernel.org/tip/2b8bfa6bb8a7d26935207710397386759b42125c
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 31 Jan 2013 23:34:25 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:53:59 -0300

perf tools: Centralize default columns init in perf_hpp__init

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
