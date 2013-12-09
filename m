Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933393Ab3LIKxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:53:51 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:58303 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933262Ab3LIKxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:53:41 -0500
Subject: [PATCH -tip v5 17/18] kprobes: Use NOKPROBE_SYMBOL() in sample
 modules
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Date: Mon, 09 Dec 2013 10:47:58 +0000
Message-ID: <20131209104758.13397.567.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131209104717.13397.8864.stgit@kbuild-fedora.novalocal>
References: <20131209104717.13397.8864.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use NOKPROBE_SYMBOL() to protect handlers from kprobes
in sample modules.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 samples/kprobes/jprobe_example.c    |    1 +
 samples/kprobes/kprobe_example.c    |    3 +++
 samples/kprobes/kretprobe_example.c |    2 ++
 3 files changed, 6 insertions(+)

diff --git a/samples/kprobes/jprobe_example.c b/samples/kprobes/jprobe_example.c
index b754135..40114ac 100644
--- a/samples/kprobes/jprobe_example.c
+++ b/samples/kprobes/jprobe_example.c
@@ -35,6 +35,7 @@ static long jdo_fork(unsigned long clone_flags, unsigned long stack_start,
 	jprobe_return();
 	return 0;
 }
+NOKPROBE_SYMBOL(jdo_fork);
 
 static struct jprobe my_jprobe = {
 	.entry			= jdo_fork,
diff --git a/samples/kprobes/kprobe_example.c b/samples/kprobes/kprobe_example.c
index 366db1a..462d90f 100644
--- a/samples/kprobes/kprobe_example.c
+++ b/samples/kprobes/kprobe_example.c
@@ -46,6 +46,7 @@ static int handler_pre(struct kprobe *p, struct pt_regs *regs)
 	/* A dump_stack() here will give a stack backtrace */
 	return 0;
 }
+NOKPROBE_SYMBOL(handler_pre);
 
 /* kprobe post_handler: called after the probed instruction is executed */
 static void handler_post(struct kprobe *p, struct pt_regs *regs,
@@ -68,6 +69,7 @@ static void handler_post(struct kprobe *p, struct pt_regs *regs,
 		p->addr, regs->ex1);
 #endif
 }
+NOKPROBE_SYMBOL(handler_post);
 
 /*
  * fault_handler: this is called if an exception is generated for any
@@ -81,6 +83,7 @@ static int handler_fault(struct kprobe *p, struct pt_regs *regs, int trapnr)
 	/* Return 0 because we don't handle the fault. */
 	return 0;
 }
+NOKPROBE_SYMBOL(handler_fault);
 
 static int __init kprobe_init(void)
 {
diff --git a/samples/kprobes/kretprobe_example.c b/samples/kprobes/kretprobe_example.c
index 1041b67..d932c52 100644
--- a/samples/kprobes/kretprobe_example.c
+++ b/samples/kprobes/kretprobe_example.c
@@ -47,6 +47,7 @@ static int entry_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
 	data->entry_stamp = ktime_get();
 	return 0;
 }
+NOKPROBE_SYMBOL(entry_handler);
 
 /*
  * Return-probe handler: Log the return value and duration. Duration may turn
@@ -66,6 +67,7 @@ static int ret_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
 			func_name, retval, (long long)delta);
 	return 0;
 }
+NOKPROBE_SYMBOL(ret_handler);
 
 static struct kretprobe my_kretprobe = {
 	.handler		= ret_handler,


