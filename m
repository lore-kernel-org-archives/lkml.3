Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715AbaFANcW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 09:32:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbaFANcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 09:32:19 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 21/27] perf top: Add top.children config option
Date: Sun,  1 Jun 2014 15:31:32 +0200
Message-Id: <1401629498-8726-22-git-send-email-jolsa@kernel.org>
In-Reply-To: <1401629498-8726-1-git-send-email-jolsa@kernel.org>
References: <1401629498-8726-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Add top.children config option for setting default value of
callchain accumulation.  It affects the output only if one of
-g or --call-graph option is given as well.

A user can write .perfconfig file like below to enable accumulation
by default:

  $ cat ~/.perfconfig
  [top]
  children = true

And it can be disabled through command line:

  $ perf top --no-children

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Arun Sharma <asharma@fb.com>
Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1401335910-16832-22-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-top.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index fea55e3..377971d 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1004,6 +1004,10 @@ static int perf_top_config(const char *var, const char *value, void *cb)
 
 	if (!strcmp(var, "top.call-graph"))
 		return record_parse_callchain(value, &top->record_opts);
+	if (!strcmp(var, "top.children")) {
+		symbol_conf.cumulate_callchain = perf_config_bool(var, value);
+		return 0;
+	}
 
 	return perf_default_config(var, value, cb);
 }
-- 
1.8.3.1

