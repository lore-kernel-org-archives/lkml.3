Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934155Ab3DOFMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 01:12:17 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42959 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932513Ab3DOFLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 01:11:44 -0400
X-AuditID: 9c930179-b7bd8ae000004629-e2-516b8c0dac16
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 09/10] perf util: No need to call read_trace_init() in tracing_data_header()
Date: Mon, 15 Apr 2013 14:11:37 +0900
Message-Id: <1366002698-10728-10-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1366002698-10728-1-git-send-email-namhyung@kernel.org>
References: <1366002698-10728-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It's useless to call the read_trace_init() function at this time as we
don't need a returned pevent and it makes me confusing. :)

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/trace-event-info.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 9648175e2a1c..e85cbcf298f3 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -520,8 +520,6 @@ static int tracing_data_header(void)
 	else
 		buf[0] = 0;
 
-	read_trace_init(buf[0], buf[0]);
-
 	if (write(output_fd, buf, 1) != 1)
 		return -1;
 
-- 
1.7.11.7

