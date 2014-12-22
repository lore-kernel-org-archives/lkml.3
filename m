Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbaLVLZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 06:25:40 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:51326 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbaLVLZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 06:25:38 -0500
From: Peng Fan <van.freenix@gmail.com>
To: christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: gleb@kernel.org, pbonzini@redhat.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        van.freenix@gmail.com
Subject: [PATCH 1/2] arm:kvm correct prototype to make sparse happy
Date: Mon, 22 Dec 2014 19:23:18 +0800
Message-Id: <1419247399-26113-1-git-send-email-van.freenix@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warning message:
arch/arm/kvm/arm.c:85:17:
error: symbol 'kvm_get_running_vcpus' redeclared with different type
(originally declared at ./arch/arm/include/asm/kvm_host.h :190) -
different address spaces

Signed-off-by: Peng Fan <van.freenix@gmail.com>
CC: Gleb Natapov <gleb@kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>
CC: Christoffer Dall <christoffer.dall@linaro.org>
CC: Marc Zyngier <marc.zyngier@arm.com>
CC: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 53036e2..219d025 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -187,7 +187,7 @@ static inline void kvm_arch_mmu_notifier_invalidate_page(struct kvm *kvm,
 }
 
 struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
-struct kvm_vcpu __percpu **kvm_get_running_vcpus(void);
+struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void);
 
 int kvm_arm_copy_coproc_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
 unsigned long kvm_arm_num_coproc_regs(struct kvm_vcpu *vcpu);
-- 
1.8.4

