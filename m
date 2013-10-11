Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840Ab3JKUAv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:00:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46296 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932614Ab3JKTlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Olof Johansson <olof@lixom.net>,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: [ 058/135] ARM: kvm: rename cpu_reset to avoid name clash
Date: Fri, 11 Oct 2013 12:38:59 -0700
Message-Id: <20131011193951.578997401@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olof Johansson <olof@lixom.net>

commit ac570e0493815e0b41681c89cb50d66421429d27 upstream.

cpu_reset is already #defined in <asm/proc-fns.h> as processor.reset,
so it expands here and causes problems.

Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kvm/reset.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm/kvm/reset.c
+++ b/arch/arm/kvm/reset.c
@@ -58,14 +58,14 @@ static const struct kvm_irq_level a15_vt
  */
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 {
-	struct kvm_regs *cpu_reset;
+	struct kvm_regs *reset_regs;
 	const struct kvm_irq_level *cpu_vtimer_irq;
 
 	switch (vcpu->arch.target) {
 	case KVM_ARM_TARGET_CORTEX_A15:
 		if (vcpu->vcpu_id > a15_max_cpu_idx)
 			return -EINVAL;
-		cpu_reset = &a15_regs_reset;
+		reset_regs = &a15_regs_reset;
 		vcpu->arch.midr = read_cpuid_id();
 		cpu_vtimer_irq = &a15_vtimer_irq;
 		break;
@@ -74,7 +74,7 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu
 	}
 
 	/* Reset core registers */
-	memcpy(&vcpu->arch.regs, cpu_reset, sizeof(vcpu->arch.regs));
+	memcpy(&vcpu->arch.regs, reset_regs, sizeof(vcpu->arch.regs));
 
 	/* Reset CP15 registers */
 	kvm_reset_coprocs(vcpu);


