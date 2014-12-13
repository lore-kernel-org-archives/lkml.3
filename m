Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbaLMEWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 23:22:20 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:11715 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754388AbaLMEWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 23:22:18 -0500
Message-Id: <20141213042216.999677852@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 12 Dec 2014 23:21:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH 1/2] ftrace/x86: Update i386 call to prepare_ftrace_return()
References: <20141213042144.599602592@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-ftrace-x86-Update-i386-call-to-prepare_ftrace_return.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The parameters for prepare_ftrace_return() used by the function graph
tracer were swapped to simplify the code on x86_64. But i386 function
graph trampoline also calls this function, and it did not have its
parameters swapped.

Link: http://lkml.kernel.org/r/20141210231732.GA24163@wfg-t540p.sh.intel.com

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Tested-by: Fengguang Wu <fengguang.wu@intel.com>
Fixes: 6a06bdbf7f9c "ftrace/fgraph/x86: Have prepare_ftrace_return() take ip as first parameter"
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/entry_32.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index b553ed89e5f5..df3e608d409b 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1192,10 +1192,10 @@ ENTRY(ftrace_graph_caller)
 	pushl %eax
 	pushl %ecx
 	pushl %edx
-	movl 0xc(%esp), %edx
-	lea 0x4(%ebp), %eax
+	movl 0xc(%esp), %eax
+	lea 0x4(%ebp), %edx
 	movl (%ebp), %ecx
-	subl $MCOUNT_INSN_SIZE, %edx
+	subl $MCOUNT_INSN_SIZE, %eax
 	call prepare_ftrace_return
 	popl %edx
 	popl %ecx
-- 
2.1.3


