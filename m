Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab3HWTCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:02:01 -0400
Received: from a9-78.smtp-out.amazonses.com ([54.240.9.78]:46521 "EHLO
	a9-78.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754659Ab3HWTB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:01:58 -0400
Message-ID: <00000140ac8dec92-f01525aa-0880-4e11-8c31-9cccce37bfa7-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Fri, 23 Aug 2013 19:01:57 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org
Cc: linux-arch@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [guv 01/16] x86: Use this_cpu_inc/dec for debug registers
References: <20130823190135.726207430@linux.com>
X-SES-Outgoing: 2013.08.23-54.240.9.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this patch already exists in one form or another in some x86 tree.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/x86/include/asm/debugreg.h
===================================================================
--- linux.orig/arch/x86/include/asm/debugreg.h	2013-08-06 13:52:23.740092873 -0500
+++ linux/arch/x86/include/asm/debugreg.h	2013-08-06 13:52:23.740092873 -0500
@@ -97,11 +97,11 @@ extern void hw_breakpoint_restore(void);
 DECLARE_PER_CPU(int, debug_stack_usage);
 static inline void debug_stack_usage_inc(void)
 {
-	__get_cpu_var(debug_stack_usage)++;
+	__this_cpu_inc(debug_stack_usage);
 }
 static inline void debug_stack_usage_dec(void)
 {
-	__get_cpu_var(debug_stack_usage)--;
+	__this_cpu_dec(debug_stack_usage);
 }
 int is_debug_stack(unsigned long addr);
 void debug_stack_set_zero(void);
Index: linux/arch/x86/kernel/cpu/common.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/common.c	2013-07-19 09:06:36.850047837 -0500
+++ linux/arch/x86/kernel/cpu/common.c	2013-08-06 13:54:36.426384889 -0500
@@ -1144,9 +1144,9 @@ DEFINE_PER_CPU(int, debug_stack_usage);
 
 int is_debug_stack(unsigned long addr)
 {
-	return __get_cpu_var(debug_stack_usage) ||
-		(addr <= __get_cpu_var(debug_stack_addr) &&
-		 addr > (__get_cpu_var(debug_stack_addr) - DEBUG_STKSZ));
+	return __this_cpu_read(debug_stack_usage) ||
+		(addr <= __this_cpu_read(debug_stack_addr) &&
+		 addr > (__this_cpu_read(debug_stack_addr) - DEBUG_STKSZ));
 }
 
 DEFINE_PER_CPU(u32, debug_idt_ctr);

