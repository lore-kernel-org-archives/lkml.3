Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbaANF1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 00:27:40 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:60799 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaANF0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 00:26:08 -0500
X-AuditID: 9c93016f-b7b1aae000000f15-b5-52d4ca685fd7
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Andi Kleen <andi@firstfloor.org>,
        Arun Sharma <asharma@fb.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 24/24] perf tools: Enable --children option by default
Date: Tue, 14 Jan 2014 14:25:57 +0900
Message-Id: <1389677157-30513-25-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389677157-30513-1-git-send-email-namhyung@kernel.org>
References: <1389677157-30513-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now perf top and perf report will show children column by default if
it has callchain information.

Requested-by: Ingo Molnar <mingo@kernel.org>
Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/symbol.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 39ce9adbaaf0..186dca9df434 100644
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
1.7.11.7

