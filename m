Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934089Ab3DOFLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 01:11:49 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42959 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933371Ab3DOFLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 01:11:43 -0400
X-AuditID: 9c930179-b7bd8ae000004629-d6-516b8c0dfb6e
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 06/10] perf util: Get rid of unused header_page_* variables
Date: Mon, 15 Apr 2013 14:11:34 +0900
Message-Id: <1366002698-10728-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1366002698-10728-1-git-send-email-namhyung@kernel.org>
References: <1366002698-10728-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

They're not used anywhere and same information is kept in a pevent
already.  So let's get rid of them.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/trace-event-parse.c | 4 ----
 tools/perf/util/trace-event.h       | 4 ----
 2 files changed, 8 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 4454835a9ebc..0deae885c7ba 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -28,10 +28,6 @@
 #include "util.h"
 #include "trace-event.h"
 
-int header_page_size_size;
-int header_page_ts_size;
-int header_page_data_offset;
-
 bool latency_format;
 
 struct pevent *read_trace_init(int file_bigendian, int host_bigendian)
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 1978c398ad87..10d6e7b202c5 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -10,10 +10,6 @@ struct perf_sample;
 union perf_event;
 struct perf_tool;
 
-extern int header_page_size_size;
-extern int header_page_ts_size;
-extern int header_page_data_offset;
-
 extern bool latency_format;
 extern struct pevent *perf_pevent;
 
-- 
1.7.11.7

