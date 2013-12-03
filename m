Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab3LCXiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:38:08 -0500
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:42375 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753015Ab3LCXiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:38:04 -0500
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Dec 2013 18:38:04 EST
Message-Id: <20131203233252.318527534@linux.com>
User-Agent: quilt/0.60-1
Date: Tue, 03 Dec 2013 17:32:46 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 14/41] x86: Rename __this_cpu_xxx_# operations to raw_cpu_xxx_#
References: <20131203233232.928771708@linux.com>
Content-Disposition: inline; filename=x86_rename
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required now since the core portion expects a different naming.

Change the names from __this_cpu_xxxx_# to raw_cpu_xxxx_#.

Also changes the uses of the x86 percpu primitives in preempt.h.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/x86/include/asm/percpu.h
===================================================================
--- linux.orig/arch/x86/include/asm/percpu.h	2013-12-02 16:07:50.984600478 -0600
+++ linux/arch/x86/include/asm/percpu.h	2013-12-02 16:07:50.984600478 -0600
@@ -362,25 +362,25 @@ do {									\
  */
 #define this_cpu_read_stable(var)	percpu_from_op("mov", var, "p" (&(var)))
 
-#define __this_cpu_read_1(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
-#define __this_cpu_read_2(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
-#define __this_cpu_read_4(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
-
-#define __this_cpu_write_1(pcp, val)	percpu_to_op("mov", (pcp), val)
-#define __this_cpu_write_2(pcp, val)	percpu_to_op("mov", (pcp), val)
-#define __this_cpu_write_4(pcp, val)	percpu_to_op("mov", (pcp), val)
-#define __this_cpu_add_1(pcp, val)	percpu_add_op((pcp), val)
-#define __this_cpu_add_2(pcp, val)	percpu_add_op((pcp), val)
-#define __this_cpu_add_4(pcp, val)	percpu_add_op((pcp), val)
-#define __this_cpu_and_1(pcp, val)	percpu_to_op("and", (pcp), val)
-#define __this_cpu_and_2(pcp, val)	percpu_to_op("and", (pcp), val)
-#define __this_cpu_and_4(pcp, val)	percpu_to_op("and", (pcp), val)
-#define __this_cpu_or_1(pcp, val)	percpu_to_op("or", (pcp), val)
-#define __this_cpu_or_2(pcp, val)	percpu_to_op("or", (pcp), val)
-#define __this_cpu_or_4(pcp, val)	percpu_to_op("or", (pcp), val)
-#define __this_cpu_xchg_1(pcp, val)	percpu_xchg_op(pcp, val)
-#define __this_cpu_xchg_2(pcp, val)	percpu_xchg_op(pcp, val)
-#define __this_cpu_xchg_4(pcp, val)	percpu_xchg_op(pcp, val)
+#define raw_cpu_read_1(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
+#define raw_cpu_read_2(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
+#define raw_cpu_read_4(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
+
+#define raw_cpu_write_1(pcp, val)	percpu_to_op("mov", (pcp), val)
+#define raw_cpu_write_2(pcp, val)	percpu_to_op("mov", (pcp), val)
+#define raw_cpu_write_4(pcp, val)	percpu_to_op("mov", (pcp), val)
+#define raw_cpu_add_1(pcp, val)		percpu_add_op((pcp), val)
+#define raw_cpu_add_2(pcp, val)		percpu_add_op((pcp), val)
+#define raw_cpu_add_4(pcp, val)		percpu_add_op((pcp), val)
+#define raw_cpu_and_1(pcp, val)		percpu_to_op("and", (pcp), val)
+#define raw_cpu_and_2(pcp, val)		percpu_to_op("and", (pcp), val)
+#define raw_cpu_and_4(pcp, val)		percpu_to_op("and", (pcp), val)
+#define raw_cpu_or_1(pcp, val)		percpu_to_op("or", (pcp), val)
+#define raw_cpu_or_2(pcp, val)		percpu_to_op("or", (pcp), val)
+#define raw_cpu_or_4(pcp, val)		percpu_to_op("or", (pcp), val)
+#define raw_cpu_xchg_1(pcp, val)	percpu_xchg_op(pcp, val)
+#define raw_cpu_xchg_2(pcp, val)	percpu_xchg_op(pcp, val)
+#define raw_cpu_xchg_4(pcp, val)	percpu_xchg_op(pcp, val)
 
 #define this_cpu_read_1(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
 #define this_cpu_read_2(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
@@ -401,16 +401,16 @@ do {									\
 #define this_cpu_xchg_2(pcp, nval)	percpu_xchg_op(pcp, nval)
 #define this_cpu_xchg_4(pcp, nval)	percpu_xchg_op(pcp, nval)
 
-#define __this_cpu_add_return_1(pcp, val) percpu_add_return_op(pcp, val)
-#define __this_cpu_add_return_2(pcp, val) percpu_add_return_op(pcp, val)
-#define __this_cpu_add_return_4(pcp, val) percpu_add_return_op(pcp, val)
-#define __this_cpu_cmpxchg_1(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
-#define __this_cpu_cmpxchg_2(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
-#define __this_cpu_cmpxchg_4(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
-
-#define this_cpu_add_return_1(pcp, val)	percpu_add_return_op(pcp, val)
-#define this_cpu_add_return_2(pcp, val)	percpu_add_return_op(pcp, val)
-#define this_cpu_add_return_4(pcp, val)	percpu_add_return_op(pcp, val)
+#define raw_cpu_add_return_1(pcp, val)		percpu_add_return_op(pcp, val)
+#define raw_cpu_add_return_2(pcp, val)		percpu_add_return_op(pcp, val)
+#define raw_cpu_add_return_4(pcp, val)		percpu_add_return_op(pcp, val)
+#define raw_cpu_cmpxchg_1(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+#define raw_cpu_cmpxchg_2(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+#define raw_cpu_cmpxchg_4(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+
+#define this_cpu_add_return_1(pcp, val)		percpu_add_return_op(pcp, val)
+#define this_cpu_add_return_2(pcp, val)		percpu_add_return_op(pcp, val)
+#define this_cpu_add_return_4(pcp, val)		percpu_add_return_op(pcp, val)
 #define this_cpu_cmpxchg_1(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
 #define this_cpu_cmpxchg_2(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
 #define this_cpu_cmpxchg_4(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
@@ -427,7 +427,7 @@ do {									\
 	__ret;								\
 })
 
-#define __this_cpu_cmpxchg_double_4	percpu_cmpxchg8b_double
+#define raw_cpu_cmpxchg_double_4	percpu_cmpxchg8b_double
 #define this_cpu_cmpxchg_double_4	percpu_cmpxchg8b_double
 #endif /* CONFIG_X86_CMPXCHG64 */
 
@@ -436,22 +436,22 @@ do {									\
  * 32 bit must fall back to generic operations.
  */
 #ifdef CONFIG_X86_64
-#define __this_cpu_read_8(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
-#define __this_cpu_write_8(pcp, val)	percpu_to_op("mov", (pcp), val)
-#define __this_cpu_add_8(pcp, val)	percpu_add_op((pcp), val)
-#define __this_cpu_and_8(pcp, val)	percpu_to_op("and", (pcp), val)
-#define __this_cpu_or_8(pcp, val)	percpu_to_op("or", (pcp), val)
-#define __this_cpu_add_return_8(pcp, val) percpu_add_return_op(pcp, val)
-#define __this_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
-#define __this_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
-
-#define this_cpu_read_8(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
-#define this_cpu_write_8(pcp, val)	percpu_to_op("mov", (pcp), val)
-#define this_cpu_add_8(pcp, val)	percpu_add_op((pcp), val)
-#define this_cpu_and_8(pcp, val)	percpu_to_op("and", (pcp), val)
-#define this_cpu_or_8(pcp, val)		percpu_to_op("or", (pcp), val)
-#define this_cpu_add_return_8(pcp, val)	percpu_add_return_op(pcp, val)
-#define this_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
+#define raw_cpu_read_8(pcp)			percpu_from_op("mov", (pcp), "m"(pcp))
+#define raw_cpu_write_8(pcp, val)		percpu_to_op("mov", (pcp), val)
+#define raw_cpu_add_8(pcp, val)			percpu_add_op((pcp), val)
+#define raw_cpu_and_8(pcp, val)			percpu_to_op("and", (pcp), val)
+#define raw_cpu_or_8(pcp, val)			percpu_to_op("or", (pcp), val)
+#define raw_cpu_add_return_8(pcp, val)		percpu_add_return_op(pcp, val)
+#define raw_cpu_xchg_8(pcp, nval)		percpu_xchg_op(pcp, nval)
+#define raw_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+
+#define this_cpu_read_8(pcp)			percpu_from_op("mov", (pcp), "m"(pcp))
+#define this_cpu_write_8(pcp, val)		percpu_to_op("mov", (pcp), val)
+#define this_cpu_add_8(pcp, val)		percpu_add_op((pcp), val)
+#define this_cpu_and_8(pcp, val)		percpu_to_op("and", (pcp), val)
+#define this_cpu_or_8(pcp, val)			percpu_to_op("or", (pcp), val)
+#define this_cpu_add_return_8(pcp, val)		percpu_add_return_op(pcp, val)
+#define this_cpu_xchg_8(pcp, nval)		percpu_xchg_op(pcp, nval)
 #define this_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
 
 /*
@@ -474,7 +474,7 @@ do {									\
 	__ret;								\
 })
 
-#define __this_cpu_cmpxchg_double_8	percpu_cmpxchg16b_double
+#define raw_cpu_cmpxchg_double_8	percpu_cmpxchg16b_double
 #define this_cpu_cmpxchg_double_8	percpu_cmpxchg16b_double
 
 #endif
@@ -495,9 +495,9 @@ static __always_inline int x86_this_cpu_
 	unsigned long __percpu *a = (unsigned long *)addr + nr / BITS_PER_LONG;
 
 #ifdef CONFIG_X86_64
-	return ((1UL << (nr % BITS_PER_LONG)) & __this_cpu_read_8(*a)) != 0;
+	return ((1UL << (nr % BITS_PER_LONG)) & raw_cpu_read_8(*a)) != 0;
 #else
-	return ((1UL << (nr % BITS_PER_LONG)) & __this_cpu_read_4(*a)) != 0;
+	return ((1UL << (nr % BITS_PER_LONG)) & raw_cpu_read_4(*a)) != 0;
 #endif
 }
 
Index: linux/arch/x86/include/asm/preempt.h
===================================================================
--- linux.orig/arch/x86/include/asm/preempt.h	2013-12-02 16:07:50.984600478 -0600
+++ linux/arch/x86/include/asm/preempt.h	2013-12-02 16:07:50.984600478 -0600
@@ -13,12 +13,12 @@ DECLARE_PER_CPU(int, __preempt_count);
  */
 static __always_inline int preempt_count(void)
 {
-	return __this_cpu_read_4(__preempt_count) & ~PREEMPT_NEED_RESCHED;
+	return raw_cpu_read_4(__preempt_count) & ~PREEMPT_NEED_RESCHED;
 }
 
 static __always_inline void preempt_count_set(int pc)
 {
-	__this_cpu_write_4(__preempt_count, pc);
+	raw_cpu_write_4(__preempt_count, pc);
 }
 
 /*
@@ -47,17 +47,17 @@ static __always_inline void preempt_coun
 
 static __always_inline void set_preempt_need_resched(void)
 {
-	__this_cpu_and_4(__preempt_count, ~PREEMPT_NEED_RESCHED);
+	raw_cpu_and_4(__preempt_count, ~PREEMPT_NEED_RESCHED);
 }
 
 static __always_inline void clear_preempt_need_resched(void)
 {
-	__this_cpu_or_4(__preempt_count, PREEMPT_NEED_RESCHED);
+	raw_cpu_or_4(__preempt_count, PREEMPT_NEED_RESCHED);
 }
 
 static __always_inline bool test_preempt_need_resched(void)
 {
-	return !(__this_cpu_read_4(__preempt_count) & PREEMPT_NEED_RESCHED);
+	return !(raw_cpu_read_4(__preempt_count) & PREEMPT_NEED_RESCHED);
 }
 
 /*
@@ -66,12 +66,12 @@ static __always_inline bool test_preempt
 
 static __always_inline void __preempt_count_add(int val)
 {
-	__this_cpu_add_4(__preempt_count, val);
+	raw_cpu_add_4(__preempt_count, val);
 }
 
 static __always_inline void __preempt_count_sub(int val)
 {
-	__this_cpu_add_4(__preempt_count, -val);
+	raw_cpu_add_4(__preempt_count, -val);
 }
 
 static __always_inline bool __preempt_count_dec_and_test(void)
@@ -84,7 +84,7 @@ static __always_inline bool __preempt_co
  */
 static __always_inline bool should_resched(void)
 {
-	return unlikely(!__this_cpu_read_4(__preempt_count));
+	return unlikely(!raw_cpu_read_4(__preempt_count));
 }
 
 #ifdef CONFIG_PREEMPT

