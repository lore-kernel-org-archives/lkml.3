Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab3ENCKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 22:10:41 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:59853 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab3ENCJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 22:09:13 -0400
X-AuditID: 9c93017d-b7b62ae000004f69-6a-51919cc55a50
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 8/9] perf report: Add report.percent-limit config variable
Date: Tue, 14 May 2013 11:09:06 +0900
Message-Id: <1368497347-9628-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1368497347-9628-1-git-send-email-namhyung@kernel.org>
References: <1368497347-9628-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Now an user can set a default value of --percent-limit option into the
perfconfig file.

  $ cat ~/.perfconfig
  [report]
  percent-limit = 0.1

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 0a4979bdd4c4..ca98d34cd58b 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -62,6 +62,11 @@ static int perf_report_config(const char *var, const char *value, void *cb)
 		symbol_conf.event_group = perf_config_bool(var, value);
 		return 0;
 	}
+	if (!strcmp(var, "report.percent-limit")) {
+		struct perf_report *rep = cb;
+		rep->min_percent = strtof(value, NULL);
+		return 0;
+	}
 
 	return perf_default_config(var, value, cb);
 }
@@ -823,7 +828,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_END()
 	};
 
-	perf_config(perf_report_config, NULL);
+	perf_config(perf_report_config, &report);
 
 	argc = parse_options(argc, argv, options, report_usage, 0);
 
-- 
1.7.11.7

