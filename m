Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbaDXIYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:24:10 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:38525 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbaDXIYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:24:07 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 02/11] perf hists: Rename hists__inc_stats()
Date: Thu, 24 Apr 2014 17:23:54 +0900
Message-Id: <1398327843-31845-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398327843-31845-1-git-send-email-namhyung@kernel.org>
References: <1398327843-31845-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing hists__inc_nr_entries() is a misnomer as it's not only
increasing ->nr_entries but also other stats.  So rename it to more
general hists__inc_stats().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-diff.c | 2 +-
 tools/perf/util/hist.c    | 6 +++---
 tools/perf/util/hist.h    | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 6ef80f22c1e2..0e46fa1b5ca0 100644
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
index 5a892477aa50..12d6c1bd761d 100644
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
index 5a0343eb22e2..51478c94d976 100644
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
-- 
1.9.2

