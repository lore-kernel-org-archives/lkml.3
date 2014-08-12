Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbaHLGmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 02:42:42 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:41257 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbaHLGku (ORCPT
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
Subject: [PATCH 08/13] perf lock: Move call to symbol__init() after creating session
Date: Tue, 12 Aug 2014 15:40:40 +0900
Message-Id: <1407825645-24586-9-git-send-email-namhyung@kernel.org>
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
 tools/perf/builtin-lock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index c8122d323621..d73580b39908 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -865,6 +865,8 @@ static int __cmd_report(bool display_info)
 		return -ENOMEM;
 	}
 
+	symbol__init();
+
 	if (!perf_session__has_traces(session, "lock record"))
 		goto out_delete;
 
@@ -974,7 +976,6 @@ int cmd_lock(int argc, const char **argv, const char *prefix __maybe_unused)
 	unsigned int i;
 	int rc = 0;
 
-	symbol__init();
 	for (i = 0; i < LOCKHASH_SIZE; i++)
 		INIT_LIST_HEAD(lockhash_table + i);
 
-- 
2.0.0

