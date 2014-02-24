Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaBXQMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:12:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33843 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbaBXQMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:12:48 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 1/3] ftrace/x86: One more missing sync after fixup of function modification failure
Date: Mon, 24 Feb 2014 17:12:20 +0100
Message-Id: <1393258342-29978-2-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1393258342-29978-1-git-send-email-pmladek@suse.cz>
References: <1393258342-29978-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a failure occurs while modifying ftrace function, it bails out and will
remove the tracepoints to be back to what the code originally was.

There is missing the final sync run across the CPUs after the fix up is done
and before the ftrace int3 handler flag is reset.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 arch/x86/kernel/ftrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 6b566c82d82c..69885e2f2095 100644
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
1.8.4

