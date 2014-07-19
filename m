Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174AbaGSNQn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 09:16:43 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:11706 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755367AbaGSNQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 09:16:14 -0400
Message-Id: <20140719131613.422315101@goodmis.org>
User-Agent: quilt/0.63-1
Date: Sat, 19 Jul 2014 09:15:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Simek <monstr@monstr.eu>
Subject: [for-next][PATCH 23/32] microblaze: ftrace: Remove check of obsolete variable
 function_trace_stop
References: <20140719131524.009152325@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0023-microblaze-ftrace-Remove-check-of-obsolete-variable-.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Nothing sets function_trace_stop to disable function tracing anymore.
Remove the check for it in the arch code.

Link: http://lkml.kernel.org/r/53C8D82B.4030204@monstr.eu

Tested-by: Michal Simek <monstr@monstr.eu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/microblaze/Kconfig         | 1 -
 arch/microblaze/kernel/mcount.S | 5 -----
 2 files changed, 6 deletions(-)

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 9ae08541e30d..40e1c1dd0e24 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -22,7 +22,6 @@ config MICROBLAZE
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_GRAPH_TRACER
-	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_FUNCTION_TRACER
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
diff --git a/arch/microblaze/kernel/mcount.S b/arch/microblaze/kernel/mcount.S
index fc1e1322ce4c..fed9da5de8c4 100644
--- a/arch/microblaze/kernel/mcount.S
+++ b/arch/microblaze/kernel/mcount.S
@@ -91,11 +91,6 @@ ENTRY(ftrace_caller)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 	SAVE_REGS
 	swi	r15, r1, 0;
-	/* MS: HAVE_FUNCTION_TRACE_MCOUNT_TEST begin of checking */
-	lwi	r5, r0, function_trace_stop;
-	bneid	r5, end;
-	nop;
-	/* MS: HAVE_FUNCTION_TRACE_MCOUNT_TEST end of checking */
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 #ifndef CONFIG_DYNAMIC_FTRACE
 	lwi	r5, r0, ftrace_graph_return;
-- 
2.0.1


