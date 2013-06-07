Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab3FGXGv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:06:51 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:41591 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757688Ab3FGXDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:03:54 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 24/31] mips/kvm: Add thread_struct fields used by MIPSVZ hosts.
Date: Fri,  7 Jun 2013 16:03:28 -0700
Message-Id: <1370646215-6543-25-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

... and their accessors in asm-offsets.c

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/include/asm/processor.h | 6 ++++++
 arch/mips/kernel/asm-offsets.c    | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/arch/mips/include/asm/processor.h b/arch/mips/include/asm/processor.h
index 1470b7b..e0aa198 100644
--- a/arch/mips/include/asm/processor.h
+++ b/arch/mips/include/asm/processor.h
@@ -198,6 +198,7 @@ typedef struct {
 #define ARCH_MIN_TASKALIGN	8
 
 struct mips_abi;
+struct kvm_vcpu;
 
 /*
  * If you change thread_struct remember to change the #defines below too!
@@ -230,6 +231,11 @@ struct thread_struct {
 	unsigned long cp0_badvaddr;	/* Last user fault */
 	unsigned long cp0_baduaddr;	/* Last kernel fault accessing USEG */
 	unsigned long error_code;
+#ifdef CONFIG_KVM_MIPSVZ
+	struct kvm_vcpu *vcpu;
+	unsigned int mm_asid;
+	unsigned int guest_asid;
+#endif
 #ifdef CONFIG_CPU_CAVIUM_OCTEON
     struct octeon_cop2_state cp2 __attribute__ ((__aligned__(128)));
     struct octeon_cvmseg_state cvmseg __attribute__ ((__aligned__(128)));
diff --git a/arch/mips/kernel/asm-offsets.c b/arch/mips/kernel/asm-offsets.c
index c5cc28f..37fd9e2 100644
--- a/arch/mips/kernel/asm-offsets.c
+++ b/arch/mips/kernel/asm-offsets.c
@@ -132,6 +132,11 @@ void output_thread_defines(void)
 	       thread.cp0_baduaddr);
 	OFFSET(THREAD_ECODE, task_struct, \
 	       thread.error_code);
+#ifdef CONFIG_KVM_MIPSVZ
+	OFFSET(THREAD_VCPU, task_struct, thread.vcpu);
+	OFFSET(THREAD_MM_ASID, task_struct, thread.mm_asid);
+	OFFSET(THREAD_GUEST_ASID, task_struct, thread.guest_asid);
+#endif
 	BLANK();
 }
 
-- 
1.7.11.7

