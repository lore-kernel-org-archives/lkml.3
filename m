Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030216Ab3GSHv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:51:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35754 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966041Ab3GSHvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:51:55 -0400
Date: Fri, 19 Jul 2013 00:51:37 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-dfjxa6n116ughjjxohpkuvi8@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf diff:
  Display data file info ahead of the diff output
Git-Commit-ID: 1d81c7fc25c0f0559e3306fc73ecfe78b740c9e8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:51:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1d81c7fc25c0f0559e3306fc73ecfe78b740c9e8
Gitweb:     http://git.kernel.org/tip/1d81c7fc25c0f0559e3306fc73ecfe78b740c9e8
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Sat, 1 Dec 2012 21:56:03 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:54:06 -0300

perf diff: Display data file info ahead of the diff output

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
