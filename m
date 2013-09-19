Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab3ISOzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 10:55:05 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58742 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261Ab3ISOzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 10:55:02 -0400
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>,
        linux-efi@vger.kernel.org
Subject: [PATCH 01/11] efi: Simplify EFI_DEBUG
Date: Thu, 19 Sep 2013 16:54:44 +0200
Message-Id: <1379602494-26684-2-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379602494-26684-1-git-send-email-bp@alien8.de>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

... and lose one #ifdef .. #endif sandwich.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/platform/efi/efi.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 90f6ed127096..7cec1e9e5494 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -51,7 +51,7 @@
 #include <asm/x86_init.h>
 #include <asm/rtc.h>
 
-#define EFI_DEBUG	1
+#define EFI_DEBUG
 
 #define EFI_MIN_RESERVE 5120
 
@@ -402,9 +402,9 @@ int __init efi_memblock_x86_reserve_range(void)
 	return 0;
 }
 
-#if EFI_DEBUG
 static void __init print_efi_memmap(void)
 {
+#ifdef EFI_DEBUG
 	efi_memory_desc_t *md;
 	void *p;
 	int i;
@@ -419,8 +419,8 @@ static void __init print_efi_memmap(void)
 			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
 			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
 	}
-}
 #endif  /*  EFI_DEBUG  */
+}
 
 void __init efi_reserve_boot_services(void)
 {
@@ -774,10 +774,7 @@ void __init efi_init(void)
 		x86_platform.set_wallclock = efi_set_rtc_mmss;
 	}
 #endif
-
-#if EFI_DEBUG
 	print_efi_memmap();
-#endif
 }
 
 void __init efi_late_init(void)
-- 
1.8.4

