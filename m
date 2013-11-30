Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab3K3Mvo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 07:51:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59619 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab3K3Mvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 07:51:39 -0500
Date: Sat, 30 Nov 2013 04:51:24 -0800
From: tip-bot for Stanislav Fomichev <tipbot@zytor.com>
Message-ID: <tip-54874e3236b834064943c02a647823ab5d97be57@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, stfomichev@yandex-team.ru,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, stfomichev@yandex-team.ru, tglx@linutronix.de
In-Reply-To: <1383323151-19810-3-git-send-email-stfomichev@yandex-team.ru>
References: <1383323151-19810-3-git-send-email-stfomichev@yandex-team.ru>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf timechart:
  Add option to limit number of tasks
Git-Commit-ID: 54874e3236b834064943c02a647823ab5d97be57
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 30 Nov 2013 04:51:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  54874e3236b834064943c02a647823ab5d97be57
Gitweb:     http://git.kernel.org/tip/54874e3236b834064943c02a647823ab5d97be57
Author:     Stanislav Fomichev <stfomichev@yandex-team.ru>
AuthorDate: Fri, 1 Nov 2013 20:25:46 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 27 Nov 2013 14:58:36 -0300

perf timechart: Add option to limit number of tasks

Add -n option to specify min. number of tasks to print.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1383323151-19810-3-git-send-email-stfomichev@yandex-team.ru
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-timechart.txt | 4 ++++
 tools/perf/builtin-timechart.c              | 5 ++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
index 3ff8bd4..4373144 100644
--- a/tools/perf/Documentation/perf-timechart.txt
+++ b/tools/perf/Documentation/perf-timechart.txt
@@ -54,6 +54,10 @@ $ perf timechart
 
   Written 10.2 seconds of trace to output.svg.
 
+-n::
+--proc-num::
+        Print task info for at least given number of tasks.
+
 SEE ALSO
 --------
 linkperf:perf-record[1]
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index bb21e57..c352be4 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -41,6 +41,7 @@
 #define SUPPORT_OLD_POWER_EVENTS 1
 #define PWR_EVENT_EXIT -1
 
+static int proc_num = 15;
 
 static unsigned int	numcpus;
 static u64		min_freq;	/* Lowest CPU frequency seen */
@@ -955,7 +956,7 @@ static void write_svg_file(const char *filename)
 	do {
 		count = determine_display_tasks(thresh);
 		thresh /= 10;
-	} while (!process_filter && thresh && count < 15);
+	} while (!process_filter && thresh && count < proc_num);
 
 	open_svg(filename, numcpus, count, first_time, last_time);
 
@@ -1102,6 +1103,8 @@ int cmd_timechart(int argc, const char **argv,
 		       parse_process),
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
+	OPT_INTEGER('n', "proc-num", &proc_num,
+		    "min. number of tasks to print"),
 	OPT_END()
 	};
 	const char * const timechart_usage[] = {
