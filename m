Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759934Ab3EWQum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 12:50:42 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:59972 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759808Ab3EWQtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 12:49:20 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH v6 3/6] mips/kvm: Fix name of gpr field in struct kvm_regs.
Date: Thu, 23 May 2013 09:49:07 -0700
Message-Id: <1369327750-28580-4-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1369327750-28580-1-git-send-email-ddaney.cavm@gmail.com>
References: <1369327750-28580-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Signed-off-by: David Daney <david.daney@cavium.com>
Acked-by: Sanjay Lal <sanjayl@kymasys.com>
---
 arch/mips/include/uapi/asm/kvm.h | 3 ++-
 arch/mips/kvm/kvm_mips.c         | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/mips/include/uapi/asm/kvm.h b/arch/mips/include/uapi/asm/kvm.h
index 86812fb..d145ead 100644
--- a/arch/mips/include/uapi/asm/kvm.h
+++ b/arch/mips/include/uapi/asm/kvm.h
@@ -26,7 +26,8 @@
  * extended to 64-bits.
  */
 struct kvm_regs {
-	__u64 gprs[32];
+	/* out (KVM_GET_REGS) / in (KVM_SET_REGS) */
+	__u64 gpr[32];
 	__u64 hi;
 	__u64 lo;
 	__u64 pc;
diff --git a/arch/mips/kvm/kvm_mips.c b/arch/mips/kvm/kvm_mips.c
index e0dad02..93da750 100644
--- a/arch/mips/kvm/kvm_mips.c
+++ b/arch/mips/kvm/kvm_mips.c
@@ -678,7 +678,7 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	int i;
 
 	for (i = 0; i < 32; i++)
-		vcpu->arch.gprs[i] = regs->gprs[i];
+		vcpu->arch.gprs[i] = regs->gpr[i];
 
 	vcpu->arch.hi = regs->hi;
 	vcpu->arch.lo = regs->lo;
@@ -692,7 +692,7 @@ int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	int i;
 
 	for (i = 0; i < 32; i++)
-		regs->gprs[i] = vcpu->arch.gprs[i];
+		regs->gpr[i] = vcpu->arch.gprs[i];
 
 	regs->hi = vcpu->arch.hi;
 	regs->lo = vcpu->arch.lo;
-- 
1.7.11.7

