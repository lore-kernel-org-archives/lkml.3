Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaCFG3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 01:29:10 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:62946 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaCFG3I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 01:29:08 -0500
From: Tony Lu <zlu@tilera.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Chris Metcalf <cmetcalf@tilera.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Lu <zlu@tilera.com>
Subject: [PATCH 4/4] perf tools: Allow building for tile
Thread-Topic: [PATCH 4/4] perf tools: Allow building for tile
Thread-Index: Ac85BVqbtyiKkQ1fRuKpi1LK3Mep1A==
Date: Thu, 6 Mar 2014 06:28:57 +0000
Message-ID: <BAB94DBB0E89D8409949BC28AC95914C5D67FF50@USMAExch1.tad.internal.tilera.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested by building perf:
- Cross-compiled for tile on x86_64
- Built natively on tile

Signed-off-by: Zhigang Lu <zlu@tilera.com>
Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 tools/perf/config/Makefile.arch | 3 ++-
 tools/perf/perf.h               | 8 ++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/perf/config/Makefile.arch b/tools/perf/config/Makefile.arch
index fef8ae9..4b06719 100644
--- a/tools/perf/config/Makefile.arch
+++ b/tools/perf/config/Makefile.arch
@@ -5,7 +5,8 @@ ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
                                   -e s/arm.*/arm/ -e s/sa110/arm/ \
                                   -e s/s390x/s390/ -e s/parisc64/parisc/ \
                                   -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
-                                  -e s/sh[234].*/sh/ -e s/aarch64.*/arm64/ )
+                                  -e s/sh[234].*/sh/ -e s/aarch64.*/arm64/ \
+                                  -e s/tile.*/tile/ )
 
 # Additional ARCH settings for x86
 ifeq ($(ARCH),i386)
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index e84fa26..75caf68 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -139,6 +139,14 @@
 #define CPUINFO_PROC	"core ID"
 #endif
 
+#ifdef __tile__
+#define mb()		asm volatile ("mf" ::: "memory")
+#define wmb()		asm volatile ("mf" ::: "memory")
+#define rmb()		asm volatile ("mf" ::: "memory")
+#define cpu_relax()	asm volatile ("mfspr zero, PASS" ::: "memory")
+#define CPUINFO_PROC    "model name"
+#endif
+
 #define barrier() asm volatile ("" ::: "memory")
 
 #ifndef cpu_relax
-- 
1.8.3.1

