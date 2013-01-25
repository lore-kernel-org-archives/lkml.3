Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001Ab3AYLJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:09:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41324 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab3AYLJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:09:08 -0500
Date: Fri, 25 Jan 2013 03:08:29 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-be0o8si9f1z40cwoa534f7me@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists:
  Rename hists__fprintf_nr_events to events_stats__fprintf
Git-Commit-ID: 52168eea32cc01377b31c1ca9a759eae06830ea0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:08:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  52168eea32cc01377b31c1ca9a759eae06830ea0
Gitweb:     http://git.kernel.org/tip/52168eea32cc01377b31c1ca9a759eae06830ea0
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 18 Dec 2012 16:02:17 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:11 -0300

perf hists: Rename hists__fprintf_nr_events to events_stats__fprintf

As this function deals exclusively with hists->stats.

Preparatory patch for removing the by now needless session->hists, that
should be just session->stats.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-be0o8si9f1z40cwoa534f7me@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/stdio/hist.c | 6 +++---
 tools/perf/util/hist.h     | 2 +-
 tools/perf/util/session.c  | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 0eae3b2..f979829 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -459,7 +459,7 @@ out:
 	return ret;
 }
 
-size_t hists__fprintf_nr_events(struct hists *hists, FILE *fp)
+size_t events_stats__fprintf(struct events_stats *stats, FILE *fp)
 {
 	int i;
 	size_t ret = 0;
@@ -467,7 +467,7 @@ size_t hists__fprintf_nr_events(struct hists *hists, FILE *fp)
 	for (i = 0; i < PERF_RECORD_HEADER_MAX; ++i) {
 		const char *name;
 
-		if (hists->stats.nr_events[i] == 0)
+		if (stats->nr_events[i] == 0)
 			continue;
 
 		name = perf_event__name(i);
@@ -475,7 +475,7 @@ size_t hists__fprintf_nr_events(struct hists *hists, FILE *fp)
 			continue;
 
 		ret += fprintf(fp, "%16s events: %10d\n", name,
-			       hists->stats.nr_events[i]);
+			       stats->nr_events[i]);
 	}
 
 	return ret;
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index d3664ab..cb6533b 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -98,7 +98,7 @@ void hists__output_recalc_col_len(struct hists *hists, int max_rows);
 
 void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h);
 void hists__inc_nr_events(struct hists *self, u32 type);
-size_t hists__fprintf_nr_events(struct hists *self, FILE *fp);
+size_t events_stats__fprintf(struct events_stats *stats, FILE *fp);
 
 size_t hists__fprintf(struct hists *self, bool show_header, int max_rows,
 		      int max_cols, FILE *fp);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 76d6e25..6e8dd2a 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1353,11 +1353,11 @@ size_t perf_session__fprintf_nr_events(struct perf_session *session, FILE *fp)
 	struct perf_evsel *pos;
 	size_t ret = fprintf(fp, "Aggregated stats:\n");
 
-	ret += hists__fprintf_nr_events(&session->hists, fp);
+	ret += events_stats__fprintf(&session->hists.stats, fp);
 
 	list_for_each_entry(pos, &session->evlist->entries, node) {
 		ret += fprintf(fp, "%s stats:\n", perf_evsel__name(pos));
-		ret += hists__fprintf_nr_events(&pos->hists, fp);
+		ret += events_stats__fprintf(&pos->hists.stats, fp);
 	}
 
 	return ret;
