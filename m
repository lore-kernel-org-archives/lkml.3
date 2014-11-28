Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaK1SYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:24:22 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:47607 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbaK1SYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:24:17 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC PATCH 05/30] s390: Translate cputime magic constants to macros
Date: Fri, 28 Nov 2014 19:23:35 +0100
Message-Id: <1417199040-21044-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the code more self-explanatory by naming magic constants.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/s390/include/asm/cputime.h | 47 +++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/arch/s390/include/asm/cputime.h b/arch/s390/include/asm/cputime.h
index f8c1969..820b38a 100644
--- a/arch/s390/include/asm/cputime.h
+++ b/arch/s390/include/asm/cputime.h
@@ -10,7 +10,8 @@
 #include <linux/types.h>
 #include <asm/div64.h>
 
-
+#define CPUTIME_PER_USEC 4096ULL
+#define CPUTIME_PER_SEC (CPUTIME_PER_USEC * USEC_PER_SEC)
 /* We want to use full resolution of the CPU timer: 2**-12 micro-seconds. */
 
 typedef unsigned long long __nocast cputime_t;
@@ -38,24 +39,24 @@ static inline unsigned long __div(unsigned long long n, unsigned long base)
  */
 static inline unsigned long cputime_to_jiffies(const cputime_t cputime)
 {
-	return __div((__force unsigned long long) cputime, 4096000000ULL / HZ);
+	return __div((__force unsigned long long) cputime, CPUTIME_PER_SEC / HZ);
 }
 
 static inline cputime_t jiffies_to_cputime(const unsigned int jif)
 {
-	return (__force cputime_t)(jif * (4096000000ULL / HZ));
+	return (__force cputime_t)(jif * (CPUTIME_PER_SEC / HZ));
 }
 
 static inline u64 cputime64_to_jiffies64(cputime64_t cputime)
 {
 	unsigned long long jif = (__force unsigned long long) cputime;
-	do_div(jif, 4096000000ULL / HZ);
+	do_div(jif, CPUTIME_PER_SEC / HZ);
 	return jif;
 }
 
 static inline cputime64_t jiffies64_to_cputime64(const u64 jif)
 {
-	return (__force cputime64_t)(jif * (4096000000ULL / HZ));
+	return (__force cputime64_t)(jif * (CPUTIME_PER_SEC / HZ));
 }
 
 /*
@@ -68,7 +69,7 @@ static inline unsigned int cputime_to_usecs(const cputime_t cputime)
 
 static inline cputime_t usecs_to_cputime(const unsigned int m)
 {
-	return (__force cputime_t)(m * 4096ULL);
+	return (__force cputime_t)(m * CPUTIME_PER_USEC);
 }
 
 #define usecs_to_cputime64(m)		usecs_to_cputime(m)
@@ -78,12 +79,12 @@ static inline cputime_t usecs_to_cputime(const unsigned int m)
  */
 static inline unsigned int cputime_to_secs(const cputime_t cputime)
 {
-	return __div((__force unsigned long long) cputime, 2048000000) >> 1;
+	return __div((__force unsigned long long) cputime, CPUTIME_PER_SEC / 2) >> 1;
 }
 
 static inline cputime_t secs_to_cputime(const unsigned int s)
 {
-	return (__force cputime_t)(s * 4096000000ULL);
+	return (__force cputime_t)(s * CPUTIME_PER_SEC);
 }
 
 /*
@@ -91,8 +92,8 @@ static inline cputime_t secs_to_cputime(const unsigned int s)
  */
 static inline cputime_t timespec_to_cputime(const struct timespec *value)
 {
-	unsigned long long ret = value->tv_sec * 4096000000ULL;
-	return (__force cputime_t)(ret + value->tv_nsec * 4096 / 1000);
+	unsigned long long ret = value->tv_sec * CPUTIME_PER_SEC;
+	return (__force cputime_t)(ret + (value->tv_nsec * CPUTIME_PER_USEC) / NSEC_PER_USEC);
 }
 
 static inline void cputime_to_timespec(const cputime_t cputime,
@@ -103,12 +104,12 @@ static inline void cputime_to_timespec(const cputime_t cputime,
 	register_pair rp;
 
 	rp.pair = __cputime >> 1;
-	asm ("dr %0,%1" : "+d" (rp) : "d" (2048000000UL));
-	value->tv_nsec = rp.subreg.even * 1000 / 4096;
+	asm ("dr %0,%1" : "+d" (rp) : "d" (CPUTIME_PER_SEC / 2));
+	value->tv_nsec = rp.subreg.even * NSEC_PER_USEC / CPUTIME_PER_USEC;
 	value->tv_sec = rp.subreg.odd;
 #else
-	value->tv_nsec = (__cputime % 4096000000ULL) * 1000 / 4096;
-	value->tv_sec = __cputime / 4096000000ULL;
+	value->tv_nsec = (__cputime % CPUTIME_PER_SEC) * NSEC_PER_USEC / CPUTIME_PER_USEC;
+	value->tv_sec = __cputime / CPUTIME_PER_SEC;
 #endif
 }
 
@@ -119,8 +120,8 @@ static inline void cputime_to_timespec(const cputime_t cputime,
  */
 static inline cputime_t timeval_to_cputime(const struct timeval *value)
 {
-	unsigned long long ret = value->tv_sec * 4096000000ULL;
-	return (__force cputime_t)(ret + value->tv_usec * 4096ULL);
+	unsigned long long ret = value->tv_sec * CPUTIME_PER_SEC;
+	return (__force cputime_t)(ret + value->tv_usec * CPUTIME_PER_USEC);
 }
 
 static inline void cputime_to_timeval(const cputime_t cputime,
@@ -131,12 +132,12 @@ static inline void cputime_to_timeval(const cputime_t cputime,
 	register_pair rp;
 
 	rp.pair = __cputime >> 1;
-	asm ("dr %0,%1" : "+d" (rp) : "d" (2048000000UL));
-	value->tv_usec = rp.subreg.even / 4096;
+	asm ("dr %0,%1" : "+d" (rp) : "d" (CPUTIME_PER_USEC / 2));
+	value->tv_usec = rp.subreg.even / CPUTIME_PER_USEC;
 	value->tv_sec = rp.subreg.odd;
 #else
-	value->tv_usec = (__cputime % 4096000000ULL) / 4096;
-	value->tv_sec = __cputime / 4096000000ULL;
+	value->tv_usec = (__cputime % CPUTIME_PER_SEC) / CPUTIME_PER_USEC;
+	value->tv_sec = __cputime / CPUTIME_PER_SEC;
 #endif
 }
 
@@ -146,13 +147,13 @@ static inline void cputime_to_timeval(const cputime_t cputime,
 static inline clock_t cputime_to_clock_t(cputime_t cputime)
 {
 	unsigned long long clock = (__force unsigned long long) cputime;
-	do_div(clock, 4096000000ULL / USER_HZ);
+	do_div(clock, CPUTIME_PER_SEC / USER_HZ);
 	return clock;
 }
 
 static inline cputime_t clock_t_to_cputime(unsigned long x)
 {
-	return (__force cputime_t)(x * (4096000000ULL / USER_HZ));
+	return (__force cputime_t)(x * (CPUTIME_PER_SEC / USER_HZ));
 }
 
 /*
@@ -161,7 +162,7 @@ static inline cputime_t clock_t_to_cputime(unsigned long x)
 static inline clock_t cputime64_to_clock_t(cputime64_t cputime)
 {
 	unsigned long long clock = (__force unsigned long long) cputime;
-	do_div(clock, 4096000000ULL / USER_HZ);
+	do_div(clock, CPUTIME_PER_SEC / USER_HZ);
 	return clock;
 }
 
-- 
2.1.3

