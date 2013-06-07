Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917Ab3FGXIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:08:07 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:61285 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757684Ab3FGXDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:03:53 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 22/31] mips/kvm: Split get_new_mmu_context into two parts.
Date: Fri,  7 Jun 2013 16:03:26 -0700
Message-Id: <1370646215-6543-23-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

The new function (part) get_new_asid() can now be used from MIPSVZ code.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/include/asm/mmu_context.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/mmu_context.h b/arch/mips/include/asm/mmu_context.h
index 8201160..5609a32 100644
--- a/arch/mips/include/asm/mmu_context.h
+++ b/arch/mips/include/asm/mmu_context.h
@@ -108,8 +108,8 @@ static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 
 #ifndef CONFIG_MIPS_MT_SMTC
 /* Normal, classic MIPS get_new_mmu_context */
-static inline void
-get_new_mmu_context(struct mm_struct *mm, unsigned long cpu)
+static inline unsigned long
+get_new_asid(unsigned long cpu)
 {
 	extern void kvm_local_flush_tlb_all(void);
 	unsigned long asid = asid_cache(cpu);
@@ -125,7 +125,13 @@ get_new_mmu_context(struct mm_struct *mm, unsigned long cpu)
 		if (!asid)		/* fix version if needed */
 			asid = ASID_FIRST_VERSION;
 	}
+	return asid;
+}
 
+static inline void
+get_new_mmu_context(struct mm_struct *mm, unsigned long cpu)
+{
+	unsigned long asid = get_new_asid(cpu);
 	cpu_context(cpu, mm) = asid_cache(cpu) = asid;
 }
 
-- 
1.7.11.7

