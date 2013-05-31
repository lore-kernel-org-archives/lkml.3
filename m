Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab3EaLnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:43:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56858 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab3EaLns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:43:48 -0400
Date: Fri, 31 May 2013 04:43:29 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-eec574e6bc3ee4558d4a282e0e3e1bd6dd0ad67b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        andi@firstfloor.org, a.p.zijlstra@chello.nl, penberg@kernel.org,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1368497347-9628-9-git-send-email-namhyung@kernel.org>
References: <1368497347-9628-9-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report:
  Add report.percent-limit config variable
Git-Commit-ID: eec574e6bc3ee4558d4a282e0e3e1bd6dd0ad67b
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

Commit-ID:  eec574e6bc3ee4558d4a282e0e3e1bd6dd0ad67b
Gitweb:     http://git.kernel.org/tip/eec574e6bc3ee4558d4a282e0e3e1bd6dd0ad67b
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 14 May 2013 11:09:06 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 28 May 2013 16:24:02 +0300

perf report: Add report.percent-limit config variable

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
 
