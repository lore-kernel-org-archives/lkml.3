Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934952AbaGQQPC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:15:02 -0400
Received: from mail.kernel.org ([198.145.19.201]:52656 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030363AbaGQQO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:14:57 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 28/33] perf tools: Remove verbose from functions prototypes
Date: Thu, 17 Jul 2014 13:12:30 -0300
Message-Id: <1405613555-23380-29-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405613555-23380-1-git-send-email-acme@kernel.org>
References: <1405613555-23380-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

And use verbose as an global object in following functions:

  __map_groups__fprintf_maps
  __map_groups__fprintf_removed_maps
  map_groups__fprintf_maps
  map_groups__fprintf

Also making map_groups__fprintf_maps static.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1405374411-29012-2-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/stdio/hist.c |  2 +-
 tools/perf/util/map.c      | 24 ++++++++++++------------
 tools/perf/util/map.h      |  9 ++++-----
 tools/perf/util/thread.c   |  4 ++--
 4 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 90122abd3721..40af0acb4fe9 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -479,7 +479,7 @@ print_entries:
 
 		if (h->ms.map == NULL && verbose > 1) {
 			__map_groups__fprintf_maps(h->thread->mg,
-						   MAP__FUNCTION, verbose, fp);
+						   MAP__FUNCTION, fp);
 			fprintf(fp, "%.10s end\n", graph_dotted_line);
 		}
 	}
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 7af14807ee90..845f627e45f4 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -12,6 +12,7 @@
 #include "vdso.h"
 #include "build-id.h"
 #include "util.h"
+#include "debug.h"
 #include <linux/string.h>
 
 const char *map_type__name[MAP__NR_TYPES] = {
@@ -568,8 +569,8 @@ int map_groups__find_ams(struct addr_map_symbol *ams, symbol_filter_t filter)
 	return ams->sym ? 0 : -1;
 }
 
-size_t __map_groups__fprintf_maps(struct map_groups *mg,
-				  enum map_type type, int verbose, FILE *fp)
+size_t __map_groups__fprintf_maps(struct map_groups *mg, enum map_type type,
+				  FILE *fp)
 {
 	size_t printed = fprintf(fp, "%s:\n", map_type__name[type]);
 	struct rb_node *nd;
@@ -587,17 +588,16 @@ size_t __map_groups__fprintf_maps(struct map_groups *mg,
 	return printed;
 }
 
-size_t map_groups__fprintf_maps(struct map_groups *mg, int verbose, FILE *fp)
+static size_t map_groups__fprintf_maps(struct map_groups *mg, FILE *fp)
 {
 	size_t printed = 0, i;
 	for (i = 0; i < MAP__NR_TYPES; ++i)
-		printed += __map_groups__fprintf_maps(mg, i, verbose, fp);
+		printed += __map_groups__fprintf_maps(mg, i, fp);
 	return printed;
 }
 
 static size_t __map_groups__fprintf_removed_maps(struct map_groups *mg,
-						 enum map_type type,
-						 int verbose, FILE *fp)
+						 enum map_type type, FILE *fp)
 {
 	struct map *pos;
 	size_t printed = 0;
@@ -614,23 +614,23 @@ static size_t __map_groups__fprintf_removed_maps(struct map_groups *mg,
 }
 
 static size_t map_groups__fprintf_removed_maps(struct map_groups *mg,
-					       int verbose, FILE *fp)
+					       FILE *fp)
 {
 	size_t printed = 0, i;
 	for (i = 0; i < MAP__NR_TYPES; ++i)
-		printed += __map_groups__fprintf_removed_maps(mg, i, verbose, fp);
+		printed += __map_groups__fprintf_removed_maps(mg, i, fp);
 	return printed;
 }
 
-size_t map_groups__fprintf(struct map_groups *mg, int verbose, FILE *fp)
+size_t map_groups__fprintf(struct map_groups *mg, FILE *fp)
 {
-	size_t printed = map_groups__fprintf_maps(mg, verbose, fp);
+	size_t printed = map_groups__fprintf_maps(mg, fp);
 	printed += fprintf(fp, "Removed maps:\n");
-	return printed + map_groups__fprintf_removed_maps(mg, verbose, fp);
+	return printed + map_groups__fprintf_removed_maps(mg, fp);
 }
 
 int map_groups__fixup_overlappings(struct map_groups *mg, struct map *map,
-				   int verbose, FILE *fp)
+				   FILE *fp)
 {
 	struct rb_root *root = &mg->maps[map->type];
 	struct rb_node *next = rb_first(root);
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 5806a906198b..22d13a219590 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -142,8 +142,8 @@ void map__fixup_end(struct map *map);
 
 void map__reloc_vmlinux(struct map *map);
 
-size_t __map_groups__fprintf_maps(struct map_groups *mg,
-				  enum map_type type, int verbose, FILE *fp);
+size_t __map_groups__fprintf_maps(struct map_groups *mg, enum map_type type,
+				  FILE *fp);
 void maps__insert(struct rb_root *maps, struct map *map);
 void maps__remove(struct rb_root *maps, struct map *map);
 struct map *maps__find(struct rb_root *maps, u64 addr);
@@ -153,8 +153,7 @@ void map_groups__init(struct map_groups *mg);
 void map_groups__exit(struct map_groups *mg);
 int map_groups__clone(struct map_groups *mg,
 		      struct map_groups *parent, enum map_type type);
-size_t map_groups__fprintf(struct map_groups *mg, int verbose, FILE *fp);
-size_t map_groups__fprintf_maps(struct map_groups *mg, int verbose, FILE *fp);
+size_t map_groups__fprintf(struct map_groups *mg, FILE *fp);
 
 int maps__set_kallsyms_ref_reloc_sym(struct map **maps, const char *symbol_name,
 				     u64 addr);
@@ -211,7 +210,7 @@ struct symbol *map_groups__find_function_by_name(struct map_groups *mg,
 }
 
 int map_groups__fixup_overlappings(struct map_groups *mg, struct map *map,
-				   int verbose, FILE *fp);
+				   FILE *fp);
 
 struct map *map_groups__find_by_name(struct map_groups *mg,
 				     enum map_type type, const char *name);
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index b9c36ef42d2f..9692c06a9e21 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -129,12 +129,12 @@ int thread__comm_len(struct thread *thread)
 size_t thread__fprintf(struct thread *thread, FILE *fp)
 {
 	return fprintf(fp, "Thread %d %s\n", thread->tid, thread__comm_str(thread)) +
-	       map_groups__fprintf(thread->mg, verbose, fp);
+	       map_groups__fprintf(thread->mg, fp);
 }
 
 void thread__insert_map(struct thread *thread, struct map *map)
 {
-	map_groups__fixup_overlappings(thread->mg, map, verbose, stderr);
+	map_groups__fixup_overlappings(thread->mg, map, stderr);
 	map_groups__insert(thread->mg, map);
 }
 
-- 
1.9.3

