Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab3KNUZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 15:25:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36311 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916Ab3KNUZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 15:25:27 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 06/10] perf evsel: Introduce perf_evsel__prev() method
Date: Thu, 14 Nov 2013 17:25:11 -0300
Message-Id: <1384460715-23198-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384460715-23198-1-git-send-email-acme@infradead.org>
References: <1384460715-23198-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Just one use so far, on the hists browser, for completeness since there
we use perf_evlist__{first,last} and perf_evsel__next() for handling the
TAB and UNTAB keys.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-d09l4lejp5427enuf3igpckw@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c | 2 +-
 tools/perf/util/evsel.h        | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 089fd3713783..a440e03cd8c2 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1855,7 +1855,7 @@ browse_hists:
 				if (pos->node.prev == &evlist->entries)
 					pos = perf_evlist__last(evlist);
 				else
-					pos = list_entry(pos->node.prev, struct perf_evsel, node);
+					pos = perf_evsel__prev(pos);
 				goto browse_hists;
 			case K_ESC:
 				if (!ui_browser__dialog_yesno(&menu->b,
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index f5029653dcd7..1ea7c92e6e33 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -279,6 +279,11 @@ static inline struct perf_evsel *perf_evsel__next(struct perf_evsel *evsel)
 	return list_entry(evsel->node.next, struct perf_evsel, node);
 }
 
+static inline struct perf_evsel *perf_evsel__prev(struct perf_evsel *evsel)
+{
+	return list_entry(evsel->node.prev, struct perf_evsel, node);
+}
+
 /**
  * perf_evsel__is_group_leader - Return whether given evsel is a leader event
  *
-- 
1.8.1.4

