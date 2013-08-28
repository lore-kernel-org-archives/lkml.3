Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab3H1UGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 16:06:24 -0400
Received: from a9-62.smtp-out.amazonses.com ([54.240.9.62]:51753 "EHLO
	a9-62.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755231Ab3H1UGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 16:06:23 -0400
X-Greylist: delayed 1085 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Aug 2013 16:06:23 EDT
Message-ID: <00000140c678246b-29eb9519-707e-497c-9fb7-59161f0dc74e-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Wed, 28 Aug 2013 19:48:17 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org
Cc: linux-arch@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [gcv v3 35/35] Remove __get_cpu_var and __raw_get_cpu_var macros [only in 3.13]
References: <20130828193457.140443630@linux.com>
X-SES-Outgoing: 2013.08.28-54.240.9.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No user is left in the kernel source tree. Therefore we can
drop the definitions.

[Patch should not be merged until all the replacement patches have been
merged. Probably this means hold until the 3.13 merge window]

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/asm-generic/percpu.h
===================================================================
--- linux.orig/include/asm-generic/percpu.h	2013-08-26 14:40:32.528082727 -0500
+++ linux/include/asm-generic/percpu.h	2013-08-26 14:40:32.520082812 -0500
@@ -65,9 +65,6 @@ extern unsigned long __per_cpu_offset[NR
 #define this_cpu_ptr(ptr) __this_cpu_ptr(ptr)
 #endif
 
-#define __get_cpu_var(var) (*this_cpu_ptr(&(var)))
-#define __raw_get_cpu_var(var) (*__this_cpu_ptr(&(var)))
-
 #ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
 extern void setup_per_cpu_areas(void);
 #endif
@@ -80,8 +77,6 @@ extern void setup_per_cpu_areas(void);
 })
 
 #define per_cpu(var, cpu)	(*((void)(cpu), VERIFY_PERCPU_PTR(&(var))))
-#define __get_cpu_var(var)	(*VERIFY_PERCPU_PTR(&(var)))
-#define __raw_get_cpu_var(var)	(*VERIFY_PERCPU_PTR(&(var)))
 #define this_cpu_ptr(ptr)	per_cpu_ptr(ptr, 0)
 #define __this_cpu_ptr(ptr)	this_cpu_ptr(ptr)
 

