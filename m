Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432AbaDXQNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:13:10 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:31528 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758609AbaDXQDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:03:23 -0400
Message-Id: <20140424160320.656524368@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 24 Apr 2014 12:02:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Petr Mladek <pmladek@suse.cz>
Subject: [for-next][PATCH 6/8] ftrace/x86: Fix order of warning messages when ftrace modifies code
References: <20140424160232.271454710@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0006-ftrace-x86-Fix-order-of-warning-messages-when-ftrace.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Petr Mladek <pmladek@suse.cz>

The colon at the end of the printk message suggests that it should get printed
before the details printed by ftrace_bug().

When touching the line, let's use the preferred pr_warn() macro as suggested
by checkpatch.pl.

Link: http://lkml.kernel.org/r/1392650573-3390-5-git-send-email-pmladek@suse.cz

Signed-off-by: Petr Mladek <pmladek@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/ftrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 52819e8..3d837b0 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -621,8 +621,8 @@ void ftrace_replace_code(int enable)
 	return;
 
  remove_breakpoints:
+	pr_warn("Failed on %s (%d):\n", report, count);
 	ftrace_bug(ret, rec ? rec->ip : 0);
-	printk(KERN_WARNING "Failed on %s (%d):\n", report, count);
 	for_ftrace_rec_iter(iter) {
 		rec = ftrace_rec_iter_record(iter);
 		/*
-- 
1.8.5.3


