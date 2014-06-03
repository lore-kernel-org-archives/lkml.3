Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965088AbaFCSfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:35:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44956 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933596AbaFCSfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:35:46 -0400
Date: Tue, 3 Jun 2014 11:35:30 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-104ac991bd821773cba6f262f97a4a752ed76dd5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, rodrigo@sdfg.com.ar, namhyung@kernel.org,
        fweisbec@gmail.com, tglx@linutronix.de, asharma@fb.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, rodrigo@sdfg.com.ar, namhyung@kernel.org,
        fweisbec@gmail.com, tglx@linutronix.de, asharma@fb.com
In-Reply-To: <1401335910-16832-22-git-send-email-namhyung@kernel.org>
References: <1401335910-16832-22-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Add top.children config option
Git-Commit-ID: 104ac991bd821773cba6f262f97a4a752ed76dd5
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

Commit-ID:  104ac991bd821773cba6f262f97a4a752ed76dd5
Gitweb:     http://git.kernel.org/tip/104ac991bd821773cba6f262f97a4a752ed76dd5
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 22 Jan 2013 18:09:46 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Sun, 1 Jun 2014 14:35:07 +0200

perf top: Add top.children config option

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
