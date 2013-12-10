Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab3LJUbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:31:40 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34309 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab3LJUbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:31:37 -0500
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
Subject: [PATCH 30/34] perf symbols: Constify some DSO methods parameters
Date: Tue, 10 Dec 2013 17:31:12 -0300
Message-Id: <1386707476-12370-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386707476-12370-1-git-send-email-acme@infradead.org>
References: <1386707476-12370-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Those methods are not supposed to change the data structures they
manipulate, so make that clearer by using the const qualifier in the
function signature and in some variables.

Suggested-by: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-j7oyakex7zy3r82h33rdw25x@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/build-id.c |  2 +-
 tools/perf/util/build-id.h |  2 +-
 tools/perf/util/dso.c      | 11 +++++------
 tools/perf/util/dso.h      |  4 ++--
 4 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index a92770c98cc7..6baabe63182b 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -89,7 +89,7 @@ int build_id__sprintf(const u8 *build_id, int len, char *bf)
 	return raw - build_id;
 }
 
-char *dso__build_id_filename(struct dso *dso, char *bf, size_t size)
+char *dso__build_id_filename(const struct dso *dso, char *bf, size_t size)
 {
 	char build_id_hex[BUILD_ID_SIZE * 2 + 1];
 
diff --git a/tools/perf/util/build-id.h b/tools/perf/util/build-id.h
index 929f28a7c14d..845ef865eced 100644
--- a/tools/perf/util/build-id.h
+++ b/tools/perf/util/build-id.h
@@ -10,7 +10,7 @@ extern struct perf_tool build_id__mark_dso_hit_ops;
 struct dso;
 
 int build_id__sprintf(const u8 *build_id, int len, char *bf);
-char *dso__build_id_filename(struct dso *dso, char *bf, size_t size);
+char *dso__build_id_filename(const struct dso *dso, char *bf, size_t size);
 
 int build_id__mark_dso_hit(struct perf_tool *tool, union perf_event *event,
 			   struct perf_sample *sample, struct perf_evsel *evsel,
diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 19babb0d365d..fbc66fde6b30 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -28,7 +28,7 @@ char dso__symtab_origin(const struct dso *dso)
 	return origin[dso->symtab_type];
 }
 
-int dso__binary_type_file(struct dso *dso, enum dso_binary_type type,
+int dso__binary_type_file(const struct dso *dso, enum dso_binary_type type,
 			  char *root_dir, char *file, size_t size)
 {
 	char build_id_hex[BUILD_ID_SIZE * 2 + 1];
@@ -200,11 +200,10 @@ dso_cache__free(struct rb_root *root)
 	}
 }
 
-static struct dso_cache*
-dso_cache__find(struct rb_root *root, u64 offset)
+static struct dso_cache *dso_cache__find(const struct rb_root *root, u64 offset)
 {
-	struct rb_node **p = &root->rb_node;
-	struct rb_node *parent = NULL;
+	struct rb_node * const *p = &root->rb_node;
+	const struct rb_node *parent = NULL;
 	struct dso_cache *cache;
 
 	while (*p != NULL) {
@@ -566,7 +565,7 @@ void dsos__add(struct list_head *head, struct dso *dso)
 	list_add_tail(&dso->node, head);
 }
 
-struct dso *dsos__find(struct list_head *head, const char *name, bool cmp_short)
+struct dso *dsos__find(const struct list_head *head, const char *name, bool cmp_short)
 {
 	struct dso *pos;
 
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index a2d71292f746..99f3c647d683 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -128,7 +128,7 @@ void dso__read_running_kernel_build_id(struct dso *dso,
 int dso__kernel_module_get_build_id(struct dso *dso, const char *root_dir);
 
 char dso__symtab_origin(const struct dso *dso);
-int dso__binary_type_file(struct dso *dso, enum dso_binary_type type,
+int dso__binary_type_file(const struct dso *dso, enum dso_binary_type type,
 			  char *root_dir, char *file, size_t size);
 
 int dso__data_fd(struct dso *dso, struct machine *machine);
@@ -143,7 +143,7 @@ struct dso *dso__kernel_findnew(struct machine *machine, const char *name,
 				const char *short_name, int dso_type);
 
 void dsos__add(struct list_head *head, struct dso *dso);
-struct dso *dsos__find(struct list_head *head, const char *name,
+struct dso *dsos__find(const struct list_head *head, const char *name,
 		       bool cmp_short);
 struct dso *__dsos__findnew(struct list_head *head, const char *name);
 bool __dsos__read_build_ids(struct list_head *head, bool with_hits);
-- 
1.8.1.4

