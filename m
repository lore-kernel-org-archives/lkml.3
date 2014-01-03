Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbaACD5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 22:57:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaACD5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 22:57:12 -0500
Date: Fri, 3 Jan 2014 11:56:49 +0800
From: Dave Young <dyoung@redhat.com>
To: matt@console-pimps.org, hpa@zytor.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        kexec@lists.infradead.org
Subject: [PATCH tip/efi-kexec] x86: setup.c build fix
Message-ID: <20140103035648.GA5291@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case without CONFIG_EFI, there will be below build error:
   arch/x86/built-in.o: In function `setup_arch':
>> (.init.text+0x9dc): undefined reference to `parse_efi_setup'

Thus fix it by adding blank inline function in asm/efi.h
Also remove an unused declaration for variable efi_data_len.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 arch/x86/include/asm/efi.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: tip/arch/x86/include/asm/efi.h
===================================================================
--- tip.orig/arch/x86/include/asm/efi.h
+++ tip/arch/x86/include/asm/efi.h
@@ -142,8 +142,6 @@ struct efi_setup_data {
 };
 
 extern u64 efi_setup;
-extern u32 efi_data_len;
-extern void parse_efi_setup(u64 phys_addr, u32 data_len);
 
 #ifdef CONFIG_EFI
 
@@ -153,7 +151,7 @@ static inline bool efi_is_native(void)
 }
 
 extern struct console early_efi_console;
-
+extern void parse_efi_setup(u64 phys_addr, u32 data_len);
 #else
 /*
  * IF EFI is not configured, have the EFI calls return -ENOSYS.
@@ -165,6 +163,7 @@ extern struct console early_efi_console;
 #define efi_call4(_f, _a1, _a2, _a3, _a4)		(-ENOSYS)
 #define efi_call5(_f, _a1, _a2, _a3, _a4, _a5)		(-ENOSYS)
 #define efi_call6(_f, _a1, _a2, _a3, _a4, _a5, _a6)	(-ENOSYS)
+static inline void parse_efi_setup(u64 phys_addr, u32 data_len) {}
 #endif /* CONFIG_EFI */
 
 #endif /* _ASM_X86_EFI_H */
