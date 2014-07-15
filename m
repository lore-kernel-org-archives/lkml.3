Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933704AbaGOTp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:45:59 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:38553 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933682AbaGOTps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:45:48 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
        akpm@linux-foundation.org, arnd@arndb.de, konrad.wilk@oracle.com,
        plagnioj@jcrosoft.com, tomi.valkeinen@ti.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stefan.bader@canonical.com, luto@amacapital.net, airlied@gmail.com,
        bp@alien8.de, Toshi Kani <toshi.kani@hp.com>
Subject: [RFC PATCH 9/11] x86, efi: Cleanup PCD bit manipulation in EFI
Date: Tue, 15 Jul 2014 13:34:42 -0600
Message-Id: <1405452884-25688-10-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1405452884-25688-1-git-send-email-toshi.kani@hp.com>
References: <1405452884-25688-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up the PCD bit manipulation in EFI virtual mapping,
and uses _PAGE_CACHE_<type> macros, instead.  This keeps the efi code
independent from the PAT slot assignment.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 arch/x86/platform/efi/efi_64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 290d397..55c6e77 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -202,10 +202,10 @@ void efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 static void __init __map_region(efi_memory_desc_t *md, u64 va)
 {
 	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
-	unsigned long pf = 0;
+	unsigned long pf = _PAGE_CACHE_WB;
 
 	if (!(md->attribute & EFI_MEMORY_WB))
-		pf |= _PAGE_PCD;
+		pf = _PAGE_CACHE_UC_MINUS;
 
 	if (kernel_map_pages_in_pgd(pgd, md->phys_addr, va, md->num_pages, pf))
 		pr_warn("Error mapping PA 0x%llx -> VA 0x%llx!\n",
