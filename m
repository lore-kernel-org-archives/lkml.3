Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaIAAyb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 20:54:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270AbaIAAyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 20:54:19 -0400
From: Laszlo Ersek <lersek@redhat.com>
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org,
        linux-ia64@vger.kernel.org, matt.fleming@intel.com, msalter@redhat.com,
        lersek@redhat.com
Subject: [PATCH 5/5] arm64: efi: format EFI memory type & attrs with efi_md_typeattr_format()
Date: Mon,  1 Sep 2014 02:53:40 +0200
Message-Id: <1409532820-5027-6-git-send-email-lersek@redhat.com>
In-Reply-To: <1409532820-5027-1-git-send-email-lersek@redhat.com>
References: <1409532820-5027-1-git-send-email-lersek@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 arch/arm64/kernel/efi.c | 26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 03aaa99..3b1f23c 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -119,23 +119,6 @@ static int __init uefi_init(void)
 	return retval;
 }
 
-static __initdata char memory_type_name[][32] = {
-	{"Reserved"},
-	{"Loader Code"},
-	{"Loader Data"},
-	{"Boot Code"},
-	{"Boot Data"},
-	{"Runtime Code"},
-	{"Runtime Data"},
-	{"Conventional Memory"},
-	{"Unusable Memory"},
-	{"ACPI Reclaim Memory"},
-	{"ACPI Memory NVS"},
-	{"Memory Mapped I/O"},
-	{"MMIO Port Space"},
-	{"PAL Code"},
-};
-
 /*
  * Return true for RAM regions we want to permanently reserve.
  */
@@ -166,10 +149,13 @@ static __init void reserve_regions(void)
 		paddr = md->phys_addr;
 		npages = md->num_pages;
 
-		if (uefi_debug)
-			pr_info("  0x%012llx-0x%012llx [%s]",
+		if (uefi_debug) {
+			char buf[64];
+
+			pr_info("  0x%012llx-0x%012llx %s",
 				paddr, paddr + (npages << EFI_PAGE_SHIFT) - 1,
-				memory_type_name[md->type]);
+				efi_md_typeattr_format(buf, sizeof(buf), md));
+		}
 
 		memrange_efi_to_native(&paddr, &npages);
 		size = npages << PAGE_SHIFT;
-- 
1.8.3.1

