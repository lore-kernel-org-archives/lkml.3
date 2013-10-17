Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab3JQLT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 07:19:28 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:55539 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab3JQLTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 07:19:25 -0400
From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, catalin.marinas@arm.com,
        will.deacon@arm.com, steve.capper@linaro.org, nico@linaro.org,
        srikar@linux.vnet.ibm.com, rostedt@goodmis.org,
        masami.hiramatsu.pt@hitachi.com, dsaxena@linaro.org,
        jiang.liu@huawei.com, Vijaya.Kumar@caviumnetworks.com,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
Subject: [PATCH RFC 6/6] kprobes: Add cases for arm and arm64 in sample module
Date: Thu, 17 Oct 2013 16:47:51 +0530
Message-Id: <1382008671-4515-7-git-send-email-sandeepa.prabhu@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org>
References: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add info prints in sample kprobe handlers for ARM and ARM64
architecture.

Signed-off-by: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
---
 samples/kprobes/kprobe_example.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/samples/kprobes/kprobe_example.c b/samples/kprobes/kprobe_example.c
index 366db1a..0521246 100644
--- a/samples/kprobes/kprobe_example.c
+++ b/samples/kprobes/kprobe_example.c
@@ -42,6 +42,14 @@ static int handler_pre(struct kprobe *p, struct pt_regs *regs)
 			" ex1 = 0x%lx\n",
 		p->addr, regs->pc, regs->ex1);
 #endif
+#ifdef CONFIG_ARM
+	printk(KERN_INFO "pre_handler: p->addr = 0x%p, pc = 0x%lx\n",
+			p->addr, regs->ARM_pc);
+#endif
+#ifdef CONFIG_ARM64
+	printk(KERN_INFO "pre_handler: p->addr = 0x%p, pc = 0x%lx\n",
+		p->addr, (long)regs->pc);
+#endif
 
 	/* A dump_stack() here will give a stack backtrace */
 	return 0;
@@ -67,6 +75,14 @@ static void handler_post(struct kprobe *p, struct pt_regs *regs,
 	printk(KERN_INFO "post_handler: p->addr = 0x%p, ex1 = 0x%lx\n",
 		p->addr, regs->ex1);
 #endif
+#ifdef CONFIG_ARM
+	printk(KERN_INFO "post_handler: p->addr = 0x%p, pc = 0x%lx\n",
+			p->addr, regs->ARM_pc);
+#endif
+#ifdef CONFIG_ARM64
+	printk(KERN_INFO "post_handler: p->addr = 0x%p, pc = 0x%lx\n",
+		p->addr, (long)regs->pc);
+#endif
 }
 
 /*
-- 
1.8.1.2

