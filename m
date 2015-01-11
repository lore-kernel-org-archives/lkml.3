Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbbAKWF1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:05:27 -0500
Received: from shelob.surriel.com ([74.92.59.67]:38178 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbbAKWFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:05:15 -0500
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, hpa@zytor.com, matt.fleming@intel.com, bp@suse.de,
        oleg@redhat.com, pbonzini@redhat.com, tglx@linutronix.de,
        luto@amacapital.net
Subject: [RFC PATCH 01/11] x86,fpu: document the data structures a little
Date: Sun, 11 Jan 2015 16:46:23 -0500
Message-Id: <1421012793-30106-2-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421012793-30106-1-git-send-email-riel@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Add some documentation to data structures used for FPU context
switching.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 arch/x86/include/asm/processor.h | 9 +++++++--
 arch/x86/kernel/cpu/common.c     | 1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index a092a0c..17bd8a0 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -400,6 +400,11 @@ struct xsave_struct {
 	/* new processor state extensions will go here */
 } __attribute__ ((packed, aligned (64)));
 
+/*
+ * The FPU state used depends on the capabilities of the hardware; the
+ * registers used for vector instructions on newer hardware are included
+ * in the FPU state.
+ */
 union thread_xstate {
 	struct i387_fsave_struct	fsave;
 	struct i387_fxsave_struct	fxsave;
@@ -408,8 +413,8 @@ union thread_xstate {
 };
 
 struct fpu {
-	unsigned int last_cpu;
-	unsigned int has_fpu;
+	unsigned int last_cpu;		/* FPU state last loaded on this CPU */
+	unsigned int has_fpu;		/* FPU state in current use on CPU */
 	union thread_xstate *state;
 };
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c604965..36837bb 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1143,6 +1143,7 @@ DEFINE_PER_CPU(unsigned int, irq_count) __visible = -1;
 DEFINE_PER_CPU(int, __preempt_count) = INIT_PREEMPT_COUNT;
 EXPORT_PER_CPU_SYMBOL(__preempt_count);
 
+/* Task that currently has its FPU state loaded on the CPU. */
 DEFINE_PER_CPU(struct task_struct *, fpu_owner_task);
 
 /*
-- 
1.9.3

