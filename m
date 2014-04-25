Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaDYNOD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:14:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40496 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbaDYNN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:13:57 -0400
Date: Fri, 25 Apr 2014 06:13:46 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-ae993efc9c6bd109b027d2799a442892067e9230@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1398327843-31845-4-git-send-email-namhyung@kernel.org>
References: <1398327843-31845-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists:
  Move column length calculation out of hists__inc_stats()
Git-Commit-ID: ae993efc9c6bd109b027d2799a442892067e9230
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

Commit-ID:  ae993efc9c6bd109b027d2799a442892067e9230
Gitweb:     http://git.kernel.org/tip/ae993efc9c6bd109b027d2799a442892067e9230
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 24 Apr 2014 16:25:19 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Thu, 24 Apr 2014 16:30:58 +0200

perf hists: Move column length calculation out of hists__inc_stats()

It's not the part of logic of hists__inc_stats() so it'd be better to
move it out of the function.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1398327843-31845-4-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-diff.c | 3 +++
 tools/perf/util/hist.c    | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 0e46fa1..c9cc771 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -587,6 +587,9 @@ static void hists__compute_resort(struct hists *hists)
 
 		insert_hist_entry_by_compute(&hists->entries, he, compute);
 		hists__inc_stats(hists, he);
+
+		if (!he->filtered)
+			hists__calc_col_len(hists, he);
 	}
 }
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 12d6c1b..f5b388e 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -320,7 +320,6 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 void hists__inc_stats(struct hists *hists, struct hist_entry *h)
 {
 	if (!h->filtered) {
-		hists__calc_col_len(hists, h);
 		hists->nr_non_filtered_entries++;
 		hists->stats.total_non_filtered_period += h->stat.period;
 	}
@@ -687,6 +686,9 @@ void hists__output_resort(struct hists *hists)
 
 		__hists__insert_output_entry(&hists->entries, n, min_callchain_hits);
 		hists__inc_stats(hists, n);
+
+		if (!n->filtered)
+			hists__calc_col_len(hists, n);
 	}
 }
 
