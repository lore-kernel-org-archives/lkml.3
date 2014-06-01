Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbaFANeH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 09:34:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757686AbaFANcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 09:32:21 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 22/27] perf tools: Enable --children option by default
Date: Sun,  1 Jun 2014 15:31:33 +0200
Message-Id: <1401629498-8726-23-git-send-email-jolsa@kernel.org>
In-Reply-To: <1401629498-8726-1-git-send-email-jolsa@kernel.org>
References: <1401629498-8726-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Now perf top and perf report will show children column by default if
it has callchain information.

Requested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
Tested-by: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1401335910-16832-23-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/symbol.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 95e2497..7b9096f 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -29,11 +29,12 @@ int vmlinux_path__nr_entries;
 char **vmlinux_path;
 
 struct symbol_conf symbol_conf = {
-	.use_modules	  = true,
-	.try_vmlinux_path = true,
-	.annotate_src	  = true,
-	.demangle	  = true,
-	.symfs            = "",
+	.use_modules		= true,
+	.try_vmlinux_path	= true,
+	.annotate_src		= true,
+	.demangle		= true,
+	.cumulate_callchain	= true,
+	.symfs			= "",
 };
 
 static enum dso_binary_type binary_type_symtab[] = {
-- 
1.8.3.1

