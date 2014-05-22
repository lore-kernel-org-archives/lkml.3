Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbaEVMVF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:21:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50939 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbaEVMVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:21:01 -0400
Date: Thu, 22 May 2014 05:20:50 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-093f0ef34c50ff5cca41c1e18e258ff688e915b6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1400480762-22852-4-git-send-email-namhyung@kernel.org>
References: <1400480762-22852-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Use hpp formats to sort hist entries
Git-Commit-ID: 093f0ef34c50ff5cca41c1e18e258ff688e915b6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  093f0ef34c50ff5cca41c1e18e258ff688e915b6
Gitweb:     http://git.kernel.org/tip/093f0ef34c50ff5cca41c1e18e258ff688e915b6
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 3 Mar 2014 12:07:47 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Wed, 21 May 2014 11:45:34 +0200

perf tools: Use hpp formats to sort hist entries

It wrapped sort entries to hpp functions, so using the hpp sort list
to sort entries.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1400480762-22852-4-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/hist.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 7f0236c..38373c9 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -432,11 +432,11 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 int64_t
 hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	struct sort_entry *se;
+	struct perf_hpp_fmt *fmt;
 	int64_t cmp = 0;
 
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		cmp = se->se_cmp(left, right);
+	perf_hpp__for_each_sort_list(fmt) {
+		cmp = fmt->cmp(left, right);
 		if (cmp)
 			break;
 	}
@@ -447,15 +447,11 @@ hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
 int64_t
 hist_entry__collapse(struct hist_entry *left, struct hist_entry *right)
 {
-	struct sort_entry *se;
+	struct perf_hpp_fmt *fmt;
 	int64_t cmp = 0;
 
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		int64_t (*f)(struct hist_entry *, struct hist_entry *);
-
-		f = se->se_collapse ?: se->se_cmp;
-
-		cmp = f(left, right);
+	perf_hpp__for_each_sort_list(fmt) {
+		cmp = fmt->collapse(left, right);
 		if (cmp)
 			break;
 	}
