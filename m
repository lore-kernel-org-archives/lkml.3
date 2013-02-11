Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab3BKMNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 07:13:23 -0500
Received: from mail-ia0-f177.google.com ([209.85.210.177]:48554 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab3BKMNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 07:13:20 -0500
From: aik@ozlabs.ru
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Paul Mackerras <paulus@samba.org>,
        Alexander Graf <agraf@suse.de>,
        Michael Ellerman <michael@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH 1/4] powerpc: lookup_linux_pte has been made public
Date: Mon, 11 Feb 2013 23:12:40 +1100
Message-Id: <5118e055.22ca320a.1f08.ffffe2e5@mx.google.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360584763-21988-1-git-send-email-a>
References: <1360584763-21988-1-git-send-email-a>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

The lookup_linux_pte() function returns a linux PTE which
is required to convert KVM guest physical address into host real
address in real mode.

This convertion will be used by upcoming support of H_PUT_TCE_INDIRECT
as TCE list address comes from the guest directly so it is a guest
physical.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: David Gibson <david@gibson.dropbear.id.au>
---
 arch/powerpc/include/asm/pgtable-ppc64.h |    3 +++
 arch/powerpc/kvm/book3s_hv_rm_mmu.c      |    4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/pgtable-ppc64.h b/arch/powerpc/include/asm/pgtable-ppc64.h
index 0182c20..ddcc898 100644
--- a/arch/powerpc/include/asm/pgtable-ppc64.h
+++ b/arch/powerpc/include/asm/pgtable-ppc64.h
@@ -377,6 +377,9 @@ static inline pte_t *find_linux_pte_or_hugepte(pgd_t *pgdir, unsigned long ea,
 }
 #endif /* !CONFIG_HUGETLB_PAGE */
 
+pte_t lookup_linux_pte(pgd_t *pgdir, unsigned long hva,
+		int writing, unsigned long *pte_sizep);
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_POWERPC_PGTABLE_PPC64_H_ */
diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index 19c93ba..6a042d0 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -145,8 +145,8 @@ static void remove_revmap_chain(struct kvm *kvm, long pte_index,
 	unlock_rmap(rmap);
 }
 
-static pte_t lookup_linux_pte(pgd_t *pgdir, unsigned long hva,
-			      int writing, unsigned long *pte_sizep)
+pte_t lookup_linux_pte(pgd_t *pgdir, unsigned long hva,
+		       int writing, unsigned long *pte_sizep)
 {
 	pte_t *ptep;
 	unsigned long ps = *pte_sizep;
-- 
1.7.10.4

