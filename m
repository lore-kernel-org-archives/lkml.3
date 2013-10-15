Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686Ab3JOFTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:19:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60821 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932665Ab3JOFT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:19:29 -0400
Date: Mon, 14 Oct 2013 22:19:14 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-b016a0dd08999218a05a4b176bc08a9ff68ccc5e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build:
  Pass through all targets to Makefile.perf
Git-Commit-ID: b016a0dd08999218a05a4b176bc08a9ff68ccc5e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:19:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b016a0dd08999218a05a4b176bc08a9ff68ccc5e
Gitweb:     http://git.kernel.org/tip/b016a0dd08999218a05a4b176bc08a9ff68ccc5e
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Thu, 3 Oct 2013 14:32:10 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:59 +0200

tools/perf/build: Pass through all targets to Makefile.perf

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
