Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbaHLGml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 02:42:41 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:41274 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbaHLGku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 02:40:50 -0400
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
Subject: [PATCH 09/13] perf sched: Move call to symbol__init() after creating session
Date: Tue, 12 Aug 2014 15:40:41 +0900
Message-Id: <1407825645-24586-10-git-send-email-namhyung@kernel.org>
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
 tools/perf/builtin-sched.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 7c16aeb6b675..dcd9ebf5a7df 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1462,6 +1462,8 @@ static int perf_sched__read_events(struct perf_sched *sched,
 		return -1;
 	}
 
+	symbol__init();
+
 	if (perf_session__set_tracepoints_handlers(session, handlers))
 		goto out_delete;
 
@@ -1747,7 +1749,6 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (!strcmp(argv[0], "script"))
 		return cmd_script(argc, argv, prefix);
 
-	symbol__init();
 	if (!strncmp(argv[0], "rec", 3)) {
 		return __cmd_record(argc, argv);
 	} else if (!strncmp(argv[0], "lat", 3)) {
-- 
2.0.0

