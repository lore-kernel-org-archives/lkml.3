Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbaBQPYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 10:24:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961AbaBQPYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 10:24:22 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 4/4] x86: Fix order of warning messages when ftrace modifies code
Date: Mon, 17 Feb 2014 16:22:53 +0100
Message-Id: <1392650573-3390-5-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1392650573-3390-1-git-send-email-pmladek@suse.cz>
References: <1392650573-3390-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The colon at the end of the printk message suggests that it should get printed
before the details printed by ftrace_bug().

When touching the line, let's use the preferred pr_warn() macro as suggested
by checkpatch.pl.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 arch/x86/kernel/ftrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 525a9f954c8b..ad7c38f5206b 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -622,8 +622,8 @@ void ftrace_replace_code(int enable)
 	return;
 
  remove_breakpoints:
+	pr_warn("Failed on %s (%d):\n", report, count);
 	ftrace_bug(ret, rec ? rec->ip : 0);
-	printk(KERN_WARNING "Failed on %s (%d):\n", report, count);
 	for_ftrace_rec_iter(iter) {
 		int err;
 
-- 
1.8.4

