Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030248Ab3GSHwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:52:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35814 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965772Ab3GSHwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:52:42 -0400
Date: Fri, 19 Jul 2013 00:52:25 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-mpmm8l71mnlp7139voba3aak@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf diff: Making compute functions static
Git-Commit-ID: ef358e6dcaba76d1c00dba5fc6cd4cde1d1a2f13
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:52:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ef358e6dcaba76d1c00dba5fc6cd4cde1d1a2f13
Gitweb:     http://git.kernel.org/tip/ef358e6dcaba76d1c00dba5fc6cd4cde1d1a2f13
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Sun, 21 Oct 2012 23:31:51 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:54:14 -0300

perf diff: Making compute functions static

All compute functions are now local to the diff command, making them
static.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-mpmm8l71mnlp7139voba3aak@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c | 30 +++++++++++++++---------------
 tools/perf/util/hist.h    |  7 -------
 2 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index cc7bf4f..f2fbf69 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -224,23 +224,23 @@ static int setup_compute(const struct option *opt, const char *str,
 	return -EINVAL;
 }
 
-double perf_diff__period_percent(struct hist_entry *he, u64 period)
+static double period_percent(struct hist_entry *he, u64 period)
 {
 	u64 total = he->hists->stats.total_period;
 	return (period * 100.0) / total;
 }
 
-double perf_diff__compute_delta(struct hist_entry *he, struct hist_entry *pair)
+static double compute_delta(struct hist_entry *he, struct hist_entry *pair)
 {
-	double old_percent = perf_diff__period_percent(he, he->stat.period);
-	double new_percent = perf_diff__period_percent(pair, pair->stat.period);
+	double old_percent = period_percent(he, he->stat.period);
+	double new_percent = period_percent(pair, pair->stat.period);
 
 	pair->diff.period_ratio_delta = new_percent - old_percent;
 	pair->diff.computed = true;
 	return pair->diff.period_ratio_delta;
 }
 
-double perf_diff__compute_ratio(struct hist_entry *he, struct hist_entry *pair)
+static double compute_ratio(struct hist_entry *he, struct hist_entry *pair)
 {
 	double old_period = he->stat.period ?: 1;
 	double new_period = pair->stat.period;
@@ -250,7 +250,7 @@ double perf_diff__compute_ratio(struct hist_entry *he, struct hist_entry *pair)
 	return pair->diff.period_ratio;
 }
 
-s64 perf_diff__compute_wdiff(struct hist_entry *he, struct hist_entry *pair)
+static s64 compute_wdiff(struct hist_entry *he, struct hist_entry *pair)
 {
 	u64 old_period = he->stat.period;
 	u64 new_period = pair->stat.period;
@@ -292,8 +292,8 @@ static int formula_wdiff(struct hist_entry *he, struct hist_entry *pair,
 		  new_period, compute_wdiff_w2, old_period, compute_wdiff_w1);
 }
 
-int perf_diff__formula(struct hist_entry *he, struct hist_entry *pair,
-		       char *buf, size_t size)
+static int formula_fprintf(struct hist_entry *he, struct hist_entry *pair,
+			   char *buf, size_t size)
 {
 	switch (compute) {
 	case COMPUTE_DELTA:
@@ -421,13 +421,13 @@ static void hists__precompute(struct hists *hists)
 
 		switch (compute) {
 		case COMPUTE_DELTA:
-			perf_diff__compute_delta(he, pair);
+			compute_delta(he, pair);
 			break;
 		case COMPUTE_RATIO:
-			perf_diff__compute_ratio(he, pair);
+			compute_ratio(he, pair);
 			break;
 		case COMPUTE_WEIGHTED_DIFF:
-			perf_diff__compute_wdiff(he, pair);
+			compute_wdiff(he, pair);
 			break;
 		default:
 			BUG_ON(1);
@@ -744,7 +744,7 @@ hpp__entry_pair(struct hist_entry *he, struct hist_entry *pair,
 		if (pair->diff.computed)
 			diff = pair->diff.period_ratio_delta;
 		else
-			diff = perf_diff__compute_delta(he, pair);
+			diff = compute_delta(he, pair);
 
 		if (fabs(diff) >= 0.01)
 			scnprintf(buf, size, "%+4.2F%%", diff);
@@ -758,7 +758,7 @@ hpp__entry_pair(struct hist_entry *he, struct hist_entry *pair,
 		if (pair->diff.computed)
 			ratio = pair->diff.period_ratio;
 		else
-			ratio = perf_diff__compute_ratio(he, pair);
+			ratio = compute_ratio(he, pair);
 
 		if (ratio > 0.0)
 			scnprintf(buf, size, "%14.6F", ratio);
@@ -772,14 +772,14 @@ hpp__entry_pair(struct hist_entry *he, struct hist_entry *pair,
 		if (pair->diff.computed)
 			wdiff = pair->diff.wdiff;
 		else
-			wdiff = perf_diff__compute_wdiff(he, pair);
+			wdiff = compute_wdiff(he, pair);
 
 		if (wdiff != 0)
 			scnprintf(buf, size, "%14ld", wdiff);
 		break;
 
 	case PERF_HPP_DIFF__FORMULA:
-		perf_diff__formula(he, pair, buf, size);
+		formula_fprintf(he, pair, buf, size);
 		break;
 
 	case PERF_HPP_DIFF__PERIOD:
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 79681f6..bfcbb11 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -242,11 +242,4 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist __maybe_unused,
 #endif
 
 unsigned int hists__sort_list_width(struct hists *self);
-
-double perf_diff__compute_delta(struct hist_entry *he, struct hist_entry *pair);
-double perf_diff__compute_ratio(struct hist_entry *he, struct hist_entry *pair);
-s64 perf_diff__compute_wdiff(struct hist_entry *he, struct hist_entry *pair);
-int perf_diff__formula(struct hist_entry *he, struct hist_entry *pair,
-		       char *buf, size_t size);
-double perf_diff__period_percent(struct hist_entry *he, u64 period);
 #endif	/* __PERF_HIST_H */
