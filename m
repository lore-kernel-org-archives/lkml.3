Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935458Ab3E3QLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:11:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50991 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934606Ab3E3QCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:17 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 25/66] perf report: Add report.percent-limit config variable
Date: Thu, 30 May 2013 19:00:58 +0300
Message-Id: <1369929699-8724-26-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Now an user can set a default value of --percent-limit option into the
perfconfig file.

  $ cat ~/.perfconfig
  [report]
  percent-limit = 0.1

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1368497347-9628-9-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 0a4979b..ca98d34 100644
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
1.8.1.4

