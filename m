Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479AbaGEKms (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 06:42:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57875 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165AbaGEKmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 06:42:46 -0400
Date: Sat, 5 Jul 2014 03:42:27 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-5rfzbalwjphmdzzil74eazyl@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        acme@kernel.org, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        acme@kernel.org, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix wrong condition for allocation failure
Git-Commit-ID: d180ac14a95d738c2d2622db82c2212a8f998200
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d180ac14a95d738c2d2622db82c2212a8f998200
Gitweb:     http://git.kernel.org/tip/d180ac14a95d738c2d2622db82c2212a8f998200
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Fri, 20 Jun 2014 10:56:34 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Fri, 27 Jun 2014 11:14:54 +0200

perf tools: Fix wrong condition for allocation failure

Check real allocated pointer for NULL.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-5rfzbalwjphmdzzil74eazyl@git.kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 65a151e..3e80aa1 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -184,7 +184,7 @@ static void perf_evsel__reset_stat_priv(struct perf_evsel *evsel)
 static int perf_evsel__alloc_stat_priv(struct perf_evsel *evsel)
 {
 	evsel->priv = zalloc(sizeof(struct perf_stat));
-	if (evsel == NULL)
+	if (evsel->priv == NULL)
 		return -ENOMEM;
 	perf_evsel__reset_stat_priv(evsel);
 	return 0;
