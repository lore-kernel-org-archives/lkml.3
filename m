Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504AbaAMK2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:28:47 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:54224 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbaAMK2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:28:44 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH v3] perf: add support for the xtensa architecture
Date: Mon, 13 Jan 2014 12:27:35 +0200
Message-Id: <aafcdb22f04e2d3188d2938528939481be56b649.1389608855.git.baruch@tkos.co.il>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested using kernel tracepoints on a QEMU simulated environment. Kernel support
for perf depends on the patch "xtensa: enable HAVE_PERF_EVENTS", which is
scheduled for v3.14. Hardware performance counters are not supported under
xtensa yet.

Acked-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
v2: use the "core ID" field from /proc/cpuinfo (Max Filippov)

v3: add testing and kernel dependency information (Ingo Molnar)
---
 tools/perf/perf.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index b079304bd53d..e441864dbe03 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -132,6 +132,13 @@
 #define CPUINFO_PROC	"CPU"
 #endif
 
+#ifdef __xtensa__
+#define mb()		asm volatile("memw" ::: "memory")
+#define wmb()		asm volatile("memw" ::: "memory")
+#define rmb()		asm volatile("" ::: "memory")
+#define CPUINFO_PROC	"core ID"
+#endif
+
 #define barrier() asm volatile ("" ::: "memory")
 
 #ifndef cpu_relax
-- 
1.8.5.2

