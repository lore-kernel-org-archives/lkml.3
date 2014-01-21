Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbaAUUpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 15:45:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37249 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbaAUUnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 15:43:18 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/8] perf timechart: Fix wrong SVG height
Date: Tue, 21 Jan 2014 17:42:57 -0300
Message-Id: <1390336984-1553-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1390336984-1553-1-git-send-email-acme@infradead.org>
References: <1390336984-1553-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stanislav Fomichev <stfomichev@yandex-team.ru>

If we call perf timechart with -p 0 arguments, it means we don't want
any tasks related data. It works, but space for tasks data is reserved
in the generated SVG. Remove this unused empty space via passing 0 as
count to the open_svg.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1390217980-22424-2-git-send-email-stfomichev@yandex-team.ru
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-timechart.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 652af0b66a62..25526d6eae59 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1045,6 +1045,9 @@ static void write_svg_file(struct timechart *tchart, const char *filename)
 		thresh /= 10;
 	} while (!process_filter && thresh && count < tchart->proc_num);
 
+	if (!tchart->proc_num)
+		count = 0;
+
 	open_svg(filename, tchart->numcpus, count, tchart->first_time, tchart->last_time);
 
 	svg_time_grid();
-- 
1.8.1.4

