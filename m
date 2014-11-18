Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbaKRQyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:54:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:32260 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932545AbaKRQyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:54:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,410,1413270000"; 
   d="scan'208";a="609874440"
From: kan.liang@intel.com
To: acme@kernel.org, jolsa@redhat.com, namhyung@kernel.org
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V4 2/3] perf tool:perf diff support for different binaries
Date: Tue, 18 Nov 2014 11:38:19 -0500
Message-Id: <1416328700-1836-3-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1416328700-1836-1-git-send-email-kan.liang@intel.com>
References: <1416328700-1836-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

Currently, the perf diff only works with same binaries. That's because
it compares the symbol start address. It doesn't work if the perf.data
comes from different binaries. This patch matches the function names.

Signed-off-by: Kan Liang <kan.liang@intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/sort.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 95efaaf..bea2e07 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1432,6 +1432,15 @@ int sort_dimension__add(const char *tok)
 			sort__has_parent = 1;
 		} else if (sd->entry == &sort_sym) {
 			sort__has_sym = 1;
+			/*
+			 * perf diff displays the performance difference amongst
+			 * two or more perf.data files. Those files could come
+			 * from different binaries. So we should not compare
+			 * their ips, but the name of symble.
+			 */
+			if (sort__mode == SORT_MODE__DIFF)
+				sd->entry->se_collapse = sort__sym_sort;
+
 		} else if (sd->entry == &sort_dso) {
 			sort__has_dso = 1;
 		}
-- 
1.8.3.2

