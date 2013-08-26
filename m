Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab3HZVQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 17:16:19 -0400
Received: from a9-42.smtp-out.amazonses.com ([54.240.9.42]:53940 "EHLO
	a9-42.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752356Ab3HZVQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 17:16:18 -0400
Message-ID: <00000140bc7bfb1f-c50e3577-e101-4c19-8950-044fc4e8d140-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Mon, 26 Aug 2013 21:16:16 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org
Cc: linux-arch@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [guv v2 31/31] Remove __get_cpu_var and __raw_get_cpu_var macros
References: <20130826204351.725357339@linux.com>
X-SES-Outgoing: 2013.08.26-54.240.9.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No user is left in the kernel source tree. Therefore we can
drop the definitions.

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
 

