Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbaAKTnV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 14:43:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:6002 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392AbaAKTnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 14:43:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,644,1384329600"; 
   d="scan'208";a="437435644"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: jolsa@redhat.com, namhyung@kernel.org, mingo@kernel.org, dsahern@gmail.com,
        fweisbec@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 6/9] perf, tools: Fix max stack handling with lbr-as-callgraph
Date: Sat, 11 Jan 2014 11:42:56 -0800
Message-Id: <1389469379-13340-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1389469379-13340-1-git-send-email-andi@firstfloor.org>
References: <1389469379-13340-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The original lbr-as-callstack code ignored the maxium callgraph
length set by the user. Fix this.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/machine.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 4032634..853639c 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1372,7 +1372,7 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 	}
 
 	if (callchain_param.branch_callstack) {
-		int nr = branch->nr;
+		int nr = min(max_stack, branch->nr);
 		struct branch_entry be[nr];
 
 		for (i = 0; i < nr; i++) { 
@@ -1397,6 +1397,7 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 			if (err)
 				return err;
 		}
+		chain_nr -= nr;
 	}
 
 	if (chain->nr > PERF_MAX_STACK_DEPTH) {
-- 
1.8.3.1

