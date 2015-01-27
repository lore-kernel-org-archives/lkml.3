Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759804AbbA0Uad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 15:30:33 -0500
Received: from skprod2.natinst.com ([130.164.80.23]:38276 "EHLO ni.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759780AbbA0Uab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 15:30:31 -0500
From: Xander Huff <xander.huff@ni.com>
To: mingo@redhat.com
Cc: josh.cartwright@ni.com, jaeden.amero@ni.com, gratian.crisan@ni.com,
        linux-kernel@vger.kernel.org, ben.shelton@ni.com, brad.mouring@ni.com,
        rich.tollerton@ni.com, Xander Huff <xander.huff@ni.com>
Subject: [PATCH] lockdep: selftest: fix warnings due to missing PREEMPT_RT conditionals
Date: Tue, 27 Jan 2015 14:30:19 -0600
Message-Id: <1422390619-5238-1-git-send-email-xander.huff@ni.com>
X-Mailer: git-send-email 1.9.1
X-MIMETrack: Itemize by SMTP Server on US-AUS-MGWOut1/AUS/H/NIC(Release 8.5.3FP6|November
 21, 2013) at 01/27/2015 02:30:24 PM,
	Serialize by Router on US-AUS-MGWOut1/AUS/H/NIC(Release 8.5.3FP6|November
 21, 2013) at 01/27/2015 02:30:24 PM,
	Serialize complete at 01/27/2015 02:30:24 PM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-27_03:2015-01-27,2015-01-26,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Cartwright <josh.cartwright@ni.com>

"lockdep: Selftest: Only do hardirq context test for raw spinlock"
disabled the execution of certain tests with PREEMPT_RT_FULL, but did
not prevent the tests from still being defined.  This leads to warnings
like:

  ./linux/lib/locking-selftest.c:574:1: warning: 'irqsafe1_hard_rlock_12' defined but not used [-Wunused-function]
  ./linux/lib/locking-selftest.c:574:1: warning: 'irqsafe1_hard_rlock_21' defined but not used [-Wunused-function]
  ./linux/lib/locking-selftest.c:577:1: warning: 'irqsafe1_hard_wlock_12' defined but not used [-Wunused-function]
  ./linux/lib/locking-selftest.c:577:1: warning: 'irqsafe1_hard_wlock_21' defined but not used [-Wunused-function]
  ./linux/lib/locking-selftest.c:580:1: warning: 'irqsafe1_soft_spin_12' defined but not used [-Wunused-function]
  ...

Fixed by wrapping the test definitions in #ifndef CONFIG_PREEMPT_RT_FULL
conditionals.

Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
Signed-off-by: Xander Huff <xander.huff@ni.com>
Acked-by: Gratian Crisan <gratian.crisan@ni.com>
---
 lib/locking-selftest.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index 507a22f..51e558f 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -570,6 +570,8 @@ GENERATE_TESTCASE(init_held_rsem)
 #include "locking-selftest-spin-hardirq.h"
 GENERATE_PERMUTATIONS_2_EVENTS(irqsafe1_hard_spin)
 
+#ifndef CONFIG_PREEMPT_RT_FULL
+
 #include "locking-selftest-rlock-hardirq.h"
 GENERATE_PERMUTATIONS_2_EVENTS(irqsafe1_hard_rlock)
 
@@ -585,9 +587,12 @@ GENERATE_PERMUTATIONS_2_EVENTS(irqsafe1_soft_rlock)
 #include "locking-selftest-wlock-softirq.h"
 GENERATE_PERMUTATIONS_2_EVENTS(irqsafe1_soft_wlock)
 
+#endif
+
 #undef E1
 #undef E2
 
+#ifndef CONFIG_PREEMPT_RT_FULL
 /*
  * Enabling hardirqs with a softirq-safe lock held:
  */
@@ -620,6 +625,8 @@ GENERATE_PERMUTATIONS_2_EVENTS(irqsafe2A_rlock)
 #undef E1
 #undef E2
 
+#endif
+
 /*
  * Enabling irqs with an irq-safe lock held:
  */
@@ -643,6 +650,8 @@ GENERATE_PERMUTATIONS_2_EVENTS(irqsafe2A_rlock)
 #include "locking-selftest-spin-hardirq.h"
 GENERATE_PERMUTATIONS_2_EVENTS(irqsafe2B_hard_spin)
 
+#ifndef CONFIG_PREEMPT_RT_FULL
+
 #include "locking-selftest-rlock-hardirq.h"
 GENERATE_PERMUTATIONS_2_EVENTS(irqsafe2B_hard_rlock)
 
@@ -658,6 +667,8 @@ GENERATE_PERMUTATIONS_2_EVENTS(irqsafe2B_soft_rlock)
 #include "locking-selftest-wlock-softirq.h"
 GENERATE_PERMUTATIONS_2_EVENTS(irqsafe2B_soft_wlock)
 
+#endif
+
 #undef E1
 #undef E2
 
@@ -689,6 +700,8 @@ GENERATE_PERMUTATIONS_2_EVENTS(irqsafe2B_soft_wlock)
 #include "locking-selftest-spin-hardirq.h"
 GENERATE_PERMUTATIONS_3_EVENTS(irqsafe3_hard_spin)
 
+#ifndef CONFIG_PREEMPT_RT_FULL
+
 #include "locking-selftest-rlock-hardirq.h"
 GENERATE_PERMUTATIONS_3_EVENTS(irqsafe3_hard_rlock)
 
@@ -704,6 +717,8 @@ GENERATE_PERMUTATIONS_3_EVENTS(irqsafe3_soft_rlock)
 #include "locking-selftest-wlock-softirq.h"
 GENERATE_PERMUTATIONS_3_EVENTS(irqsafe3_soft_wlock)
 
+#endif
+
 #undef E1
 #undef E2
 #undef E3
@@ -737,6 +752,8 @@ GENERATE_PERMUTATIONS_3_EVENTS(irqsafe3_soft_wlock)
 #include "locking-selftest-spin-hardirq.h"
 GENERATE_PERMUTATIONS_3_EVENTS(irqsafe4_hard_spin)
 
+#ifndef CONFIG_PREEMPT_RT_FULL
+
 #include "locking-selftest-rlock-hardirq.h"
 GENERATE_PERMUTATIONS_3_EVENTS(irqsafe4_hard_rlock)
 
@@ -752,10 +769,14 @@ GENERATE_PERMUTATIONS_3_EVENTS(irqsafe4_soft_rlock)
 #include "locking-selftest-wlock-softirq.h"
 GENERATE_PERMUTATIONS_3_EVENTS(irqsafe4_soft_wlock)
 
+#endif
+
 #undef E1
 #undef E2
 #undef E3
 
+#ifndef CONFIG_PREEMPT_RT_FULL
+
 /*
  * read-lock / write-lock irq inversion.
  *
@@ -818,6 +839,10 @@ GENERATE_PERMUTATIONS_3_EVENTS(irq_inversion_soft_wlock)
 #undef E2
 #undef E3
 
+#endif
+
+#ifndef CONFIG_PREEMPT_RT_FULL
+
 /*
  * read-lock / write-lock recursion that is actually safe.
  */
@@ -856,6 +881,8 @@ GENERATE_PERMUTATIONS_3_EVENTS(irq_read_recursion_soft)
 #undef E2
 #undef E3
 
+#endif
+
 /*
  * read-lock / write-lock recursion that is unsafe.
  */
-- 
1.9.1

