Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbaG2RJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 13:09:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbaG2RJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 13:09:34 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, lszubowi@redhat.com,
        Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-efi@vger.kernel.org
Subject: [PATCH] x86, efi: print debug values in Kib not MB
Date: Tue, 29 Jul 2014 13:09:21 -0400
Message-Id: <1406653761-3884-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current debug print in EFI does

[    0.000000] efi: mem84: type=3, attr=0xf, range=[0x00000000645b5000-0x00000000645fb000) (0MB)

and rounds off the size to 0MB and isn't very useful.  We should print this in
Kib.  After applying this patch we get better info with

[    0.000000] efi: mem84: type=3, attr=0xf, range=[0x00000000645b5000-0x00000000645fb000) (280kiB)

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: lszubowi@redhat.com
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: linux-efi@vger.kernel.org
---
 arch/x86/platform/efi/efi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 87fc96b..3875090 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -384,10 +384,10 @@ static void __init print_efi_memmap(void)
 	     p < memmap.map_end;
 	     p += memmap.desc_size, i++) {
 		md = p;
-		pr_info("mem%02u: type=%u, attr=0x%llx, range=[0x%016llx-0x%016llx) (%lluMB)\n",
+		pr_info("mem%02u: type=%u, attr=0x%llx, range=[0x%016llx-0x%016llx) (%lluKiB)\n",
 			i, md->type, md->attribute, md->phys_addr,
 			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
-			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
+			(md->num_pages << 2));
 	}
 #endif  /*  EFI_DEBUG  */
 }
-- 
1.7.9.3

