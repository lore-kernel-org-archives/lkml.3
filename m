Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3I0Xjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 19:39:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:39152 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151Ab3I0Xjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 19:39:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,996,1371106800"; 
   d="scan'208";a="408323441"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: jolsa@redhat.com, eranian@google.com, linux-kernel@vger.kernel.org,
        namhyung.kim@lge.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf, tools: Fix sorting for 64bit entries
Date: Fri, 27 Sep 2013 16:39:24 -0700
Message-Id: <1380325164-4478-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Some of the node comparisons in hist.c dropped the upper
32bit by using an int variable to store the compare
result. This broke various 64bit fields, causing
incorrect collapsing (found for the TSX transaction field)

Just use int64_t always.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/hist.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 4714a72..4832b59 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -350,7 +350,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 	struct rb_node **p;
 	struct rb_node *parent = NULL;
 	struct hist_entry *he;
-	int cmp;
+	int64_t cmp;
 
 	p = &hists->entries_in->rb_node;
 
@@ -887,7 +887,7 @@ static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
 	struct rb_node **p;
 	struct rb_node *parent = NULL;
 	struct hist_entry *he;
-	int cmp;
+	int64_t cmp;
 
 	if (sort__need_collapse)
 		root = &hists->entries_collapsed;
-- 
1.8.3.1

