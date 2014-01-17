Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaAQPCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:02:00 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36285 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbaAQO5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:57:38 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/19] perf tools: Add 'build-test' make target
Date: Fri, 17 Jan 2014 11:57:19 -0300
Message-Id: <1389970645-12075-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389970645-12075-1-git-send-email-acme@infradead.org>
References: <1389970645-12075-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Currently various build test can be performed using a Makefile named
tests/make, so one needs to remember and specify it with -f option on
command line.

Add the 'build-test' target in the main Makefile as a shortcut.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1389837173-3632-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.8.1.4

