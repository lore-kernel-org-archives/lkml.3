Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934363Ab3GRW7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 18:59:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:5770 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932682Ab3GRW7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 18:59:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,697,1367996400"; 
   d="scan'208";a="367595679"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH] perf, tools: Move weight back to common sort keys
Date: Thu, 18 Jul 2013 15:58:53 -0700
Message-Id: <1374188333-17899-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.1.4
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

Well TSX is another (in fact the original) user of the flags,
and it needs them to be common. So move local/global weight
back to the common sort keys.

Cc: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/sort.c | 4 ++--
 tools/perf/util/sort.h | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 313a5a7..5919480 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -872,6 +872,8 @@ static struct sort_dimension common_sort_dimensions[] = {
 	DIM(SORT_PARENT, "parent", sort_parent),
 	DIM(SORT_CPU, "cpu", sort_cpu),
 	DIM(SORT_SRCLINE, "srcline", sort_srcline),
+	DIM(SORT_LOCAL_WEIGHT, "local_weight", sort_local_weight),
+	DIM(SORT_GLOBAL_WEIGHT, "weight", sort_global_weight),
 };
 
 #undef DIM
@@ -891,8 +893,6 @@ static struct sort_dimension bstack_sort_dimensions[] = {
 #define DIM(d, n, func) [d - __SORT_MEMORY_MODE] = { .name = n, .entry = &(func) }
 
 static struct sort_dimension memory_sort_dimensions[] = {
-	DIM(SORT_LOCAL_WEIGHT, "local_weight", sort_local_weight),
-	DIM(SORT_GLOBAL_WEIGHT, "weight", sort_global_weight),
 	DIM(SORT_MEM_DADDR_SYMBOL, "symbol_daddr", sort_mem_daddr_sym),
 	DIM(SORT_MEM_DADDR_DSO, "dso_daddr", sort_mem_daddr_dso),
 	DIM(SORT_MEM_LOCKED, "locked", sort_mem_locked),
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 45ac84c..2860d46 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -138,6 +138,8 @@ enum sort_type {
 	SORT_PARENT,
 	SORT_CPU,
 	SORT_SRCLINE,
+	SORT_LOCAL_WEIGHT,
+	SORT_GLOBAL_WEIGHT,
 
 	/* branch stack specific sort keys */
 	__SORT_BRANCH_STACK,
@@ -149,9 +151,7 @@ enum sort_type {
 
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

