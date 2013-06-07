Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab3FGXN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:13:57 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:36514 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580Ab3FGXDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:03:46 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 03/31] mips/kvm: Fix 32-bitisms in kvm_locore.S
Date: Fri,  7 Jun 2013 16:03:07 -0700
Message-Id: <1370646215-6543-4-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

For a warning free compile, we need to use the width aware PTR_LI and
PTR_LA macros.  Use LI variant for immediate data and LA variant for
addresses.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/kvm/kvm_locore.S | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/mips/kvm/kvm_locore.S b/arch/mips/kvm/kvm_locore.S
index dca2aa6..e86fa2a 100644
--- a/arch/mips/kvm/kvm_locore.S
+++ b/arch/mips/kvm/kvm_locore.S
@@ -310,7 +310,7 @@ NESTED (MIPSX(GuestException), CALLFRAME_SIZ, ra)
     LONG_S  t0, VCPU_R26(k1)
 
     /* Get GUEST k1 and save it in VCPU */
-    la      t1, ~0x2ff
+	PTR_LI	t1, ~0x2ff
     mfc0    t0, CP0_EBASE
     and     t0, t0, t1
     LONG_L  t0, 0x3000(t0)
@@ -384,14 +384,14 @@ NESTED (MIPSX(GuestException), CALLFRAME_SIZ, ra)
     mtc0        k0, CP0_DDATA_LO
 
     /* Restore RDHWR access */
-    la      k0, 0x2000000F
+	PTR_LI	k0, 0x2000000F
     mtc0    k0,  CP0_HWRENA
 
     /* Jump to handler */
 FEXPORT(__kvm_mips_jump_to_handler)
     /* XXXKYMA: not sure if this is safe, how large is the stack?? */
     /* Now jump to the kvm_mips_handle_exit() to see if we can deal with this in the kernel */
-    la          t9,kvm_mips_handle_exit
+	PTR_LA	t9, kvm_mips_handle_exit
     jalr.hb     t9
     addiu       sp,sp, -CALLFRAME_SIZ           /* BD Slot */
 
@@ -566,7 +566,7 @@ __kvm_mips_return_to_host:
     mtlo    k0
 
     /* Restore RDHWR access */
-    la      k0, 0x2000000F
+	PTR_LI	k0, 0x2000000F
     mtc0    k0,  CP0_HWRENA
 
 
-- 
1.7.11.7

