Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbaKYMOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:14:30 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:6969 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752213AbaKYMO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:14:27 -0500
Message-Id: <20141125121426.767863973@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 25 Nov 2014 07:13:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [for-next][PATCH 4/5] kprobes: Add IPMODIFY flag to kprobe_ftrace_ops
References: <20141125121355.225538266@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0004-kprobes-Add-IPMODIFY-flag-to-kprobe_ftrace_ops.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Add FTRACE_OPS_FL_IPMODIFY flag to kprobe_ftrace_ops
since kprobes can changes regs->ip.

Link: http://lkml.kernel.org/r/20141121102523.11844.21298.stgit@localhost.localdomain

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/kprobes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 3995f546d0f3..831978cebf1d 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -915,7 +915,7 @@ static struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
 #ifdef CONFIG_KPROBES_ON_FTRACE
 static struct ftrace_ops kprobe_ftrace_ops __read_mostly = {
 	.func = kprobe_ftrace_handler,
-	.flags = FTRACE_OPS_FL_SAVE_REGS,
+	.flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_IPMODIFY,
 };
 static int kprobe_ftrace_enabled;
 
-- 
2.1.1


