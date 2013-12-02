Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab3LBOiC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:38:02 -0500
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:46654 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752123Ab3LBOh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:37:59 -0500
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, stfomichev@yandex-team.ru,
        namhyung@kernel.org, artagnon@gmail.com, jolsa@redhat.com
Subject: [PATCH 2/5] perf timechart: print pid along the name
Date: Mon,  2 Dec 2013 18:37:34 +0400
Message-Id: <1385995056-20158-3-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385995056-20158-1-git-send-email-stfomichev@yandex-team.ru>
References: <1385995056-20158-1-git-send-email-stfomichev@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add PID to the figures of CPU usage timechart.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 tools/perf/builtin-timechart.c | 1 +
 tools/perf/util/svghelper.c    | 4 ++--
 tools/perf/util/svghelper.h    | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index d955095b6d63..99fe363f1de8 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -841,6 +841,7 @@ static void draw_cpu_usage(struct timechart *tchart)
 					svg_process(sample->cpu,
 						    sample->start_time,
 						    sample->end_time,
+						    p->pid,
 						    "sample",
 						    c->comm,
 						    sample->backtrace);
diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index 740f0328fc13..927851d05d03 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -285,7 +285,7 @@ void svg_cpu_box(int cpu, u64 __max_freq, u64 __turbo_freq)
 	fprintf(svgfile, "</g>\n");
 }
 
-void svg_process(int cpu, u64 start, u64 end, const char *type, const char *name, const char *backtrace)
+void svg_process(int cpu, u64 start, u64 end, int pid, const char *type, const char *name, const char *backtrace)
 {
 	double width;
 
@@ -294,7 +294,7 @@ void svg_process(int cpu, u64 start, u64 end, const char *type, const char *name
 
 
 	fprintf(svgfile, "<g transform=\"translate(%4.8f,%4.8f)\">\n", time2pixels(start), cpu2y(cpu));
-	fprintf(svgfile, "<title>%s %s</title>\n", name, time_to_string(end - start));
+	fprintf(svgfile, "<title>%d %s running %s</title>\n", pid, name, time_to_string(end - start));
 	if (backtrace)
 		fprintf(svgfile, "<desc>Switched because:\n%s</desc>\n", backtrace);
 	fprintf(svgfile, "<rect x=\"0\" width=\"%4.8f\" y=\"0\" height=\"%4.1f\" class=\"%s\"/>\n",
diff --git a/tools/perf/util/svghelper.h b/tools/perf/util/svghelper.h
index 7db6ae98bf2c..8b77ca631686 100644
--- a/tools/perf/util/svghelper.h
+++ b/tools/perf/util/svghelper.h
@@ -11,7 +11,7 @@ extern void svg_waiting(int Yslot, int cpu, u64 start, u64 end, const char *back
 extern void svg_cpu_box(int cpu, u64 max_frequency, u64 turbo_frequency);
 
 
-extern void svg_process(int cpu, u64 start, u64 end, const char *type, const char *name, const char *backtrace);
+extern void svg_process(int cpu, u64 start, u64 end, int pid, const char *type, const char *name, const char *backtrace);
 extern void svg_cstate(int cpu, u64 start, u64 end, int type);
 extern void svg_pstate(int cpu, u64 start, u64 end, u64 freq);
 
-- 
1.8.3.2

