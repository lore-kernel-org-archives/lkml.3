Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab3HEWHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:07:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:21922 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755064Ab3HEWDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:03:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,821,1367996400"; 
   d="scan'208";a="342111475"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 05/16] x86, asmlinkage: Make 32bit/64bit __switch_to visible
Date: Mon,  5 Aug 2013 15:02:39 -0700
Message-Id: <1375740170-7446-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
References: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This function is called from inline assembler, so has to be visible.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/switch_to.h | 4 ++--
 arch/x86/kernel/process_32.c     | 2 +-
 arch/x86/kernel/process_64.c     | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/switch_to.h b/arch/x86/include/asm/switch_to.h
index 4ec45b3..d7f3b3b 100644
--- a/arch/x86/include/asm/switch_to.h
+++ b/arch/x86/include/asm/switch_to.h
@@ -2,8 +2,8 @@
 #define _ASM_X86_SWITCH_TO_H
 
 struct task_struct; /* one of the stranger aspects of C forward declarations */
-struct task_struct *__switch_to(struct task_struct *prev,
-				struct task_struct *next);
+__visible struct task_struct *__switch_to(struct task_struct *prev,
+					   struct task_struct *next);
 struct tss_struct;
 void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 		      struct tss_struct *tss);
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index f8adefc..884f98f 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -247,7 +247,7 @@ EXPORT_SYMBOL_GPL(start_thread);
  * the task-switch, and shows up in ret_from_fork in entry.S,
  * for example.
  */
-__notrace_funcgraph struct task_struct *
+__visible __notrace_funcgraph struct task_struct *
 __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 {
 	struct thread_struct *prev = &prev_p->thread,
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 05646ba..6e8c1d0 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -274,7 +274,7 @@ void start_thread_ia32(struct pt_regs *regs, u32 new_ip, u32 new_sp)
  * Kprobes not supported here. Set the probe on schedule instead.
  * Function graph tracer not supported too.
  */
-__notrace_funcgraph struct task_struct *
+__visible __notrace_funcgraph struct task_struct *
 __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 {
 	struct thread_struct *prev = &prev_p->thread;
-- 
1.8.3.1

