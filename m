Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab3I3JBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 05:01:20 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42057 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab3I3JBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 05:01:19 -0400
X-AuditID: 9c930179-b7c8bae000006c65-5f-52493ddde619
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH] perf stat: Set child_pid after perf_evlist__prepare_workload()
Date: Mon, 30 Sep 2013 18:01:11 +0900
Message-Id: <1380531671-28076-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The commit acf2892270dc ("perf stat: Use perf_evlist__prepare/
start_workload()") converted to use the function but forgot to update
child_pid.  Fix it.

Cc: David Ahern <dsahern@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-stat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index f686d5ff594e..5098f144b92d 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -457,6 +457,7 @@ static int __run_perf_stat(int argc, const char **argv)
 			perror("failed to prepare workload");
 			return -1;
 		}
+		child_pid = evsel_list->workload.pid;
 	}
 
 	if (group)
-- 
1.7.11.7

