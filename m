Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab3AXFov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 00:44:51 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:34797 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab3AXFon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 00:44:43 -0500
Date: Wed, 23 Jan 2013 21:44:39 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>, Anton Blanchard <anton@au1.ibm.com>,
        ellerman@au1.ibm.com, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH][v2] perf tools, powerpc: Fix compile warnings in
 tests/attr.c
Message-ID: <20130124054439.GA31588@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012405-3620-0000-0000-000000FACC8E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[PATCH][v2] perf tools, powerpc: Fix compile warnings in tests/attr.c

We print several '__u64' quantities using '%llu'. On powerpc, we by
default include '<asm-generic/int-l64.h> which results in __u64 being
an unsigned long. This causes compile warnings which are treated as
errors due to '-Werror'.

By defining __SANE_USERSPACE_TYPES__ we include <asm-generic/int-ll64.h>
and define __u64 as unsigned long long.

Changelog[v2]:
	[Michael Ellerman] Use __SANE_USERSPACE_TYPES__ and avoid PRIu64
	format specifier - which as Jiri Olsa pointed out, breaks on x86-64.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 tools/perf/tests/attr.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/tools/perf/tests/attr.c b/tools/perf/tests/attr.c
index f61dd3f..bdcceb8 100644
--- a/tools/perf/tests/attr.c
+++ b/tools/perf/tests/attr.c
@@ -19,6 +19,11 @@
  * permissions. All the event text files are stored there.
  */
 
+/*
+ * Powerpc needs __SANE_USERSPACE_TYPES__ before <linux/types.h> to select
+ * 'int-ll64.h' and avoid compile warnings when printing __u64 with %llu.
+ */
+#define __SANE_USERSPACE_TYPES__
 #include <stdlib.h>
 #include <stdio.h>
 #include <inttypes.h>
-- 
1.7.1

