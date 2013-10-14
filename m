Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab3JNUoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:44:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38553 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757536Ab3JNUCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:51 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 046/161] tools/perf/build: Pass through all targets to Makefile.perf
Date: Mon, 14 Oct 2013 17:00:35 -0300
Message-Id: <1381780950-25642-47-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

Jiri reported that 'make .o' stopped working:

  > [jolsa@krava perf]$ make -f Makefile perf.o
  > cc    -c -o perf.o perf.c
  > In file included from builtin.h:4:0,
  >                  from perf.c:9:
  > util/util.h:74:24: fatal error: lk/debugfs.h: No such file or directory
  > compilation terminated.
  > make: *** [perf.o] Error 1

This is due to GNU make having built-in rules for popular targets such
as *.o. Clear them out so that all targets as passed through to Makefile.perf.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/n/tip-5wkuvmlaaxtfgepKcvRij8sh@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/Makefile | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 3b925ad0d5f5..6f6f13a13bb6 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -1,3 +1,10 @@
+
+#
+# Clear out the built-in rules GNU make defines by default (such as .o targets),
+# so that we pass through all targets to Makefile.perf:
+#
+.SUFFIXES:
+
 #
 # Do a parallel build with multiple jobs, based on the number of CPUs online
 # in this system: 'make -j8' on a 8-CPU system, etc.
-- 
1.8.1.4

