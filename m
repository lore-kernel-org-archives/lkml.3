Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab3H0Dw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 23:52:26 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:56349 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab3H0DwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 23:52:24 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/3] perf evlist: Add tracepoint lookup by name
Date: Mon, 26 Aug 2013 21:52:13 -0600
Message-Id: <1377575535-43544-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1377575535-43544-1-git-send-email-dsahern@gmail.com>
References: <1377575535-43544-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will be used by upcoming perf-trace replay option.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/evlist.c |   15 +++++++++++++++
 tools/perf/util/evlist.h |    4 ++++
 2 files changed, 19 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 1f5105a..c0e43ee 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -210,6 +210,21 @@ perf_evlist__find_tracepoint_by_id(struct perf_evlist *evlist, int id)
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
index 327abab..8a509e2 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -71,6 +71,10 @@ int perf_evlist__set_filter(struct perf_evlist *evlist, const char *filter);
 struct perf_evsel *
 perf_evlist__find_tracepoint_by_id(struct perf_evlist *evlist, int id);
 
+struct perf_evsel *
+perf_evlist__find_tracepoint_by_name(struct perf_evlist *evlist,
+				     const char *name);
+
 void perf_evlist__id_add(struct perf_evlist *evlist, struct perf_evsel *evsel,
 			 int cpu, int thread, u64 id);
 
-- 
1.7.10.1

