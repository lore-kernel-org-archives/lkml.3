Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751157AbaABH5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 02:57:31 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:44012 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbaABH5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 02:57:30 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-xtensa@linux-xtensa.org, linux-kernel@vger.kernel.org,
        Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH v2] perf: add support for the xtensa architecture
Date: Thu,  2 Jan 2014 09:57:10 +0200
Message-Id: <2681fd21a9ee014ffe77c0ec7304157be7209b6f.1388649430.git.baruch@tkos.co.il>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
v2: use the "core ID" field from /proc/cpuinfo (Max Filippov)
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

