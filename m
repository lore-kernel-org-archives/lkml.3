Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbaAHIuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:50:46 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:61879 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905AbaAHIqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:46:51 -0500
X-AuditID: 9c93017d-b7b66ae000006a2a-2b-52cd1070856f
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 20/28] perf report: Add report.children config option
Date: Wed,  8 Jan 2014 17:46:25 +0900
Message-Id: <1389170793-21926-21-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
References: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add report.children config option for setting default value of
callchain accumulation.  It affects the report output only if
perf.data contains callchain info.

A user can write .perfconfig file like below to enable accumulation
by default:

  $ cat ~/.perfconfig
  [report]
  children = true

And it can be disabled through command line:

  $ perf report --no-children

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 6db8d6d74ad1..a15fa05e4a70 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -71,6 +71,10 @@ static int report__config(const char *var, const char *value, void *cb)
 		rep->min_percent = strtof(value, NULL);
 		return 0;
 	}
+	if (!strcmp(var, "report.children")) {
+		symbol_conf.cumulate_callchain = perf_config_bool(var, value);
+		return 0;
+	}
 
 	return perf_default_config(var, value, cb);
 }
-- 
1.7.11.7

