Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231Ab3FDFUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 01:20:47 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56528 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab3FDFUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 01:20:40 -0400
X-AuditID: 9c930179-b7c07ae000000e33-3e-51ad792283ed
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 16/16] perf util: Remove unused enum and macro in trace-event.h
Date: Tue,  4 Jun 2013 14:20:31 +0900
Message-Id: <1370323231-14022-17-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370323231-14022-1-git-send-email-namhyung@kernel.org>
References: <1370323231-14022-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

They're internals of ftrace ring-buffer and not used in perf code
directly.  As it now resides on libtraceevent/kbuffer.h, just get
rid of them.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/trace-event.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 96ad22f98726..929baae82f71 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -12,16 +12,6 @@ struct perf_tool;
 
 extern struct pevent *perf_pevent;
 
-enum {
-	RINGBUF_TYPE_PADDING		= 29,
-	RINGBUF_TYPE_TIME_EXTEND	= 30,
-	RINGBUF_TYPE_TIME_STAMP		= 31,
-};
-
-#ifndef TS_SHIFT
-#define TS_SHIFT		27
-#endif
-
 int bigendian(void);
 
 struct pevent *read_trace_init(int file_bigendian, int host_bigendian);
-- 
1.7.11.7

