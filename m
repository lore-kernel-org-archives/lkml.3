Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbaG1FWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 01:22:48 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:38874 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaG1FWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 01:22:47 -0400
Subject: [PATCH ftrace/core v4 3/4] kprobes: Add IPMODIFY flag to
 kprobe_ftrace_ops
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Steven Rostedt <rostedt@goodmis.org>, Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Date: Mon, 28 Jul 2014 05:22:36 +0000
Message-ID: <20140728052236.29491.17679.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140728052215.29491.23631.stgit@kbuild-fedora.novalocal>
References: <20140728052215.29491.23631.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add FTRACE_OPS_FL_IPMODIFY flag to kprobe_ftrace_ops
since kprobes can changes regs->ip.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 kernel/kprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 3214289..e52d86f 100644
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
 


