Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289Ab3JOL0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 07:26:10 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:59772 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab3JOL0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 07:26:08 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH v2] perf tools: use ansi versions of asm and volatile
Date: Tue, 15 Oct 2013 16:49:20 +0530
Message-Id: <1381835960-22900-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.4.477.g5d89aa9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asm and volatile are provided for backward compatibility; use the ansi
versions __asm__ and __volatile__.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 Thanks to Peter for pointing out the instances I missed.

 tools/perf/arch/powerpc/util/header.c |  2 +-
 tools/perf/perf.h                     | 54 +++++++++++++++++------------------
 tools/perf/tests/perf-time-to-tsc.c   |  2 +-
 tools/perf/tests/rdpmc.c              |  6 ++--
 4 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/tools/perf/arch/powerpc/util/header.c b/tools/perf/arch/powerpc/util/header.c
index 2f7073d..4b0a302 100644
--- a/tools/perf/arch/powerpc/util/header.c
+++ b/tools/perf/arch/powerpc/util/header.c
@@ -10,7 +10,7 @@
 #define __stringify(x)          __stringify_1(x)
 
 #define mfspr(rn)       ({unsigned long rval; \
-			 asm volatile("mfspr %0," __stringify(rn) \
+			 __asm__ __volatile__("mfspr %0," __stringify(rn) \
 				      : "=r" (rval)); rval; })
 
 #define SPRN_PVR        0x11F	/* Processor Version Register */
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index cf20187..6c447db 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -4,8 +4,8 @@
 #include <asm/unistd.h>
 
 #if defined(__i386__)
-#define rmb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
-#define cpu_relax()	asm volatile("rep; nop" ::: "memory");
+#define rmb()		__asm__ __volatile__("lock; addl $0,0(%%esp)" ::: "memory")
+#define cpu_relax()	__asm__ __volatile__("rep; nop" ::: "memory");
 #define CPUINFO_PROC	"model name"
 #ifndef __NR_perf_event_open
 # define __NR_perf_event_open 336
@@ -13,8 +13,8 @@
 #endif
 
 #if defined(__x86_64__)
-#define rmb()		asm volatile("lfence" ::: "memory")
-#define cpu_relax()	asm volatile("rep; nop" ::: "memory");
+#define rmb()		__asm__ __volatile__("lfence" ::: "memory")
+#define cpu_relax()	__asm__ __volatile__("rep; nop" ::: "memory");
 #define CPUINFO_PROC	"model name"
 #ifndef __NR_perf_event_open
 # define __NR_perf_event_open 298
@@ -23,47 +23,47 @@
 
 #ifdef __powerpc__
 #include "../../arch/powerpc/include/uapi/asm/unistd.h"
-#define rmb()		asm volatile ("sync" ::: "memory")
-#define cpu_relax()	asm volatile ("" ::: "memory");
+#define rmb()		__asm__ __volatile__ ("sync" ::: "memory")
+#define cpu_relax()	__asm__ __volatile__ ("" ::: "memory");
 #define CPUINFO_PROC	"cpu"
 #endif
 
 #ifdef __s390__
-#define rmb()		asm volatile("bcr 15,0" ::: "memory")
-#define cpu_relax()	asm volatile("" ::: "memory");
+#define rmb()		__asm__ __volatile__("bcr 15,0" ::: "memory")
+#define cpu_relax()	__asm__ __volatile__("" ::: "memory");
 #endif
 
 #ifdef __sh__
 #if defined(__SH4A__) || defined(__SH5__)
-# define rmb()		asm volatile("synco" ::: "memory")
+# define rmb()		__asm__ __volatile__("synco" ::: "memory")
 #else
-# define rmb()		asm volatile("" ::: "memory")
+# define rmb()		__asm__ __volatile__("" ::: "memory")
 #endif
-#define cpu_relax()	asm volatile("" ::: "memory")
+#define cpu_relax()	__asm__ __volatile__("" ::: "memory")
 #define CPUINFO_PROC	"cpu type"
 #endif
 
 #ifdef __hppa__
-#define rmb()		asm volatile("" ::: "memory")
-#define cpu_relax()	asm volatile("" ::: "memory");
+#define rmb()		__asm__ __volatile__("" ::: "memory")
+#define cpu_relax()	__asm__ __volatile__("" ::: "memory");
 #define CPUINFO_PROC	"cpu"
 #endif
 
 #ifdef __sparc__
-#define rmb()		asm volatile("":::"memory")
-#define cpu_relax()	asm volatile("":::"memory")
+#define rmb()		__asm__ __volatile__("":::"memory")
+#define cpu_relax()	__asm__ __volatile__("":::"memory")
 #define CPUINFO_PROC	"cpu"
 #endif
 
 #ifdef __alpha__
-#define rmb()		asm volatile("mb" ::: "memory")
-#define cpu_relax()	asm volatile("" ::: "memory")
+#define rmb()		__asm__ __volatile__("mb" ::: "memory")
+#define cpu_relax()	__asm__ __volatile__("" ::: "memory")
 #define CPUINFO_PROC	"cpu model"
 #endif
 
 #ifdef __ia64__
-#define rmb()		asm volatile ("mf" ::: "memory")
-#define cpu_relax()	asm volatile ("hint @pause" ::: "memory")
+#define rmb()		__asm__ __volatile__ ("mf" ::: "memory")
+#define cpu_relax()	__asm__ __volatile__ ("hint @pause" ::: "memory")
 #define CPUINFO_PROC	"model name"
 #endif
 
@@ -73,36 +73,36 @@
  * arch/arm/kernel/entry-armv.S in the kernel source for details.
  */
 #define rmb()		((void(*)(void))0xffff0fa0)()
-#define cpu_relax()	asm volatile("":::"memory")
+#define cpu_relax()	__asm__ __volatile__("":::"memory")
 #define CPUINFO_PROC	"Processor"
 #endif
 
 #ifdef __aarch64__
-#define rmb()		asm volatile("dmb ld" ::: "memory")
-#define cpu_relax()	asm volatile("yield" ::: "memory")
+#define rmb()		__asm__ __volatile__("dmb ld" ::: "memory")
+#define cpu_relax()	__asm__ __volatile__("yield" ::: "memory")
 #endif
 
 #ifdef __mips__
-#define rmb()		asm volatile(					\
+#define rmb()		__asm__ __volatile__(					\
 				".set	mips2\n\t"			\
 				"sync\n\t"				\
 				".set	mips0"				\
 				: /* no output */			\
 				: /* no input */			\
 				: "memory")
-#define cpu_relax()	asm volatile("" ::: "memory")
+#define cpu_relax()	__asm__ __volatile__("" ::: "memory")
 #define CPUINFO_PROC	"cpu model"
 #endif
 
 #ifdef __arc__
-#define rmb()		asm volatile("" ::: "memory")
+#define rmb()		__asm__ __volatile__("" ::: "memory")
 #define cpu_relax()	rmb()
 #define CPUINFO_PROC	"Processor"
 #endif
 
 #ifdef __metag__
-#define rmb()		asm volatile("" ::: "memory")
-#define cpu_relax()	asm volatile("" ::: "memory")
+#define rmb()		__asm__ __volatile__("" ::: "memory")
+#define cpu_relax()	__asm__ __volatile__("" ::: "memory")
 #define CPUINFO_PROC	"CPU"
 #endif
 
diff --git a/tools/perf/tests/perf-time-to-tsc.c b/tools/perf/tests/perf-time-to-tsc.c
index 0ab61b1..3fc1bc3 100644
--- a/tools/perf/tests/perf-time-to-tsc.c
+++ b/tools/perf/tests/perf-time-to-tsc.c
@@ -31,7 +31,7 @@ static u64 rdtsc(void)
 {
 	unsigned int low, high;
 
-	asm volatile("rdtsc" : "=a" (low), "=d" (high));
+	__asm__ __volatile__("rdtsc" : "=a" (low), "=d" (high));
 
 	return low | ((u64)high) << 32;
 }
diff --git a/tools/perf/tests/rdpmc.c b/tools/perf/tests/rdpmc.c
index ff94886..3e906e1 100644
--- a/tools/perf/tests/rdpmc.c
+++ b/tools/perf/tests/rdpmc.c
@@ -9,13 +9,13 @@
 
 #if defined(__x86_64__) || defined(__i386__)
 
-#define barrier() asm volatile("" ::: "memory")
+#define barrier() __asm__ __volatile__("" ::: "memory")
 
 static u64 rdpmc(unsigned int counter)
 {
 	unsigned int low, high;
 
-	asm volatile("rdpmc" : "=a" (low), "=d" (high) : "c" (counter));
+	__asm__ __volatile__("rdpmc" : "=a" (low), "=d" (high) : "c" (counter));
 
 	return low | ((u64)high) << 32;
 }
@@ -24,7 +24,7 @@ static u64 rdtsc(void)
 {
 	unsigned int low, high;
 
-	asm volatile("rdtsc" : "=a" (low), "=d" (high));
+	__asm__ __volatile__("rdtsc" : "=a" (low), "=d" (high));
 
 	return low | ((u64)high) << 32;
 }
-- 
1.8.4.477.g5d89aa9

