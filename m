Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbaKRB7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 20:59:05 -0500
Received: from mga03.intel.com ([134.134.136.65]:30383 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbaKRB7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 20:59:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,407,1413270000"; 
   d="scan'208";a="609481085"
From: Andi Kleen <andi@firstfloor.org>
To: acme@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/2] perf, tools: Remove use of BUILD_BUG_ON
Date: Mon, 17 Nov 2014 17:58:55 -0800
Message-Id: <1416275935-20971-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416275935-20971-1-git-send-email-andi@firstfloor.org>
References: <1416275935-20971-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

BUILD_BUG_ON relies on the gcc optimizer, so it breaks
the build with DEBUG=1 which doesn't use -O2.

Turn the BUILD_BUG_ON into a runtime check again.

Also fix the check to check for 255, not 127.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/machine.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 5c4d7f8..a24909b 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1446,8 +1446,7 @@ static int remove_loops(struct branch_entry *l, int nr)
 
 	memset(chash, NO_ENTRY, sizeof(chash));
 
-	BUILD_BUG_ON_MSG(PERF_MAX_BRANCH_DEPTH > 127,
-			 "Please upgrade the type of the hash table from unsigned char");
+	BUG_ON(PERF_MAX_BRANCH_DEPTH > 255);
 	for (i = 0; i < nr; i++) {
 		int h = hash_64(l[i].from, CHASHBITS) % CHASHSZ;
 
-- 
1.9.3

