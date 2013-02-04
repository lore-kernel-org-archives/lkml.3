Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab3BDA14 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 19:27:56 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:41772 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab3BDA1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 19:27:54 -0500
From: Ben Noordhuis <info@bnoordhuis.nl>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ben Noordhuis <info@bnoordhuis.nl>
Subject: [PATCH] perf: fix undefined symbols in python binding
Date: Mon,  4 Feb 2013 01:27:32 +0100
Message-Id: <1359937652-16186-1-git-send-email-info@bnoordhuis.nl>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dummy test_attr__enabled and test_attr__open symbols to
util/python.c to fix the following dynamic linker error:

  $ python python/twatch.py
  Traceback (most recent call last):
    File "python/twatch.py", line 16, in <module>
      import perf
  ImportError: /path/to/perf.so: undefined symbol: test_attr__enabled

Signed-off-by: Ben Noordhuis <info@bnoordhuis.nl>
---
 tools/perf/util/python.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index a2657fd..163abbb 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -8,6 +8,15 @@
 #include "cpumap.h"
 #include "thread_map.h"
 
+/* Dummy to satisfy linker. */
+bool test_attr__enabled;
+
+/* Dummy to satisfy linker. */
+void test_attr__open(struct perf_event_attr *attr, pid_t pid, int cpu,
+	int fd, int group_fd, unsigned long flags)
+{
+}
+
 /* Define PyVarObject_HEAD_INIT for python 2.5 */
 #ifndef PyVarObject_HEAD_INIT
 # define PyVarObject_HEAD_INIT(type, size) PyObject_HEAD_INIT(type) size,
-- 
1.7.9.5

