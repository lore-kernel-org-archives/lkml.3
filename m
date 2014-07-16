Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965332AbaGPPG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 11:06:27 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:62336 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S964926AbaGPPGY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 11:06:24 -0400
Date: Wed, 16 Jul 2014 11:06:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [RFA][PATCH] ftrace/x86: Have function graph tracer use its own
 trampoline
Message-ID: <20140716110615.583d1ee9@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Peter,

Here's a really trivial patch that touches arch/x86/include/asm/ftrace.h

Can you ack it. Thanks.

This is based on the patches here:

  http://marc.info/?l=linux-kernel&m=140513619913439&w=2

Thanks,

-- Steve


>From 32443f104c172cc368882101cd65604dc046f099 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Date: Fri, 11 Jul 2014 23:23:53 -0400
Subject: [PATCH] ftrace/x86: Have function graph tracer use its own trampoline

The function graph trampoline is called from the function trampoline
and both do a save and restore of registers. The save of registers
done by the function trampoline when only the function graph tracer
is running is a waste of CPU cycles.

As the function graph tracer trampoline in x86 is dependent from
the function trampoline, we can call it directly when a function
is only being traced by the function graph trampoline.

Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/ftrace.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index 0525a8b..e1f7fec 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -68,6 +68,8 @@ struct dyn_arch_ftrace {
 
 int ftrace_int3_handler(struct pt_regs *regs);
 
+#define FTRACE_GRAPH_TRAMP_ADDR FTRACE_GRAPH_ADDR
+
 #endif /*  CONFIG_DYNAMIC_FTRACE */
 #endif /* __ASSEMBLY__ */
 #endif /* CONFIG_FUNCTION_TRACER */
-- 
1.8.1.4

