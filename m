Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbaAWAOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 19:14:21 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:58514 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756156AbaAWAOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 19:14:19 -0500
X-AuditID: 9c93017d-b7b51ae000000e33-6a-52e05ed274da
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Jiri Olsa <jolsa@redhat.com>, Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 16/21] perf report: Add report.children config option
Date: Thu, 23 Jan 2014 09:14:00 +0900
Message-Id: <1390436045-16830-17-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1390436045-16830-1-git-send-email-namhyung@kernel.org>
References: <1390436045-16830-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Tested-by: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 56fe8c00b1be..b8541ec61a00 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -78,7 +78,9 @@ static int report__config(const char *var, const char *value, void *cb)
 			symbol_conf.filter_relative = false;
 		else
 			return -1;
-
+	}
+	if (!strcmp(var, "report.children")) {
+		symbol_conf.cumulate_callchain = perf_config_bool(var, value);
 		return 0;
 	}
 
-- 
1.7.11.7

