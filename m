Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbaHLGll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 02:41:41 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:41300 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbaHLGkv (ORCPT
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
Subject: [PATCH 11/13] perf timechart: Move call to symbol__init() after creating session
Date: Tue, 12 Aug 2014 15:40:43 +0900
Message-Id: <1407825645-24586-12-git-send-email-namhyung@kernel.org>
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
 tools/perf/builtin-timechart.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 912e3b5bb22b..df3b1c5ae7b9 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1607,6 +1607,8 @@ static int __cmd_timechart(struct timechart *tchart, const char *output_name)
 	if (session == NULL)
 		return -ENOMEM;
 
+	symbol__init();
+
 	(void)perf_header__process_sections(&session->header,
 					    perf_data_file__fd(session->file),
 					    tchart,
@@ -1982,8 +1984,6 @@ int cmd_timechart(int argc, const char **argv,
 		return -1;
 	}
 
-	symbol__init();
-
 	if (argc && !strncmp(argv[0], "rec", 3)) {
 		argc = parse_options(argc, argv, record_options, record_usage,
 				     PARSE_OPT_STOP_AT_NON_OPTION);
-- 
2.0.0

