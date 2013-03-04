Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491Ab3CDURe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 15:17:34 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55853 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932397Ab3CDUQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 15:16:37 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: [PATCH 2/5] x86: Drop KERNEL_IMAGE_START
Date: Mon,  4 Mar 2013 21:16:17 +0100
Message-Id: <1362428180-8865-3-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1362428180-8865-1-git-send-email-bp@alien8.de>
References: <1362428180-8865-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have KERNEL_IMAGE_START and __START_KERNEL_map which both contain the
start of the kernel text mapping's virtual address. Remove the prior one
which has been replicated a lot less times around the tree.

No functionality change.

Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 arch/x86/include/asm/page_64_types.h | 1 -
 arch/x86/kernel/head64.c             | 6 +++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index 8b491e66eaa8..6c896fbe21db 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -48,6 +48,5 @@
  * arch/x86/kernel/head_64.S), and it is mapped here:
  */
 #define KERNEL_IMAGE_SIZE	(512 * 1024 * 1024)
-#define KERNEL_IMAGE_START	_AC(0xffffffff80000000, UL)
 
 #endif /* _ASM_X86_PAGE_64_DEFS_H */
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index c5e403f6d869..101ac1a9263e 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -144,10 +144,10 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	 * Build-time sanity checks on the kernel image and module
 	 * area mappings. (these are purely build-time and produce no code)
 	 */
-	BUILD_BUG_ON(MODULES_VADDR < KERNEL_IMAGE_START);
-	BUILD_BUG_ON(MODULES_VADDR-KERNEL_IMAGE_START < KERNEL_IMAGE_SIZE);
+	BUILD_BUG_ON(MODULES_VADDR < __START_KERNEL_map);
+	BUILD_BUG_ON(MODULES_VADDR - __START_KERNEL_map < KERNEL_IMAGE_SIZE);
 	BUILD_BUG_ON(MODULES_LEN + KERNEL_IMAGE_SIZE > 2*PUD_SIZE);
-	BUILD_BUG_ON((KERNEL_IMAGE_START & ~PMD_MASK) != 0);
+	BUILD_BUG_ON((__START_KERNEL_map & ~PMD_MASK) != 0);
 	BUILD_BUG_ON((MODULES_VADDR & ~PMD_MASK) != 0);
 	BUILD_BUG_ON(!(MODULES_VADDR > __START_KERNEL));
 	BUILD_BUG_ON(!(((MODULES_END - 1) & PGDIR_MASK) ==
-- 
1.8.1.3.535.ga923c31

