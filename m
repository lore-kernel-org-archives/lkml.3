Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbaIZXhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 19:37:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:4922 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755848AbaIZXhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 19:37:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,606,1406617200"; 
   d="scan'208";a="597492931"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/8] perf, tools: Only print base source file for srcline
Date: Fri, 26 Sep 2014 16:37:12 -0700
Message-Id: <1411774636-6870-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411774636-6870-1-git-send-email-andi@firstfloor.org>
References: <1411774636-6870-1-git-send-email-andi@firstfloor.org>
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
index c6a7cdc..ac877f9 100644
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
1.9.3

