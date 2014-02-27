Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaB0Pvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:51:44 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:22937 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753380AbaB0Pt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:49:27 -0500
Message-Id: <20140227154923.103932155@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 27 Feb 2014 10:46:18 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        <stable@vger.kernel.org>, Petr Mladek <pmladek@suse.cz>
Subject: [RFA][PATCH 2/5] ftrace/x86: One more missing sync after fixup of function
 modification failure
References: <20140227154616.703252665@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-ftrace-x86-One-more-missing-sync-after-fixup-of-func.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Request for Ack]

From: Petr Mladek <pmladek@suse.cz>

If a failure occurs while modifying ftrace function, it bails out and will
remove the tracepoints to be back to what the code originally was.

There is missing the final sync run across the CPUs after the fix up is done
and before the ftrace int3 handler flag is reset.

Link: http://lkml.kernel.org/r/1393258342-29978-2-git-send-email-pmladek@suse.cz

Fixes: 8a4d0a687a5 "ftrace: Use breakpoint method to update ftrace caller"
Cc: stable@vger.kernel.org # 3.5+
Signed-off-by: Petr Mladek <pmladek@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/ftrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 6b566c8..69885e2 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -660,8 +660,8 @@ ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
 		ret = -EPERM;
 		goto out;
 	}
-	run_sync();
  out:
+	run_sync();
 	return ret;
 
  fail_update:
-- 
1.8.5.3


