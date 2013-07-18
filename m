Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934202Ab3GRT72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:59:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41668 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759467Ab3GRTu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:28 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 56/76] perf diff: Display data file info ahead of the diff output
Date: Thu, 18 Jul 2013 16:49:43 -0300
Message-Id: <1374177003-3706-57-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Data files are referenced through the index of the file on the command
line. Adding list of data files for each index to ease up navigation for
user.

It's displayed only if in verbose mode.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/n/tip-dfjxa6n116ughjjxohpkuvi8@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 0cfe99e..9574ba1 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -481,6 +481,21 @@ static void hists__process(struct hists *base, struct hists *new)
 	hists__fprintf(base, true, 0, 0, 0, stdout);
 }
 
+static void data__fprintf(void)
+{
+	struct data__file *d;
+	int i;
+
+	fprintf(stdout, "# Data files:\n");
+
+	data__for_each_file(i, d)
+		fprintf(stdout, "#  [%d] %s %s\n",
+			d->idx, d->file,
+			!d->idx ? "(Baseline)" : "");
+
+	fprintf(stdout, "#\n");
+}
+
 static void data_process(void)
 {
 	struct perf_evlist *evlist_old = data__files[0].session->evlist;
@@ -500,6 +515,9 @@ static void data_process(void)
 
 		first = false;
 
+		if (verbose)
+			data__fprintf();
+
 		hists__process(&evsel_old->hists, &evsel_new->hists);
 	}
 }
-- 
1.8.1.4

