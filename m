Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbaB1EWi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 23:22:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:61057 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbaB1EWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 23:22:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,559,1389772800"; 
   d="scan'208";a="463876464"
From: Andi Kleen <andi@firstfloor.org>
To: acme@redhat.com
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, eranian@google.com,
        namhyung@kernel.org, jolsa@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 5/8] perf, tools: Only print base source file for srcline
Date: Thu, 27 Feb 2014 20:22:29 -0800
Message-Id: <1393561352-23448-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393561352-23448-1-git-send-email-andi@firstfloor.org>
References: <1393561352-23448-1-git-send-email-andi@firstfloor.org>
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
1.8.5.3

