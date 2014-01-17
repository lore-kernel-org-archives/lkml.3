Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbaAQPhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:37:16 -0500
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:45624
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752144AbaAQPhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:37:13 -0500
Message-Id: <20140117151837.601798336@linux.com>
Date: Fri, 17 Jan 2014 09:18:43 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 31/41] s390: rename __this_cpu_ptr to raw_cpu_ptr
References: <20140117151812.770437629@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=this_s390
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Patch depends on another patch in this series that introduces raw_cpu_ops]

Use raw_cpu_ptr instead.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/s390/include/asm/percpu.h
===================================================================
--- linux.orig/arch/s390/include/asm/percpu.h	2013-12-18 13:37:42.757203647 -0600
+++ linux/arch/s390/include/asm/percpu.h	2013-12-18 13:37:42.747203967 -0600
@@ -31,7 +31,7 @@
 	pcp_op_T__ old__, new__, prev__;				\
 	pcp_op_T__ *ptr__;						\
 	preempt_disable();						\
-	ptr__ = __this_cpu_ptr(&(pcp));					\
+	ptr__ = raw_cpu_ptr(&(pcp));					\
 	prev__ = *ptr__;						\
 	do {								\
 		old__ = prev__;						\
@@ -70,7 +70,7 @@
 	pcp_op_T__ val__ = (val);					\
 	pcp_op_T__ old__, *ptr__;					\
 	preempt_disable();						\
-	ptr__ = __this_cpu_ptr(&(pcp)); 				\
+	ptr__ = raw_cpu_ptr(&(pcp)); 				\
 	if (__builtin_constant_p(val__) &&				\
 	    ((szcast)val__ > -129) && ((szcast)val__ < 128)) {		\
 		asm volatile(						\
@@ -97,7 +97,7 @@
 	pcp_op_T__ val__ = (val);					\
 	pcp_op_T__ old__, *ptr__;					\
 	preempt_disable();						\
-	ptr__ = __this_cpu_ptr(&(pcp)); 				\
+	ptr__ = raw_cpu_ptr(&(pcp));	 				\
 	asm volatile(							\
 		op "    %[old__],%[val__],%[ptr__]\n"			\
 		: [old__] "=d" (old__), [ptr__] "+Q" (*ptr__)		\
@@ -116,7 +116,7 @@
 	pcp_op_T__ val__ = (val);					\
 	pcp_op_T__ old__, *ptr__;					\
 	preempt_disable();						\
-	ptr__ = __this_cpu_ptr(&(pcp)); 				\
+	ptr__ = raw_cpu_ptr(&(pcp));	 				\
 	asm volatile(							\
 		op "    %[old__],%[val__],%[ptr__]\n"			\
 		: [old__] "=d" (old__), [ptr__] "+Q" (*ptr__)		\
@@ -138,7 +138,7 @@
 	pcp_op_T__ ret__;						\
 	pcp_op_T__ *ptr__;						\
 	preempt_disable();						\
-	ptr__ = __this_cpu_ptr(&(pcp));					\
+	ptr__ = raw_cpu_ptr(&(pcp));					\
 	ret__ = cmpxchg(ptr__, oval, nval);				\
 	preempt_enable();						\
 	ret__;								\
@@ -154,7 +154,7 @@
 	typeof(pcp) *ptr__;						\
 	typeof(pcp) ret__;						\
 	preempt_disable();						\
-	ptr__ = __this_cpu_ptr(&(pcp));					\
+	ptr__ = raw_cpu_ptr(&(pcp));					\
 	ret__ = xchg(ptr__, nval);					\
 	preempt_enable();						\
 	ret__;								\
@@ -173,8 +173,8 @@
 	typeof(pcp2) *p2__;						\
 	int ret__;							\
 	preempt_disable();						\
-	p1__ = __this_cpu_ptr(&(pcp1));					\
-	p2__ = __this_cpu_ptr(&(pcp2));					\
+	p1__ = raw_cpu_ptr(&(pcp1));					\
+	p2__ = raw_cpu_ptr(&(pcp2));					\
 	ret__ = __cmpxchg_double(p1__, p2__, o1__, o2__, n1__, n2__);	\
 	preempt_enable();						\
 	ret__;								\

