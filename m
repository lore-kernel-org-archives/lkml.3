Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab3HFROa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 13:14:30 -0400
Received: from a9-92.smtp-out.amazonses.com ([54.240.9.92]:40069 "EHLO
	a9-92.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756321Ab3HFRO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 13:14:29 -0400
X-Greylist: delayed 757 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Aug 2013 13:14:29 EDT
Date: Tue, 6 Aug 2013 17:01:50 +0000
From: Christoph Lameter <cl@gentwo.org>
To: rostedt@goodmis.org
cc: linux-kernel@vger.kernel.org
Subject: x86: use this_cpu for debug_stack_usage
Message-ID: <000001405493dacb-4d662921-2531-400a-a426-4f76c8066ede-000000@email.amazonses.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.08.06-54.240.9.92
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduces overhead a bit and frees up a couple of registers.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/x86/include/asm/debugreg.h
===================================================================
--- linux.orig/arch/x86/include/asm/debugreg.h	2013-07-30 14:00:30.000000000 -0500
+++ linux/arch/x86/include/asm/debugreg.h	2013-07-30 14:00:57.503076270 -0500
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
