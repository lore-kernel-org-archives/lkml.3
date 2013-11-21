Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab3KUIcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 03:32:09 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62408 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab3KUIcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 03:32:08 -0500
From: Richard Weinberger <richard@nod.at>
To: richard@nod.at
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        rdunlap@infradead.org
Subject: [PATCH] um: Rename print_stack_trace to do_stack_trace
Date: Thu, 21 Nov 2013 09:31:55 +0100
Message-Id: <1385022715-21398-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We cannot use print_stack_trace because the name conflicts
with linux/stacktrace.h.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/kernel/sysrq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/um/kernel/sysrq.c b/arch/um/kernel/sysrq.c
index 4d6fdf6..799d7e4 100644
--- a/arch/um/kernel/sysrq.c
+++ b/arch/um/kernel/sysrq.c
@@ -19,7 +19,7 @@ struct stack_frame {
 	unsigned long return_address;
 };
 
-static void print_stack_trace(unsigned long *sp, unsigned long bp)
+static void do_stack_trace(unsigned long *sp, unsigned long bp)
 {
 	int reliable;
 	unsigned long addr;
@@ -94,5 +94,5 @@ void show_stack(struct task_struct *task, unsigned long *stack)
 	}
 	printk(KERN_CONT "\n");
 
-	print_stack_trace(sp, bp);
+	do_stack_trace(sp, bp);
 }
-- 
1.8.4.2

