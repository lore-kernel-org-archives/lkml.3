Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422638AbaIZUUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:20:32 -0400
Received: from mail.kernel.org ([198.145.19.201]:52810 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044AbaIZUU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:20:29 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Milian Wolff <mail@milianw.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/10] perf tools: Convert {record,top}.call-graph option to call-graph.record-mode
Date: Fri, 26 Sep 2014 17:19:46 -0300
Message-Id: <1411762787-26113-10-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411762787-26113-1-git-send-email-acme@kernel.org>
References: <1411762787-26113-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

So that it'll be passed to perf_callchain_config().

Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Milian Wolff <mail@milianw.de>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1411434104-5307-6-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 2 +-
 tools/perf/builtin-top.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 0ee647bcd2ec..44c6f3d55ce7 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -673,7 +673,7 @@ int record_callchain_opt(const struct option *opt __maybe_unused,
 static int perf_record_config(const char *var, const char *value, void *cb)
 {
 	if (!strcmp(var, "record.call-graph"))
-		return parse_callchain_record_opt(value);
+		var = "call-graph.record-mode"; /* fall-through */
 
 	return perf_default_config(var, value, cb);
 }
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 9d647a079d02..fc3d55f832ac 100644
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
1.9.3

