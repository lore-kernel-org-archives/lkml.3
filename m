Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbaDYNNr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:13:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40489 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaDYNNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:13:44 -0400
Date: Fri, 25 Apr 2014 06:13:33 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-6263835a1b1ad137f3c26a1383c0487a9388d06e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1398327843-31845-3-git-send-email-namhyung@kernel.org>
References: <1398327843-31845-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists: Rename hists__inc_stats()
Git-Commit-ID: 6263835a1b1ad137f3c26a1383c0487a9388d06e
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

Commit-ID:  6263835a1b1ad137f3c26a1383c0487a9388d06e
Gitweb:     http://git.kernel.org/tip/6263835a1b1ad137f3c26a1383c0487a9388d06e
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 24 Apr 2014 16:21:46 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Thu, 24 Apr 2014 16:30:30 +0200

perf hists: Rename hists__inc_stats()

The existing hists__inc_nr_entries() is a misnomer as it's not only
increasing ->nr_entries but also other stats.  So rename it to more
general hists__inc_stats().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1398327843-31845-3-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-diff.c | 2 +-
 tools/perf/util/hist.c    | 6 +++---
 tools/perf/util/hist.h    | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 6ef80f2..0e46fa1 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -586,7 +586,7 @@ static void hists__compute_resort(struct hists *hists)
 		next = rb_next(&he->rb_node_in);
 
 		insert_hist_entry_by_compute(&hists->entries, he, compute);
-		hists__inc_nr_entries(hists, he);
+		hists__inc_stats(hists, he);
 	}
 }
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 5a89247..12d6c1b 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -317,7 +317,7 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 	return he;
 }
 
-void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
+void hists__inc_stats(struct hists *hists, struct hist_entry *h)
 {
 	if (!h->filtered) {
 		hists__calc_col_len(hists, h);
@@ -686,7 +686,7 @@ void hists__output_resort(struct hists *hists)
 		next = rb_next(&n->rb_node_in);
 
 		__hists__insert_output_entry(&hists->entries, n, min_callchain_hits);
-		hists__inc_nr_entries(hists, n);
+		hists__inc_stats(hists, n);
 	}
 }
 
@@ -853,7 +853,7 @@ static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
 		he->hists = hists;
 		rb_link_node(&he->rb_node_in, parent, p);
 		rb_insert_color(&he->rb_node_in, root);
-		hists__inc_nr_entries(hists, he);
+		hists__inc_stats(hists, he);
 		he->dummy = true;
 	}
 out:
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 5a0343e..51478c9 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -116,7 +116,7 @@ void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel);
 void hists__output_recalc_col_len(struct hists *hists, int max_rows);
 
 u64 hists__total_period(struct hists *hists);
-void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h);
+void hists__inc_stats(struct hists *hists, struct hist_entry *h);
 void hists__inc_nr_events(struct hists *hists, u32 type);
 void events_stats__inc(struct events_stats *stats, u32 type);
 size_t events_stats__fprintf(struct events_stats *stats, FILE *fp);
