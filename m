Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbaEOQwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:52:45 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:46877 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbaEOQvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:51:46 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jan.kiszka@siemens.com, kvm@vger.kernel.org, gleb@kernel.org,
        avi.kivity@gmail.com
Subject: [PATCH v2 2/4] KVM: x86: drop set_rflags callback
Date: Thu, 15 May 2014 18:51:29 +0200
Message-Id: <1400172691-27030-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1400172691-27030-1-git-send-email-pbonzini@redhat.com>
References: <1400172691-27030-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not needed anymore now that the CPL is computed directly
by the task switch code.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_emulate.h | 1 -
 arch/x86/kvm/x86.c                 | 6 ------
 2 files changed, 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 24ec1216596e..a04fe4eb237d 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -189,7 +189,6 @@ struct x86_emulate_ops {
 	void (*set_idt)(struct x86_emulate_ctxt *ctxt, struct desc_ptr *dt);
 	ulong (*get_cr)(struct x86_emulate_ctxt *ctxt, int cr);
 	int (*set_cr)(struct x86_emulate_ctxt *ctxt, int cr, ulong val);
-	void (*set_rflags)(struct x86_emulate_ctxt *ctxt, ulong val);
 	int (*cpl)(struct x86_emulate_ctxt *ctxt);
 	int (*get_dr)(struct x86_emulate_ctxt *ctxt, int dr, ulong *dest);
 	int (*set_dr)(struct x86_emulate_ctxt *ctxt, int dr, ulong value);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fb313fc896dd..57eac309c22e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4646,11 +4646,6 @@ static int emulator_set_cr(struct x86_emulate_ctxt *ctxt, int cr, ulong val)
 	return res;
 }
 
-static void emulator_set_rflags(struct x86_emulate_ctxt *ctxt, ulong val)
-{
-	kvm_set_rflags(emul_to_vcpu(ctxt), val);
-}
-
 static int emulator_get_cpl(struct x86_emulate_ctxt *ctxt)
 {
 	return kvm_x86_ops->get_cpl(emul_to_vcpu(ctxt));
@@ -4835,7 +4830,6 @@ static const struct x86_emulate_ops emulate_ops = {
 	.set_idt	     = emulator_set_idt,
 	.get_cr              = emulator_get_cr,
 	.set_cr              = emulator_set_cr,
-	.set_rflags          = emulator_set_rflags,
 	.cpl                 = emulator_get_cpl,
 	.get_dr              = emulator_get_dr,
 	.set_dr              = emulator_set_dr,
-- 
1.8.3.1


