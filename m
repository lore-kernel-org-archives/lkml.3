Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab3LSPva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:51:30 -0500
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:54100 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754488Ab3LSPul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:50:41 -0500
Message-Id: <20131219155034.866017304@linux.com>
Date: Thu, 19 Dec 2013 09:50:54 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 39/40] Remove __get_cpu_var and __raw_get_cpu_var macros [only in 3.15]
References: <20131219155015.443763038@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=this_drop_get_cpu_Var
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No user is left in the kernel source tree. Therefore we can
drop the definitions.

[Patch should not be merged until all the replacement patches have been
merged. Probably this means hold until the 3.15 merge window]

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/asm-generic/percpu.h
===================================================================
--- linux.orig/include/asm-generic/percpu.h	2013-12-02 16:08:01.914296770 -0600
+++ linux/include/asm-generic/percpu.h	2013-12-02 16:08:01.914296770 -0600
@@ -65,9 +65,6 @@ extern unsigned long __per_cpu_offset[NR
 #define this_cpu_ptr(ptr) raw_cpu_ptr(ptr)
 #endif
 
-#define __get_cpu_var(var) (*this_cpu_ptr(&(var)))
-#define __raw_get_cpu_var(var) (*raw_cpu_ptr(&(var)))
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
 #define raw_cpu_ptr(ptr)	this_cpu_ptr(ptr)
 

