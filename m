Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbbAOIpB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 03:45:01 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54568 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbbAOIo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 03:44:59 -0500
From: Borislav Petkov <bp@alien8.de>
To: KVM <kvm@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] kvm: Fix CR3_PCID_INVD type on 32-bit
Date: Thu, 15 Jan 2015 09:44:56 +0100
Message-Id: <1421311496-18028-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.2.0.33.gc18b867
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

arch/x86/kvm/emulate.c: In function ‘check_cr_write’:
arch/x86/kvm/emulate.c:3552:4: warning: left shift count >= width of type
    rsvd = CR3_L_MODE_RESERVED_BITS & ~CR3_PCID_INVD;

happens because sizeof(UL) on 32-bit is 4 bytes but we shift it 63 bits
to the left.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d89c6b828c96..a8d07a060136 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -51,7 +51,7 @@
 			  | X86_CR0_NW | X86_CR0_CD | X86_CR0_PG))
 
 #define CR3_L_MODE_RESERVED_BITS 0xFFFFFF0000000000ULL
-#define CR3_PCID_INVD		 (1UL << 63)
+#define CR3_PCID_INVD		 BIT_64(63)
 #define CR4_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR4_VME | X86_CR4_PVI | X86_CR4_TSD | X86_CR4_DE\
 			  | X86_CR4_PSE | X86_CR4_PAE | X86_CR4_MCE     \
-- 
2.2.0.33.gc18b867

