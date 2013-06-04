Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543Ab3FDFWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 01:22:48 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:62012 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab3FDFUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 01:20:37 -0400
X-AuditID: 9c930179-b7c07ae000000e33-35-51ad792268a6
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 10/16] perf util: Skip reading header_event file
Date: Tue,  4 Jun 2013 14:20:25 +0900
Message-Id: <1370323231-14022-11-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370323231-14022-1-git-send-email-namhyung@kernel.org>
References: <1370323231-14022-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It seems perf does not parse header_event file so we can skip it as we
do for header_page file.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/trace-event-read.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 0dd9fbda88eb..fa45fca2a2d3 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -212,7 +212,6 @@ static int read_ftrace_printk(struct pevent *pevent)
 static int read_header_files(struct pevent *pevent)
 {
 	unsigned long long size;
-	char *header_event;
 	char buf[BUFSIZ];
 	int ret = 0;
 
@@ -236,14 +235,8 @@ static int read_header_files(struct pevent *pevent)
 	}
 
 	size = read8(pevent);
-	header_event = malloc(size);
-	if (header_event == NULL)
-		return -1;
-
-	if (do_read(header_event, size) < 0)
-		ret = -1;
+	skip(size);
 
-	free(header_event);
 	return ret;
 }
 
-- 
1.7.11.7

