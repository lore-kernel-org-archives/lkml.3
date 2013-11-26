Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab3KZF7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 00:59:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab3KZF7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 00:59:00 -0500
From: Dave Young <dyoung@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de, greg@kroah.com,
        matt@console-pimps.org, toshi.kani@hp.com
Subject: [PATCH v4 01/12] efi: remove unused variables in __map_region
Date: Tue, 26 Nov 2013 13:57:46 +0800
Message-Id: <1385445477-9665-2-git-send-email-dyoung@redhat.com>
In-Reply-To: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

variables size and end is useless in this function, thus remove them.

Reported-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Dave Young <dyoung@redhat.com>
Acked-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/platform/efi/efi_64.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index bf286c3..c5a6491 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
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
-- 
1.8.3.1

