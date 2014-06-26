Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470AbaFZRBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:01:13 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:60346 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757874AbaFZQ6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:58:55 -0400
Message-Id: <20140626165852.891982463@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 26 Jun 2014 12:52:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>,
        Michal Simek <monstr@monstr.eu>
Subject: [RFA][PATCH 22/27] microblaze: ftrace: Remove check of obsolete variable
 function_trace_stop
References: <20140626165221.736847419@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0022-microblaze-ftrace-Remove-check-of-obsolete-variable-.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Nothing sets function_trace_stop to disable function tracing anymore.
Remove the check for it in the arch code.

[ Please test this on your arch ]

Cc: Michal Simek <monstr@monstr.eu>
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
2.0.0


