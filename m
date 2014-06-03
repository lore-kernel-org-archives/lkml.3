Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964999AbaFCSeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:34:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44891 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967AbaFCSes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:34:48 -0400
Date: Tue, 3 Jun 2014 11:34:30 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-8d8e645ceafd726b8317949f899e4b3acfb20d29@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, rodrigo@sdfg.com.ar, namhyung@kernel.org,
        fweisbec@gmail.com, tglx@linutronix.de, asharma@fb.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, rodrigo@sdfg.com.ar, namhyung@kernel.org,
        fweisbec@gmail.com, tglx@linutronix.de, asharma@fb.com
In-Reply-To: <1401335910-16832-17-git-send-email-namhyung@kernel.org>
References: <1401335910-16832-17-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Add report.children config option
Git-Commit-ID: 8d8e645ceafd726b8317949f899e4b3acfb20d29
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

Commit-ID:  8d8e645ceafd726b8317949f899e4b3acfb20d29
Gitweb:     http://git.kernel.org/tip/8d8e645ceafd726b8317949f899e4b3acfb20d29
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 22 Jan 2013 18:09:46 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Sun, 1 Jun 2014 14:35:04 +0200

perf report: Add report.children config option

Add report.children config option for setting default value of
callchain accumulation.  It affects the report output only if
perf.data contains callchain info.

A user can write .perfconfig file like below to enable accumulation
by default:

  $ cat ~/.perfconfig
  [report]
  children = true

And it can be disabled through command line:

  $ perf report --no-children

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Arun Sharma <asharma@fb.com>
Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1401335910-16832-17-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-report.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f27a8aa..6cac509 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -72,6 +72,10 @@ static int report__config(const char *var, const char *value, void *cb)
 		rep->min_percent = strtof(value, NULL);
 		return 0;
 	}
+	if (!strcmp(var, "report.children")) {
+		symbol_conf.cumulate_callchain = perf_config_bool(var, value);
+		return 0;
+	}
 
 	return perf_default_config(var, value, cb);
 }
