Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506Ab3BFVtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:49:04 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57269 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758714Ab3BFVo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:44:29 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 16/17] perf evlist: Pass the event_group info via perf_attr_details
Date: Wed,  6 Feb 2013 18:44:18 -0300
Message-Id: <1360187059-12661-17-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1360187059-12661-1-git-send-email-acme@infradead.org>
References: <1360187059-12661-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that we avoid dragging symbol.o into the python binding.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-izjubje7ltd1srji5wb0ygwi@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-evlist.c | 4 ++--
 tools/perf/util/evsel.c     | 2 +-
 tools/perf/util/evsel.h     | 1 +
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
index 85a5e35..05bd9df 100644
--- a/tools/perf/builtin-evlist.c
+++ b/tools/perf/builtin-evlist.c
@@ -39,7 +39,7 @@ int cmd_evlist(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN('F', "freq", &details.freq, "Show the sample frequency"),
 	OPT_BOOLEAN('v', "verbose", &details.verbose,
 		    "Show all event attr details"),
-	OPT_BOOLEAN('g', "group", &symbol_conf.event_group,
+	OPT_BOOLEAN('g', "group", &details.event_group,
 		    "Show event group information"),
 	OPT_END()
 	};
@@ -52,7 +52,7 @@ int cmd_evlist(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (argc)
 		usage_with_options(evlist_usage, options);
 
-	if (symbol_conf.event_group && (details.verbose || details.freq)) {
+	if (details.event_group && (details.verbose || details.freq)) {
 		pr_err("--group option is not compatible with other options\n");
 		usage_with_options(evlist_usage, options);
 	}
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index a547015..9c82f98f 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1391,7 +1391,7 @@ int perf_evsel__fprintf(struct perf_evsel *evsel,
 	bool first = true;
 	int printed = 0;
 
-	if (symbol_conf.event_group) {
+	if (details->event_group) {
 		struct perf_evsel *pos;
 
 		if (!perf_evsel__is_group_leader(evsel))
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 8512f6a..52021c3 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -254,6 +254,7 @@ static inline bool perf_evsel__is_group_leader(const struct perf_evsel *evsel)
 struct perf_attr_details {
 	bool freq;
 	bool verbose;
+	bool event_group;
 };
 
 int perf_evsel__fprintf(struct perf_evsel *evsel,
-- 
1.8.1.1.361.gec3ae6e

