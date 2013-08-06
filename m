Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab3HFVng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:43:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43498 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab3HFVne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:43:34 -0400
Date: Tue, 6 Aug 2013 14:43:23 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-35ea7903b8a97162e38da9da3b560df74713321d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1375740170-7446-6-git-send-email-andi@firstfloor.org>
References: <1375740170-7446-6-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] x86, asmlinkage: Make 32bit/
 64bit __switch_to visible
Git-Commit-ID: 35ea7903b8a97162e38da9da3b560df74713321d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 06 Aug 2013 14:43:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  35ea7903b8a97162e38da9da3b560df74713321d
Gitweb:     http://git.kernel.org/tip/35ea7903b8a97162e38da9da3b560df74713321d
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 5 Aug 2013 15:02:39 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 6 Aug 2013 14:18:30 -0700

x86, asmlinkage: Make 32bit/64bit __switch_to visible

This function is called from inline assembler, so has to be visible.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1375740170-7446-6-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
