Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934958AbaGRE3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:29:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33351 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965024AbaGRE1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:27:50 -0400
Date: Thu, 17 Jul 2014 21:27:32 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-acebd408bef17169fbf79079b96f0264b535916c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
In-Reply-To: <1405374411-29012-2-git-send-email-jolsa@kernel.org>
References: <1405374411-29012-2-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Remove verbose from functions prototypes
Git-Commit-ID: acebd408bef17169fbf79079b96f0264b535916c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  acebd408bef17169fbf79079b96f0264b535916c
Gitweb:     http://git.kernel.org/tip/acebd408bef17169fbf79079b96f0264b535916c
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Mon, 14 Jul 2014 23:46:47 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 17 Jul 2014 11:04:42 -0300

perf tools: Remove verbose from functions prototypes

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
index 90122ab..40af0ac 100644
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
index 7af1480..845f627 100644
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
index 5806a90..22d13a2 100644
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
index b9c36ef..9692c06 100644
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
 
