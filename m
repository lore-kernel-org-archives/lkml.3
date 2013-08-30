Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab3H3S7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 14:59:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45593 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab3H3S7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 14:59:14 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/15] perf evlist: Add tracepoint lookup by name
Date: Fri, 30 Aug 2013 15:58:55 -0300
Message-Id: <1377889138-8793-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1377889138-8793-1-git-send-email-acme@infradead.org>
References: <1377889138-8793-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Will be used by upcoming perf-trace replay option.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1377750593-48046-2-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 15 +++++++++++++++
 tools/perf/util/evlist.h |  4 ++++
 2 files changed, 19 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 6a629af..5df4ca9 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -208,6 +208,21 @@ perf_evlist__find_tracepoint_by_id(struct perf_evlist *evlist, int id)
 	return NULL;
 }
 
+struct perf_evsel *
+perf_evlist__find_tracepoint_by_name(struct perf_evlist *evlist,
+				     const char *name)
+{
+	struct perf_evsel *evsel;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		if ((evsel->attr.type == PERF_TYPE_TRACEPOINT) &&
+		    (strcmp(evsel->name, name) == 0))
+			return evsel;
+	}
+
+	return NULL;
+}
+
 int perf_evlist__add_newtp(struct perf_evlist *evlist,
 			   const char *sys, const char *name, void *handler)
 {
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index ab95d72..841a394 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -74,6 +74,10 @@ int perf_evlist__set_filter(struct perf_evlist *evlist, const char *filter);
 struct perf_evsel *
 perf_evlist__find_tracepoint_by_id(struct perf_evlist *evlist, int id);
 
+struct perf_evsel *
+perf_evlist__find_tracepoint_by_name(struct perf_evlist *evlist,
+				     const char *name);
+
 void perf_evlist__id_add(struct perf_evlist *evlist, struct perf_evsel *evsel,
 			 int cpu, int thread, u64 id);
 
-- 
1.8.1.4

