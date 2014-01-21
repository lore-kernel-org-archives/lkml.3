Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbaAUUn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 15:43:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37260 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506AbaAUUnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 15:43:21 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-xtensa@linux-xtensa.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/8] perf tools: Add support for the xtensa architecture
Date: Tue, 21 Jan 2014 17:42:59 -0300
Message-Id: <1390336984-1553-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1390336984-1553-1-git-send-email-acme@infradead.org>
References: <1390336984-1553-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Baruch Siach <baruch@tkos.co.il>

Tested using kernel tracepoints on a QEMU simulated environment.

Kernel support for perf depends on the patch "xtensa: enable
HAVE_PERF_EVENTS", which is scheduled for v3.14.

Hardware performance counters are not supported under xtensa yet.

Acked-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Max Filippov <jcmvbkbc@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-xtensa@linux-xtensa.org
Link: http://lkml.kernel.org/r/aafcdb22f04e2d3188d2938528939481be56b649.1389608855.git.baruch@tkos.co.il
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/perf.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 3c2f213e979d..7daa806d9050 100644
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
1.8.1.4

