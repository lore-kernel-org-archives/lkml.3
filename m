Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbaITQSt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 12:18:49 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:62985 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131AbaITQSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 12:18:48 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Milian Wolff <mail@milianw.de>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] perf tools: Convert {record,top}.call-graph option to call-graph.record-mode
Date: Sun, 21 Sep 2014 01:18:06 +0900
Message-Id: <1411229886-24390-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411229886-24390-1-git-send-email-namhyung@kernel.org>
References: <1411229886-24390-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that it'll be passed to perf_callchain_config().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-record.c | 2 +-
 tools/perf/builtin-top.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 12e1f2255f89..86ed253fa1b8 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -670,7 +670,7 @@ int record_callchain_opt(const struct option *opt __maybe_unused,
 static int perf_record_config(const char *var, const char *value, void *cb)
 {
 	if (!strcmp(var, "record.call-graph"))
-		return parse_callchain_record_opt(value);
+		var = "call-graph.record-mode"; /* fall-through */
 
 	return perf_default_config(var, value, cb);
 }
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 45a3a461286f..d6cd4c3b13a0 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1021,7 +1021,7 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 static int perf_top_config(const char *var, const char *value, void *cb)
 {
 	if (!strcmp(var, "top.call-graph"))
-		return parse_callchain_record_opt(value);
+		var = "call-graph.record-mode"; /* fall-through */
 	if (!strcmp(var, "top.children")) {
 		symbol_conf.cumulate_callchain = perf_config_bool(var, value);
 		return 0;
-- 
2.1.0

