Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbaANEnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 23:43:51 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54417 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbaANEnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 23:43:23 -0500
X-AuditID: 9c93016f-b7b1aae000000f15-70-52d4c068f1d9
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 4/5] perf report: Add report.percentage config option
Date: Tue, 14 Jan 2014 13:43:18 +0900
Message-Id: <1389674599-28227-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389674599-28227-1-git-send-email-namhyung@kernel.org>
References: <1389674599-28227-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add report.percentage option for setting default value of the
symbol_conf.filter_relative.  It affects the report output only if a
filter applied.

An user can write .perfconfig file like below to show absolute
percentage of filtered entries by default:

  $ cat ~/.perfconfig
  [report]
  percentage = absolute

And it can be changed through command line:

  $ perf report --percentage relative

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 535bd6745355..1bb9e989c7bd 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -71,6 +71,16 @@ static int report__config(const char *var, const char *value, void *cb)
 		rep->min_percent = strtof(value, NULL);
 		return 0;
 	}
+	if (!strcmp(var, "report.percentage")) {
+		if (!strcmp(value, "relative"))
+			symbol_conf.filter_relative = true;
+		else if (!strcmp(value, "absolute"))
+			symbol_conf.filter_relative = false;
+		else
+			return -1;
+
+		return 0;
+	}
 
 	return perf_default_config(var, value, cb);
 }
-- 
1.7.11.7

