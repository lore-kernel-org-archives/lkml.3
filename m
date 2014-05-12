Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbaELXUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 19:20:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:25550 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbaELXUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 19:20:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1039,1389772800"; 
   d="scan'208";a="510577763"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        eranian@google.com, namhyung@kernel.org, jolsa@redhat.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 6/9] perf, tools: Fix srcline sort key output to use width
Date: Mon, 12 May 2014 16:20:26 -0700
Message-Id: <1399936829-28194-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399936829-28194-1-git-send-email-andi@firstfloor.org>
References: <1399936829-28194-1-git-send-email-andi@firstfloor.org>
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
index 635cd8f..d273cf2 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -284,7 +284,7 @@ static int hist_entry__srcline_snprintf(struct hist_entry *he, char *bf,
 					size_t size,
 					unsigned int width __maybe_unused)
 {
-	return repsep_snprintf(bf, size, "%s", he->srcline);
+	return repsep_snprintf(bf, size, "%.*s", width, he->srcline);
 }
 
 struct sort_entry sort_srcline = {
-- 
1.9.0

