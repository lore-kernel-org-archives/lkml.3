Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbaIWBCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 21:02:20 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:59445 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104AbaIWBCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 21:02:17 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Milian Wolff <mail@milianw.de>
Subject: [PATCH 5/5] perf tools: Convert {record,top}.call-graph option to call-graph.record-mode
Date: Tue, 23 Sep 2014 10:01:44 +0900
Message-Id: <1411434104-5307-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411434104-5307-1-git-send-email-namhyung@kernel.org>
References: <1411434104-5307-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that it'll be passed to perf_callchain_config().

Reviewed-by: David Ahern <dsahern@gmail.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
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

