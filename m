Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbaHLGlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 02:41:40 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:41287 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbaHLGkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 02:40:51 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 10/13] perf script: Move call to symbol__init() after creating session
Date: Tue, 12 Aug 2014 15:40:42 +0900
Message-Id: <1407825645-24586-11-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1407825645-24586-1-git-send-email-namhyung@kernel.org>
References: <1407825645-24586-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparation of fixing dso__load_kernel_sym().  It needs a
session info before calling symbol__init().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-script.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 534172b889c3..7de6ce76fa25 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1719,8 +1719,6 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 		exit(-1);
 	}
 
-	if (symbol__init() < 0)
-		return -1;
 	if (!script_name)
 		setup_pager();
 
@@ -1734,6 +1732,9 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 			goto out_delete;
 	}
 
+	if (symbol__init() < 0)
+		goto out_delete;
+
 	script.session = session;
 
 	if (cpu_list) {
-- 
2.0.0

