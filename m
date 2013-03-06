Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452Ab3CFFD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:03:59 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:54191 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab3CFFD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:03:58 -0500
From: Vinson Lee <vlee@twitter.com>
To: linux-kernel@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, Irina Tirdea <irina.tirdea@intel.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] perf tools: Fix LIBNUMA build with glibc 2.12 and older.
Date: Tue,  5 Mar 2013 21:03:43 -0800
Message-Id: <1362546223-20486-1-git-send-email-vlee@twitter.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tokens MADV_HUGEPAGE and MADV_NOHUGEPAGE are not available with
glibc 2.12 and older. Define these tokens if they are not already
defined.

This patch fixes these build errors with older versions of glibc.

    CC bench/numa.o
bench/numa.c: In function ‘alloc_data’:
bench/numa.c:334: error: ‘MADV_HUGEPAGE’ undeclared (first use in this function)
bench/numa.c:334: error: (Each undeclared identifier is reported only once
bench/numa.c:334: error: for each function it appears in.)
bench/numa.c:341: error: ‘MADV_NOHUGEPAGE’ undeclared (first use in this function)
make: *** [bench/numa.o] Error 1

Signed-off-by: Vinson Lee <vlee@twitter.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Irina Tirdea <irina.tirdea@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>

---
 tools/perf/bench/bench.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index a5223e6..6263f38 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -1,6 +1,13 @@
 #ifndef BENCH_H
 #define BENCH_H
 
+#ifndef MADV_HUGEPAGE
+#define MADV_HUGEPAGE 14
+#endif
+#ifndef MADV_NOHUGEPAGE
+#define MADV_NOHUGEPAGE 15
+#endif
+
 extern int bench_numa(int argc, const char **argv, const char *prefix);
 extern int bench_sched_messaging(int argc, const char **argv, const char *prefix);
 extern int bench_sched_pipe(int argc, const char **argv, const char *prefix);
-- 
1.7.0.4

