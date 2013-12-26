Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab3LZFin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 00:38:43 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:56656 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab3LZFiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 00:38:11 -0500
X-AuditID: 9c93017e-b7cd8ae000002ce9-fc-52bbc0bf91dc
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 5/8] perf tools: Save message when pr_*() was called
Date: Thu, 26 Dec 2013 14:38:01 +0900
Message-Id: <1388036284-32342-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1388036284-32342-1-git-send-email-namhyung@kernel.org>
References: <1388036284-32342-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The message will be saved in a temp file so that it can be shown at a
UI dialog at any time.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/debug.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 299b55586502..f55b499c93fb 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -19,12 +19,18 @@ bool dump_trace = false, quiet = false;
 static int _eprintf(int level, const char *fmt, va_list args)
 {
 	int ret = 0;
+	va_list ap;
 
 	if (verbose >= level) {
+		va_copy(ap, args);
+
 		if (use_browser >= 1)
 			ui_helpline__vshow(fmt, args);
 		else
 			ret = vfprintf(stderr, fmt, args);
+
+		perf_log_addv(fmt, ap);
+		va_end(ap);
 	}
 
 	return ret;
-- 
1.7.11.7

