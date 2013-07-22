Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933424Ab3GVUZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 16:25:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52088 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933357Ab3GVUWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 16:22:51 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/11] perf tools: Move weight back to common sort keys
Date: Mon, 22 Jul 2013 17:22:39 -0300
Message-Id: <1374524559-9839-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374524559-9839-1-git-send-email-acme@infradead.org>
References: <1374524559-9839-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This is a partial revert of Namhyung's patch

 afab87b91f3f331d55664172dad8e476e6ffca9d
 perf sort: Separate out memory-specific sort keys

He wrote

 For global/local weights, I'm not entirely sure to place them into the
 memory dimension.  But it's the only user at this time.

Well TSX is another (in fact the original) user of the flags, and it
needs them to be common. So move local/global weight back to the common
sort keys.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Link: http://lkml.kernel.org/r/1374188333-17899-1-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 4 ++--
 tools/perf/util/sort.h | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index cb2b108..5f118a0 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -874,6 +874,8 @@ static struct sort_dimension common_sort_dimensions[] = {
 	DIM(SORT_PARENT, "parent", sort_parent),
 	DIM(SORT_CPU, "cpu", sort_cpu),
 	DIM(SORT_SRCLINE, "srcline", sort_srcline),
+	DIM(SORT_LOCAL_WEIGHT, "local_weight", sort_local_weight),
+	DIM(SORT_GLOBAL_WEIGHT, "weight", sort_global_weight),
 };
 
 #undef DIM
@@ -893,8 +895,6 @@ static struct sort_dimension bstack_sort_dimensions[] = {
 #define DIM(d, n, func) [d - __SORT_MEMORY_MODE] = { .name = n, .entry = &(func) }
 
 static struct sort_dimension memory_sort_dimensions[] = {
-	DIM(SORT_LOCAL_WEIGHT, "local_weight", sort_local_weight),
-	DIM(SORT_GLOBAL_WEIGHT, "weight", sort_global_weight),
 	DIM(SORT_MEM_DADDR_SYMBOL, "symbol_daddr", sort_mem_daddr_sym),
 	DIM(SORT_MEM_DADDR_DSO, "dso_daddr", sort_mem_daddr_dso),
 	DIM(SORT_MEM_LOCKED, "locked", sort_mem_locked),
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 586022d..4e80dbd 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -143,6 +143,8 @@ enum sort_type {
 	SORT_PARENT,
 	SORT_CPU,
 	SORT_SRCLINE,
+	SORT_LOCAL_WEIGHT,
+	SORT_GLOBAL_WEIGHT,
 
 	/* branch stack specific sort keys */
 	__SORT_BRANCH_STACK,
@@ -154,9 +156,7 @@ enum sort_type {
 
 	/* memory mode specific sort keys */
 	__SORT_MEMORY_MODE,
-	SORT_LOCAL_WEIGHT = __SORT_MEMORY_MODE,
-	SORT_GLOBAL_WEIGHT,
-	SORT_MEM_DADDR_SYMBOL,
+	SORT_MEM_DADDR_SYMBOL = __SORT_MEMORY_MODE,
 	SORT_MEM_DADDR_DSO,
 	SORT_MEM_LOCKED,
 	SORT_MEM_TLB,
-- 
1.8.1.4

