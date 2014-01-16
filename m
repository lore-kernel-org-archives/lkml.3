Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaAPBxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 20:53:05 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:62639 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaAPBxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 20:53:04 -0500
X-AuditID: 9c93017e-b7b63ae000000e6a-2c-52d73b7e1c41
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] perf tools: Add 'build-test' make target
Date: Thu, 16 Jan 2014 10:52:53 +0900
Message-Id: <1389837173-3632-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently various build test was done with a Makefile named tests/make
so one needs to remember and specify it with -f option on command
line.  Add the 'build-test' target in the main Makefile as a shortcut.

Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index eefb9fb0c02f..cb2e5868c8e8 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -75,6 +75,12 @@ clean:
 	$(make)
 
 #
+# The build-test target is not really parallel, don't print the jobs info:
+#
+build-test:
+	@$(MAKE) -f tests/make --no-print-directory
+
+#
 # All other targets get passed through:
 #
 %:
-- 
1.7.11.7

