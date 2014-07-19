Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965869AbaGSNRF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 09:17:05 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:51597 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755514AbaGSNQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 09:16:16 -0400
Message-Id: <20140719131613.958346878@goodmis.org>
User-Agent: quilt/0.63-1
Date: Sat, 19 Jul 2014 09:15:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Will Deacon <will.deacon@arm.com>
Subject: [for-next][PATCH 26/32] arm64, ftrace: Remove check of obsolete variable function_trace_stop
References: <20140719131524.009152325@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0026-arm64-ftrace-Remove-check-of-obsolete-variable-funct.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Nothing sets function_trace_stop to disable function tracing anymore.
Remove the check for it in the arch code.

arm64 was broken anyway, as it had an ifdef testing
 CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST which is only set if
the arch supports the code (which it obviously did not), and
it was testing a non existent ftrace_trace_stop instead of
function_trace_stop.

Link: http://lkml.kernel.org/r/20140627124421.GP26276@arm.com

Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm64/kernel/entry-ftrace.S | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
index aa5f9fcbf9ee..38e704e597f7 100644
--- a/arch/arm64/kernel/entry-ftrace.S
+++ b/arch/arm64/kernel/entry-ftrace.S
@@ -96,11 +96,6 @@
  *     - ftrace_graph_caller to set up an exit hook
  */
 ENTRY(_mcount)
-#ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
-	ldr	x0, =ftrace_trace_stop
-	ldr	x0, [x0]		// if ftrace_trace_stop
-	ret				//   return;
-#endif
 	mcount_enter
 
 	ldr	x0, =ftrace_trace_function
-- 
2.0.1


