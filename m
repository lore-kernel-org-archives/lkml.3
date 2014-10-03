Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbaJCFaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 01:30:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60945 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbaJCFaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 01:30:16 -0400
Date: Thu, 2 Oct 2014 22:29:03 -0700
From: tip-bot for Pranith Kumar <tipbot@zytor.com>
Message-ID: <tip-2291059c852706c6f5ffb400366042b7625066cd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jesper.nilsson@axis.com, bobby.prani@gmail.com,
        torvalds@linux-foundation.org, peterz@infradead.org,
        jcmvbkbc@gmail.com, tglx@linutronix.de, egtvedt@samfundet.no
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bobby.prani@gmail.com, jesper.nilsson@axis.com,
        torvalds@linux-foundation.org, peterz@infradead.org,
        jcmvbkbc@gmail.com, tglx@linutronix.de, egtvedt@samfundet.no
In-Reply-To: <1411482607-20948-1-git-send-email-bobby.prani@gmail.com>
References: <1411482607-20948-1-git-send-email-bobby.prani@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/arch] locking,arch: Use ACCESS_ONCE()
  instead of cast to volatile in atomic_read()
Git-Commit-ID: 2291059c852706c6f5ffb400366042b7625066cd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2291059c852706c6f5ffb400366042b7625066cd
Gitweb:     http://git.kernel.org/tip/2291059c852706c6f5ffb400366042b7625066cd
Author:     Pranith Kumar <bobby.prani@gmail.com>
AuthorDate: Tue, 23 Sep 2014 10:29:50 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 3 Oct 2014 06:06:23 +0200

locking,arch: Use ACCESS_ONCE() instead of cast to volatile in atomic_read()

Use the much more reader friendly ACCESS_ONCE() instead of the cast to volatile.
This is purely a stylistic change.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Acked-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arch@vger.kernel.org
Link: http://lkml.kernel.org/r/1411482607-20948-1-git-send-email-bobby.prani@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/alpha/include/asm/atomic.h    | 4 ++--
 arch/arm/include/asm/atomic.h      | 2 +-
 arch/arm64/include/asm/atomic.h    | 4 ++--
 arch/avr32/include/asm/atomic.h    | 2 +-
 arch/cris/include/asm/atomic.h     | 2 +-
 arch/frv/include/asm/atomic.h      | 2 +-
 arch/ia64/include/asm/atomic.h     | 4 ++--
 arch/m32r/include/asm/atomic.h     | 2 +-
 arch/m68k/include/asm/atomic.h     | 2 +-
 arch/mips/include/asm/atomic.h     | 4 ++--
 arch/parisc/include/asm/atomic.h   | 4 ++--
 arch/sh/include/asm/atomic.h       | 2 +-
 arch/sparc/include/asm/atomic_32.h | 2 +-
 arch/sparc/include/asm/atomic_64.h | 4 ++--
 arch/x86/include/asm/atomic.h      | 2 +-
 arch/x86/include/asm/atomic64_64.h | 2 +-
 arch/xtensa/include/asm/atomic.h   | 2 +-
 include/asm-generic/atomic.h       | 2 +-
 18 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/arch/alpha/include/asm/atomic.h b/arch/alpha/include/asm/atomic.h
index 6fbb53a..8f8eafb 100644
--- a/arch/alpha/include/asm/atomic.h
+++ b/arch/alpha/include/asm/atomic.h
@@ -17,8 +17,8 @@
 #define ATOMIC_INIT(i)		{ (i) }
 #define ATOMIC64_INIT(i)	{ (i) }
 
-#define atomic_read(v)		(*(volatile int *)&(v)->counter)
-#define atomic64_read(v)	(*(volatile long *)&(v)->counter)
+#define atomic_read(v)		ACCESS_ONCE((v)->counter)
+#define atomic64_read(v)	ACCESS_ONCE((v)->counter)
 
 #define atomic_set(v,i)		((v)->counter = (i))
 #define atomic64_set(v,i)	((v)->counter = (i))
diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
index 832f1cd..e22c119 100644
--- a/arch/arm/include/asm/atomic.h
+++ b/arch/arm/include/asm/atomic.h
@@ -27,7 +27,7 @@
  * strex/ldrex monitor on some implementations. The reason we can use it for
  * atomic_set() is the clrex or dummy strex done on every exception return.
  */
-#define atomic_read(v)	(*(volatile int *)&(v)->counter)
+#define atomic_read(v)	ACCESS_ONCE((v)->counter)
 #define atomic_set(v,i)	(((v)->counter) = (i))
 
 #if __LINUX_ARM_ARCH__ >= 6
diff --git a/arch/arm64/include/asm/atomic.h b/arch/arm64/include/asm/atomic.h
index b83c325..7047051 100644
--- a/arch/arm64/include/asm/atomic.h
+++ b/arch/arm64/include/asm/atomic.h
@@ -35,7 +35,7 @@
  * strex/ldrex monitor on some implementations. The reason we can use it for
  * atomic_set() is the clrex or dummy strex done on every exception return.
  */
-#define atomic_read(v)	(*(volatile int *)&(v)->counter)
+#define atomic_read(v)	ACCESS_ONCE((v)->counter)
 #define atomic_set(v,i)	(((v)->counter) = (i))
 
 /*
@@ -139,7 +139,7 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
  */
 #define ATOMIC64_INIT(i) { (i) }
 
-#define atomic64_read(v)	(*(volatile long *)&(v)->counter)
+#define atomic64_read(v)	ACCESS_ONCE((v)->counter)
 #define atomic64_set(v,i)	(((v)->counter) = (i))
 
 #define ATOMIC64_OP(op, asm_op)						\
diff --git a/arch/avr32/include/asm/atomic.h b/arch/avr32/include/asm/atomic.h
index 83e980a..2d07ce1 100644
--- a/arch/avr32/include/asm/atomic.h
+++ b/arch/avr32/include/asm/atomic.h
@@ -19,7 +19,7 @@
 
 #define ATOMIC_INIT(i)  { (i) }
 
-#define atomic_read(v)		(*(volatile int *)&(v)->counter)
+#define atomic_read(v)		ACCESS_ONCE((v)->counter)
 #define atomic_set(v, i)	(((v)->counter) = i)
 
 #define ATOMIC_OP_RETURN(op, asm_op, asm_con)				\
diff --git a/arch/cris/include/asm/atomic.h b/arch/cris/include/asm/atomic.h
index 0033f9d..279766a 100644
--- a/arch/cris/include/asm/atomic.h
+++ b/arch/cris/include/asm/atomic.h
@@ -17,7 +17,7 @@
 
 #define ATOMIC_INIT(i)  { (i) }
 
-#define atomic_read(v) (*(volatile int *)&(v)->counter)
+#define atomic_read(v) ACCESS_ONCE((v)->counter)
 #define atomic_set(v,i) (((v)->counter) = (i))
 
 /* These should be written in asm but we do it in C for now. */
diff --git a/arch/frv/include/asm/atomic.h b/arch/frv/include/asm/atomic.h
index f6c3a16..102190a 100644
--- a/arch/frv/include/asm/atomic.h
+++ b/arch/frv/include/asm/atomic.h
@@ -31,7 +31,7 @@
  */
 
 #define ATOMIC_INIT(i)		{ (i) }
-#define atomic_read(v)		(*(volatile int *)&(v)->counter)
+#define atomic_read(v)		ACCESS_ONCE((v)->counter)
 #define atomic_set(v, i)	(((v)->counter) = (i))
 
 #ifndef CONFIG_FRV_OUTOFLINE_ATOMIC_OPS
diff --git a/arch/ia64/include/asm/atomic.h b/arch/ia64/include/asm/atomic.h
index 42919a8..0bf0350 100644
--- a/arch/ia64/include/asm/atomic.h
+++ b/arch/ia64/include/asm/atomic.h
@@ -21,8 +21,8 @@
 #define ATOMIC_INIT(i)		{ (i) }
 #define ATOMIC64_INIT(i)	{ (i) }
 
-#define atomic_read(v)		(*(volatile int *)&(v)->counter)
-#define atomic64_read(v)	(*(volatile long *)&(v)->counter)
+#define atomic_read(v)		ACCESS_ONCE((v)->counter)
+#define atomic64_read(v)	ACCESS_ONCE((v)->counter)
 
 #define atomic_set(v,i)		(((v)->counter) = (i))
 #define atomic64_set(v,i)	(((v)->counter) = (i))
diff --git a/arch/m32r/include/asm/atomic.h b/arch/m32r/include/asm/atomic.h
index 3946b2c..31bb74a 100644
--- a/arch/m32r/include/asm/atomic.h
+++ b/arch/m32r/include/asm/atomic.h
@@ -28,7 +28,7 @@
  *
  * Atomically reads the value of @v.
  */
-#define atomic_read(v)	(*(volatile int *)&(v)->counter)
+#define atomic_read(v)	ACCESS_ONCE((v)->counter)
 
 /**
  * atomic_set - set atomic variable
diff --git a/arch/m68k/include/asm/atomic.h b/arch/m68k/include/asm/atomic.h
index 663d4ba..e85f047 100644
--- a/arch/m68k/include/asm/atomic.h
+++ b/arch/m68k/include/asm/atomic.h
@@ -17,7 +17,7 @@
 
 #define ATOMIC_INIT(i)	{ (i) }
 
-#define atomic_read(v)		(*(volatile int *)&(v)->counter)
+#define atomic_read(v)		ACCESS_ONCE((v)->counter)
 #define atomic_set(v, i)	(((v)->counter) = i)
 
 /*
diff --git a/arch/mips/include/asm/atomic.h b/arch/mips/include/asm/atomic.h
index f3ee721..6dd6bfc 100644
--- a/arch/mips/include/asm/atomic.h
+++ b/arch/mips/include/asm/atomic.h
@@ -29,7 +29,7 @@
  *
  * Atomically reads the value of @v.
  */
-#define atomic_read(v)		(*(volatile int *)&(v)->counter)
+#define atomic_read(v)		ACCESS_ONCE((v)->counter)
 
 /*
  * atomic_set - set atomic variable
@@ -306,7 +306,7 @@ static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
  * @v: pointer of type atomic64_t
  *
  */
-#define atomic64_read(v)	(*(volatile long *)&(v)->counter)
+#define atomic64_read(v)	ACCESS_ONCE((v)->counter)
 
 /*
  * atomic64_set - set atomic variable
diff --git a/arch/parisc/include/asm/atomic.h b/arch/parisc/include/asm/atomic.h
index 219750b..226f8ca 100644
--- a/arch/parisc/include/asm/atomic.h
+++ b/arch/parisc/include/asm/atomic.h
@@ -67,7 +67,7 @@ static __inline__ void atomic_set(atomic_t *v, int i)
 
 static __inline__ int atomic_read(const atomic_t *v)
 {
-	return (*(volatile int *)&(v)->counter);
+	return ACCESS_ONCE((v)->counter);
 }
 
 /* exported interface */
@@ -204,7 +204,7 @@ atomic64_set(atomic64_t *v, s64 i)
 static __inline__ s64
 atomic64_read(const atomic64_t *v)
 {
-	return (*(volatile long *)&(v)->counter);
+	return ACCESS_ONCE((v)->counter);
 }
 
 #define atomic64_inc(v)		(atomic64_add(   1,(v)))
diff --git a/arch/sh/include/asm/atomic.h b/arch/sh/include/asm/atomic.h
index f57b8a6..05b9f74 100644
--- a/arch/sh/include/asm/atomic.h
+++ b/arch/sh/include/asm/atomic.h
@@ -14,7 +14,7 @@
 
 #define ATOMIC_INIT(i)	{ (i) }
 
-#define atomic_read(v)		(*(volatile int *)&(v)->counter)
+#define atomic_read(v)		ACCESS_ONCE((v)->counter)
 #define atomic_set(v,i)		((v)->counter = (i))
 
 #if defined(CONFIG_GUSA_RB)
diff --git a/arch/sparc/include/asm/atomic_32.h b/arch/sparc/include/asm/atomic_32.h
index 7b024f0..765c177 100644
--- a/arch/sparc/include/asm/atomic_32.h
+++ b/arch/sparc/include/asm/atomic_32.h
@@ -26,7 +26,7 @@ int atomic_cmpxchg(atomic_t *, int, int);
 int __atomic_add_unless(atomic_t *, int, int);
 void atomic_set(atomic_t *, int);
 
-#define atomic_read(v)          (*(volatile int *)&(v)->counter)
+#define atomic_read(v)          ACCESS_ONCE((v)->counter)
 
 #define atomic_add(i, v)	((void)atomic_add_return( (int)(i), (v)))
 #define atomic_sub(i, v)	((void)atomic_add_return(-(int)(i), (v)))
diff --git a/arch/sparc/include/asm/atomic_64.h b/arch/sparc/include/asm/atomic_64.h
index 7e4ca1e..4082749 100644
--- a/arch/sparc/include/asm/atomic_64.h
+++ b/arch/sparc/include/asm/atomic_64.h
@@ -14,8 +14,8 @@
 #define ATOMIC_INIT(i)		{ (i) }
 #define ATOMIC64_INIT(i)	{ (i) }
 
-#define atomic_read(v)		(*(volatile int *)&(v)->counter)
-#define atomic64_read(v)	(*(volatile long *)&(v)->counter)
+#define atomic_read(v)		ACCESS_ONCE((v)->counter)
+#define atomic64_read(v)	ACCESS_ONCE((v)->counter)
 
 #define atomic_set(v, i)	(((v)->counter) = i)
 #define atomic64_set(v, i)	(((v)->counter) = i)
diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index bf20c81..5e5cd12 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -24,7 +24,7 @@
  */
 static inline int atomic_read(const atomic_t *v)
 {
-	return (*(volatile int *)&(v)->counter);
+	return ACCESS_ONCE((v)->counter);
 }
 
 /**
diff --git a/arch/x86/include/asm/atomic64_64.h b/arch/x86/include/asm/atomic64_64.h
index 46e9052..f8d273e 100644
--- a/arch/x86/include/asm/atomic64_64.h
+++ b/arch/x86/include/asm/atomic64_64.h
@@ -18,7 +18,7 @@
  */
 static inline long atomic64_read(const atomic64_t *v)
 {
-	return (*(volatile long *)&(v)->counter);
+	return ACCESS_ONCE((v)->counter);
 }
 
 /**
diff --git a/arch/xtensa/include/asm/atomic.h b/arch/xtensa/include/asm/atomic.h
index 6266766..00b7d46 100644
--- a/arch/xtensa/include/asm/atomic.h
+++ b/arch/xtensa/include/asm/atomic.h
@@ -47,7 +47,7 @@
  *
  * Atomically reads the value of @v.
  */
-#define atomic_read(v)		(*(volatile int *)&(v)->counter)
+#define atomic_read(v)		ACCESS_ONCE((v)->counter)
 
 /**
  * atomic_set - set atomic variable
diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
index 56d4d36..1973ad2 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -126,7 +126,7 @@ ATOMIC_OP(or, |)
  * Atomically reads the value of @v.
  */
 #ifndef atomic_read
-#define atomic_read(v)	(*(volatile int *)&(v)->counter)
+#define atomic_read(v)	ACCESS_ONCE((v)->counter)
 #endif
 
 /**
