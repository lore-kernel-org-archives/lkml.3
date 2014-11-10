Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbaKJVQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 16:16:11 -0500
Received: from mga11.intel.com ([192.55.52.93]:46715 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbaKJVQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 16:16:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,355,1413270000"; 
   d="scan'208";a="620185094"
From: kan.liang@intel.com
To: acme@kernel.org, jolsa@redhat.com, namhyung@kernel.org
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V2 2/3] perf tool:perf diff support for different binaries
Date: Mon, 10 Nov 2014 16:01:19 -0500
Message-Id: <1415653280-1374-3-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1415653280-1374-1-git-send-email-kan.liang@intel.com>
References: <1415653280-1374-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

Currently, the perf diff only works with same binaries. That's because
it compares the symbol start address. It doesn't work if the perf.data
comes from different binaries. This patch matches the function names.

Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 tools/perf/util/sort.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 9402885..ee235ab 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1430,6 +1430,15 @@ int sort_dimension__add(const char *tok)
 			sort__has_parent = 1;
 		} else if (sd->entry == &sort_sym) {
 			sort__has_sym = 1;
+			/*
+			 * perf diff displays the performance difference amongst
+			 * two or more perf.data files. Those files could come from
+			 * different binaries. So we should not compare their ips.
+			 * The name of symble should be the key we do compare.
+			 */
+			if (sort__mode == SORT_MODE__DIFF)
+				sd->entry->se_collapse = sort__sym_sort;
+
 		} else if (sd->entry == &sort_dso) {
 			sort__has_dso = 1;
 		}
-- 
1.8.3.2

