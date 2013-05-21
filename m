Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab3EUGPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 02:15:35 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46119 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab3EUGOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 02:14:45 -0400
X-AuditID: 9c93017d-b7b64ae000000e51-8b-519b10d1824d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 5/7] perf report: Add -H (--hierarchy) option
Date: Tue, 21 May 2013 15:14:36 +0900
Message-Id: <1369116878-12489-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1369116878-12489-1-git-send-email-namhyung@kernel.org>
References: <1369116878-12489-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It's for enabling the hierarchical view.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-report.txt | 5 +++++
 tools/perf/builtin-report.c              | 6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 7d5f4f38aa52..3c86b9f83c54 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -210,6 +210,11 @@ OPTIONS
 	Demangle symbol names to human readable form. It's enabled by default,
 	disable with --no-demangle.
 
+-H::
+--hierarchy::
+	Show events in hierarchical view.  Each events are grouped under prior
+	sort keys.  Currently --gtk output is supported only.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-annotate[1]
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index d45bf9b0361d..9b9a35b296d8 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -809,6 +809,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN(0, "demangle", &symbol_conf.demangle,
 		    "Disable symbol demangling"),
 	OPT_BOOLEAN(0, "mem-mode", &report.mem_mode, "mem access profile"),
+	OPT_BOOLEAN('H', "hierarchy", &symbol_conf.hierarchy, "Hierarchical view"),
 	OPT_END()
 	};
 
@@ -833,6 +834,11 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 			input_name = "perf.data";
 	}
 
+	if (symbol_conf.hierarchy && use_browser != 2) {
+		pr_err("--hierarchy option is only used for --gtk output\n");
+		return -EINVAL;
+	}
+
 	if (strcmp(input_name, "-") != 0)
 		setup_browser(true);
 	else {
-- 
1.7.11.7

