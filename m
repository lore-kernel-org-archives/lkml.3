Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761854AbbA1Gp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 01:45:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760753AbbA1Gob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 01:44:31 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH 4/5] xen: add some __init annotations in arch/x86/xen/mmu.c
Date: Wed, 28 Jan 2015 07:44:24 +0100
Message-Id: <1422427465-25239-5-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1422427465-25239-1-git-send-email-jgross@suse.com>
References: <1422427465-25239-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file arch/x86/xen/mmu.c has some functions that can be annotated
with "__init".

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/xen/mmu.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 5c1f9ac..6a8bbf4 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1489,7 +1489,7 @@ static void __init xen_set_pte_init(pte_t *ptep, pte_t pte)
 	native_set_pte(ptep, pte);
 }
 
-static void pin_pagetable_pfn(unsigned cmd, unsigned long pfn)
+static void __init pin_pagetable_pfn(unsigned cmd, unsigned long pfn)
 {
 	struct mmuext_op op;
 	op.cmd = cmd;
@@ -1657,7 +1657,7 @@ void __init xen_reserve_top(void)
  * Like __va(), but returns address in the kernel mapping (which is
  * all we have until the physical memory mapping has been set up.
  */
-static void *__ka(phys_addr_t paddr)
+static void * __init __ka(phys_addr_t paddr)
 {
 #ifdef CONFIG_X86_64
 	return (void *)(paddr + __START_KERNEL_map);
@@ -1667,7 +1667,7 @@ static void *__ka(phys_addr_t paddr)
 }
 
 /* Convert a machine address to physical address */
-static unsigned long m2p(phys_addr_t maddr)
+static unsigned long __init m2p(phys_addr_t maddr)
 {
 	phys_addr_t paddr;
 
@@ -1678,13 +1678,14 @@ static unsigned long m2p(phys_addr_t maddr)
 }
 
 /* Convert a machine address to kernel virtual */
-static void *m2v(phys_addr_t maddr)
+static void * __init m2v(phys_addr_t maddr)
 {
 	return __ka(m2p(maddr));
 }
 
 /* Set the page permissions on an identity-mapped pages */
-static void set_page_prot_flags(void *addr, pgprot_t prot, unsigned long flags)
+static void __init set_page_prot_flags(void *addr, pgprot_t prot,
+				       unsigned long flags)
 {
 	unsigned long pfn = __pa(addr) >> PAGE_SHIFT;
 	pte_t pte = pfn_pte(pfn, prot);
@@ -1696,7 +1697,7 @@ static void set_page_prot_flags(void *addr, pgprot_t prot, unsigned long flags)
 	if (HYPERVISOR_update_va_mapping((unsigned long)addr, pte, flags))
 		BUG();
 }
-static void set_page_prot(void *addr, pgprot_t prot)
+static void __init set_page_prot(void *addr, pgprot_t prot)
 {
 	return set_page_prot_flags(addr, prot, UVMF_NONE);
 }
@@ -1769,7 +1770,7 @@ void __init xen_setup_machphys_mapping(void)
 }
 
 #ifdef CONFIG_X86_64
-static void convert_pfn_mfn(void *v)
+static void __init convert_pfn_mfn(void *v)
 {
 	pte_t *pte = v;
 	int i;
-- 
2.1.2

