Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab3AYWdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:33:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:13316 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116Ab3AYWdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:33:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,541,1355126400"; 
   d="scan'208";a="276768178"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, acme@redhat.com, eranian@google.com,
        jolsa@redhat.com, namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 01/18] perf, tools: Support sorting by intx, abort branch flags v2
Date: Fri, 25 Jan 2013 14:32:55 -0800
Message-Id: <1359153192-13409-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359153192-13409-1-git-send-email-andi@firstfloor.org>
References: <1359153192-13409-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Extend the perf branch sorting code to support sorting by intx
or abort qualifiers. Also print out those qualifiers.

This also fixes up some of the existing sort key documentation.

We do not support notx here, because it's simply not showing
the intx flag.

v2: Readd flags to man pages
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/sort.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index b7a4100..7896250 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -537,6 +537,8 @@ static struct sort_dimension common_sort_dimensions[] = {
 	DIM(SORT_PARENT, "parent", sort_parent),
 	DIM(SORT_CPU, "cpu", sort_cpu),
 	DIM(SORT_SRCLINE, "srcline", sort_srcline),
+	DIM(SORT_ABORT, "abort", sort_abort),
+	DIM(SORT_INTX, "intx", sort_intx)
 };
 
 #undef DIM
-- 
1.7.7.6

