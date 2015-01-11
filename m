Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbbAKWcj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:32:39 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:33599 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbbAKWcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:32:36 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: xen: mmu: Remove unused function
Date: Sun, 11 Jan 2015 23:35:41 +0100
Message-Id: <1421015741-25110-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function set_pte_mfn() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/x86/xen/mmu.c |    9 ---------
 arch/x86/xen/mmu.h |    2 --
 2 files changed, 11 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index a8a1a3d..6959550 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -281,15 +281,6 @@ static void xen_set_pmd(pmd_t *ptr, pmd_t val)
 	xen_set_pmd_hyper(ptr, val);
 }
 
-/*
- * Associate a virtual page frame with a given physical page frame
- * and protection flags for that frame.
- */
-void set_pte_mfn(unsigned long vaddr, unsigned long mfn, pgprot_t flags)
-{
-	set_pte_vaddr(vaddr, mfn_pte(mfn, flags));
-}
-
 static bool xen_batched_set_pte(pte_t *ptep, pte_t pteval)
 {
 	struct mmu_update u;
diff --git a/arch/x86/xen/mmu.h b/arch/x86/xen/mmu.h
index 73809bb..f2dcf79 100644
--- a/arch/x86/xen/mmu.h
+++ b/arch/x86/xen/mmu.h
@@ -13,8 +13,6 @@ enum pt_level {
 
 bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn);
 
-void set_pte_mfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags);
-
 pte_t xen_ptep_modify_prot_start(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
 void  xen_ptep_modify_prot_commit(struct mm_struct *mm, unsigned long addr,
 				  pte_t *ptep, pte_t pte);
-- 
1.7.10.4

