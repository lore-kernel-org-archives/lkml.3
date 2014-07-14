Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbaGNRHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:07:36 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:30956 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756210AbaGNRH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:07:29 -0400
Message-Id: <20140714170728.119738652@goodmis.org>
User-Agent: quilt/0.63-1
Date: Mon, 14 Jul 2014 13:05:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFA][PATCH 2/2] ftrace/x86: Have function graph tracer use its own trampoline
References: <20140714170506.073521585@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-ftrace-x86-Have-function-graph-tracer-use-its-own-tr.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

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
index 0525a8bdf65d..e1f7fecaa7d6 100644
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
2.0.0


