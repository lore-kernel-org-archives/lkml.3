Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132Ab3CAQH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 11:07:58 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57749 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab3CAQH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 11:07:57 -0500
From: Borislav Petkov <bp@alien8.de>
To: Matt Fleming <matt.fleming@intel.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH] x86, efi: Make efi_memblock_x86_reserve_range more readable
Date: Fri,  1 Mar 2013 17:07:44 +0100
Message-Id: <1362154064-9386-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

So basically this function copies EFI memmap stuff from boot_params into
the EFI memmap descriptor and reserves memory for it. Make it much more
readable.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/platform/efi/efi.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 5f2ecaf3f9d8..fff986da6239 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -351,24 +351,25 @@ static void __init do_add_efi_memmap(void)
 
 int __init efi_memblock_x86_reserve_range(void)
 {
+	struct efi_info *e = &boot_params.efi_info;
 	unsigned long pmap;
 
 #ifdef CONFIG_X86_32
 	/* Can't handle data above 4GB at this time */
-	if (boot_params.efi_info.efi_memmap_hi) {
+	if (e->efi_memmap_hi) {
 		pr_err("Memory map is above 4GB, disabling EFI.\n");
 		return -EINVAL;
 	}
-	pmap = boot_params.efi_info.efi_memmap;
+	pmap =  e->efi_memmap;
 #else
-	pmap = (boot_params.efi_info.efi_memmap |
-		((__u64)boot_params.efi_info.efi_memmap_hi<<32));
+	pmap = (e->efi_memmap |	((__u64)e->efi_memmap_hi << 32));
 #endif
-	memmap.phys_map = (void *)pmap;
-	memmap.nr_map = boot_params.efi_info.efi_memmap_size /
-		boot_params.efi_info.efi_memdesc_size;
-	memmap.desc_version = boot_params.efi_info.efi_memdesc_version;
-	memmap.desc_size = boot_params.efi_info.efi_memdesc_size;
+	memmap.phys_map		= (void *)pmap;
+	memmap.nr_map		= e->efi_memmap_size /
+				  e->efi_memdesc_size;
+	memmap.desc_size	= e->efi_memdesc_size;
+	memmap.desc_version	= e->efi_memdesc_version;
+
 	memblock_reserve(pmap, memmap.nr_map * memmap.desc_size);
 
 	return 0;
-- 
1.8.1.3.535.ga923c31

