Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab3LRFWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 00:22:11 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:63059 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab3LRFVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 00:21:33 -0500
X-AuditID: 9c93017d-b7c5eae000004296-38-52b130daae11
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        Jiri Olsa <jolsa@redhat.com>, Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 18/18] perf report: Add report.cumulate config option
Date: Wed, 18 Dec 2013 14:21:26 +0900
Message-Id: <1387344086-12744-19-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
References: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Add report.cumulate config option for setting default value of
callchain accumulation.  It affects the report output only if
perf.data contains callchain info.

A user can write .perfconfig file like below to enable accumulation
by default:

  $ cat ~/.perfconfig
  [report]
  cumulate = true

And it can be disabled through command line:

  $ perf report --no-cumulate

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 206947a52fa8..923ed2752209 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -71,6 +71,10 @@ static int perf_report_config(const char *var, const char *value, void *cb)
 		rep->min_percent = strtof(value, NULL);
 		return 0;
 	}
+	if (!strcmp(var, "report.cumulate")) {
+		symbol_conf.cumulate_callchain = perf_config_bool(var, value);
+		return 0;
+	}
 
 	return perf_default_config(var, value, cb);
 }
-- 
1.7.11.7

