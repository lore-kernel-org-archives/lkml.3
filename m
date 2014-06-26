Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964799AbaFZRAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:00:41 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:25973 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757878AbaFZQ6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:58:55 -0400
Message-Id: <20140626165853.482575534@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 26 Jun 2014 12:52:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Will Deacon <will.deacon@arm.com>
Subject: [RFA][PATCH 25/27] arm64, ftrace: Remove check of obsolete variable function_trace_stop
References: <20140626165221.736847419@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0025-arm64-ftrace-Remove-check-of-obsolete-variable-funct.patch
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

Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm64/kernel/entry-ftrace.S | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
index b051871f2965..1b1e330e6849 100644
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
2.0.0


