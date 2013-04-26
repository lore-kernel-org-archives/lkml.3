Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab3DZRdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 13:33:50 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:53239 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab3DZRdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 13:33:49 -0400
Date: Fri, 26 Apr 2013 10:33:21 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf: powerpc: Fix compile errors in bp_signal files
Message-ID: <20130426173320.GA7029@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042617-7408-0000-0000-00000F800A4D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0e27e218def9ae630cc07efbd21664c150a3727a Mon Sep 17 00:00:00 2001
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Fri, 26 Apr 2013 10:17:56 -0700
Subject: [PATCH] perf: powerpc: Fix compile errors in bp_signal files

When building on powerpc,  we get compile errors in bp_signal.c and
bp_signal_overflow.c due to __u64 and '%llx'.

Powerpc, needs __SANE_USERSPACE_TYPES__ to be defined so we pick up
<asm-generic/int-ll64.h> and define __u64 as unsigned long long.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 tools/perf/tests/bp_signal.c          |    6 ++++++
 tools/perf/tests/bp_signal_overflow.c |    6 ++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/tools/perf/tests/bp_signal.c b/tools/perf/tests/bp_signal.c
index 68daa28..aba0954 100644
--- a/tools/perf/tests/bp_signal.c
+++ b/tools/perf/tests/bp_signal.c
@@ -4,6 +4,12 @@
  * (git://github.com/deater/perf_event_tests)
  */
 
+/*
+ * Powerpc needs __SANE_USERSPACE_TYPES__ before <linux/types.h> to select
+ * 'int-ll64.h' and avoid compile warnings when printing __u64 with %llu.
+ */
+#define __SANE_USERSPACE_TYPES__
+
 #include <stdlib.h>
 #include <stdio.h>
 #include <unistd.h>
diff --git a/tools/perf/tests/bp_signal_overflow.c b/tools/perf/tests/bp_signal_overflow.c
index fe7ed28..44ac821 100644
--- a/tools/perf/tests/bp_signal_overflow.c
+++ b/tools/perf/tests/bp_signal_overflow.c
@@ -3,6 +3,12 @@
  * perf_event_tests (git://github.com/deater/perf_event_tests)
  */
 
+/*
+ * Powerpc needs __SANE_USERSPACE_TYPES__ before <linux/types.h> to select
+ * 'int-ll64.h' and avoid compile warnings when printing __u64 with %llu.
+ */
+#define __SANE_USERSPACE_TYPES__
+
 #include <stdlib.h>
 #include <stdio.h>
 #include <unistd.h>
-- 
1.7.1

