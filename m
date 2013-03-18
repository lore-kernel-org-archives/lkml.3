Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab3CRQhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:37:13 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49380
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752687Ab3CRQZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:25:57 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 14/54] perf evlist: Remove cpus and threads arguments from perf_evlist__new()
Date: Mon, 18 Mar 2013 13:24:59 -0300
Message-Id: <1363623939-10748-15-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1363623939-10748-1-git-send-email-acme@infradead.org>
References: <1363623939-10748-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It's almost always used with NULL for both arguments.  Get rid of the
arguments from the signature and use perf_evlist__set_maps() if needed.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1362987798-24969-1-git-send-email-namhyung@kernel.org
[ committer note: replaced spaces with tabs in some of the affected lines ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c               |    2 +-
 tools/perf/builtin-stat.c                 |    2 +-
 tools/perf/builtin-top.c                  |    2 +-
 tools/perf/builtin-trace.c                |    2 +-
 tools/perf/tests/evsel-roundtrip-name.c   |    4 ++--
 tools/perf/tests/hists_link.c             |    2 +-
 tools/perf/tests/mmap-basic.c             |    4 +++-
 tools/perf/tests/open-syscall-tp-fields.c |    2 +-
 tools/perf/tests/parse-events.c           |    2 +-
 tools/perf/tests/perf-record.c            |    2 +-
 tools/perf/util/evlist.c                  |    5 ++---
 tools/perf/util/evlist.h                  |    3 +--
 tools/perf/util/header.c                  |    4 ++--
 13 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f1a939e..e3261ea 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -964,7 +964,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 	struct perf_record *rec = &record;
 	char errbuf[BUFSIZ];
 
-	evsel_list = perf_evlist__new(NULL, NULL);
+	evsel_list = perf_evlist__new();
 	if (evsel_list == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 9984876..020329d 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1336,7 +1336,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	setlocale(LC_ALL, "");
 
-	evsel_list = perf_evlist__new(NULL, NULL);
+	evsel_list = perf_evlist__new();
 	if (evsel_list == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 72f6eb7..c5601aa 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1116,7 +1116,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		NULL
 	};
 
-	top.evlist = perf_evlist__new(NULL, NULL);
+	top.evlist = perf_evlist__new();
 	if (top.evlist == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index d222d7f..6198eb1 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -419,7 +419,7 @@ out_dump:
 
 static int trace__run(struct trace *trace, int argc, const char **argv)
 {
-	struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
+	struct perf_evlist *evlist = perf_evlist__new();
 	struct perf_evsel *evsel;
 	int err = -1, i;
 	unsigned long before;
diff --git a/tools/perf/tests/evsel-roundtrip-name.c b/tools/perf/tests/evsel-roundtrip-name.c
index 0fd99a9..0197bda 100644
--- a/tools/perf/tests/evsel-roundtrip-name.c
+++ b/tools/perf/tests/evsel-roundtrip-name.c
@@ -8,7 +8,7 @@ static int perf_evsel__roundtrip_cache_name_test(void)
 	char name[128];
 	int type, op, err = 0, ret = 0, i, idx;
 	struct perf_evsel *evsel;
-        struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
+	struct perf_evlist *evlist = perf_evlist__new();
 
         if (evlist == NULL)
                 return -ENOMEM;
@@ -64,7 +64,7 @@ static int __perf_evsel__name_array_test(const char *names[], int nr_names)
 {
 	int i, err;
 	struct perf_evsel *evsel;
-        struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
+	struct perf_evlist *evlist = perf_evlist__new();
 
         if (evlist == NULL)
                 return -ENOMEM;
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 1be64a6..e0c0267 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -436,7 +436,7 @@ int test__hists_link(void)
 	struct machines machines;
 	struct machine *machine = NULL;
 	struct perf_evsel *evsel, *first;
-        struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
+	struct perf_evlist *evlist = perf_evlist__new();
 
 	if (evlist == NULL)
                 return -ENOMEM;
diff --git a/tools/perf/tests/mmap-basic.c b/tools/perf/tests/mmap-basic.c
index cdd5075..5b1b5ab 100644
--- a/tools/perf/tests/mmap-basic.c
+++ b/tools/perf/tests/mmap-basic.c
@@ -53,12 +53,14 @@ int test__basic_mmap(void)
 		goto out_free_cpus;
 	}
 
-	evlist = perf_evlist__new(cpus, threads);
+	evlist = perf_evlist__new();
 	if (evlist == NULL) {
 		pr_debug("perf_evlist__new\n");
 		goto out_free_cpus;
 	}
 
+	perf_evlist__set_maps(evlist, cpus, threads);
+
 	for (i = 0; i < nsyscalls; ++i) {
 		char name[64];
 
diff --git a/tools/perf/tests/open-syscall-tp-fields.c b/tools/perf/tests/open-syscall-tp-fields.c
index 1c52fdc..02cb741 100644
--- a/tools/perf/tests/open-syscall-tp-fields.c
+++ b/tools/perf/tests/open-syscall-tp-fields.c
@@ -18,7 +18,7 @@ int test__syscall_open_tp_fields(void)
 	};
 	const char *filename = "/etc/passwd";
 	int flags = O_RDONLY | O_DIRECTORY;
-	struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
+	struct perf_evlist *evlist = perf_evlist__new();
 	struct perf_evsel *evsel;
 	int err = -1, i, nr_events = 0, nr_polls = 0;
 
diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 0d3d0c5..88e2f44 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -1218,7 +1218,7 @@ static int test_event(struct evlist_test *e)
 	struct perf_evlist *evlist;
 	int ret;
 
-	evlist = perf_evlist__new(NULL, NULL);
+	evlist = perf_evlist__new();
 	if (evlist == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index 1e8e512..f6ba75a 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -45,7 +45,7 @@ int test__PERF_RECORD(void)
 	};
 	cpu_set_t cpu_mask;
 	size_t cpu_mask_size = sizeof(cpu_mask);
-	struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
+	struct perf_evlist *evlist = perf_evlist__new();
 	struct perf_evsel *evsel;
 	struct perf_sample sample;
 	const char *cmd = "sleep";
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 7626bb4..a199f18 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -38,13 +38,12 @@ void perf_evlist__init(struct perf_evlist *evlist, struct cpu_map *cpus,
 	evlist->workload.pid = -1;
 }
 
-struct perf_evlist *perf_evlist__new(struct cpu_map *cpus,
-				     struct thread_map *threads)
+struct perf_evlist *perf_evlist__new(void)
 {
 	struct perf_evlist *evlist = zalloc(sizeof(*evlist));
 
 	if (evlist != NULL)
-		perf_evlist__init(evlist, cpus, threads);
+		perf_evlist__init(evlist, NULL, NULL);
 
 	return evlist;
 }
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 2dd07bd..9a7b76e 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -49,8 +49,7 @@ struct perf_evsel_str_handler {
 	void	   *handler;
 };
 
-struct perf_evlist *perf_evlist__new(struct cpu_map *cpus,
-				     struct thread_map *threads);
+struct perf_evlist *perf_evlist__new(void);
 void perf_evlist__init(struct perf_evlist *evlist, struct cpu_map *cpus,
 		       struct thread_map *threads);
 void perf_evlist__exit(struct perf_evlist *evlist);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index f4bfd79..a9b7349 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2789,7 +2789,7 @@ int perf_session__read_header(struct perf_session *session, int fd)
 	u64			f_id;
 	int nr_attrs, nr_ids, i, j;
 
-	session->evlist = perf_evlist__new(NULL, NULL);
+	session->evlist = perf_evlist__new();
 	if (session->evlist == NULL)
 		return -ENOMEM;
 
@@ -2940,7 +2940,7 @@ int perf_event__process_attr(union perf_event *event,
 	struct perf_evlist *evlist = *pevlist;
 
 	if (evlist == NULL) {
-		*pevlist = evlist = perf_evlist__new(NULL, NULL);
+		*pevlist = evlist = perf_evlist__new();
 		if (evlist == NULL)
 			return -ENOMEM;
 	}
-- 
1.7.1

