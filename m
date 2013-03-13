Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab3CMLVp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 07:21:45 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49328 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188Ab3CMLTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 07:19:49 -0400
X-AuditID: 9c930197-b7cc2ae000000eb7-8e-514060d29e4d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/6] perf util: Remove unnecessary calc_data_size variable
Date: Wed, 13 Mar 2013 20:19:42 +0900
Message-Id: <1363173585-9754-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1363173585-9754-1-git-send-email-namhyung@kernel.org>
References: <1363173585-9754-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It's not set from anywhere so no need to keep it.  Looks like an
unneeded copy of the same variable in trace-event-read.c

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/trace-event-info.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index b0bbd76f4a56..783ab51e3ff7 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -119,17 +119,10 @@ static void put_tracing_file(char *file)
 	free(file);
 }
 
-static ssize_t calc_data_size;
-
 static ssize_t write_or_die(const void *buf, size_t len)
 {
 	int ret;
 
-	if (calc_data_size) {
-		calc_data_size += len;
-		return len;
-	}
-
 	ret = write(output_fd, buf, len);
 	if (ret < 0)
 		die("writing to '%s'", output_file);
-- 
1.7.11.7

