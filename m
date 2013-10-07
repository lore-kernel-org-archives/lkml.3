Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab3JGL77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 07:59:59 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:60421 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617Ab3JGL6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:58:33 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 45/50] tools/perf/build: Pass through all targets to Makefile.perf
Date: Mon,  7 Oct 2013 13:56:38 +0200
Message-Id: <1381147003-2574-46-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381147003-2574-1-git-send-email-mingo@kernel.org>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index 3b925ad..6f6f13a 100644
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
1.7.11.7

