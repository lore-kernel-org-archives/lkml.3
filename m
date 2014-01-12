Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaALSgj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:36:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45770 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaALSgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:36:33 -0500
Date: Sun, 12 Jan 2014 10:36:15 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-a42101418072d3be357b534521be2849518611e6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1387516278-17024-2-git-send-email-namhyung@kernel.org>
References: <1387516278-17024-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Use pr_*()
  functions where applicable
Git-Commit-ID: a42101418072d3be357b534521be2849518611e6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:36:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a42101418072d3be357b534521be2849518611e6
Gitweb:     http://git.kernel.org/tip/a42101418072d3be357b534521be2849518611e6
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 20 Dec 2013 14:11:12 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 20 Dec 2013 13:34:53 -0300

perf report: Use pr_*() functions where applicable

There're some places printing messages to stdout/err directly.

It should be converted to use proper error printing functions instead.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1387516278-17024-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index ec7399a..0c9ec3e 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -242,8 +242,8 @@ static int process_sample_event(struct perf_tool *tool,
 	int ret;
 
 	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
-		fprintf(stderr, "problem processing %d event, skipping it.\n",
-			event->header.type);
+		pr_debug("problem processing %d event, skipping it.\n",
+			 event->header.type);
 		return -1;
 	}
 
@@ -637,7 +637,7 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 		return -1;
 setup:
 	if (callchain_register_param(&callchain_param) < 0) {
-		fprintf(stderr, "Can't register callchain params\n");
+		pr_err("Can't register callchain params\n");
 		return -1;
 	}
 	return 0;
@@ -859,7 +859,7 @@ repeat:
 	}
 	if (report.mem_mode) {
 		if (sort__mode == SORT_MODE__BRANCH) {
-			fprintf(stderr, "branch and mem mode incompatible\n");
+			pr_err("branch and mem mode incompatible\n");
 			goto error;
 		}
 		sort__mode = SORT_MODE__MEMORY;
