Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390AbaJ2OI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:08:59 -0400
Received: from mail.kernel.org ([198.145.19.201]:41574 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933781AbaJ2OIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:08:54 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 24/25] perf tools: Use evlist__for_each in a few remaining places
Date: Wed, 29 Oct 2014 12:06:36 -0200
Message-Id: <1414591597-2763-25-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1414591597-2763-1-git-send-email-acme@kernel.org>
References: <1414591597-2763-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Where direct use of the longer form using list_for_entry() was being
used.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-v4fw80flg25nkl8jgeod3ot9@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c  | 2 +-
 tools/perf/util/session.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 0babd390963c..7e23dae54f1d 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -413,7 +413,7 @@ int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
 	int nfds = 0;
 	struct perf_evsel *evsel;
 
-	list_for_each_entry(evsel, &evlist->entries, node) {
+	evlist__for_each(evlist, evsel) {
 		if (evsel->system_wide)
 			nfds += nr_cpus;
 		else
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 27a0049118b5..58dd5ceb8bef 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1662,7 +1662,7 @@ int perf_event__synthesize_id_index(struct perf_tool *tool,
 	max_nr = (UINT16_MAX - sizeof(struct id_index_event)) /
 		 sizeof(struct id_index_entry);
 
-	list_for_each_entry(evsel, &evlist->entries, node)
+	evlist__for_each(evlist, evsel)
 		nr += evsel->ids;
 
 	n = nr > max_nr ? max_nr : nr;
@@ -1675,7 +1675,7 @@ int perf_event__synthesize_id_index(struct perf_tool *tool,
 	ev->id_index.header.size = sz;
 	ev->id_index.nr = n;
 
-	list_for_each_entry(evsel, &evlist->entries, node) {
+	evlist__for_each(evlist, evsel) {
 		u32 j;
 
 		for (j = 0; j < evsel->ids; j++) {
-- 
1.9.3

