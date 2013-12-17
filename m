Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab3LQUwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:52:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56150 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430Ab3LQUwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:52:22 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/10] perf timechart: Print pid along the name
Date: Tue, 17 Dec 2013 17:52:04 -0300
Message-Id: <1387313531-14629-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387313531-14629-1-git-send-email-acme@infradead.org>
References: <1387313531-14629-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stanislav Fomichev <stfomichev@yandex-team.ru>

Add PID to the figures of CPU usage timechart.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>
Link: http://lkml.kernel.org/r/1385995056-20158-3-git-send-email-stfomichev@yandex-team.ru
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.8.1.4

