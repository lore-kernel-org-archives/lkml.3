Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab3KAQgI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:36:08 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:33654 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754567Ab3KAQfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:35:42 -0400
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, namhyung@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] perf timechart: add option to limit number of tasks
Date: Fri,  1 Nov 2013 20:25:46 +0400
Message-Id: <1383323151-19810-3-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1383323151-19810-1-git-send-email-stfomichev@yandex-team.ru>
References: <1383323151-19810-1-git-send-email-stfomichev@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add -n option to specify min. number of tasks to print.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 tools/perf/Documentation/perf-timechart.txt | 4 ++++
 tools/perf/builtin-timechart.c              | 5 ++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
index 1632b0efc757..919cbe9ce428 100644
--- a/tools/perf/Documentation/perf-timechart.txt
+++ b/tools/perf/Documentation/perf-timechart.txt
@@ -41,6 +41,10 @@ OPTIONS
 --symfs=<directory>::
         Look for files with symbols relative to this directory.
 
+-n::
+--proc-num::
+        Print task info for at least given number of tasks.
+
 SEE ALSO
 --------
 linkperf:perf-record[1]
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index c68ed44c2319..51a5532b3382 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -40,6 +40,7 @@
 #define SUPPORT_OLD_POWER_EVENTS 1
 #define PWR_EVENT_EXIT -1
 
+static int proc_num = 15;
 
 static unsigned int	numcpus;
 static u64		min_freq;	/* Lowest CPU frequency seen */
@@ -954,7 +955,7 @@ static void write_svg_file(const char *filename)
 	do {
 		count = determine_display_tasks(thresh);
 		thresh /= 10;
-	} while (!process_filter && thresh && count < 15);
+	} while (!process_filter && thresh && count < proc_num);
 
 	open_svg(filename, numcpus, count, first_time, last_time);
 
@@ -1096,6 +1097,8 @@ int cmd_timechart(int argc, const char **argv,
 		       parse_process),
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
+	OPT_INTEGER('n', "proc-num", &proc_num,
+		    "min. number of tasks to print"),
 	OPT_END()
 	};
 	const char * const timechart_usage[] = {
-- 
1.8.3.2

