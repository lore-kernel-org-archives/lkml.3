Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbaKUViq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 16:38:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:37215 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbaKUVip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 16:38:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,432,1413270000"; 
   d="scan'208";a="636139656"
From: Andi Kleen <andi@firstfloor.org>
To: acme@kernel.org
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/2] perf, tools: Allow to force redirect pr_debug to stderr.
Date: Fri, 21 Nov 2014 13:38:00 -0800
Message-Id: <1416605880-25055-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416605880-25055-1-git-send-email-andi@firstfloor.org>
References: <1416605880-25055-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

When debugging the tui browser I find it useful to
redirect the debug log into a file. Currently it's always
forced to the message line.

Add an option to force it to stderr. Then it can be
easily redirected.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/debug.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index ba357f3..ad60b2f 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -19,13 +19,14 @@
 int verbose;
 bool dump_trace = false, quiet = false;
 int debug_ordered_events;
+static int redirect_to_stderr;
 
 static int _eprintf(int level, int var, const char *fmt, va_list args)
 {
 	int ret = 0;
 
 	if (var >= level) {
-		if (use_browser >= 1)
+		if (use_browser >= 1 && !redirect_to_stderr)
 			ui_helpline__vshow(fmt, args);
 		else
 			ret = vfprintf(stderr, fmt, args);
@@ -145,6 +146,7 @@ static struct debug_variable {
 } debug_variables[] = {
 	{ .name = "verbose",		.ptr = &verbose },
 	{ .name = "ordered-events",	.ptr = &debug_ordered_events},
+	{ .name = "stderr",		.ptr = &redirect_to_stderr},
 	{ .name = NULL, }
 };
 
-- 
1.9.3

