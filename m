Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab3HZUor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 16:44:47 -0400
Received: from a9-58.smtp-out.amazonses.com ([54.240.9.58]:46064 "EHLO
	a9-58.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752325Ab3HZUop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 16:44:45 -0400
Message-ID: <00000140bc5f1696-c002fa01-3db1-4f4e-979c-354c054a0caf-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Mon, 26 Aug 2013 20:44:43 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org
Cc: linux-arch@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [guv v2 01/31] x86: Use this_cpu_inc/dec for debug registers
References: <20130826204351.725357339@linux.com>
X-SES-Outgoing: 2013.08.26-54.240.9.58
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

