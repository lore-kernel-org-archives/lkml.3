Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab3KUGTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 01:19:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902Ab3KUGTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 01:19:06 -0500
Message-Id: <20131121061752.715177297@dhcp-16-126.nay.redhat.com>
User-Agent: quilt/0.60-1
Date: Thu, 21 Nov 2013 14:17:05 +0800
From: dyoung@redhat.com
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de, greg@kroah.com,
        matt@console-pimps.org, toshi.kani@hp.com,
        Dave Young <dyoung@redhat.com>
Subject: [patch 1/9 v3] efi: remove unused variables in __map_region
References: <20131121061704.363730447@dhcp-16-126.nay.redhat.com>
Content-Disposition: inline; filename=01-remove-unused-var-in-map-region.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

variables size and end is useless in this function, thus remove them.

Reported-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Dave Young <dyoung@redhat.com>
---
 arch/x86/platform/efi/efi_64.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- efi.orig/arch/x86/platform/efi/efi_64.c
+++ efi/arch/x86/platform/efi/efi_64.c
@@ -148,15 +148,11 @@ void efi_setup_page_tables(void)
 static void __init __map_region(efi_memory_desc_t *md, u64 va)
 {
 	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
-	unsigned long pf = 0, size;
-	u64 end;
+	unsigned long pf = 0;
 
 	if (!(md->attribute & EFI_MEMORY_WB))
 		pf |= _PAGE_PCD;
 
-	size = md->num_pages << PAGE_SHIFT;
-	end  = va + size;
-
 	if (kernel_map_pages_in_pgd(pgd, md->phys_addr, va, md->num_pages, pf))
 		pr_warn("Error mapping PA 0x%llx -> VA 0x%llx!\n",
 			   md->phys_addr, va);

