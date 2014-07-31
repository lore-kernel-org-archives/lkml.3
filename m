Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaGaRSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:18:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:9031 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbaGaRRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:17:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,773,1400050800"; 
   d="scan'208";a="463663350"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        mingo@kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 6/9] perf, tools: Fix srcline sort key output to use width
Date: Thu, 31 Jul 2014 10:17:06 -0700
Message-Id: <1406827029-7991-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406827029-7991-1-git-send-email-andi@firstfloor.org>
References: <1406827029-7991-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The srcline sort output ignored the width, which caused
various problems with displaying srcline in the tui
browser. Just cut it off at width.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/sort.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 14e5a03..58b4a92 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -305,7 +305,7 @@ static int hist_entry__srcline_snprintf(struct hist_entry *he, char *bf,
 					size_t size,
 					unsigned int width __maybe_unused)
 {
-	return repsep_snprintf(bf, size, "%s", he->srcline);
+	return repsep_snprintf(bf, size, "%.*s", width, he->srcline);
 }
 
 struct sort_entry sort_srcline = {
-- 
1.9.3

