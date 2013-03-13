Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873Ab3CMLVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 07:21:05 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49328 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241Ab3CMLTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 07:19:50 -0400
X-AuditID: 9c930197-b7cc2ae000000eb7-93-514060d25727
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 5/6] perf util: Remove duplicated page_size definition
Date: Wed, 13 Mar 2013 20:19:44 +0900
Message-Id: <1363173585-9754-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1363173585-9754-1-git-send-email-namhyung@kernel.org>
References: <1363173585-9754-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It's defined in util/util.c and gets set from the begining of perf
run.  No need to duplicate it.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/trace-event-info.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 3c452b587daa..5729f434c5b1 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -43,8 +43,6 @@
 
 #define VERSION "0.5"
 
-unsigned int page_size;
-
 static const char *output_file = "trace.info";
 static int output_fd;
 
@@ -431,7 +429,6 @@ static void tracing_data_header(void)
 	write_or_die(buf, 1);
 
 	/* save page_size */
-	page_size = sysconf(_SC_PAGESIZE);
 	write_or_die(&page_size, 4);
 }
 
-- 
1.7.11.7

