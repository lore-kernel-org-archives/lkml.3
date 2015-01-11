Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbbAKEDo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 23:03:44 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:62237 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbbAKEDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 23:03:32 -0500
From: David Long <dave.long@linaro.org>
To: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Cc: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        William Cohen <wcohen@redhat.com>,
        Steve Capper <steve.capper@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 6/6] kprobes: Add arm64 case in kprobe example module
Date: Sat, 10 Jan 2015 23:03:21 -0500
Message-Id: <1420949002-3726-7-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1420949002-3726-1-git-send-email-dave.long@linaro.org>
References: <1420949002-3726-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>

Add info prints in sample kprobe handlers for ARM64

Signed-off-by: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
---
 samples/kprobes/kprobe_example.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/samples/kprobes/kprobe_example.c b/samples/kprobes/kprobe_example.c
index 366db1a..51d459c 100644
--- a/samples/kprobes/kprobe_example.c
+++ b/samples/kprobes/kprobe_example.c
@@ -42,6 +42,10 @@ static int handler_pre(struct kprobe *p, struct pt_regs *regs)
 			" ex1 = 0x%lx\n",
 		p->addr, regs->pc, regs->ex1);
 #endif
+#ifdef CONFIG_ARM64
+	pr_info("pre_handler: p->addr = 0x%p, pc = 0x%lx\n",
+		p->addr, (long)regs->pc);
+#endif
 
 	/* A dump_stack() here will give a stack backtrace */
 	return 0;
@@ -67,6 +71,10 @@ static void handler_post(struct kprobe *p, struct pt_regs *regs,
 	printk(KERN_INFO "post_handler: p->addr = 0x%p, ex1 = 0x%lx\n",
 		p->addr, regs->ex1);
 #endif
+#ifdef CONFIG_ARM64
+	pr_info("post_handler: p->addr = 0x%p, pc = 0x%lx\n",
+		p->addr, (long)regs->pc);
+#endif
 }
 
 /*
-- 
1.8.1.2

