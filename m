Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbaANBEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 20:04:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:62451 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755595AbaANBEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 20:04:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,656,1384329600"; 
   d="scan'208";a="466147303"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: jolsa@redhat.com, namhyung@kernel.org, mingo@kernel.org, dsahern@gmail.com,
        fweisbec@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 5/6] perf, tools: Only print base source file for srcline
Date: Mon, 13 Jan 2014 17:04:20 -0800
Message-Id: <1389661461-18996-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1389661461-18996-1-git-send-email-andi@firstfloor.org>
References: <1389661461-18996-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

For perf report with --sort srcline only print the base source file
name. This makes the results generally fit much better to the
screen. The path is usually not that useful anyways because it is
often from different systems.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/srcline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index 680c02b..88bf0e8 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -274,7 +274,7 @@ char *get_srcline(struct dso *dso, unsigned long addr)
 	if (!addr2line(dso_name, addr, &file, &line, dso))
 		goto out;
 
-	if (asprintf(&srcline, "%s:%u", file, line) < 0) {
+	if (asprintf(&srcline, "%s:%u", basename(file), line) < 0) {
 		free(file);
 		goto out;
 	}
-- 
1.8.3.1

