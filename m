Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbaF0MV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 08:21:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874AbaF0MVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 08:21:24 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/5] perf tools: Fix wrong condition for allocation failure
Date: Fri, 27 Jun 2014 14:20:59 +0200
Message-Id: <1403871661-18474-4-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403871661-18474-1-git-send-email-jolsa@kernel.org>
References: <1403871661-18474-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
-- 
1.8.3.1

