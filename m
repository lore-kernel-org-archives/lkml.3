Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaEWKGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:06:33 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:49284 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaEWKEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:04:36 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 21/26] perf tools: Enable --children option by default
Date: Fri, 23 May 2014 19:04:18 +0900
Message-Id: <1400839463-21933-22-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400839463-21933-1-git-send-email-namhyung@kernel.org>
References: <1400839463-21933-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now perf top and perf report will show children column by default if
it has callchain information.

Requested-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
Tested-by: Arun Sharma <asharma@fb.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/symbol.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 95e249779931..7b9096f29cdb 100644
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
1.9.2

